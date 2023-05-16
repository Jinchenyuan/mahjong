local skynet = require "skynet"
require "skynet.manager"

skynet.start(
	function()
		local agent = {}
		for i = 1, 20 do
			agent[i] = skynet.newservice("dbread")
			skynet.call(agent[i], "lua", "start")
		end
		local balance = 1
		skynet.dispatch(
			"lua",
			function(_, _, cmd, ...)
				local r = skynet.call(agent[balance], "lua", cmd, ...)
				skynet.retpack(r)
				balance = balance + 1
				if balance > #agent then
					balance = 1
				end
			end
		)
		skynet.register ".DB"
	end
)
