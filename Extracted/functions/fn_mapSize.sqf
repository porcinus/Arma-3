/*
	Author: 
		Karel Moricky, tweaked by Killzone_Kid

	Description:
		Returns map size from config or -1 if does not exist

	Parameter(s):
		0 (Optional): STRING - world name (current world used as default)

	Returns:
		NUMBER
*/

params [["_map", worldName, [""]]];

private _config = configFile >> "cfgWorlds" >> _map >> "mapSize";

if (isNumber _config) exitWith { getNumber _config };
if (isText _config) exitWith { parseNumber getText _config };

-1 