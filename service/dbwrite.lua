local service = require "service"
local db = require "dbwrite.db"
local CMD = db.host
service.init {
    command = CMD
}
