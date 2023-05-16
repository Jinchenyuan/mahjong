local service = require "service"
local CMD = require "chestnut.chat.cmd"

service.init {
    name = ".CHAT",
    command = CMD
}
