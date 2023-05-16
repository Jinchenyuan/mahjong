local skynet = require "skynet"
local savedata = require "savedata"
local model = require "chestnut.chat.model"
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

function CMD.create_chat_session()
end

------------------------------------------
-- 登陆
function CMD.login(u)
    objmgr.add(u)
    return model.login(u)
end

function CMD.logout(uid)
    model.logout(uid)
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
function CMD.create_chat_session(uid, args)
    local u = objmgr.get(uid)
    return skynet.call(".CHAT_MGR", "lua", "create_chat_session", uid, args)
end

function CMD.say(uid, args)
    local u = objmgr.get(uid)
    return skynet.call(".CHAT_MGR", "lua", "say", uid, args)
end

return CMD
