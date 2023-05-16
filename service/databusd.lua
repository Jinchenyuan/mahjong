-- databus服务
-- 同步服务间数据
local service = require "service"
local databus = require "databus"
service.init {
    name = databus.name,
    command = databus.host
}
