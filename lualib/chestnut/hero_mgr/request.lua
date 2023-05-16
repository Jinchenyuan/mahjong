-- 这个文件会被agent里的同名文件引用
local skynet = require "skynet"
local objmgr = require "objmgr"
local client = require "client"
local REQUEST = client.request()

function REQUEST.fetch_heros(fd, args)
    local u = objmgr.get_by_fd(fd)
    return skynet.call(u.hero, "fetch_heros", u.uid, args)
end

function REQUEST.fetch_hero(fd, args)
    local u = objmgr.get_by_fd(fd)
    return skynet.call(u.hero, "fetch_hero", u.uid, args)
end

function REQUEST.unlock_hero(fd, args)
    local u = objmgr.get_by_fd(fd)
    return skynet.call(u.hero, "unlock_hero", u.uid, args)
end

return REQUEST
