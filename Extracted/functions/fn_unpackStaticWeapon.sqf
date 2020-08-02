/*
	Author: 
		Dean "Rocket" Hall, reworked by Killzone_Kid

	Description:
		This function will move given support team to the given position
		The weapon crew will unpack carried weapon and start watching given position
		Requires three personnel in the team: Team Leader, Gunner and Asst. Gunner
		This function is MP compatible
		When weapon is unpacked, scripted EH "StaticWeaponUnpacked" is called with the following params: [group, leader, gunner, assistant, weapon]

	Parameters:
		0: GROUP or OBJECT - the support team group or a unit from this group 
		1: ARRAY, STRING or OBJECT - weapon placement position, object position or marker
		2: ARRAY, STRING or OBJECT - target position, object position to watch or marker
		3: (Optional) ARRAY, STRING or OBJECT - position, object or marker group leader should move to
		
	Returns:
		NOTHING
	
	NOTE:
		If a unit flees, all bets are off and the function will exit leaving units on their own
		To guarantee weapon assembly, make sure the group has maximum courage (_group allowFleeing 0)
	
	Example1:
		[leader1, "weapon_mrk", "target_mrk"] call BIS_fnc_unpackStaticWeapon;
		
	Example2:
		group1 allowFleeing 0;
		[group1, "weapon_mrk", tank1, "leader_mrk"] call BIS_fnc_unpackStaticWeapon;
*/

params [
	["_group", grpNull, [grpNull, objNull]], 
	["_weaponPos", [0,0,0], [[], "", objNull], 3],
	["_targetPos", [0,0,0], [[], "", objNull], 3],
	["_leaderPos", [0,0,0], [[], "", objNull], 3]
];

private _leader = leader _group;
if (!local _leader) exitWith {_this remoteExecCall ["BIS_fnc_unpackStaticWeapon", _leader]};

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

if (_group isEqualType objNull) then {_group = group _group};
if (isNull _group) exitWith _err_badGroup;

if (_weaponPos isEqualType "") then {_weaponPos = getMarkerPos _weaponPos};
if (_weaponPos isEqualType objNull) then {_weaponPos = getPosATL _weaponPos};
if (_weaponPos isEqualTo [0,0,0]) exitWith _err_badPosition;

if (_targetPos isEqualType "") then {_targetPos = getMarkerPos _targetPos};
if (_targetPos isEqualType objNull) then {_targetPos = getPosATL _targetPos};
if (_targetPos isEqualTo [0,0,0]) exitWith _err_badPosition;

if (_leaderPos isEqualType "") then {_leaderPos = getMarkerPos _leaderPos};
if (_leaderPos isEqualType objNull) then {_leaderPos = getPosATL _leaderPos};

private _cfg = configFile >> "CfgVehicles";
private _supportUnits = (units _group - [_leader]) select {getText (_cfg >> typeOf _x >> "vehicleClass") == "MenSupport"};
private _gunner = 
{
	if (unitBackpack _x isKindOf "Weapon_Bag_Base") exitWith {_x};
	
	objNull
} 
forEach _supportUnits;

if (isNull _gunner) exitWith _err_badGroup;

private _cfgBase = configFile >> "CfgVehicles" >> backpack _gunner >> "assembleInfo" >> "base";
private _compatibleBases = if (isText _cfgBase) then {[getText _cfgBase]} else {getArray _cfgBase};
private _assistant = 
{	
	private _xx = _x;
	
	if ({unitBackpack _xx isKindOf _x} count _compatibleBases > 0) exitWith {_xx};
	
	objNull
}
forEach (_supportUnits - [_gunner]);

if (isNull _assistant) exitWith _err_badGroup;

// -- calculate optimal positions for weapon crew
private _targetDir = _weaponPos getDir _targetPos;
private _assistantPos = _weaponPos getPos [1.5, _targetDir + 90]; _assistantPos set [2, _weaponPos select 2]; // -- keep z
private _gunnerPos = _weaponPos getPos [1.5, _targetDir - 90]; _gunnerPos set [2, _weaponPos select 2]; // -- keep z

