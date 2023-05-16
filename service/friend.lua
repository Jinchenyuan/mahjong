-- 好友服务
-- 管理用户所有好友事务
local service = require "service"
local CMD = require "chestnut.friend.cmd"
service.init {
    name = ".FRIEND",
    command = CMD
}
