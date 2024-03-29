#define LUA_LIB

#include "lua.hpp"
#include "NFCNavigationModule.h"

struct pathfinding {
	NFCNavigationHandle *handle;
};

static int
lalloc(lua_State *L) {
	size_t l;
	const char *respath = luaL_checklstring(L, 1, &l);
	struct pathfinding *nav = (struct pathfinding *)lua_newuserdata(L, sizeof(struct pathfinding));
	nav->handle = NFCNavigationHandle::Create(respath);

	lua_pushvalue(L, lua_upvalueindex(1));
	lua_setmetatable(L, -1);
	return 1;
}

static int 
lFindStraightPath(lua_State *L) {
	struct pathfinding *nav = (struct pathfinding *)lua_touserdata(L, 1);
	lua_Number start_x = luaL_checknumber(L, 2);
	lua_Number start_y = luaL_checknumber(L, 3);
	lua_Number start_z = luaL_checknumber(L, 4);
	lua_Number end_x = luaL_checknumber(L, 5);
	lua_Number end_y = luaL_checknumber(L, 6);
	lua_Number end_z = luaL_checknumber(L, 7);

	float start[3];
	start[0] = start_x;
	start[1] = start_y;
	start[2] = start_z;

	float end[3];
	end[0] = end_x;
	end[1] = end_y;
	end[2] = end_z;

	std::vector<std::array<float, 3>> paths;
	int pos = nav->handle->FindStraightPath(start, end, paths);
	if (pos > 0)
	{
		lua_pushinteger(L, pos);
		return 1;
	}
	return 0;
}

static int
lFindRandomPointAroundCircle(lua_State *L/*, const float* centerPos, std::vector<float[3]>& points, int32_t max_points, float maxRadius*/) {
	struct pathfinding *nav = (struct pathfinding *)lua_touserdata(L, 1);
	lua_Number start_x = luaL_checknumber(L, 1);
	lua_Number start_y = luaL_checknumber(L, 2);
	lua_Number start_z = luaL_checknumber(L, 3);
	return 0;
}

static int 
lRaycast(lua_State *L) {
	struct pathfinding *nav = (struct pathfinding *)lua_touserdata(L, 1);
	lua_Number start_x = luaL_checknumber(L, 2);
	lua_Number start_y = luaL_checknumber(L, 3);
	lua_Number start_z = luaL_checknumber(L, 4);
	lua_Number end_x = luaL_checknumber(L, 5);
	lua_Number end_y = luaL_checknumber(L, 6);
	lua_Number end_z = luaL_checknumber(L, 7);

	float start[3];
	start[0] = start_x;
	start[1] = start_y;
	start[2] = start_z;

	float end[3];
	end[0] = end_x;
	end[1] = end_y;
	end[2] = end_z;

	std::vector<std::array<float, 3>> hitPointVec;
	int res = nav->handle->Raycast(start, end, hitPointVec);
	lua_pushinteger(L, res);
	lua_newtable(L);
	for (size_t i = 0; i < hitPointVec.size(); i++)
	{
		lua_newtable(L);
		lua_pushinteger(L, hitPointVec[i][0]);
		lua_setfield(L, -2, "x");
		lua_pushinteger(L, hitPointVec[i][1]);
		lua_setfield(L, -2, "y");
		lua_pushinteger(L, hitPointVec[i][2]);
		lua_setfield(L, -2, "z");
	}
	return 2;
}

extern "C" {
LUAMOD_API int luaopen_navigation(lua_State *L);
}

LUAMOD_API int
luaopen_navigation(lua_State *L) {
	luaL_checkversion(L);
	luaL_Reg metatable[] = {
		{ "FindStraightPath", lFindStraightPath },
		{ "FindRandomPointAroundCircle", lFindRandomPointAroundCircle },
		{ "Raycast", lRaycast },
		{ NULL, NULL },
	};
	luaL_newlib(L, metatable);
	lua_pushcclosure(L, lalloc, 1);

	return 1;
}
