local skynet = require "skynet"
local CMD = {}
local services = {}

function CMD.register()
end

function CMD.triger(module, uid, key, value)
end

local _M = {}

_M.host = CMD
_M.name = ".DATABUS"

function _M.init(mod)
end

function _M.triger(module, uid, key, value)
    skynet.send(_M.name, "lua", module, uid, key, value)
end

return _M
