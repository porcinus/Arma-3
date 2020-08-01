/*
	Author:
		Killzone_Kid

	Description:
		Returns all vehicle turrets from config with options. 
		Does what allTurrets command (https://community.bistudio.com/wiki/allTurrets) does, 
		except the param is vehicle's config class name

	Parameter(s):
		STRING - vehicle class name
		OR
		ARRAY
			0: STRING - vehicle classname
			1: BOOLEAN
				true - include FFV turrets
				false - exclude FFV turrets

	Returns:
		ARRAY of turret paths
		
	Example:
		_allTurrets = "C_Offroad_01_F" call BIS_fnc_allTurrets; //[]
		_allTurrets = ["C_Offroad_01_F", true] call BIS_fnc_allTurrets; //[[0],[1],[2],[3]]
		_allTurrets = ["C_Offroad_01_F", false] call BIS_fnc_allTurrets; //[]
*/

params [["_class", ""], "_inclFFV"];

/// --- validate input
#include "..\paramsCheck.inc"
paramsCheck(_class,isEqualType,"")

private _turrets = [];
private _path = [];
private _fnc_turrets = 
{
	private _index = 0;
	{
		if !(call _condition) then
		{
			_path append [_index];
			_turrets pushBack +_path;
			_index = _index + 1;
		};
			
		if (isClass (_x >> "Turrets")) then
		{
			_x call _fnc_turrets;
			_path deleteAt (count _path - 1);
		};
	}
	forEach ("true" configClasses (_this >> "Turrets"));
};

if (isNil "_inclFFV") exitWith // classic turrets
{
	private _condition = {getNumber (_x >> "showAsCargo") > 0};
	(configFile >> "CfgVehicles" >> _class) call _fnc_turrets; 
	_turrets
};

if (_inclFFV isEqualTo true) exitWith // include person (cargo) FFV (firing from vehicle) turrets
{
	private _condition = {false};
	(configFile >> "CfgVehicles" >> _class) call _fnc_turrets; 
	_turrets
};

if (_inclFFV isEqualTo false) exitWith // exclude person (cargo) FFV turrets
{
	private _condition = {getNumber (_x >> "isPersonTurret") > 0};
	(configFile >> "CfgVehicles" >> _class) call _fnc_turrets;
	_turrets 
};

["Please check the function description for correct usage"] call BIS_fnc_error;
_turrets 