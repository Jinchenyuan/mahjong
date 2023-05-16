local skynet = require "skynet"
local objmgr = require "objmgr"
local dbc = require "dbread.db"
local dbw = require "dbwrite.db"
local json = require "rapidjson"
local luaTableDump = require "luaTableDump"
local _M = {}
local teams = {}

function _M.init_data()
    local d = dbc.read_teams()
    if d then
        for _, it in pairs(d) do
            local item = {}
            item.id = it.id
            item.name = it.name
            item.simple = it.simple
            item.power = it.power
            item.join_tp = it.join_tp
            item.join_cond = it.join_cond
            item.y = false
            teams[item.id] = item
        end
    end
    return true
end

function _M.save_data()
    for _, it in pairs(teams) do
        if it.y then
            local item = {}
            item.id = it.id
            item.name = it.name
            item.simple = it.simple
            item.power = it.power
            item.join_tp = it.join_tp
            item.join_cond = it.join_cond
            dbw.write_teams(item)
        end
    end
end

function _M.login(u)
    return true
end

function _M.logout(u)
    return true
end

function _M.on_enter(u)
    return true
end

function _M.fetch_teams(uid, args)
    local obj = objmgr.get(uid)
    return {
        errorcode = 0,
        teams = {}
    }
end

function _M.fetch_team(uid, args)
    local obj = objmgr.get(uid)
    return {
        errorcode = 0,
        team = {}
    }
end

function _M.create_team(uid, args)
    return {
        errorcode = 0,
        id = 0
    }
end

function _M.join_team(uid, args)
    return {
        errorcode = 0
    }
end

function _M.fetch_myteams(uid, args)
    return {
        errorcode = 0,
        teams = {}
    }
end

function _M.quit_team(uid, args)
    return {
        errorcode = 0
    }
end

return _M
