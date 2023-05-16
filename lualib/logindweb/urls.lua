local xroute = require "web.route"
local manager = require "logindweb.manager"
local view = require "logindweb.view"

local _M = {
    get = {},
    post = {}
}

-- main
_M.get["/test"] = assert(view["test"])
_M.get["/stat"] = assert(view["stat"])

-- manager
_M.get["/manager/version"] = assert(manager["version"])
_M.post["/manager/abort"] = assert(manager["abort"])
_M.post["/manager/getaccount"] = assert(manager["get_account"])

local function route(ctx)
    xroute.route(ctx, _M)
end

return {route = route}
