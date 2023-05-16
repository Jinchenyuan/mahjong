-- 这个文件会被agent里的同名文件引用
local skynet = require "skynet"
local client = require "client"
local REQUEST = client.request()
local objmgr = require "objmgr"
local traceback = debug.traceback

function REQUEST.fetchinbox(self, args)
	return context.fetch(self.obj, args)
end

function REQUEST.syncsysmail(self, args)
	return context.sync(self.obj, args)
end

function REQUEST.viewedsysmail(self, args)
	return context.viewed(self.obj, args)
end

return REQUEST
