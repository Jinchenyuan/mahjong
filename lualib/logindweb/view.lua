local skynet = require "skynet"
local errorcode = require "enum.servicecode"
local string_split = string.split

local VIEW = {}

function VIEW:test()
	panic(1010)
	return "OK"
end

function VIEW:stat()
	local stat = {}
	stat.task = skynet.task()
	stat.mqlen = skynet.stat "mqlen"
	stat.cpu = skynet.stat "cpu"
	stat.message = skynet.stat "message"
	return stat
end

return VIEW
