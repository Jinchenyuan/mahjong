local skynet = require "skynet"
local savedata = require "savedata"
local model = require "chestnut.checkin.model"
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

return CMD
