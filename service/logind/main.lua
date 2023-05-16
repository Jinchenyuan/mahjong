local skynet = require "skynet"
require "skynet.manager"
local log = require "chestnut.skynet.log"
local server = require "server"

skynet.start(
	function()
		-- open cluster
		server.host.open_logind()

		-- 逻辑类服务
		skynet.uniqueservice("db")
		local dw = skynet.uniqueservice("dbwrite")
		local ok = skynet.call(dw, "lua", "start")
		if not ok then
			log.error("service dbwrite start failture error")
			skynet.exit()
			return
		end
		skynet.newservice("logind/dbtest")
		skynet.uniqueservice("logind/logindverify")

		-- gate 类服务最后起
		-- 调试服务
		skynet.newservice("debug_console", 8000)

		-- 监听服务
		skynet.uniqueservice("logind/simpleweb")
		local logind = skynet.getenv("logind") or "0.0.0.0:3002"
		local addr = skynet.newservice("logind/logind", logind)
		skynet.name(".LOGIND", addr)

		-- 服务启动完成后注册
		server.host.register_service(".LOGIND", addr)

		skynet.exit()
	end
)
