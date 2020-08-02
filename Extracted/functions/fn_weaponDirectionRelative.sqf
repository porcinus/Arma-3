/*
	Author: 
		Killzone_Kid
	
	Description:
		Returns relative direction vector of given weapon for the given vehicle
	
	Parameter(s):
		0: [Object] - vehicle
		1: [String] - vehicle weapon
		2: [Boolean] - (Optional) if true - result is in render scope, false - simulation scope. Default: true
	
	Returns:
		[Array] in format [x,y,z]
	
	Example:
		_relweapondir = [tank, "cannon_105mm"] call BIS_fnc_weaponDirectionRelative;
*/


/// --- validate input
#include "..\paramsCheck.inc"
#define arr [objNull,""]
paramsCheck(_this,isEqualTypeParams,arr)

params ["_veh", "_wep", ["_visual", true]];

if (_visual isEqualTo true) exitWith {_veh vectorWorldToModelVisual (_veh weaponDirection _wep)};

_veh vectorWorldToModel (_veh weaponDirection _wep)