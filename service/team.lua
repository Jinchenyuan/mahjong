local service = require "service"
local CMD = require "chestnut.team.cmd"

service.init {
    name = ".TEAM",
    command = CMD
}
