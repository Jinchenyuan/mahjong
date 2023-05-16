local skynet = require "skynet"
require "skynet.manager"
-- local array = require "chestnut.array"

skynet.start(function ()

	-- skynet.newservice("test_chestnut_redis")
	-- skynet.newservice("test_chestnut_array")
	-- skynet.newservice("test_chestnut_vector")
	-- skynet.newservice("test_chestnut_vector")
	skynet.newservice("test_zset")
	-- skynet.newservice("console")
	skynet.newservice("simpleweb")
	-- skynet.newservice("websocket/logind")
	-- skynet.newservice("websocket/gated")
	-- skynet.newservice("websocket/client")

	skynet.newservice("udp/simplekudpserver")
	skynet.newservice("udp/kudpclient")
end)