local skynet = require "skynet"
local savedata = require "savedata"
local model = require "chestnut.taskdaily.model"
local CMD = require "cmd"
local objmgr = require "objmgr"
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
	return model.init_data()
end

function CMD.sayhi()
	return true
end

function CMD.close()
	model.save_data()
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
	local u = objmgr.get(uid)
	return model.logout(u)
end

function CMD.auth(args)
	local u = objmgr.get(args.uid)
	u.fd = args.fd
	u.authed = true
	return true
end

function CMD.enter(uid)
	local u = objmgr.get(uid)
	return model.on_enter(u)
end

------------------------------------------
-- 协议
function CMD.fetch_dailytasks(uid, args, ...)
	return model.fetch_dailytasks(uid, args, ...)
end

return CMD
