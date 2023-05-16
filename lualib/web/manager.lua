local skynet = require "skynet"
local log = require "chestnut.skynet.log"
local tableDump = require "luaTableDump"
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

return VIEW
