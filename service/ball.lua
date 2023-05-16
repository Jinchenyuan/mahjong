local service = require "service"
local CMD = require "chestnut.ballroom.cmd"
local id = tonumber(...)

-- local client_mod = {}
-- client_mod.request = REQUEST
-- client_mod.response = RESPONSE

-- client.init(client_mod)

local mod = {}
mod.command = CMD
service.init(mod)
