local service = require "service"
local CMD = require "chestnut.bag.cmd"

service.init {
    name = ".BAG",
    command = CMD
}
