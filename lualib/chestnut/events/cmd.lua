local skynet = require "skynet"
local savedata = require "savedata"
local model = require "chestnut.store.model"
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
-- 协议

-- 注册事件
function CMD.on(uid)
    local u = objmgr.get(u)
    return model.init_data(u)
end

function CMD.omit(uid)
end

return CMD
