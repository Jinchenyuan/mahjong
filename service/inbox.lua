local service = require "service"
local CMD = require "chestnut.inbox.cmd"
service.init {
	name = ".INBOX",
	command = CMD
}
