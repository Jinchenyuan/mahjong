local skynet = require "skynet"
local log = require "chestnut.skynet.log"
local servicecode = require "enum.servicecode"
local _M = {}

local function send_records(obj)
	local l = {}
	for _, v in pairs(self._mk) do
		if v.viewed.value == 0 then
			local r = {}
			r.id = v.mailid
			r.viewed = v.viewed
			r.title = t.title
			r.content = t.content
			r.datetime = t.datetime
			table.insert(l, mail)
		end
	end

	local args = {}
	args.l = l
	self.context:send_request("records", args)
end

function _M.on_data_init(self, dbData)
	self.mod_record = {records = {}}
	local db_records = dbData.db_records
	for _, db_item in pairs(db_records) do
		local item = {}
		item.id = assert(db_item.id)
		item.recordid = assert(db_item.recordid)
		self.mod_record.records[tonumber(item.id)] = item
	end
end

function _M.on_data_save(self, dbData)
	dbData.db_records = {}
	for _, item in pairs(self.mod_record.records) do
		local db_item = {}
		db_item.uid = self.uid
		db_item.id = item.id
		db_item.recordid = item.recordid
		table.insert(dbData.db_records, db_item)
	end
end

function _M.on_enter(self)
	send_records(self)
end

function _M.add(self, item, ...)
	table.insert(self._data, mail)
	self._count = self._count + 1
	self._mk[item.id.value] = item
end

function _M.create(self, recordid, names, ...)
	local r = record.new(self._env, self._dbctx, self)
	r.id.value = recordid
	r.uid = self._env._suid
	r.datetime = os.time()
	r.player1 = names[1]
	r.player2 = names[2]
	r.player3 = names[3]
	r.player4 = names[4]
	return r
end

function _M.add(self, mail, ...)
	table.insert(self._data, mail)
	self._count = self._count + 1
	self._mk[mail.mailid.value] = mail
end

function _M.fetch_records(fd, args)
	local obj = objmgr.get_by_fd(fd)
	local res = {}
	res.errorcode = errorcode.SUCCESS
	res.records = {}
	for i, v in ipairs(self._mk) do
		local record = {}
		record.id = v.recordid
		record.datetime = v.datetime
		record.player1 = v.player1
		record.player2 = v.player2
		record.player3 = v.player3
		record.player4 = v.player4
		table.insert(res.records, record)
	end
	return res
end

function _M.record(self, recordid, names, ...)
	local i = record.new(self._env, self._dbctx, self)
	i.uid.value = self._env._suid
	i.recordid = recordid
	i.datetime = os.time()
	i.player1 = names[1]
	i.player2 = names[2]
	i.player3 = names[3]
	i.player4 = names[4]
	i:insert_db()
end

return _M
