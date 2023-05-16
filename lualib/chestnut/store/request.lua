local skynet = require "skynet"
local objmgr = require "objmgr"
local REQUEST = require "request"
local log = require "chestnut.skynet.log"

function REQUEST.fetch_store_items(fd, args)
    log.debug("---------------------------------------fetch_store_items")
    local obj = objmgr.get_by_fd(fd)
    if obj.mod_user.level < 10 then
        return {
            errorcode = 10
        }
    end
    return skynet.call(".STORE", "lua", "fetch_store_items", obj.uid, args)
end

function REQUEST.fetch_store_item(fd, args)
    local obj = objmgr.get_by_fd(fd)
    return skynet.call(".STORE", "lua", "fetch_store_item", obj.uid, args)
end

function REQUEST.buy_store_item(fd, args)
    local obj = objmgr.get_by_fd(fd)
    return skynet.call(".STORE", "lua", "buy_store_item", obj.uid, args)
end

return REQUEST
