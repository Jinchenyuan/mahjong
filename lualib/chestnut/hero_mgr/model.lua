-- 英雄模块
-- 主要用来管理游戏内所有英雄的模块
local skynet = require "skynet"
local sd = require "skynet.sharetable"
local log = require "chestnut.skynet.log"
local objmgr = require "objmgr"
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

local function init_hero(obj)
end

function _M.init_data()
end

function _M.save_data(u)
	db_data.db_user_heros = {}
	for _, v in pairs(self.mod_hero.heros) do
		local hero = {}
		hero.uid = self.uid
		hero.hero_id = v.hero_id
		hero.level = v.level
		hero.create_at = v.create_at
		hero.update_at = os.time()
		table.insert(db_data.db_user_heros, hero)
	end
end

function _M.login(u)
	local db_data = dbr.read_hero(u.uid)
	u.mod_hero = {}
	u.mod_hero.heros = {}
	for k, v in pairs(db_data.db_user_heros) do
		local hero = {}
		hero.hero_id = v.hero_id
		hero.level = v.level
		hero.create_at = v.create_at
		hero.update_at = v.update_at
		self.mod_hero.heros[hero.hero_id] = hero
	end
end

function _M.on_enter(u)
	client.push(self, "player_heros", {list = {{id = 111, level = 1}}})
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
