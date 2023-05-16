local skynet = require "skynet"
local sd = require "skynet.sharetable"
local log = require "chestnut.skynet.log"
local table_dump = require "luaTableDump"
local servicecode = require "enum.servicecode"
local dbr = require "dbread.db"
local assert = assert
local _M = {}
local info_cfg

skynet.init(
	function()
		info_cfg = sd.query("InfoConfig")
	end
)

function _M.init_data()
end

function _M.save_data()
end

------------------------------------------
-- 逻辑
function _M.fetch_heros(u, args)
	return {errorcode = 0}
end

function _M.fetch_hero(u, args)
	return {errorcode = 0}
end

return _M
