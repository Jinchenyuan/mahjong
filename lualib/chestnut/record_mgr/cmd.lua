local skynet = require "skynet"
local model = require "chestnut.record_mgr.model"
local savedata = require "savedata"
local CMD = require "cmd"
local SUB = {}

function SUB.save_data()
    context.save_data()
end

function CMD.start()
    savedata.init {
        command = SUB
    }
    savedata.subscribe()
    return true
end

function CMD.init_data()
    return context.init_data()
end

function CMD.sayhi()
    return true
end

function CMD.close()
    context.save_data()
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
    return model.save_user(u)
end

function CMD.auth(u)
    local u = objmgr.get(args.uid)
    u.fd = args.fd
    u.authed = true
    return true
end

function CMD.enter(uid)
    local u = objmgr.get(uid)
    return true
end

------------------------------------------
-- 协议
function CMD.fetch_record(uid, id)
end

return CMD
