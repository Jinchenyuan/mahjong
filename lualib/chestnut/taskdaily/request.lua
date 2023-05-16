local skynet = require "skynet"
local objmgr = require "objmgr"
local REQUEST = require "request"

function REQUEST.fetch_dailytasks(fd, args)
	local obj = objmgr.get_by_fd(fd)
	return skynet.call(".TASKDAILY", "lua", "fetch_dailytasks", obj.uid, args)
end

return REQUEST
