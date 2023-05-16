-- 这个文件会被agent里的同名文件引用
local skynet = require "skynet"
local objmgr = require "objmgr"
local REQUEST = require "request"

function REQUEST.fetch_team(fd, args)
	local obj = objmgr.get_by_fd(fd)
	return skynet.call(".TEAM", "lua", "fetch_teams", obj.uid, args)
end

function REQUEST.join_team(fd, args)
	local obj = objmgr.get_by_fd(fd)
	return skynet.call(".TEAM", "lua", "join_team", obj.uid, args)
end

function REQUEST.fetch_myteams(fd, args)
	local obj = objmgr.get_by_fd(fd)
	return skynet.call(".TEAM", "lua", "fetch_myteams", obj.uid, args)
end

function REQUEST.quit_team(fd, args)
	local obj = objmgr.get_by_fd(fd)
	return skynet.call(".TEAM", "lua", "quit_team", obj.uid, args)
end

return REQUEST
