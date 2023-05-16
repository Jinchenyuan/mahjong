-- 这个文件会被agent里的同名文件引用
local skynet = require "skynet"
local client = require "client"
local REQUEST = client.request()
local objmgr = require "objmgr"

function REQUEST.fetchinbox(fd, args)
	local u = objmgr.get_by_fd(fd)
	return skynet.call(".INBOX", "lua", "fetchinbox", u.uid, args)
end

function REQUEST.syncsysmail(fd, args)
	local u = objmgr.get_by_fd(fd)
	return skynet.call(".INBOX", "lua", "syncsysmail", u.uid, args)
end

function REQUEST.viewedsysmail(fd, args)
	local u = objmgr.get_by_fd(fd)
	return skynet.call(".INBOX", "lua", "viewedsysmail", u.uid, args)
end

return REQUEST
