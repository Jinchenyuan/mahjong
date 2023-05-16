local skynet = require "skynet"
local socket = require "skynet.socket"
local websocket = require "simplewebsocket"
local log = require "chestnut.skynet.log"
local servicecode = require "enum.servicecode"

local server = {}
local users = {}
local username_map = {}
local internal_id = 0
local forwarding  = {}  -- agent -> connection
local MODE = ...


-- login server disallow multi login, so login_handler never be reentry
-- call by login server
function server.login_handler(uid, secret)
    if users[uid] then
        error(string.format("%s is already login", uid))
    end

    internal_id = internal_id + 1
    local id = internal_id
    local username = string.format("%d:%d", uid, id)
    log.info("gated username: %s, uid: %s", username, uid)

    -- you can use a pool to alloc new agent
    -- local agent = skynet.newservice "agent"
    local agent = skynet.call(".AGENT_MGR", "lua", "enter", uid)
    if agent == 0 or agent == -1 then
        local res = {}
        res.errorcode = servicecode.NOT_ENOUGH_AGENT
        res.subid = id
        return res
    end
    local u = {
        username = username,
        agent = agent,
        uid = uid,
        subid = id,
    }

    -- trash subid (no used)
    local err = skynet.call(agent, "lua", "login", skynet.self(), uid, id, secret)
    if err == servicecode.SUCCESS then
        log.info("gated call login err = %d", err)
        users[uid] = u
        username_map[username] = u

        -- you should return unique subid
        local res = {}
        res.errorcode = err
        res.subid = id
        return res
    else
        log.info("gated call login err = %d", err)
        local res = {}
        res.errorcode = err
        res.subid = 0
        return res
    end
end

-- call by agent
function server.logout_handler(uid, subid)
    local u = users[uid]
    if u then
        local username = string.format("%d:%d", uid, subid)
        assert(u.username == username)
        users[uid] = nil
        username_map[u.username] = nil
        forwarding[u.fd] = nil
        log.info("call login logout")
        local err = skynet.call(".wslogind", "lua", "logout", uid, subid)
        if err ~= servicecode.SUCCESS then
            log.error("wslogind service logout failture.")
        else
            log.info("wslogind service logout ok.")
        end
        return err
    else
        log.error("wsgate service not contains uid(%d)", uid)
        return servicecode.FAIL
    end
end

-- call by login server
function server.kick_handler(uid, subid)
    local u = users[uid]
    if u then
        -- local username = msgserver.username(uid, subid, servername)
        local username = string.format("%d:%d", uid, subid)
        assert(u.username == username)
        -- NOTICE: logout may call skynet.exit, so you should use pcall.
        -- pcall(skynet.call, u.agent.handle, "lua", "logout")
        log.info("uid(%d) kick agent, call agent logout", uid)
        local ok = skynet.call(u.agent, "lua", "logout")
        if not ok then
            log.error("gated pcall agent kick error.")
            return false
        else
            return ok
        end
    else
        log.error("uid = %d not existence.")
        return false
    end
end

-- call by self (when socket disconnect)
function server.disconnect_handler(fd)
    local u = forwarding[fd]
    if u then
        forwarding[fd] = nil
        skynet.call(u.agent, "lua", "afk")
        skynet.call(u.agent, "lua", "logout")
        log.info("agent logout ok.")
    end
end

-- call by self
function server.start_handler(username, fd, ws)
    -- body
    local u = username_map[username]
    if u then
        local agent = u.agent
        if agent then
            local conf = {
                client = fd,
            }
            skynet.call(agent, "lua", "auth", conf)
            u.ws = ws
            u.fd = fd
            forwarding[fd] = u
            return true
        end
    end
    return false
end

-- handler
function server.on_open(id)
    log.info(string.format("%d::open", id))
    skynet.error("New client from : " .. id)
    -- log.info("New client from : %d", ws.id)
end

function server.on_message(id, message)
    -- if forwarding[ws.id] then
    --     if forwarding[ws.id] and forwarding[ws.id].agent then
    --         skynet.redirect(forwarding[ws.id].agent, skynet.self(), "client", 1, message)
    --     end
    -- else
    --     log.info("wsgate auth: %s", message)
    --     if not server.start_handler(message, ws.id, ws) then
    --         ws:send_text("500")
    --         ws:close()
    --     else
    --         ws:send_text("200")
    --     end
    -- end
    -- ws:send_text(message .. "from server")
    -- ws:close()
    websocket.send(id, message)
end

function server.on_close(id, code, reason)
    log.info(string.format("%d close:%s  %s", ws.id, code, reason))
    server.disconnect_handler(ws.id)
end

-- cmd
local CMD = {}

function CMD.start()
    return skynet.call(".wslogind", "lua", "register_gate", "sample1", skynet.self(), "gated")
end

function CMD.kick(uid, subid)
    return server.kick_handler(uid, subid)
end

function CMD.login(uid, secret)
    return server.login_handler(uid, secret)
end

function CMD.logout(uid, subid)
    return server.logout_handler(uid, subid)
end

function CMD.push_client(id, args)
    if forwarding[id] and forwarding[id].ws then
        forwarding[id].ws:send_binary(args)
    end
    return servicecode.NORET
end

function server.command_handler(command, ...)
	local f = assert(CMD[command])
	return f(...)
end

websocket.listen(MODE, server, "wsgated:9948")
