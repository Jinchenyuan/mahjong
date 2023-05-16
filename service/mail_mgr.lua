local service = require "service"
local CMD = require "chestnut.mail_mgr.cmd"
service.init {
	name = ".MAIL_MGR",
	command = CMD
}
