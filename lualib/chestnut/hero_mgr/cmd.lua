local skynet = require "skynet"
local savedata = require "savedata"
local model = require "chestnut.hero_mgr.model"
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
    return model.login(u)
end

function CMD.logout(uid)
    local u = objmgr.get(uid)
    return model.save_user(u)
end

function CMD.enter(uid)
    local u = objmgr.get(uid)
end

function CMD.fetch_heros(uid, args)
    local u = objmgr.get(u)
    return model.fetch_heros(u, args)
end

function CMD.unlock_hero(uid, args)
    local u = objmgr.get(u)
    return model.fetch_heros(u, args)
end

return CMD
