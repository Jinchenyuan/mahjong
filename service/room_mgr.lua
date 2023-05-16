local service = require "service"
local CMD = require "chestnut.room_mgr.cmd"

service.init {
	name = ".ROOM_MGR",
	command = CMD
}
