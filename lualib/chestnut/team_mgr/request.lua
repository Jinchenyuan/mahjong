local skynet = require "skynet"
local REQUEST = require "request"
local objmgr = require "objmgr"

function REQUEST.fetch_teams(fd, args)
    local obj = objmgr.get_by_fd(fd)
    return skynet.call(".TEAM_MGR", "lua", "fetch_teams", obj.uid, args)
end

function REQUEST.create_team(fd, args)
    local obj = objmgr.get_by_fd(fd)
    return skynet.call(".TEAM_MGR", "lua", "create_team", obj.uid, args)
end

return REQUEST
