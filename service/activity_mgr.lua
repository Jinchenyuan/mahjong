local service = require "service"
local CMD = require "chestnut.activity_mgr.cmd"

service.init {
	name = ".ACTIVITY_MGR",
	command = CMD
}
