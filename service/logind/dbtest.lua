local skynet = require "skynet"
require "skynet.manager"
local dbw = require "dbwrite.db"
local dbr = require "dbread.db"
local table_dump = require "luaTableDump"

local function test_account()
    local account = {}
    account.username = "xheee"
    account.password = "xxx"
    account.uid = 123
    account.create_at = os.time()
    dbw.write_account(account)

    -- local res = dbr.read_account_by_username("lihao", "123456")
    -- skynet.error(table_dump(res))
end

local function test_nameid()
    local account = {}
    account.nameid = "xxas"
    account.uid = 11
    dbw.write_nameid(account)
end

skynet.start(
    function()
        test_account()
        -- test_nameid()
        skynet.exit()
    end
)
