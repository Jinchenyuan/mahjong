local skynet = require "skynet"
local mc = require "skynet.multicast"
local log = require "chestnut.skynet.log"
local service = require "service"
local assert = assert
local channel

local function save_data_loop()
	while true do
		skynet.sleep(100 * 10) -- 10s
		channel:publish("save_data")
	end
end

local CMD = {}

function CMD.get_channel_id()
	return channel.channel
end

service.init {
	name = ".REFRESHD",
	init = function()
		channel = mc.new()
		skynet.fork(save_data_loop)
	end,
	command = CMD
}
