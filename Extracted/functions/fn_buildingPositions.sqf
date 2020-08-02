/*
	Author: 
		Nelson Duarte, optimised by Killzone_Kid
	
	Description:
		This function return all available positions of a building defined in model, if any
	
	Parameter(s):
		0:	OBJECT	- The building object
		1:	NUMBER	- (Optional) The maximum number of positions to return. Not specified or -1 to return all
	
	Returns:
		ARRAY - List of all available positions within building
*/


params ["_building", ["_max", -1]];

/// --- validate general input
#include "..\paramsCheck.inc"
#define arr1 [_building,_max]
#define arr2 [objNull,0]
paramsCheck(arr1,isEqualTypeArray,arr2)

private _availablePositions = _building buildingPos -1;

if (_max < 0) exitWith {_availablePositions};

_availablePositions resize (_max min count _availablePositions);
_availablePositions