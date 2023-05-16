local skynet = require "skynet"
local service = require "service"
local kcp = require "simplekcp"
local CMD = {}
local K

local function dispatch(...)
    skyent.error(...)
end

service.init{
    init = function()
        K = kcp.udp(dispatch, "0.0.0.0:9911")
    end,
    command = CMD,
}
