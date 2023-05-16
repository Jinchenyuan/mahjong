local skynet = require "skynet"
local service = require "service"
local log = require "chestnut.skynet.log"
local model = require "chestnut.chat_mgr.model"
local savedata = require "savedata"
local objmgr = require "objmgr"
local traceback = debug.traceback
local assert = assert
local CMD = {}
local SUB = {}

function SUB.save_data()
	model.save_data()
end

function CMD.start()
	savedata.init {
		command = SUB
	}
	savedata.subscribe()
	return true
end

function CMD.init_data()
	model.init_data()
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
	return model.login(u)
end

function CMD.logout(uid)
	local u = objmgr.get(args.uid)
	return model.logout(u)
end

function CMD.auth(args)
	local u = objmgr.get(args.uid)
	u.fd = args.fd
	u.authed = true
	return true
end

function CMD.enter(uid)
	local u = objmgr.get(args.uid)
	return model.on_enter(u)
end

------------------------------------------
-- 协议

function CMD.create_chat_session(uid, args)
	local u = objmgr.get(uid)
	return model.create_chat_session(u, args)
end

function CMD.say(uid, args)
	local u = objmgr.get(uid)
	return model.say(u, args)
end

return CMD
