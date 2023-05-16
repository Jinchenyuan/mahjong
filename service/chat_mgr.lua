local skynet = require "skynet"
local log = require "chestnut.skynet.log"
local service = require "service"
local client = require "client"
local assert = assert
local objmgr = require "objmgr"

local rooms = {} -- 房间聊天
local CMD = {}

function CMD.start()
	return true
end

function CMD.init_data()
	return true
end

function CMD.sayhi()
	return true
end

function CMD.close()
	return true
end

function CMD.kill()
	skynet.exit()
end

------------------------------------------
-- 登陆
function CMD.login(u)
	objmgr.add(u)
	return true
end

function CMD.logout(uid)
	objmgr.del(uid)
end

function CMD.auth(args)
	local u = objmgr.get(args.uid)
	u.fd = args.fd
	u.authed = true
	return true
end

function CMD.enter(uid)
	return true
end

------------------------------------------
-- 房间信息
function CMD.room_create(room_id, addr)
	assert(room_id and addr)
	assert(rooms[room_id] == nil)
	rooms[room_id] = {}
	rooms[room_id].addr = addr
	rooms[room_id].users = {}
	return true
end

function CMD.room_init_users(room_id, xusers)
	local room = rooms[room_id]
	for k, v in pairs(xusers) do
		room.users[k] = {uid = v.uid}
	end
	return true
end

function CMD.room_join(room_id, uid, agent)
	local u = objmgr.get(uid)
	local room = rooms[room_id]
	room.users[uid] = u
	return true
end

function CMD.room_rejoin(room_id, uid, agent)
	assert(room_id and uid and agent)
	local u = objmgr.get(uid)
	local room = assert(rooms[room_id])
	return true
end

function CMD.room_afk(room_id, uid)
	assert(room_id and uid)
	local room = assert(rooms[room_id])
	local user = assert(room.users[uid])
	user.agent = nil
	return true
end

function CMD.room_leave(room_id, uid)
	assert(room_id and uid)
	local room = rooms[room_id]
	if room then
		room.users[uid] = nil
	else
		log.error("room(%d) leave", room_id)
	end
	return true
end

function CMD.room_recycle(room_id)
	-- body
	rooms[room_id] = nil
	return true
end

function CMD.say(from, to, word)
	if rooms[to] then
		local room = rooms[to]
		for _, v in pairs(room) do
			if users[v] then
				skynet.send(users[v].agent, "lua", "say", from, word)
			end
		end
	elseif users[to] then
		skynet.send(users[to].agent, "lua", "say", from, word)
	end
end

service.init {
	name = ".CHAT_MGR",
	command = CMD
}
