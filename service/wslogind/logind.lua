local skynet = require "skynet"
local crypt = require "skynet.crypt"
local websocket = require "simplewebsocket"
local log = require "chestnut.skynet.log"
local servicecode = require "enum.servicecode"
local service = require "service"

local verify
local server_list = {}
local user_online = {}
local server_handler = {}
local MODE = ...

function server_handler.auth_handler(token)
    -- the token is base64(user)@base64(server):base64(password)
    local user, server, password = token:match("([^@]+)@([^:]+):(.+)")
    user = crypt.base64decode(user)
    server = crypt.base64decode(server)
    password = crypt.base64decode(password)
    assert(password == "Password", "Invalid password")
    log.info("auth_handler %s@%s:%s", user, server, password)
    local res = skynet.call(verify, "lua", "signup", server, user, password)
    if res.code == 200 then
        return server_handler.login_handler(server, res.uid)
    else
        log.error("signup server return code is not 200.")
        return string.format("%d", res.code)
    end
end

function server_handler.login_handler(server, uid, secret)
    log.info(string.format("%s@%s is login, secret is", uid, server))
    local gameserver = assert(server_list[server], "Unknown server")
    -- only one can login, because disallow multilogin
    local last = user_online[uid]
    if last then
        log.info("uid(%d) logined again, will kick last address(%d), begin ---------- ", uid, last.address)
        local ok = skynet.call(last.address, "lua", "kick", uid, last.subid)
        if not ok then
            log.error("kick uid(%d) failture, so you can not login.", uid)
            error(string.format("kick uid(%d) failture", uid))
        else
            log.info("uid(%d) logined again, last address has logout, end ---------- ", uid)
        end
    end
    if user_online[uid] then
        error(string.format("user %s is already online", uid))
    end
    local res = skynet.call(gameserver.address, "lua", "login", uid, "secret")
    if res.errorcode == servicecode.SUCCESS then
        user_online[uid] = { address = gameserver.address, subid = res.subid , server = server}
        local gated = gameserver.gated

        local key = string.format("200#%d:%d@%s", uid, res.subid, gated)
        return key
    elseif res.errorcode == servicecode.LOGIN_AGENT_LOAD_ERR then
        log.error("LOGIN_AGENT_LOAD_ERR.")
        return string.format("%d", res.errorcode)
    else
        error("gen subid is wrong")
    end
end

function server_handler.on_open(id)
    log.info(string.format("%d::open", id))
    skynet.error("New client from : " .. id)
end

function server_handler.on_message(id, message)
    -- local ok, err = pcall(server_handler.auth_handler, message)
    -- if ok then
    --     ws:send_text(err)
    --     ws:close()
    -- else
    --     log.error(err)
    --     ws:send_text("500")
    --     ws:close()
    -- end
    websocket.send(id, message)
end

function server_handler.on_close(id, code, reason)
    log.info(string.format("%d close:%s  %s", id, code, reason))
end

local CMD = {}

function CMD.register_gate(server, address, gated)
	local s = {
		address = address,
		gated = gated,
	}
	server_list[server] = s
	return true
end

function CMD.logout(uid, subid)
	local u = user_online[uid]
	if u then
		log.info(string.format("%s@%s is logout", uid, u.server))
		local err = gserver.call(u.address, 'lua', 'kick', uid, subid)
		if err == servicecode.SUCCESS then
			user_online[uid] = nil
		end
		return err
	else
		log.error("logined service logout failture, uid: %d, subid: %d", uid, subid)
		return servicecode.FAIL
	end
end

function server_handler.command_handler(command, ...)
	local f = assert(CMD[command])
	return f(...)
end

local client_handler = {}

skynet.register_protocol {
    name = "client",
    id = skynet.PTYPE_CLIENT,
    pack = function(m) return skynet.pack(m) end,
    -- unpack = skynet.tostring,
}

websocket.listen(MODE, server_handler, 'wslogind:9189')