if (_gunner distance2D _gunnerPos > _gunner distance2D _assistantPos) then
{
	// -- swap
	private _tmp = _gunnerPos; _gunnerPos = _assistantPos; _assistantPos = _tmp;
}; 

_gunner addEventHandler ["WeaponAssembled", format [
	'
		params ["_gunner", "_weapon"];
		
		_gunner removeEventHandler ["WeaponAssembled", _thisEventHandler];
		
		_weapon setDir (_weapon getDir %3);
		_weapon setPosATL getPosATL _gunner;
	
		_gunner assignAsGunner _weapon;
		_gunner moveInGunner _weapon;
		_gunner doWatch %3;
		
		_leader = "%1" call BIS_fnc_objectFromNetId;
		_assistant = "%2" call BIS_fnc_objectFromNetId;
		
		_group = group _gunner;
		_group addVehicle _weapon;
		
		[_group, "StaticWeaponUnpacked", [_group, _leader, _gunner, _assistant, _weapon]] call BIS_fnc_callScriptedEventHandler;
	', 
	_leader call BIS_fnc_netId,
	_assistant call BIS_fnc_netId,
	_targetPos
]]; 

// -- leader logic
[_leader, _leaderPos, _targetPos] spawn
{
	params ["_leader", "_leaderPos", "_targetPos"];
	
	waitUntil {isNull (_leader getVariable ["BIS_staticWeaponLeaderScript", scriptNull])};
	_leader setVariable ["BIS_staticWeaponLeaderScript", _thisScript];
	
	if !(_leaderPos isEqualTo [0,0,0]) then
	{
		_leader doWatch _targetPos;
		_leader doMove _leaderPos;
		
		waitUntil {unitReady _leader};	
	};
	
	if (fleeing _leader) exitWith {};
	
	doStop _leader;
	
	_leader setUnitPos "MIDDLE";
	_leader doWatch _targetPos;
	
	waitUntil {stance _leader isEqualTo "CROUCH" || !alive _leader};
	
	_leader selectWeapon binocular _leader;
};

// -- assistant logic
private _assistantReady = [_assistant, _assistantPos, _targetPos] spawn
{
	params ["_assistant", "_assistantPos", "_targetPos"];
	
	_assistant doWatch _targetPos;
	_assistant doMove _assistantPos;
	
	waitUntil {unitReady _assistant};
	
	if (fleeing _assistant) exitWith {};
	
	doStop _assistant;
	
	_assistant setUnitPos "MIDDLE";
	_assistant doWatch _targetPos;
	
	waitUntil {stance _assistant isEqualTo "CROUCH" || !alive _assistant};
};

// -- gunner logic
[_gunner, _gunnerPos, _targetPos, _assistant, _assistantReady] spawn
{
	params ["_gunner", "_gunnerPos", "_targetPos", "_assistant", "_assistantReady"];
		
	_gunner doWatch _targetPos;
	_gunner doMove _gunnerPos;

	waitUntil {unitReady _gunner};
	
	if (!alive _gunner || fleeing _gunner) exitWith {_gunner removeAllEventHandlers "WeaponAssembled"};
	
	doStop _gunner;
	
	_gunner setUnitPos "MIDDLE";
	_gunner doWatch _targetPos;
	
	waitUntil {stance _gunner isEqualTo "CROUCH" || !alive _gunner};
	waitUntil {scriptDone _assistantReady};
	
	if (!alive _assistant || fleeing _assistant) exitWith {_gunner removeAllEventHandlers "WeaponAssembled"};
	
	// -- unpack weapon
	_weaponBase = unitBackpack _assistant;
	_gunner action ["PutBag", _assistant];
	_gunner action ["Assemble", _weaponBase];
};

nil 