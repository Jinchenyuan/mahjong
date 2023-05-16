local service = require "service"
local CMD = require "chestnut.outbox.cmd"
service.init {
    name = ".OUTBOX",
    command = CMD
}
