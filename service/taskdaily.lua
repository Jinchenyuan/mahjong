local service = require "service"
local CMD = require "chestnut.taskdaily.cmd"

service.init {
    name = ".TASKDAILY",
    command = CMD
}
