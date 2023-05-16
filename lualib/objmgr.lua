local skynet = require "skynet"
local id = 1
local objs = {} -- uid->obj
local fds = {} -- fd->obj
local _M = {}

skynet.init(
    function()
    end
)

function _M.new_obj(...)
    local obj = {
        id = id
    }
    id = id + 1
    return obj
end

function _M.add(obj)
    assert(obj.uid)
    assert(objs[obj.uid] == nil)
    objs[obj.uid] = obj
end

function _M.addfd(obj)
    assert(obj.fd)
    assert(fds[obj.fd] == nil)
    fds[obj.fd] = obj
end

function _M.del(obj)
    objs[obj.uid] = nil
    objs[obj.fd] = nil
end

function _M.have(uid)
    return objs[uid]
end

function _M.get(k)
    return objs[k]
end

function _M.get_by_fd(k)
    return fds[k]
end

function _M.foreach(cb, ...)
    for _, v in pairs(objs) do
        cb(v, ...)
    end
end

return _M
