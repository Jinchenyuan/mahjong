-- 这个文件会被agent里的同名文件引用
local skynet = require "skynet"
local log = require "chestnut.skynet.log"
local servicecode = require "enum.servicecode"
local REQUEST = require "request"
local objmgr = require "objmgr"
local room = require "chestnut.room.model"

function REQUEST.room_info(fd, args)
	local ok, err = pcall(self.systems.room.room_info, self.systems.room, args)
	if ok then
		return err
	else
		log.error("uid(%d) REQUEST = [room_info], error = [%s]", self.uid, err)
		local res = {}
		res.errorcode = 1
		return res
	end
end

------------------------------------------
-- 麻将协议
function REQUEST.match(fd, args)
	local u = objmgr.get(fd)
	return skynet.call(".ROOM", "lua", "match", args)
end

function REQUEST.create(args)
	local u = objmgr.get(fd)
	return room.create(u, args)
end

function REQUEST.join(fd, args)
	local u = objmgr.get(fd)
	return room.join(u, args)
end

function REQUEST.rejoin(fd)
	local u = objmgr.get(fd)
	return room.rejoin(u)
end

function REQUEST.leave(fd, args)
	local u = objmgr.get(fd)
	return room.leave(u, args)
end

function REQUEST.ready(fd, args, ...)
	local u = objmgr.get(fd)
	return M:forward_room("ready", args, ...)
end

function REQUEST.call(fd, args, ...)
	local u = objmgr.get(fd)
	local M = self.systems.room
	return M:forward_room("call", args, ...)
end

-- 此协议已经无效
function REQUEST:shuffle(args, ...)
	-- body
	local M = self.systems.room
	return M:forward_room("shuffle", args, ...)
end

-- 此协议已经无效
function REQUEST:dice(args, ...)
	local M = self.systems.room
	return M:forward_room("dice", args, ...)
end

function REQUEST:lead(args, ...)
	local M = self.systems.room
	return M:forward_room("lead", args, ...)
end

function REQUEST:step(args, ...)
	local M = self.systems.room
	return M:forward_room("step", args, ...)
end

function REQUEST:restart(args, ...)
	local M = self.systems.room
	return M:forward_room("restart", args, ...)
end

function REQUEST:xuanpao(args, ...)
	local M = self.systems.room
	return M:forward_room("xuanpao", args, ...)
end

function REQUEST:xuanque(args, ...)
	local M = self.systems.room
	return M:forward_room("xuanque", args, ...)
end

------------------------------------------
-- 大佬2协议
function REQUEST.big2call(fd, ...)
	local u = objmgr.get(fd)
	return self.systems.room:forward_room("call", ...)
end

function REQUEST:big2step(...)
	return self.systems.room:forward_room("step", ...)
end

function REQUEST:big2restart(...)
	return self.systems.room:forward_room("restart", ...)
end

function REQUEST:big2ready(...)
	return self.systems.room:forward_room("ready", ...)
end

function REQUEST:big2match(...)
	return self.systems.room:match(...)
end

function REQUEST:big2create(...)
	return self.systems.room:create(...)
end

function REQUEST:big2join(...)
	return self.systems.room:join(...)
end

function REQUEST:big2rejoin(...)
	return self.systems.room:rejoin(...)
end

function REQUEST:big2leave(...)
	-- body
	return self.systems.room:leave(...)
end

------------------------------------------
-- 德州协议
function REQUEST.pokercall(fd, ...)
	return self.systems.room:forward_room("call", ...)
end

function REQUEST:pokerstep(...)
	return self.systems.room:forward_room("step", ...)
end

function REQUEST:pokerrestart(...)
	return self.systems.room:forward_room("restart", ...)
end

function REQUEST:pokerready(...)
	return self.systems.room:forward_room("ready", ...)
end

function REQUEST:pokermatch(...)
	return self.systems.room:match(...)
end

function REQUEST:pokercreate(...)
	return self.systems.room:create(...)
end

function REQUEST:pokerjoin(...)
	return self.systems.room:join(...)
end

function REQUEST:pokerrejoin(...)
	return self.systems.room:rejoin(...)
end

function REQUEST:pokerleave(...)
	return self.systems.room:leave(...)
end

function REQUEST:pokerjoined(...)
	return self.systems.room:forward_room("joined", ...)
end

------------------------------------------
-- 球球大作战协议
--

return REQUEST
