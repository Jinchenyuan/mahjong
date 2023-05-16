include "../path.lua"
project     = "testtest"
luaservice  = "./testtest/?.lua;" .. luaservice

thread      = 8
-- logger      = project .. "_master.log"
logservice  = "logger"
xlogpath    = "./logs/" .. project
xlogroll    = 512   -- M
harbor      = 1
address     = "127.0.0.1:2401"
master      = "127.0.0.1:2001"
start       = "main"	-- main script
bootstrap   = "snlua bootstrap"	-- The service for bootstrap
standalone  = "0.0.0.0:2001"
-- daemon      = "./" .. project .. "_m1.pid"

-- signup server
signupd      = "0.0.0.0:3001"
signupd_name = "WX_SIGNUPD"

-- login server
logind       = "0.0.0.0:3002"
logind_name  = "LOGIND"

-- gate server
gated        = "0.0.0.0:3301"
gated_name   = "sample1"
maxclient = 64


-- db server
db_host     = "127.0.0.1"
db_port     = 3306
db_database = "test"
db_user     = "root"
db_password = "123456"
cache_host  = "127.0.0.1"
cache_port  = 6379
cache_db    = 0