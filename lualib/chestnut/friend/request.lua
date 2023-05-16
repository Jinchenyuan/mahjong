local skynet = require "skynet"
local log = require "chestnut.skynet.log"
local REQUEST = require "request"
local objmgr = require "objmgr"

function REQUEST.fetch_friends(fd, args)
	local obj = objmgr.get_by_fd(fd)
	return skynet.call(".FRIEND", "lua", "fetch_friends", obj.uid, args)
end

function REQUEST.fetch_friend(fd, args)
	local obj = objmgr.get_by_fd(fd)
	return skynet.call(".FRIEND", "lua", "fetch_friend", obj.uid, args)
end

function REQUEST.rm_friend(self, args)
	local obj = objmgr.get_by_fd(fd)
	return skynet.call(".FRIEND", "lua", "fetch_friend", obj.uid, args)
end

function REQUEST.fetch_friend_reqs(self, args)
	local obj = objmgr.get_by_fd(fd)
	return skynet.call(".FRIEND", "lua", "fetch_friend", obj.uid, args)
end

function REQUEST.acc_friend_req(self, args)
	local obj = objmgr.get_by_fd(fd)
	return skynet.call(".FRIEND", "lua", "fetch_friend", obj.uid, args)
end

function REQUEST.rej_friend_req(self, args)
	local obj = objmgr.get_by_fd(fd)
	return skynet.call(".FRIEND", "lua", "fetch_friend", obj.uid, args)
end

function REQUEST.acc_friend_req_all(self, args)
	local obj = objmgr.get_by_fd(fd)
	return skynet.call(".FRIEND", "lua", "fetch_friend", obj.uid, args)
end

function REQUEST.rej_friend_req_all(self, args)
	local obj = objmgr.get_by_fd(fd)
	return skynet.call(".FRIEND", "lua", "fetch_friend", obj.uid, args)
end

return REQUEST
