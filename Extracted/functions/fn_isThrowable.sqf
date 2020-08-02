/*
	Author: 
		Killzone_Kid

	Description:
		Returns true if given magazine is throwable

	Parameter(s):
		0: STRING - magazine class name

	Returns:
		BOOL - true if throwable
		
	Example:
		_isThrowable = "SmokeShellGreen" call BIS_fnc_isThrowable
*/

/// --- validate input
#include "..\paramsCheck.inc"
paramsCheck(_this,isEqualType,"")

private _cfgMagazine = configFile >> "CfgMagazines" >> _this;

if (getNumber (_cfgMagazine >> "initSpeed") < 30) exitWith
{
	toLower getText (configFile >> "CfgAmmo" >> getText (_cfgMagazine >> "ammo") >> "simulation") in [
		"shotgrenade", 					
		"shotsmokex",
		"shotsmoke", 
		"shotsubmunitions", 
		"shotdeploy", 
		"shotilluminating", 
		"shotshell", 
		"shotnvgmarker"
	]
};

false