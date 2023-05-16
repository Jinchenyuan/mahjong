-- 玩家英雄模块
-- 主要用来管理玩家所拥有的英雄的模块
local skynet = require "skynet"
local sd = require "skynet.sharetable"
local log = require "chestnut.skynet.log"
local objmgr = require "objmgr"
local table_dump = require "luaTableDump"
local servicecode = require "enum.servicecode"
local dbr = require "dbread.db"
local dbw = require "dbwrite.db"
local client = require "client"
local assert = assert
local _M = {}
local info_cfg

skynet.init(
	function()
		info_cfg = sd.query("InfoConfig")
	end
)

function _M.init_data()
	return true
end

function _M.save_data()
	-- TODO:
	-- 修改存数据
	-- objmgr.foreach(
	-- 	function(obj)
	-- 		local heros = obj.mod_hero.heros
	-- 		for _, v in pairs(heros) do
	-- 			if v.y then
	-- 				local hero = {}
	-- 				hero.uid = v.uid
	-- 				hero.hero_id = v.hero_id
	-- 				hero.level = v.level
	-- 				dbw.write_user_heros(hero)
	-- 			end
	-- 		end
	-- 	end
	-- )
end

function _M.login(u)
	local d = dbr.read_user_heros(u.uid)
	u.mod_hero = {}
	u.mod_hero.heros = {}
	for k, v in pairs(d) do
		local hero = {}
		hero.hero_id = v.hero_id
		hero.level = v.level
		hero.create_at = v.create_at
		hero.update_at = v.update_at
		u.mod_hero.heros[hero.hero_id] = hero
	end
	return true
end

function _M.logout(u)
	return true
end

function _M.on_enter(u)
	client.push(u, "player_heros", {list = {{id = 111, level = 1}}})
	return true
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
