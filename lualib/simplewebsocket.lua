local skynet = require "skynet"
local socket = require "skynet.socket"
local service = require "skynet.service"
local websocket = require "http.websocket"
local log = require "chestnut.skynet.log"
local xservice = require "service"

local online = {}
local _M = {}

function _M.listen(MODE, server, target)
    if MODE == "agent" then
        local handle = {}

        function handle.connect(id)
            local addr = websocket.addrinfo(id)
            online[id] = {
                id = id,
                addr = addr
            }
            local f = server.on_open
            if f then
                f(id)
            end
        end
    
        function handle.handshake(id, header, url)
            local addr = websocket.addrinfo(id)
            skynet.error("ws handshake from: " .. tostring(id), "url", url, "addr:", addr)
            skynet.error("----header-----")
            for k,v in pairs(header) do
                skynet.error(k,v)
            end
            skynet.error("--------------")
        end
    
        function handle.message(id, msg)
            local f = assert(server.on_message)
            f(id, message)
            -- websocket.write(id, msg)
        end
    
        function handle.ping(id)
            print("ws ping from: " .. tostring(id) .. "\n")
        end
    
        function handle.pong(id)
            print("ws pong from: " .. tostring(id))
        end
    
        function handle.close(id, code, reason)
            print("ws close from: " .. tostring(id), code, reason)
        end
    
        function handle.error(id)
            print("ws error from: " .. tostring(id))
        end
    
        local CMD = {}

        function CMD.accept(id, protocol, addr)
            local ok, err = websocket.accept(id, handle, protocol, addr)
            if not ok then
                log.error("%s", err)
            end
            return xservice.NORET
        end

        function CMD.id(id)
            local addr = websocket.addrinfo(id)
            return addr
        end

        CMD.ping = server.ping

        function CMD.command(cmd, ... )
            local f = assert(server.command_handler)
            f(cmd, ...)
        end

        xservice.init({
            command = CMD
        })
    else
        skynet.start(function ()
            local agent = {}
            for i= 1, 20 do
                agent[i] = skynet.newservice(SERVICE_NAME, "agent")
            end
            local arr = string.split(target, ':')
            local port = math.tointeger(arr[2])
            local balance = 1
            local protocol = "ws"
            local id = socket.listen("0.0.0.0", port)
            skynet.error(string.format("Listen websocket port %d protocol:%s", port, protocol))
            socket.start(id, function(id, addr)
                print(string.format("accept client socket_id: %s addr:%s", id, addr))
                skynet.send(agent[balance], "lua", "accept", id, protocol, addr)
                balance = balance + 1
                if balance > #agent then
                    balance = 1
                end
            end)
            skynet.register(arr[1])
        end)
    end
end

function _M.send(id, msg)
    if online[id] then
        websocket.write(id, msg)
    end
end

function _M.close(id)
    if online[id] then
        websocket.close(id)
    end
end

function _M.addr(id)
end

return _M
