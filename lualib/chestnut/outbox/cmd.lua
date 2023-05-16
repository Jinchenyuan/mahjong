local skynet = require "skynet"
local savedata = require "savedata"
local model = require "chestnut.outbox.model"
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

function CMD.test_mail(ctx)
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

return CMD
