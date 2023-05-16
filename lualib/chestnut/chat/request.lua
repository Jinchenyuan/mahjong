local skynet = require "skynet"
local REQUEST = require "request"
local objmgr = require "objmgr"

function REQUEST.create_chat_session(fd, args)
	local u = objmgr.get_by_fd(fd)
	return skynet.call(".CHAT", "lua", "create_chat_session", u.uid, args)
end

function REQUEST.say(fd, args)
	local u = objmgr.get_by_fd(fd)
	return skynet.call(".CHAT", "lua", "say", u.uid, args)
end

------------------------------------------
-- 房间聊天协议
function REQUEST:rchat(args, ...)
	local M = self.systems.room
	return M:forward_room("rchat", args, ...)
end

return REQUEST
