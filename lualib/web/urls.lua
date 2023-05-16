local xroute = require "web.route"
local view = require "web.view"
local manager = require "web.manager"
-- local pet = require "web.pet.view"

local _M = {
    get = {},
    post = {}
}

-- main
_M.get["/"] = assert(view["index"])
_M.get["/index"] = assert(view["index"])
_M.get["^/user$"] = assert(view["user"])
_M.get["^/role"] = assert(view["role"])
_M.get["/get_email"] = assert(view["get_email"])
_M.get["^/props"] = assert(view["props"])
_M.get["^/equipments"] = assert(view["equipments"])
_M.get["^/validation"] = assert(view["validation"])
_M.get["^/validation_ro"] = assert(view["validation_ro"])
_M.get["^/percudure"] = assert(view["percudure"])
_M.get["^/404"] = assert(view["_404"])
_M.get["^/test"] = assert(view["test"])

-- manager
_M.get["/manager/version"] = assert(manager["version"])
_M.post["/manager/abort"] = assert(manager["abort"])

local function route(ctx)
    xroute.route(ctx, _M)
end

return {route = route}
