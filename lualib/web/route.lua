local skynet = require "skynet"
local urllib = require "http.url"
local handler = require "web.handler"
local json = require "rapidjson"
local log = require "chestnut.skynet.log"
local slt2 = require "slt2.slt2"

local function handleInternalError(ctx)
	ctx.status = 500
	ctx.body = "internale error"
end

local function handle406(ctx)
	ctx.status = 406
	ctx.body = "Not Acceptable"
end

local function handle404(ctx)
	ctx.status = 404
	ctx.body = "404 page"
end

local function JSONP(ctx, p)
	ctx.status = 200
	ctx.response.header["content-type"] = "application/json"
	ctx.body = json.encode(p)
end

local function HTML(ctx, path, p)
	ctx.status = 200
	-- local tmpl = slt2.loadstring(...)
	local tmpl = ""
	ctx.response.header["content-type"] = "text/html"
	ctx.response.body = slt2.render(tmpl, p)
end

local function TLP(ctx)
	ctx.status = 200
	-- local tmpl = slt2.loadstring(...)
	local tmpl = ""
	ctx.response.header["content-type"] = "text/html"
	ctx.body = slt2.render(tmpl, p)
end

local function route(ctx, urls)
	-- 复制header
	for k, v in pairs(ctx.header) do
		ctx.response.header[k] = v
	end
	ctx.response.header["content-length"] = nil
	ctx.JSONP = JSONP
	ctx.HTML = HTML
	ctx.handle406 = handle406
	ctx.handle404 = handle404
	if ctx.method == "GET" then
		local ok, ret = pcall(handler.handle_get, ctx, urls)
		if not ok then
			log.error("ret = %s", ret)
			handleInternalError(ctx)
		end
	elseif ctx.method == "POST" then
		local ok, ret = pcall(handler.handle_post, ctx, urls)
		if not ok then
			log.error("ret = %s", ret)
			handleInternalError(ctx)
		end
	end
end

return {route = route}
