local skynet = require "skynet"
local model = require "chestnut.achievement.model"
local savedata = require "savedata"
local objmgr = require "objmgr"
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
    return model.login(uid)
end

function CMD.logout(uid)
    return true
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
-- 协议

return CMD
