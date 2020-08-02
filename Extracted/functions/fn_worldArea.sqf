/*
	Author: 
		Karel Moricky, modified by Killzone_Kid

	Description:
		Creates (or returns if it already exists) trigger with size of map

	Parameter(s):
		NOTHING

	Returns:
		OBJECT - local trigger
*/

if (isNil "hsim_worldArea") then
{
	private _mapSize = worldSize / 2;
	hsim_worldArea = createTrigger ["EmptyDetector", [_mapSize, _mapSize], false];
	hsim_worldArea setTriggerArea [_mapSize, _mapSize, 0, true];
};

hsim_worldArea