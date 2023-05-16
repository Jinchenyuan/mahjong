local service = require "service"
local context = require "chestnut.pokerroom.context"
local CMD = require "chestnut.pokerroom.cmd"
local id = tonumber(...)

-- local client_mod = {}
-- client_mod.request = REQUEST
-- client_mod.response = RESPONSE

-- client.init(client_mod)

local mod = {}
mod.require = {}
mod.init = function(...)
    context.inid(id)
end
mod.command = CMD
service.init(mod)
