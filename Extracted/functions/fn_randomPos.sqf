/*
	Author: 
		Karel Moricky, optimised by Killzone_Kid

	Description:
		Selects random position according to given params within given area

	Parameter(s):
		0: (Optional)
			ARRAY - whitelisted areas. Areas could be:
				OBJECT - trigger
				STRING - marker
				ARRAY - [center, radius] or [center, [a, b, angle, rect]]
				LOCATION - location
				Default value - ARRAY (map area)
		1: (Optional)			
			ARRAY - blacklisted areas. Areas could be:
				OBJECT - trigger
				STRING - marker
				STRING - special tags: 
					"water" - exclude water
					"ground" - exclude land
				ARRAY - [center, radius] or [center, [a, b, angle, rect]]
				LOCATION - location
				Default value - ["water"]
		2: (Optional)
			CODE - custom condition than returns true

	Returns:
		ARRAY - [x,y,z] or [0,0] if position cannot be allocated
		
	Example 1:
		_randomPosMapNoWater = [] call BIS_fnc_randomPos;
		or
		_randomPosMapNoWater = [nil,["water"]] call BIS_fnc_randomPos;
	
	Example 2:
		_randomPosMapNoLand = [nil,["ground"]] call BIS_fnc_randomPos;
		
	Example 3:
		_randomPosMap = [nil,[]] call BIS_fnc_randomPos;
	
	Example 4:	
		_randomPosAroundPlayer = [[[position player,50]],[]] call BIS_fnc_randomPos;
	
*/

private _mapSize = worldSize / 2;
private _wordArea = [[_mapSize, _mapSize, 0], _mapSize, _mapSize, 0, true];
params [["_whiteList", [_wordArea]], ["_blackList", ["water"]], ["_condition", {true}]];

/// --- validate input
#include "..\paramsCheck.inc"
#define arr1 [_whiteList,_blackList,_condition]
#define arr2 [[],[],{}]
paramsCheck(arr1,isEqualTypeParams,arr2)

private _noWater = false;
private _noLand = false;
private _result = [0,0]; //--- [x,y] only to indicate failure

//--- normalise blacklist
private _blackListClean = [];
{
	call
	{
		private _tag = _x param [0, ""];
		if (_tag isEqualType "") then {_tag = toLower _tag};
		if (_tag isEqualTo "water") exitWith {_noWater = true}; 
		if (_tag isEqualTo "ground") exitWith {_noLand = true}; 
		_blackListClean pushBack (_x call bis_fnc_getArea);
	};
} 
forEach _blackList;

//--- Attempt to find position candidate
for "_i" from 0 to 99 do 
{
	//--- Select random position in random whitelisted area
	private _posCandidate = selectRandom _whiteList call BIS_fnc_randomPosTrigger;
	
	if 
	(
		!(
			//--- Check position against water
			(_noWater && {surfaceIsWater _posCandidate}) 
			||
			//--- Check position against land			
			(_noLand && {!surfaceIsWater _posCandidate})
		)
		&&
		{
			//--- Check position against black list
			{if (_posCandidate inArea _x) exitWith {1}} count _blackListClean == 0
		}
		&&
		//--- Check position against condition
		{_posCandidate call _condition}
	) 
	exitWith {_result = _posCandidate};
};

_result