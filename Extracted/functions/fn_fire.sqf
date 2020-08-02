/*
	Author: 
		Killzone_Kid

	Description:
		Makes a unit or a vehicle fire given muzzle. Make sure that there is some ammo to fire, and, in case of a unit, the weapon with given muzzle is already selected.

	Parameters:
		0:	OBJECT - unit or vehicle
		1:	STRING - muzzle name of the muzzle to fire
		2 (Optional):	ARRAY - turret path of the turret with given muzzle (vehicles only)

	Returns:
		BOOLEAN - in SP and on hosted server in MP. true if all checks have passed and muzzle should have fired, false if there was a problem, for example:
			* no ammo
			* non-existing muzzle
			* the muzzle is on weapon that is not selected
			* the weapon has no unit operating it
		
		NOTHING - on client in MP

*/

params ["_entity", "_muzzle", ["_turret", []]];

/// --- validate input
#include "..\paramsCheck.inc"
#define arr1 [_entity,_muzzle,_turret]
#define arr2 [objNull,"",[]]
paramsCheck(arr1,isEqualTypeParams,arr2)

if (!isServer) exitWith 
{
	_this remoteExecCall ["BIS_fnc_fire", 2]; //--- make it global in MP
	nil
};

private _fnc_forceWeaponFire = 
{
	params ["_unit", "_mode"];
	
	if (_mode isEqualTo "") exitWith {}; //--- no suitable muzzle
	if (_mode == "this") then {_mode = _muzzle};
	
	[_unit, [_muzzle, _mode]] remoteExec ["forceWeaponFire", _unit];
	true
};

if (_entity isKindOf "CAManBase") then
{	
	!isNil
	{
		if !(_entity ammo _muzzle isEqualTo 0) then 
		{
			private _cfgWeapons = configFile >> "CfgWeapons";
			private _cfgThrowMuzzle = _cfgWeapons >> "Throw" >> _muzzle;
			
			if (!isNull _cfgThrowMuzzle) exitWith {[_entity, getArray (_cfgThrowMuzzle >> "modes") param [0, ""]] call _fnc_forceWeaponFire};
			
			private _state = weaponState _entity;
			
			if (isNil "_state" || {_state isEqualTo ["","","","",0]}) exitWith {}; //--- cannot get weapon state info
			
			0 = _state params ["_currentWeapon", "_currentMuzzle", "_currentMode"];
			
			if (_muzzle == _currentMuzzle) exitWith {[_entity, _currentMode] call _fnc_forceWeaponFire};

			{
				if (_x == "this" && _muzzle == _currentWeapon) exitWith {[_entity, getArray (_cfgWeapons >> _currentWeapon >> "modes") param [0, ""]] call _fnc_forceWeaponFire};
				if (_x == _muzzle) exitWith {[_entity, getArray (_cfgWeapons >> _currentWeapon >> _muzzle >> "modes") param [0, ""]] call _fnc_forceWeaponFire};
			}
			forEach getArray (_cfgWeapons >> _currentWeapon >> "muzzles");
		};
	};
} 
else
{
	{
		if (
			!isNil
			{
				private _thisTurret = _x;
				
				private _state = weaponState [_entity, _thisTurret, _muzzle];
				
				if (isNil "_state" || {_state isEqualTo ["","","","",0]}) exitWith {}; //--- cannot get weapon state info
				
				0 = _state params ["", "_thisMuzzle", "_thisMode", "_thisMagazine", "_thisAmmo"];
				
				private _firerer = _entity turretUnit _thisTurret;

				if (!isNull _firerer) then
				{
					if (_thisMagazine isEqualTo "" && _muzzle == _thisMuzzle) exitWith {[_firerer, _thisMode] call _fnc_forceWeaponFire}; //--- horn and stuff
					
					{
						0 = _x params ["_xMagazine", "_xTurret", "_xAmmo", "_id", "_owner"];
						
						if (_xTurret isEqualTo _thisTurret && _xMagazine == _thisMagazine && _xAmmo == _thisAmmo && _xAmmo != 0) exitWith
						{
							[_entity, ["UseMagazine", _entity, _firerer, _owner, _id]] remoteExec ["action", _entity turretOwner _thisTurret];
							true
						};
					}
					forEach magazinesAllTurrets _entity;
				};
			}
		)
		exitWith {true};
		
		false
	}
	forEach ([[_turret],[[-1]] + allTurrets _entity] select (_turret isEqualTo []));
};