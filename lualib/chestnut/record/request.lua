-- 这个文件会被agent里的同名文件引用
local skynet = require "skynet"
local REQUEST = require "request"

function REQUEST.fetch_records(fd, args)
	return context.fetch_records(fd, args)
end

return REQUEST
