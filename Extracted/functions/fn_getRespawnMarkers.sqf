/*
	Author: 
		Karel Moricky, optimised by Killzone_Kid

	Description:
		Returns all respawn markers for given side

	Parameter(s):
		0: SIDE - side to which markers belongs to
		1: BOOL - true to return vehicle respawn markers

	Returns:
		ARRAY
*/

params ["_side", ["_isVehicleRespawn", false]];
if (isNil "_side") then {_side = player call BIS_fnc_objectSide};

/// --- validate input
#include "..\paramsCheck.inc"
#define arr1 [_side,_isVehicleRespawn]
#define arr2 [sideUnknown,false]
paramsCheck(arr1,isEqualTypeParams,arr2)

if (_side in [east, west, resistance, civilian]) exitWith 
{
	private _marker = format ["respawn%1_%2", ["", "_vehicle"] select _isVehicleRespawn, _side];
	allMapMarkers select compile format ["_x select [0, %1] == '%2'", count _marker, _marker];
};

["Base respawn for %1 is not supported", _side] call BIS_fnc_error;
[]