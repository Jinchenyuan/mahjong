local service = require "service"
local CMD = require "chestnut.zsetd.cmd"

service.init {
	name = ".ZSETD",
	command = CMD
}
