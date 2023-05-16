local skynet = require "skynet"
local log = require "chestnut.skynet.log"
local objmgr = require "objmgr"
local REQUEST = require "request"

function REQUEST.fetch_bag_items(fd, args)
	local u = objmgr.get_by_fd(fd)
	return skynet.call(".BAG", "fetch_bag_items", u.uid, args)
end

return REQUEST
