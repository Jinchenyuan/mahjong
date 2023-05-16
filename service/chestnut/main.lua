local skynet = require "skynet"
require "skynet.manager"
local log = require "chestnut.skynet.log"
local cluster = require "skynet.cluster"
local lifemgr = require "lifemgr"
local server = require "server"

skynet.start(
	function()
		-- open cluster
		server.host.open_game1()

		-- 工具类服务
		skynet.uniqueservice("protoloader")

		-- config
		skynet.uniqueservice("sdata_mgr")

		-- 数据库
		local dbinitd = skynet.newservice("dbinitd")
		local ok = skynet.call(dbinitd, "lua", "initdb")
		if not ok then
			log.error("init db error")
			skynet.exit()
			return
		end

		skynet.uniqueservice("db")
		local dw = skynet.uniqueservice("dbwrite")
		local ok = skynet.call(dw, "lua", "start")
		if not ok then
			log.error("service dbwrite start failture error")
			skynet.exit()
			return
		end
		skynet.newservice("chestnut/dbtest")
		skynet.uniqueservice("sid_mgr")
		local d = skynet.uniqueservice("discoveryd")
		skynet.call(d, "lua", "start")

		-- 公告数据类服务
		lifemgr.uniqueservice("radio_mgr")
		lifemgr.uniqueservice("chat_mgr")
		lifemgr.uniqueservice("mail_mgr")
		lifemgr.uniqueservice("record_mgr")
		lifemgr.uniqueservice("offagent_mgr")
		lifemgr.uniqueservice("activity_mgr")
		lifemgr.uniqueservice("friend_mgr")
		lifemgr.uniqueservice("zsetd_mgr")
		lifemgr.uniqueservice("room_mgr")
		lifemgr.uniqueservice("store")
		lifemgr.uniqueservice("team_mgr")

		-- 玩家数据类服务
		lifemgr.uniqueservice("bag")
		lifemgr.uniqueservice("hero")
		lifemgr.uniqueservice("taskdaily")
		lifemgr.uniqueservice("inbox")
		lifemgr.uniqueservice("outbox")
		lifemgr.uniqueservice("chat")
		lifemgr.uniqueservice("team")

		-- 调试类服务
		skynet.newservice("debug_console", 8001)

		-- http
		skynet.uniqueservice("chestnut/simpleweb")

		-- 启动gate
		local gated = skynet.getenv("gated") or "0.0.0.0:3301"
		local address, port = string.match(gated, "([%d.]+)%:(%d+)")
		local gated_name = skynet.getenv("gated_name") or "sample"
		local max_client = skynet.getenv("maxclient") or 1024
		local gate = skynet.uniqueservice("chestnut/gated")
		skynet.call(
			gate,
			"lua",
			"open",
			{
				gated = gated,
				address = address or "0.0.0.0",
				port = port,
				maxclient = tonumber(max_client),
				servername = gated_name
				--nodelay = true,
			}
		)

		-- 启动udp服务
		local udpgated = skynet.getenv("udpgated")
		if udpgated then
		-- local address, port = string.match(udpgated, "([%d.]+)%:(%d+)")
		-- local gated_name = skynet.getenv("gated_name") or "sample"
		-- local max_client = skynet.getenv("maxclient") or 1024
		-- local udpgate = skynet.uniqueservice("rudpserver_mgr")
		-- skynet.call(udpgate, "lua", "start")
		end

		-- MOCK
		-- local agent_robot = skynet.uniqueservice("agent_robot/agent")
		-- skynet.call(agent_robot, "lua", "login")
		-- skynet.call(agent_robot, "lua", 'auth')

		log.info("host successful --------------------------------------------")
		skynet.exit()
	end
)
