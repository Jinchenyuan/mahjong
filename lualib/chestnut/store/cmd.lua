local skynet = require "skynet"
local savedata = require "savedata"
local model = require "chestnut.store.model"
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
    return model.logout(u)
end

function CMD.auth(u)
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

function CMD.fetch_store_items(uid, args)
    local u = objmgr.get(uid)
    return model.fetch_store_items(u, args)
end

function CMD.fetch_store_item(uid, args)
    local u = objmgr.get(uid)
    return model.fetch_store_item(u, args)
end

function CMD.buy_store_item(uid, args)
    local u = objmgr.get(uid)
    return model.buy_store_item(u, args)
end

return CMD
