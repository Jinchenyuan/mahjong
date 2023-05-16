local skynet = require "skynet"
local log = require "chestnut.skynet.log"
local util = require "common.utils"
local service = require "service"
local servicecode = require "enum.servicecode"
local lifemgr = require "lifemgr"
local assert = assert
local users = {} -- uid:u
local agents = {} -- agent:count
local MAX_U = 5

local CMD = {}

------------------------------------------
-- 游戏设计
function CMD.start()
	agents["agent"] = {
		id = 1,
		q = {}
	}
	local addr = lifemgr.newservice("agent")
	table.insert(agents["agent"].q, {addr = addr})
	return true
end

function CMD.create_user()
end

function CMD.enter(uid, key)
	local pool = agents[key]
	local agent = pool.q[pool.id]
	pool.id = pool.id + 1
	return agent.addr
end

-- 次方法实现有问题，暂时不理
function CMD.exit(uid)
	assert(uid)
	local u = users[uid]
	if u then
		local cancel =
			util.set_timeout(
			100 * 60 * 60,
			function()
				-- body
				cs(enqueue, u.addr)
				users[uid] = nil
			end
		)
		u.cancel = cancel
		return true
	end
	return false
end

function CMD.exit_at_once(uid)
	-- local u = assert(users[uid])
	-- local cnt = agents[u.addr]
	-- agents[u.addr] = cnt - 1
	-- cs(enqueue, u)
	-- users[uid] = nil
	return servicecode.SUCCESS
end

service.init {
	name = ".discoveryd",
	command = CMD
}
