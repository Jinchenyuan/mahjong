local skynet = require "skynet"
local client = require "client"
local dbr = require "dbread.db"
local table_dump = require "luaTableDump"

local _M = {}

function _M.init_data()
end

function _M.save_data()
end

function _M.login(u)
	local res = dbc.read_user_bag(uid)
	local str = table_dump(res)
	skynet.error(str)

	-- if not dbData or not dbData.db_user_items then
	-- 	log.error("bag is nil")
	-- 	return
	-- end
	-- local set = dbData.db_user_items
	-- local package = {}
	-- for _, db_item in pairs(set) do
	-- 	local item = {}
	-- 	item.id = assert(db_item.id)
	-- 	item.num = assert(db_item.num)
	-- 	item.createAt = assert(db_item.create_at)
	-- 	item.updateAt = assert(db_item.update_at)
	-- 	package[tonumber(item.id)] = item
	-- end
	-- self.mod_bag = {bags = {}}
	-- self.mod_bag.bags[PackageType.COMMON] = package

	return service.OK
end

function _M.save_user(u)
end

function _M.login(self, db_data)
	local data = db_data.db_user_achievements
	self.mod_achievement = {}
	self.mod_achievement.achieves = {}
	if data ~= nil then
		for k, v in pairs(data) do
			local item = {}
			item.id = v.id
			item.reach = v.reach
			item.recv = v.recv
			self.mod_achievement.achieves[item.id] = item
		end
	end
	return true
end

function _M.logout(self, db_data)
	db_data.db_user_achievements = {}
	local data = self.mod_achievement.achieves
	for k, v in pairs(data) do
		local item = {}
		item.uid = self.uid
		item.id = v.id
		item.reach = v.reach
		item.recv = v.recv
		item.create_at = v.create_at
		item.update_at = v.update_at
		table.insert(db_data.db_user_achievements, item)
	end
	return true
end

function _M.on_enter(self)
	-- client.push(self, '')
end

function _M.active()
end

return _M
