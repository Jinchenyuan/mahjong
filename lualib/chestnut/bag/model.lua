local skynet = require "skynet"
local log = require "chestnut.skynet.log"
local PackageType = require "enum.PackageType"
local sd = require "skynet.sharetable"
local objmgr = require "objmgr"
local dbc = require "dbread.db"
local dbw = require "dbwrite.db"
local table_dump = require "luaTableDump"
local service = require "service"
local _M = {}
local item_cfg

skynet.init(
	function()
		item_cfg = sd.query("itemConfig")
	end
)

local function push_items(obj)
end

function _M._increase(self, pt, id, num)
	local uid = self.agentContext.uid
	local index = self.context:get_entity_index(UserComponent)
	local entity = index:get_entity(uid)
	local package = assert(entity.package.packages[pt])
	if not package[id] then
		package[id] = {id = id, num = 0, createAt = os.time(), updateAt = os.time()}
	end
	package[id].num = package[id].num + num
	-- 增加道具
	local item = {id = id, num = num}
	self.agentContext:send_request("add_item", {i = item})
	return true
end

function _M._decrease(self, pt, id, num)
	local uid = self.agentContext.uid
	local index = self.context:get_entity_index(UserComponent)
	local entity = index:get_entity(uid)
	local package = assert(entity.package.packages[pt])
	if not package[id] then
		package[id] = {id = id, num = 0, createAt = os.time(), updateAt = os.time()}
	end
	local item = package[id]
	if item.num >= num then
		item.num = item.num - num
		local item = {id = id, num = num}
		self.agentContext:send_request("sub_item", {i = item})
	else
		log.error("not enought item, num is %d, need %d", item.num, num)
		return false
	end
	return true
end

function _M.init_data()
	return service.OK
end

function _M.save_data()
	-- dbData.db_user_items = {}
	-- local set = self.mod_bag.bags[PackageType.COMMON]
	-- local package = {}
	-- for _, db_item in pairs(set) do
	-- 	local item = {}
	-- 	item.uid = self.uid
	-- 	item.id = assert(db_item.id)
	-- 	item.num = assert(db_item.num)
	-- 	item.create_at = assert(db_item.createAt)
	-- 	item.update_at = assert(db_item.updateAt)
	-- 	table.insert(package, item)
	-- end
	-- dbData.db_user_items = package
end

function _M.login(u)
	local package = {}
	local list = dbc.read_user_bag(u.uid)
	if list then
		for _, db_item in pairs(list) do
			local item = {}
			item.id = assert(db_item.id)
			item.num = assert(db_item.num)
			item.createAt = assert(db_item.create_at)
			item.updateAt = assert(db_item.update_at)
			package[tonumber(item.id)] = item
		end
	end
	u.bags = {}
	u.bags[PackageType.COMMON] = package
	return service.OK
end

function _M.logout(u)
	objmgr.del(u)
	return true
end

function _M.on_enter(u)
	-- push_items(self)
	return true
end

function _M.on_exit(self)
end

function _M.on_func_open(self)
	local uid = self.agentContext.uid
	local index = self.context:get_entity_index(UserComponent)
	local entity = index:get_entity(uid)
	entity.package.packages = {}
	entity.package.packages[PackageType.COMMON] = {}
	entity.package.packages[PackageType.COMMON][1] = {id = 1, num = 113, createAt = os.time(), updateAt = os.time()} -- 砖石
	entity.package.packages[PackageType.COMMON][2] = {id = 2, num = 113, createAt = os.time(), updateAt = os.time()} -- 金币
	entity.package.packages[PackageType.COMMON][3] = {id = 3, num = 1, createAt = os.time(), updateAt = os.time()} -- 经验
	entity.package.packages[PackageType.COMMON][4] = {id = 4, num = 100, createAt = os.time(), updateAt = os.time()} -- 门票
end

function _M.check_consume(self, id, value)
	local uid = self.uid
	local index = self.context:get_entity_index(UserComponent)
	local entity = index:get_entity(uid)
	local itemConfig = ds.query("item")[string.format("%d", id)]
	local package = entity.package.packages[itemConfig.type]
	assert(package)
	local item = package[id]
	if item.num < value then
		return false
	end
	return true
end

function _M.get_item(obj, id)
	local bag = obj.mod_bag.bags[PackageType.COMMON]
	local item = bag[id]
	return item
end

function _M.get_fd_item(fd, id)
	local obj = objmgr.get_by_fd(fd)
	return _M.get_item(obj)
end

function _M.get_uid_item(uid, id)
	local obj = objmgr.get(uid)
	return _M.get_item(obj)
end

function _M.consume(obj, id, value)
	if not self:check_consume(id, value) then
		return false
	end
	local itemConfig = ds.query("item")[string.format("%d", id)]
	return self:_decrease(itemConfig.type, id, value)
end

function _M.consume_uid(uid, id, value)
	local obj = objmgr.get(uid)
	return _M.consume_uid(obj, id, value)
end

function _M.reward(obj, id, num)
end

function _M.rcard_num(self)
	local uid = self.agentContext.uid
	local index = self.context:get_entity_index(UserComponent)
	local entity = index:get_entity(uid)
	local package = entity.package.packages[PackageType.COMMON]
	assert(package)
	local item = package[4]
	if not item then
		item = {id = 4, num = 0}
		package[4] = item
	end
	return item.num
end

function _M.fetch_items(fd, args)
	local obj = objmgr.get_by_fd(fd)
	local package = obj.mod_bag.bags[PackageType.COMMON]
	assert(package)
	local all = {}
	for _, v in pairs(package) do
		local item = {id = v.id, num = v.num}
		table.insert(all, item)
	end
	return {
		errorcode = 0,
		all = all
	}
end

return _M
