local skynet = require "skynet"
local sd = require "skynet.sharetable"
local savedata = require "savedata"
local snowflake = require "chestnut.snowflake"
local client = require "client"
local log = require "chestnut.skynet.log"
local servicecode = require "enum.servicecode"
local _M = {}

skynet.init(
	function()
	end
)

function _M.init()
end

function _M.init_data()
	return true
end

function _M.save_data()
	return true
end

function _M.login(u)
	return true
end

function _M.logout(u)
	return true
end

function _M.on_enter(u)
	return true
end

return _M
