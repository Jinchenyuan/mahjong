local skynet = require "skynet"
local log = require "chestnut.skynet.log"
local db_write = require "dbwrite.db_write"
local util = require "db.util"
local service = require "service"
local table_dump = require "luaTableDump"
local ctx
local QUERY = {}

function QUERY.start(...)
	local db = util.connect_mysql()
	ctx = {db = db, dump = util.dump}
	return service.OK
end

function QUERY.close()
	util.disconnect_mysql(db)
	return service.OK
end

function QUERY.kill()
	skynet.exit()
end

------------------------------------------
-- 写数据
function QUERY.write_account(db_account)
	log.debug("start write account")
	db_write.write_account(ctx, db_account)
	return service.NORET
end

function QUERY.write_nameid(d)
	skynet.error(table_dump(d))
	db_write.write_nameid(ctx, d)
	return service.NORET
end

function QUERY.write_auth(data)
	return service.NORET
end

function QUERY.write_union(db_union)
	return service.NORET
end

function QUERY.write_user(data)
	db_write.write_user(ctx, data.db_user)
	db_write.write_user_funcopen(ctx, data.db_funcs)
	return service.NORET
end

function QUERY.write_user_room(data)
	db_write.write_user_room(ctx, data)
	return service.NORET
end

function QUERY.write_user_package(data)
	db_write.write_user_package(ctx, data)
	return service.NORET
end

function QUERY.write_user_achievement(data)
	db_write.write_user_achievement(ctx, data)
	return service.NORET
end

function QUERY.write_user_friends(data)
	db_write.write_user_friends(ctx, data)
	return service.NORET
end

function QUERY.write_user_heros(item)
	db_write.write_user_heros(ctx, item)
	return service.NORET
end

function QUERY.write_sysmail()
	return service.NORET
end

function QUERY.write_room_mgr(data)
	db_write.write_room_mgr_users(ctx, data.db_users)
	db_write.write_room_mgr_rooms(ctx, data.db_rooms)
	return service.NORET
end

function QUERY.write_room(data)
	db_write.write_room_users(ctx, data.db_users)
	db_write.write_room(ctx, data.db_room)
	return service.NORET
end

function QUERY.write_zset(tname, data)
	db_write.write_zset(ctx, tname, data)
	return service.NORET
end

function QUERY.write_teams(data)
	db_write.write_teams(ctx, data)
	return service.NORET
end

function QUERY.write_events(data)
	db_write.write_events(data)
	return service.NORET
end

------------------------------------------
-- 修改离线数据
function QUERY.write_offuser_room(db_user_room)
	db_write.write_offuser_room_created(ctx, db_user_room)
	return service.NORET
end

-------------------------------------------------------------end

local _M = {}

_M.host = QUERY

local address = nil
local function get_address()
	if not address then
		address = skynet.uniqueservice "dbwrite"
	end
	return address
end

------------------------------------------
-- 写数据
function _M.write_account(account)
	local handle = get_address()
	skynet.send(handle, "lua", "write_account", account)
end

function _M.write_union(union)
	local handle = get_address()
	skynet.send(handle, "lua", "write_union", union)
end

function _M.write_nameid(d)
	local handle = get_address()
	skynet.send(handle, "lua", "write_nameid", d)
end

function _M.write_user(user)
	local handle = get_address()
	skynet.send(handle, "lua", "write_user", user)
end

function _M.write_user_room(data)
	db_write.write_user_room(ctx, data)
	skynet.send(handle, "lua", "write_user_room", data)
end

function _M.write_user_package(data)
	local handle = get_address()
	skynet.send(handle, "lua", "write_user_package", data)
end

function _M.write_user_achievement(data)
	local handle = get_address()
	skynet.send(handle, "lua", "write_user_achievement", data)
end

function _M.write_user_friends(data)
	local handle = get_address()
	skynet.send(handle, "lua", "write_user_friends", data)
end

function _M.write_user_heros(item)
	local handle = get_address()
	skynet.send(handle, "lua", "write_user_heros", item)
end

function _M.write_zset(tname, data)
	local handle = get_address()
	skynet.send(handle, "lua", "write_zset", tname, data)
end

function _M.write_teams(data)
	local handle = get_address()
	return skynet.send(handle, "lua", "write_teams", data)
end

function _M.write_room_mgr(data)
	local handle = get_address()
	return skynet.send(handle, "lua", "write_room_mgr", data)
end

function _M.write_events(data)
	local handle = get_address()
	return skynet.send(handle, "lua", "write_events", data)
end

return _M
