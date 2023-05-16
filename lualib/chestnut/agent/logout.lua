local skynet = require "skynet"
local objmgr = require "objmgr"
local servicecode = require "enum.servicecode"
local log = require "chestnut.skynet.log"
local FuncOpenSystem = require "chestnut.systems.funcopen"
local user = require "chestnut.systems.user"
local room = require "chestnut.room.model"

local _M = {}

function _M.save_data(obj)
	local data = {}
	FuncOpenSystem.on_data_save(obj, data)
	user.on_data_save(obj, data)
	room.on_data_save(obj, data)
	if table.length(data) > 0 then
		dbw.write_user(data)
	else
		log.error("uid(%d) not data", obj.uid)
	end
end

function _M.logout(obj)
	assert(obj.authed)
	if obj.authed then
		-- 调用所有模块logout
		skynet.call(".RADIO_MGR", "lua", "logout", obj.uid)
		skynet.call(".CHAT_MGR", "lua", "logout", obj.uid)
		skynet.call(".MAIL_MGR", "lua", "logout", obj.uid)

		-- 用户
		skynet.call(".BAG", "lua", "logout", obj.uid)
		skynet.call(".HERO", "lua", "logout", obj.uid)
		skynet.call(".TASKDAILY", "lua", "logout", obj.uid)
		skynet.call(".INBOX", "lua", "logout", obj.uid)
		skynet.call(".OUTBOX", "lua", "logout", obj.uid)
		skynet.call(".CHAT", "lua", "logout", obj.uid)

		-- 调用systems
		log.info("uid(%d) systems begin-------------------------------------afk", obj.uid)
		_M.save_data(obj)

		-- 调用gatelogout
		local err = skynet.call(obj.gate, "lua", "logout", obj.uid, obj.subid)
		if err == servicecode.SUCCESS then
			log.info("uid(%d) agent afk", obj.uid)
		end
		return err
	else
		return servicecode.NOT_AUTHED
	end
end

return _M
