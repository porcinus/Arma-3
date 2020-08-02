/*
	Author: 
		Dean "Rocket" Hall, reworked by Killzone_Kid

	Description:
		This function will make weapon team pack a static weapon
		The weapon crew will pack carried weapon (or given weapon if different) and follow leader
		Requires three personnel in the team: Team Leader, Gunner and Asst. Gunner
		This function is MP compatible
		When weapon is packed, scripted EH "StaticWeaponPacked" is called with the following params: [group, leader, gunner, assistant, weaponBag, tripodBag]

	Parameters:
		0: GROUP or OBJECT - the support team group or a unit from this group
		1: (Optional) OBJECT - weapon to pack. If nil, current group weapon is packed
		2: (Optional) ARRAY, STRING or OBJECT - position, object or marker the group leader should move to after weapon is packed. By default the group will
		   resume on to the next assigned waypoint. If this param is provided, group will not go to the next waypoint and will move to given position instead
		
	Returns:
		NOTHING
	
	NOTE:
		If a unit flees, all bets are off and the function will exit leaving units on their own
		To guarantee weapon disassembly, make sure the group has maximum courage (_group allowFleeing 0)
	
	Example1:
		[leader1] call BIS_fnc_packStaticWeapon;
		
	Example2:
		group1 allowFleeing 0;
		[group1, nil, "leaderpos_marker"] call BIS_fnc_packStaticWeapon;
*/

params [
	["_group", grpNull, [grpNull, objNull]], 
	["_weapon", objNull, [objNull]],
	["_leaderPos", [0,0,0], [[], "", objNull], 3]
];

private _leader = leader _group;
if (!local _leader) exitWith {_this remoteExecCall ["BIS_fnc_packStaticWeapon", _leader]};

private _err_badGroup = 
{
	["Bad group! The group should exist and consist of minimum a Leader, Gunner and Asst. Gunner"] call BIS_fnc_error;
	nil
};

private _err_badPosition = 
{
	["Bad position! Position should exist and could be array, marker or object"] call BIS_fnc_error;
	nil
};

private _err_badWeapon = 
{
	["Bad static weapon! Static weapon should exist and not be packed or broken"] call BIS_fnc_error;
	nil
};

if (_group isEqualType objNull) then {_group = group _group};
if (isNull _group) exitWith _err_badGroup;

if (_leaderPos isEqualType "") then {_leaderPos = getMarkerPos _leaderPos};
if (_leaderPos isEqualType objNull) then {_leaderPos = getPosATL _leaderPos};

private _cfg = configFile >> "CfgVehicles";
private _supportUnits = (units _group - [_leader]) select {getText (_cfg >> typeOf _x >> "vehicleClass") == "MenSupport"};

private _gunnerBackpackClass = "";
private _gunner = 
{
	// -- unit is weapon carrier
	_gunnerBackpackClass = getText (_cfg >> typeOf _x >> "backpack");
	
	if (_gunnerBackpackClass isKindOf "Weapon_Bag_Base") exitWith {_x};
	
	objNull
} 
forEach _supportUnits;

if (isNull _gunner) exitWith _err_badGroup;

private _cfgBase = configFile >> "CfgVehicles" >> _gunnerBackpackClass >> "assembleInfo" >> "base";
private _compatibleBases = if (isText _cfgBase) then {[getText _cfgBase]} else {getArray _cfgBase};
private _assistant = 
{	
	private _xx = _x;
	
	if (
		{
			// -- unit is assistant weapon carrier
			getText (_cfg >> typeOf _xx >> "backpack") isKindOf _x
		} 
		count _compatibleBases > 0
	) 
	exitWith {_xx};
	
	objNull
}
forEach (_supportUnits - [_gunner]);

if (isNull _assistant) exitWith _err_badGroup;

private _isWeaponGunner = false;

if (isNull _weapon) then 
{
	_weapon = assignedVehicle _gunner;
	_isWeaponGunner = objectParent _gunner isEqualTo _weapon;
};

if (!alive _weapon || !(_weapon isKindOf "StaticWeapon") || !isNull objectParent _weapon) exitWith _err_badWeapon;

