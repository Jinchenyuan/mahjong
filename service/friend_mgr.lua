-- 管理好友申请
local skynet = require "skynet"
local log = require "chestnut.skynet.log"
local service = require "service"
local client = require "client"
local savedata = require "savedata"
local traceback = debug.traceback
local assert = assert
local dbw = require "dbwrite.db"
local dbr = require "dbread.db"
local objmgr = require "objmgr"

local rooms = {} -- 房间聊天
local CMD = {}
local SUB = {}

local function save_data()
end

function SUB.save_data(...)
end

function CMD.start()
	savedata.init {
		command = SUB
	}
	savedata.subscribe()
	return true
end

function CMD.init_data()
	return true
end

function CMD.sayhi()
	return true
end

function CMD.close()
	save_data()
	return true
end

function CMD.kill()
	skynet.exit()
end

------------------------------------------
-- 登陆
function CMD.login(u)
	objmgr.add(u)
	return true
end

function CMD.logout(uid)
	return true
end

function CMD.auth()
end

function CMD.enter()
end

service.init {
	name = ".FRIEND_MGR",
	command = CMD
}
