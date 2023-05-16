local skynet = require "skyent"
local savedata = require "savedata"
local model = require "chestnut.friend.model"
local CMD = require "cmd"
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
-- gameplay 协议
function CMD.fetch_friends(uid, args)
end

function CMD.add_friend_req(obj, args)
	return self:query(session)
end

return CMD
