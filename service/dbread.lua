local service = require "service"
local db = require "dbread.db"
local CMD = db.host
service.init {
    command = CMD
}
