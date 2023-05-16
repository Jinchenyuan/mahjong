local skynet = require "skynet"
local log = require "chestnut.skynet.log"
local tableDump = require "luaTableDump"
local dbread = require "dbread.db"
local VIEW = {}

function VIEW.version(ctx)
    log.info("hello version")
    log.info(tableDump(ctx))
    return {
        ver = "1.0.1"
    }
end

function VIEW:abort()
    print("hello abort")
end

function VIEW:get_account()
    log.info("%s", tableDump(self))
    -- local res = dbread.read_sysmail()
    -- return res
end

function VIEW:add_account()
end

function VIEW:update_account()
end

function VIEW:del_account()
end

return VIEW
