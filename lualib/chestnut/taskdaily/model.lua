local skynet = require "skynet"
local objmgr = require "objmgr"
local log = require "chestnut.skynet.log"

local _M = {}

-- 初始服务整个数据
function _M.init_data()
    return true
end

function _M.save_data()
    -- 存储所有用户数据
end

function _M.login(u)
    log.debug("load user data")
    return {
        errorcode = 0
    }
end

function _M.logout(u)
    log.debug("unload user data")
    return {
        errorcode = 0
    }
end

function _M.on_enter(u)
    log.debug("uid taskdaily enter", u)
    return {
        errorcode = 0
    }
end

function _M.fetch_dailytasks(u, args)
    return {
        errorcode = 0
    }
end

return _M
