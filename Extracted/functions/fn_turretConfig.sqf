/*
	Author:
		Killzone_Kid

	Description:
		Returns vehicle turret config for the turret given by the turret path
		Using [-1] for turret path returns vehicle config

	Parameter(s):
		ARRAY
			0: STRING or OBJECT - vehicle
			1: ARRAY - turret path

	Returns:
		CONFIG - turret config or configNull
		
	Example:
		["B_APC_Wheeled_01_cannon_F", [0,0]] call BIS_fnc_turretConfig;
		[car1, [-1]] call BIS_fnc_turretConfig;
*/

params [["_vehicle", "", ["", objNull]], ["_path", [], [[]]]];

if !(_path isEqualTypeAll 0) exitWith { configNull };

private _turret = configFile >> "CfgVehicles" >> (if (_vehicle isEqualType "") then { _vehicle } else { typeOf _vehicle });
	
//-- if driver turret return vehicle config
if (_path isEqualTo [-1]) exitWith { _turret };
	
{
	private _turrets = _turret >> "Turrets";
	_turret = if (_x >= 0 && _x < count _turrets) then { _turrets select _x } else { configNull };
}
forEach _path;

_turret 