local skynet = require "skynet"
local socket = require "skynet.socket"
local crypt = require "skynet.crypt"
local log = require "chestnut.skynet.log"
local kcp = require "lkcp"
local service = require "service"
local _M = {}
local U = {}
local SESSION = 0

local function udpdispatch(str, from)
	if K then
		address = from
		K:input(str)
	else
		log.error('K is invalid')
	end
end

local function kcpsend(str, info)
	if K then
		socket.sendto(U, address, str)
	else
		log.error("Session is invalid %d")
	end
end

local function loop(id)
    local K = k
    while true do
        K:update()
        local str = K:recv()
		if str then
			dispatch(str, address)
		end
		skynet.sleep(6000)	
    end
end

-- 监听
function _M.udp(handler, target)
    local arr = string.split(target, ":")
    local host = arr[1]
	local port = arr[2]
	local k = kcp(kcpsend)
	local u = socket.udp(udpdispatch, host, port)
	U[u] = {
		u = u,
		k = k,
	}
end

-- 链接
function _M.connect(handler, id, target)
	local arr = string.split(target, ":")
    local host = arr[1]
	local port = arr[2]
	socket.udp_connect(id, host, port, udpdispatch)
end

function _M.sendto(id, msg)
end

function _M.close(id)
end

return _M