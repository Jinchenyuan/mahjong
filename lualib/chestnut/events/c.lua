local skynet = require "skynet"
local _M = {}

function _M.on(...)
    skynet.call(".EVENTS", "lua", "on", ...)
end

function _M.omit(...)
    skynet.send(".EVENTS", "lua", "omit", ...)
end

return _M
