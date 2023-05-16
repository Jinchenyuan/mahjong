local skynet = require "skynet"
local log = require "chestnut.skynet.log"
local context = require "chestnut.agent.model"
local client = require "client"
local REQUEST = client.request()
local FuncOpenSystem = require "chestnut.systems.funcopen"
local user = require "chestnut.systems.user"
local objmgr = require "objmgr"

-- 公告数据模块
require "chestnut.team_mgr.request"
require "chestnut.store.request"

-- 用户数据模块
require "chestnut.achievement.request"
require "chestnut.bag.request"
require "chestnut.chat.request"
require "chestnut.checkin.request"
require "chestnut.friend.request"
require "chestnut.hero.request"
require "chestnut.inbox.request"
require "chestnut.outbox.request"
require "chestnut.record.request"
require "chestnut.team.request"
require "chestnut.taskdaily.request"
require "chestnut.room.request"

function REQUEST.handshake(fd)
	return context.handshake(fd)
end

function REQUEST.enter(fd)
	return context.enter(fd)
end

function REQUEST.logout(fd)
	return context.logout_req(fd)
end

------------------------------------------
-- 系统模块
function REQUEST.modify_name(fd, args)
	local obj = objmgr.get_by_fd(fd)
	user.modify_name(obj, args)
	return {errorcode = 0}
end

function REQUEST.user_info(fd, args)
	return context.user_info(fd, args)
end

function REQUEST.fetch_rank_power(fd, args)
	return context.fetch_rank_power(fd, args)
end

return REQUEST
