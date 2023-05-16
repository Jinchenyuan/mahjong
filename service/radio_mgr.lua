-- 全服公告模块
local skynet = require "skynet"
local service = require "service"
local log = require "chestnut.skynet.log"
local objmgr = require "objmgr"

local board = "weixinhao:nihao"
local adver = "weixinhao:nihao"

local CMD = {}

function CMD.start(...)
	return true
end

function CMD.init_data()
	return true
end

function CMD.sayhi(...)
	return true
end

function CMD.close(...)
	return true
end

function CMD.kill(...)
	skynet.exit()
end

-- 登陆
function CMD.login(u)
	objmgr.add(u)
	return true
end

function CMD.logout(uid)
	objmgr.del(uid)
end

function CMD.auth(args)
	local u = objmgr.get(args.uid)
	u.fd = args.fd
	u.authed = true
	return true
end

function CMD.enter(uid)
	return true
end

-- 消息
function CMD.board()
	local res = {}
	res.errorcode = 0
	res.text = board
	return res
end

function CMD.adver()
	local res = {}
	res.errorcode = 0
	res.text = adver
	return res
end

function CMD.radio(type, text, ...)
	if type == 1 then
		board = text
		local args = {}
		args.text = text
		for _, v in pairs(users) do
			skynet.send(v.agent, "lua", "board", args)
		end
	elseif type == 2 then
		adver = text
		local args = {}
		args.text = text
		for _, v in pairs(users) do
			skynet.send(v.agent, "lua", "adver", args)
		end
	end
end

service.init {
	name = ".RADIO_MGR",
	command = CMD
}
