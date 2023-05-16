local service = require "service"
local context = require "chestnut.mahjongroom.rcontext"
local CMD = require "chestnut.mahjongroom.cmd"

local id = tonumber(...)

local mod = {}
mod.require = {}
mod.init = function(...)
	context.init(id)
end
mod.command = CMD
service.init(mod)
