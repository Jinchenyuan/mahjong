local skynet = require "skynet"
local sd = require "skynet.sharetable"
local objmgr = require "objmgr"
local servicecode = require "enum.servicecode"
local dbc = require "dbread.db"
local _M = {}
local shop_cfg
local table_insert = table.insert

skynet.init(
    function()
        shop_cfg = sd.query("ShopConfig")
    end
)

function _M.init_data()
    return true
end

function _M.save_data()
end

function _M.login(u)
    return true
end

function _M.logout(u)
    return true
end

function _M.on_enter(u)
    -- objmgr.a
    return true
end

function _M.fetch_store_items(u, args)
    local items = {}
    for k, v in pairs(shop_cfg) do
        item = {}
        item.id = v.sid
        table_insert(items, item)
    end
    return {
        errorcode = 0,
        items = items
    }
end

function _M.fetch_store_item(u, args)
end

function _M.buy_store_item(u, args)
end

return _M
