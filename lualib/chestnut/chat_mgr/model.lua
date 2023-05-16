local skynet = require "skynet"
local sd = require "skynet.sharedata"
local snowflake = require "chestnut.snowflake"
local log = require "chestnut.skynet.log"
local client = require "client"
local objmgr = require "objmgr"
local _M = {}
local roomid = 0
local rooms = {} -- 房间聊天

skynet.init(
	function()
	end
)

function _M.init()
	local room = {id = roomid}
	rooms[room.id] = room
end

function _M.init_data()
	return true
end

function _M.save_data()
	return true
end

function _M.login(u)
	return true
end

function _M.logout(u)
	objmgr.del(u)
	return true
end

function _M.on_enter()
	return true
end

------------------------------------------
-- 逻辑

function _M.create_chat_session(u, args)
	roomid = roomid + 1
	local room = {
		session = roomid,
		users = {u.uid}
	}
	rooms[roomid] = room
	local ret = {
		errorcode = 0,
		session = roomid
	}
	client.push(u, "create_chat_session", ret)
	return {errorcode = 0}
end

function _M.say(u, args)
	local room = rooms[args.session]
	local users = room.users
	for _, id in ipairs(users) do
		local xu = objmgr.get(id)
		local ret = {
			errorcode = 0,
			session = roomid,
			sid = args.sid,
			p = args.p
		}
		client.push(xu, "say", ret)
	end
	return {errorcode = 0}
end

return _M
