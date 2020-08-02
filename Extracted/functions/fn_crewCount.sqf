/*
	Author: 
		Karel Moricky, modified by Killzone_Kid

	Description:
		Returns number of crew positions in vehicle.
		By default cargo positions and FFV turrets are excluded.

	Parameter(s):
		0: STRING (vehicle class) vehicle
		1: BOOL - (Optional) true to also include cargo/FFV positions

	Returns:
		NUMBER
*/

params [["_class", -1], ["_inclCargo", false]];

/// --- validate input
#include "..\paramsCheck.inc"
paramsCheck(_class,isEqualType,"")

private _cfg = configFile >> "CfgVehicles" >> _class;
private _turrets = 0;

if (_inclCargo isEqualTo true) exitWith
{
	private _fnc_turretsFFV = 
	{
		{
			_turrets = _turrets + 1;
			if (isClass (_x >> "Turrets")) then {_x call _fnc_turretsFFV};
		}
		forEach ("true" configClasses (_this >> "Turrets"));
	};

	_cfg call _fnc_turretsFFV;
	
	getNumber (_cfg >> "hasDriver") + // driver
	getNumber (_cfg >> "transportSoldier") + // all cargo positions
	_turrets // all turrets including FFV
};

private _fnc_turrets = 
{
	{
		if !(getNumber (_x >> "showAsCargo") > 0) then {_turrets = _turrets + 1};
		if (isClass (_x >> "Turrets")) then {_x call _fnc_turrets};
	}
	forEach ("true" configClasses (_this >> "Turrets"));
};

_cfg call _fnc_turrets;

getNumber (_cfg >> "hasDriver") + // driver
_turrets // default turrets