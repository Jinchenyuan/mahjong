local skynet = require "skynet"
local savedata = require "savedata"
local CMD = require "cmd"
local context = require "chestnut.ballroom.model"
local SUB = {}

function SUB.save_data()
end

function SUB.update()
end

function CMD.start()
	savedata.init {
		command = SUB
	}
	savedata.subscribe()
	return true
end

function CMD.init_data()
	return true
end

function CMD.sayhi()
	return true
end

function CMD.save_data()
end

function CMD.close()
	return true
end

function CMD.kill()
	skynet.exit()
end

------------------------------------------
-- 房间协议
function CMD.create(uid, agent, mode, args)
	return context.create(uid, agent, mode, args)
end

function CMD.join(uid, agent, ...)
	return context.join(agent.uid, agent.agent, agent.name, agent.sex, agent.secret)
end

function CMD.rejoin(uid, args)
	return context.rejoin(args.uid, args.agent)
end

function CMD.afk(uid)
	return context.afk(uid)
end

function CMD.leave(uid)
	return context.leave(uid)
end

------------------------------------------
-- gameplay 协议
function CMD.query(uid, session)
	return context.query(uid, session)
end

function CMD.born(uid, session, ...)
	return context.born(uid, session, ...)
end

function CMD.opcode(uid, session, args, ...)
	return context.opcode(uid, session, args, ...)
end

return CMD
