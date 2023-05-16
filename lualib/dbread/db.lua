local skynet = require "skynet"
local log = require "chestnut.skynet.log"
local db_read = require "dbread.db_read"
local util = require "db.util"
local address
local ctx
local QUERY = {}

local function get_address()
	if not address then
		address = skynet.uniqueservice "db"
	end
	return address
end

function QUERY.start(...)
	local db = util.connect_mysql()
	ctx = {db = db, dump = util.dump}
	return true
end

function QUERY.close()
	util.disconnect_mysql(db)
end

function QUERY.kill()
	skynet.exit()
end

------------------------------------------
-- read data
function QUERY.read_account_by_username(username, password)
	local res = {}
	local accounts = db_read.read_account_by_username(ctx, username, password)
	if #accounts == 1 then
		local users = db_read.read_users_by_uid(ctx, accounts[1].uid)
		res.accounts = accounts
		res.users = users
	end
	return res
end

function QUERY.read_auth_by_openid(openid)
end

function QUERY.read_user(uid)
	local res = {}
	res.db_users = db_read.read_users_by_uid(ctx, uid)
	res.db_user_funcopens = db_read.read_user_funcopens(ctx, uid)
	res.db_user_rooms = db_read.read_room_users(ctx, uid)
	return res
end

function QUERY.read_user_bag(uid)
	return db_read.read_user_packages(ctx, uid)
end

function QUERY.read_user_rooms(uid)
	local res = {}
	res.db_user_rooms = db_read.read_user_rooms(ctx, uid)
	return
end

function QUERY.read_user_heros(uid)
	return db_read.read_user_heros(ctx, uid)
end

function QUERY.read_user_friends(uid)
	return db_read.read_user_friends(ctx, uid)
end

function QUERY.read_user_friend_reqs()
	return db_read.read_user_friend_reqs(ctx)
end

function QUERY.read_user_inbox(uid)
	return db_read.read_user_inbox(ctx, uid)
end

function QUERY.read_user_outbox(uid)
	return db_read.read_user_outbox(ctx, uid)
end

function QUERY.read_sysmail()
	return db_read.read_sysmail(ctx)
end

function QUERY.read_room_mgr()
	local res = {}
	res.db_users = db_read.read_room_mgr_users(ctx)
	res.db_rooms = db_read.read_room_mgr_rooms(ctx)
	return res
end

function QUERY.read_room(id)
	local res = {}
	res.db_rooms = db_read.read_room(ctx, id)
	res.db_users = db_read.read_room_users(ctx, id)
	return res
end

function QUERY.read_zset(tname)
	local res = {}
	res[tname] = db_read.read_zset(ctx, tname)
	return res
end

function QUERY.read_teams()
	return db_read.read_teams(ctx)
end

function QUERY.read_achievements()
end

function QUERY.read_events(key)
	return db_read.read_events(key)
end

-------------------------------------------------------------end

local _M = {}

_M.host = QUERY

function _M.read_sysmail()
	local handle = get_address()
	return skynet.call(handle, "lua", "read_sysmail")
end

function _M.read_events(key)
	local handle = get_address()
	return skynet.call(handle, "lua", "read_events", key)
end

function _M.read_account_by_username(username, password)
	local handle = get_address()
	return skynet.call(handle, "lua", "read_account_by_username", username, password)
end

function _M.read_user(uid)
	local handle = get_address()
	return skynet.call(handle, "lua", "read_user", uid)
end

function _M.read_user_bag(uid)
	local handle = get_address()
	return skynet.call(handle, "lua", "read_user_bag", uid)
end

function _M.read_user_friend_reqs()
	local handle = get_address()
	return skynet.call(handle, "lua", "read_user_friend_reqs")
end

function _M.read_user_heros(uid)
	local handle = get_address()
	return skynet.call(handle, "lua", "read_user_heros", uid)
end

function _M.read_user_friends(uid)
	local handle = get_address()
	return skynet.call(handle, "lua", "read_user_friends", uid)
end

function _M.read_user_inbox(uid)
	local handle = get_address()
	return skynet.call(handle, "lua", "read_user_inbox", uid)
end

function _M.read_user_outbox(uid)
	local handle = get_address()
	return skynet.call(handle, "lua", "read_user_outbox", uid)
end

function _M.read_room_mgr()
	local handle = get_address()
	return skynet.call(handle, "lua", "read_room_mgr")
end

function _M.read_room(roomid)
	local handle = get_address()
	return skynet.call(handle, "lua", "read_room", roomid)
end

function _M.read_zset(tname)
	local handle = get_address()
	return skynet.call(handle, "lua", "read_zset", tname)
end

function _M.read_teams()
	local handle = get_address()
	return skynet.call(handle, "lua", "read_teams")
end

function _M.read_achievements()
end

return _M