_gunner addEventHandler ["WeaponDisassembled", format [
	'
		params ["_gunner", "_weaponBag", "_baseBag"];
		
		_gunner removeEventHandler ["WeaponDisassembled", _thisEventHandler];
		
		_leader = "%1" call BIS_fnc_objectFromNetId;
		_assistant = "%2" call BIS_fnc_objectFromNetId;
		
		_gunner action ["TakeBag", _weaponBag];
		_assistant action ["TakeBag", _baseBag];
			
		_gunner setUnitPos "AUTO";
		_gunner doWatch objNull;
		_gunner doFollow _leader;
		
		_assistant setUnitPos "AUTO";
		_assistant doWatch objNull;
		_assistant doFollow _leader;
		
		_group = group _gunner;
		[_group, "StaticWeaponPacked", [_group, _leader, _gunner, _assistant, _weaponBag, _baseBag]] call BIS_fnc_callScriptedEventHandler;
	',
	_leader call BIS_fnc_netId,
	_assistant call BIS_fnc_netId
]];

if (_isWeaponGunner) then {moveOut _gunner};
_group leaveVehicle assignedVehicle _gunner;
unassignVehicle _gunner;

private _weaponPos = getPosATL _weapon;
private _assistantPos = _weapon getRelPos [1, 135]; _assistantPos set [2, _weaponPos select 2]; // -- keep z
private _gunnerPos = _weapon getRelPos [1, -135]; _gunnerPos set [2, _weaponPos select 2]; // -- keep z

if (_gunner distance2D _gunnerPos > _gunner distance2D _assistantPos) then
{
	// -- swap
	private _tmp = _gunnerPos; _gunnerPos = _assistantPos; _assistantPos = _tmp;
}; 

// -- leader logic
[_leader, _leaderPos] spawn 
{
	params ["_leader", "_leaderPos"];

	waitUntil {isNull (_leader getVariable ["BIS_staticWeaponLeaderScript", scriptNull])};
	_leader setVariable ["BIS_staticWeaponLeaderScript", _thisScript];
	
	_weapons = [primaryWeapon _leader, handgunWeapon _leader, secondaryWeapon _leader];

	if (!(currentWeapon _leader in _weapons) || currentWeapon _leader isEqualTo "") then
	{
		{
			if !(_x isEqualTo "") exitWith {_leader selectWeapon _x};
		}
		forEach _weapons;
	};
	
	_leader setUnitPos "AUTO";
	_leader doWatch objNull;
	
	if (_leaderPos isEqualTo [0,0,0]) exitWith {_leader doFollow _leader};
	
	_leader doMove _leaderPos;
		
	waitUntil {unitReady _leader};
		
	doStop _leader;
};

// -- assistant logic
private _assistantReady = [_assistant, _assistantPos, _weapon, _isWeaponGunner] spawn
{
	params ["_assistant", "_assistantPos", "_weapon", "_isWeaponGunner"];
	
	if (!_isWeaponGunner) then
	{
		_assistant setUnitPos "AUTO";
		_assistant doWatch _weapon;
		_assistant doMove _assistantPos;
		
		waitUntil {unitReady _assistant};
	};
	
	doStop _assistant;
	_assistant doWatch _weapon;
	
	if (fleeing _assistant) exitWith {};
};

// -- gunner logic
[_gunner, _gunnerPos, _weapon, _assistant, _assistantReady, _isWeaponGunner] spawn
{
	params ["_gunner", "_gunnerPos", "_weapon", "_assistant", "_assistantReady", "_isWeaponGunner"];
		
	if (!_isWeaponGunner) then
	{
		_gunner setUnitPos "AUTO";
		_gunner doWatch _weapon;
		_gunner doMove _gunnerPos;
		
		waitUntil {unitReady _gunner};
	};
	
	if (!alive _gunner || fleeing _gunner) exitWith {_gunner removeAllEventHandlers "WeaponDisassembled"};
	
	doStop _gunner;
	_gunner doWatch _weapon;
	
	waitUntil {scriptDone _assistantReady};
	
	if (!alive _assistant || fleeing _assistant) exitWith {_gunner removeAllEventHandlers "WeaponDisassembled"};
	
	// -- pack weapon
	_gunner action ["Disassemble", _weapon];
};

nil

