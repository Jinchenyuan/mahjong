local service = require "service"
local CMD = require "chestnut.hero.cmd"

service.init {
    name = ".HERO",
    command = CMD
}
