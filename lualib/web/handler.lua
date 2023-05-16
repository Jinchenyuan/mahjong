local skynet = require "skynet"
local log = require "chestnut.skynet.log"
local mime = require "web.mime"
local static_cache = {}
local cache = true
local root = skynet.getenv "http_root"
local tableDump = require "luaTableDump"

local _M = {}

local function unpack_seg(text, s)
	assert(text and s)
	local from = text:find(s, 1, true)
	if from then
		return text:sub(1, from - 1), text:sub(from + 1)
	else
		return text
	end
end

local function unpack_line(text)
	local from = text:find("\n", 1, true)
	if from then
		return text:sub(1, from - 1), text:sub(from + 1)
	end
	return nil, text
end

local function split_file_name(path, ...)
	assert(type(path) == "string")
	return ""
end

local function split_file_suffix(path, ...)
	return ""
end

local function parse_body(ctx, boundary, ...)
	local str = tostring(...)
	if str and #str > 0 then
		local r = {}
		local function split(str)
			local p = string.find(str, "=")
			local key = string.sub(str, 1, p - 1)
			local value = string.sub(str, p + 1)
			r[key] = value
		end
		local s = 1
		repeat
			local p = string.find(str, "&", s)
			if p ~= nil then
				local frg = string.sub(str, s, p - 1)
				s = p + 1
				split(frg)
			else
				local frg = string.sub(str, s)
				split(frg)
				break
			end
		until false
		return r
	else
		return str
	end
end

local function parse_file(ctx, boundary)
	local header = ctx.header
	local body = ctx.request.body
	local line = ""
	local file = ""
	local last = body
	local mark = string.gsub(boundary, "^-*(%d+)-*", "%1")
	line, last = unpack_line(last)
	assert(string.match(line, string.format("^-*(%s)-*", mark)))
	line, last = unpack_line(last)
	line, last = unpack_line(last)
	line, last = unpack_line(last)
	line, last = unpack_line(last)
	while line do
		if string.match(line, string.format("^-*(%s)-*", mark)) then
			break
		else
			file = file .. line .. "\n"
			line, last = unpack_line(last)
		end
	end
	header["content-type"] = nil
	return file, header
end

local function parse_content_type(ctx)
	local header = ctx.header
	local mime_version = header["mime-version"]
	local content_type = header["content-type"]
	local content_transfer_encoding = header["content-transfer-encoding"]
	local content_disposition = header["content-disposition"]
	local content_length = header["content-length"]
	if content_type then
		log.info("header = %s", tableDump(header))
		local t, param = unpack_seg(content_type, ";")
		if t == "multipart/form-data" then
			-- TODO:
			-- 解析文件
			local idx = string.find(param, "=")
			local boundary = string.sub(param, idx + 1)
			return t, boundary
		else
			local parameter = {}
			while param do
				local p, e = unpack_seg(param, ";")
				if p then
					local k, v = unpack_seg(p, "=")
					k = tostring(k)
					parameter[k] = v
					param = e
				else
				end
			end
			return t, boundary
		end
	end
end

local function post_handler(ctx, urls)
	local path = ctx.path
	local v = urls.post[path]
	if v then
		local ok, ret = pcall(v, ctx)
		if ok then
			local d = {
				code = 0,
				data = ret
			}
			ctx.JSONP(ctx, d)
		else
			log.error("ret = %s", ret)
			local d = {
				code = 1
			}
			ctx.JSONP(ctx, d)
		end
	else
		ctx.handle404(ctx)
	end
end

local function static_handler(path, ...)
	if cache then
		if static_cache[path] then
			return true, static_cache[path]
		else
			local fpath = root .. path
			local fd = io.open(fpath, "r")
			if fd == nil then
				log.error(string.format("fpath is wrong, %s", fpath))
				return false
			else
				local r = fd:read("a")
				fd:close()
				static_cache[path] = r
				return true, r
			end
		end
	else
		local fpath = root .. path
		local fd = io.open(fpath, "r")
		if fd == nil then
			log.error(string.format("fpath is wrong, %s", fpath))
			return false
		else
			local r = fd:read("a")
			fd:close()
			static_cache[path] = r
			return true, r
		end
	end
end

function _M.handle_post(ctx, urls)
	local t, boundary = parse_content_type(ctx)
	if t == "application/x-www-form-urlencoded" then
		post_handler(ctx, urls)
		return
	elseif t == "application/json" then
		post_handler(ctx, urls)
		return
	elseif t == "multipart/form-data" then
		if boundary then
			lgo.info("boundary = %s", boundary)
			local res = parse_body(ctx, boundary)
			post_handler(ctx, urls)
			return
		else
			post_handler(ctx, urls)
			return
		end
	else
		post_handler(ctx, urls)
		return
	end
end

function _M.handle_static(code, path, header, body, handle_static, ...)
	if string.match(path, "^/[%w%./-]+%.%w+") then
		local ok, res = fetch_static(path)
		return ok, code, {}, res
	else
		local mime_version = header["mime-version"]
		local content_type = header["content-type"]
		local content_transfer_encoding = header["content-transfer-encoding"]
		local content_disposition = header["content-disposition"]
		local content_length = header["content-length"]
		local name = split_file_name(path)
		for _, v in pairs(mime) do
			local fpath = path .. "." .. v[1]
			local ok, res = fetch_static(fpath)
			if ok then
				return ok, code, {}, res
			end
		end

		return false
	end
end

function _M.handle_get(ctx, urls)
	local path = ctx.path
	local v = urls.get[path]
	if v then
		local ok, ret = pcall(v, ctx)
		if ok then
			local d = {
				code = 0,
				data = ret
			}
			ctx.JSONP(ctx, d)
		else
			local d = {
				code = 1,
				data = ret
			}
			ctx.JSONP(ctx, d)
		end
	else
		ctx.handle404(ctx)
	end
end

return _M
