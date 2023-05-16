local skynet = require "skynet"
local log = require "chestnut.skynet.log"
local servicecode = require "enum.servicecode"
local logout = require "chestnut.agent.logout"
local objmgr = require "objmgr"
local client = require "client"
local dbc = require "dbread.db"
local dbw = require "dbwrite.db"
local table_dump = require "luaTableDump"
local FuncOpenSystem = require "chestnut.systems.funcopen"
local user = require "chestnut.systems.user"
local room = require "chestnut.room.model"
local _M = {}
local assert = assert
local _reload = false

local function init_data(obj)
	local uid = obj.uid
	log.info("uid(%d) load_cache_to_data", uid)
	local res = dbc.read_user(uid)
	-- init system
	user.on_data_init(obj, res)
	FuncOpenSystem.on_data_init(obj, res)
	room.on_data_init(obj, res)

	-- 登陆每个模块
	local u = {uid = obj.uid, agent = skynet.self()}

	-- 公共数据
	skynet.call(".RADIO_MGR", "lua", "login", u)
	skynet.call(".CHAT_MGR", "lua", "login", u)
	skynet.call(".MAIL_MGR", "lua", "login", u)

	-- 用户数据模块
	skynet.call(".BAG", "lua", "login", u)
	skynet.call(".HERO", "lua", "login", u)
	skynet.call(".TASKDAILY", "lua", "login", u)
	skynet.call(".INBOX", "lua", "login", u)
	skynet.call(".OUTBOX", "lua", "login", u)
	skynet.call(".CHAT", "lua", "login", u)

	return servicecode.SUCCESS
end

function _M.init_data()
	-- 初始化agent服务的公共数据
end

function _M.sayhi(reload)
	-- 重连的时候，auth函数用此判断
	_reload = reload
	return true
end

function _M.close()
	return true
end

function _M.kill()
end

function _M.save_data()
	objmgr.foreach(
		function(obj)
			if obj.authed then
				logout.save_data(obj)
			end
		end
	)
end

function _M.login(gate, uid, subid, secret)
	log.info("agent login")
	local obj = objmgr.get(uid)
	if obj then
		obj.subid = subid
		if not obj.loaded then
			-- 加载数据
			-- TODO:
			init_data(obj)
			obj.loaded = true
		end
	else
		obj = objmgr.new_obj()
		obj.gate = gate
		obj.uid = uid
		obj.subid = subid
		obj.secret = secret
		obj.logined = true
		obj.authed = false
		objmgr.add(obj)
		-- TODO:
		init_data(obj)
	end
	return servicecode.SUCCESS
end

-- call by gated
function _M.logout(uid)
	local obj = objmgr.get(uid)
	assert(obj.logined)
	assert(obj.authed)
	save_data(obj)

	-- 断线重连
	if false then
		obj.logined = false
		obj.authed = false
		return skynet.call(".AGENT_MGR", "lua", "exit", obj.uid)
	else
		local err = skynet.call(".AGENT_MGR", "lua", "exit_at_once", obj.uid)
		if err == servicecode.SUCCESS then
			objmgr.del(obj)
			log.info("uid(%d) agent logout", obj.uid)
		end
		return err
	end
	return servicecode.SUCCESS
end

function _M.logout_req(fd)
	local obj = objmgr.get_by_fd(fd)
	local res = {}
	if logout.logout(obj) == servicecode.SUCCESS then
		res.errorcode = 0
	else
		res.errorcode = 1
	end
	return res
end

-- call by agent mgr
function _M.kill_cache(uid)
	local obj = objmgr.get(uid)
	assert(obj)
	objmgr.del(obj)
	log.info("uid(%d) agent kill cache", uid)
	return servicecode.SUCCESS
end

function _M.auth(args)
	local obj = assert(objmgr.get(args.uid))
	obj.fd = args.client
	obj.authed = true
	objmgr.addfd(obj)
	assert(obj == objmgr.get_by_fd(args.client))

	-- 初始各个模块
	local u = {uid = obj.uid, fd = obj.fd}

	skynet.call(".RADIO_MGR", "lua", "auth", u)
	skynet.call(".CHAT_MGR", "lua", "auth", u)
	skynet.call(".MAIL_MGR", "lua", "auth", u)

	-- 用户数据
	skynet.call(".BAG", "lua", "auth", u)
	skynet.call(".HERO", "lua", "auth", u)
	skynet.call(".TASKDAILY", "lua", "auth", u)
	skynet.call(".INBOX", "lua", "auth", u)
	skynet.call(".OUTBOX", "lua", "auth", u)
	skynet.call(".CHAT", "lua", "auth", u)

	return true
end

function _M.afk(fd)
	log.info("agent fd(%d) afk", fd)
	local obj = objmgr.get_by_fd(fd)
	return logout.logout(obj)
end

function _M.handshake(fd)
	local obj = objmgr.get_by_fd(fd)
	client.push(obj, "handshake")
	local res = {}
	res.errorcode = 0
	return res
end

function _M.enter(fd)
	local obj = objmgr.get_by_fd(fd)

	user.on_enter(obj)
	FuncOpenSystem.on_enter(obj)
	room.on_enter(obj)

	-- 初始各个模块
	-- 初始公共模块

	skynet.call(".RADIO_MGR", "lua", "enter", obj.uid)
	skynet.call(".CHAT_MGR", "lua", "enter", obj.uid)
	skynet.call(".MAIL_MGR", "lua", "enter", obj.uid)

	-- 初始用户数据模块
	skynet.call(".BAG", "lua", "enter", obj.uid)
	skynet.call(".HERO", "lua", "enter", obj.uid)
	skynet.call(".TASKDAILY", "lua", "enter", obj.uid)
	skynet.call(".INBOX", "lua", "enter", obj.uid)
	skynet.call(".OUTBOX", "lua", "enter", obj.uid)
	skynet.call(".CHAT", "lua", "enter", obj.uid)

	return {errorcode = 0}
end

function _M.user_info(fd, args)
	local obj = objmgr.get_by_fd(fd)
	local res = {}
	res.info = {
		num = 0,
		nickname = obj.mod_user.nickname,
		nameid = "",
		rcard = 0,
		level = obj.mod_user.level
	}
	return res
end

function _M.fetch_rank_power(fd, args)
	local addr = skynet.call(".ZSET_MGR", "lua", "get", "power")
	local reply = skynet.call(addr, "lua", "range", 1, 2000)
	skynet.error(table_dump(reply))
	local res = {}
	res.errorcode = 1
	res.list = {}
	return res
end

return _M
