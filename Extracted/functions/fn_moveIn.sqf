/*
	Author: 
		Karel Moricky, optimised by Killzone_Kid

	Description:
		Moves a unit into vehicle. If no role specified, or role is "", unit is moved into any available position
		Compatible with assignedVehicleRole output format
		NOTE: In MP this function should be used only where the unit you are moving in is local

	Parameters:
		0: OBJECT - vehicle
		1: OBJECT - unit
		2: 
			ARRAY - role in format [name] or [name, position]
			STRING - role name

	Returns:
		BOOL - true if moved in succesfully
*/

/// --- validate general input
#include "..\paramsCheck.inc"
#define arr [objNull,objNull]
paramsCheck(_this,isEqualTypeParams,arr)

params ["_vehicle", "_unit", ["_role", ""]];
_role params ["_role", ["_seat", [-1]]];

if !(_role isEqualType "") then {_role = str _role};
 
toLower _role call
{
	if (_this isEqualTo "") exitWith {_unit moveInAny _vehicle};	
	if (_this isEqualTo "driver") exitWith {_unit moveInDriver _vehicle};
	if (_this isEqualTo "turret") exitWith 
	{
		if (_seat isEqualTo [-1]) exitWith {_unit moveInDriver _vehicle};
		if (_seat isEqualType [] && {_seat isEqualTypeAll 0}) exitWith {_unit moveInTurret [_vehicle, _seat]};
		["Given turret path '%1' is invalid", _seat] call BIS_fnc_error;
	};
	if (_this isEqualTo "cargo") exitWith {_unit moveInCargo ([_vehicle, [_vehicle, _seat]] select (_seat isEqualType 0))};
	if (_this isEqualTo "commander") exitWith {_unit moveInCommander _vehicle};
	if (_this isEqualTo "gunner") exitWith {_unit moveInGunner _vehicle};
	//--- Error
	["'%1' is not a supported vehicle role, must be one of: 'DRIVER', 'COMMANDER', 'GUNNER', 'TURRET', 'CARGO' or ''", _role] call BIS_fnc_error;
};

_unit in _vehicle 