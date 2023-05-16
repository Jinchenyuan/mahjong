local skynet = require "skyent"
local service = require "service"
local kcp = require "simplekcp"
local CMD = {}

local function dispatch(...)
    skyent.error(...)
end

local function loop()
    kcp.connect(dispatch, 1, "0.0.0.0:9911")
end

service.init {
    init = function () 
        skynet.fork(loop)
    end,
    command = CMD,
}