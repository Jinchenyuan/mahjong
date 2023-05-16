local skynet = require "skynet"
local _M = {}

function _M.board(...)
	return skynet.call(".RADIOCENTER", "lua", "board")
end

function _M.adver(...)
	return skynet.call(".RADIOCENTER", "lua", "adver")
end

return _M
