/*
NNS
Spawn a support helicopter that will unload or paradrop (if no suitable location found) troop on wanted location.
_type can be set to a shortcut class or a fullname class.
Script will try to autodetect right side if not provided (set to nil).
You can supply specific class for troop if you want. if not, set to configNull.
Yan can also add waypoints to unloaded units by using a unit as waypoint storage (priority over group to join).

Notes:
- Because of the way Arma AI work, this script is far from bulletproof (but it is stable).
- Some helicopter classes do have troubles to take off.
- When stalking, unit will always search for nearest enemy.

Shortcut types:
- "ghosthawk" (nato)
- "hummingbird" (nato)
- "huron" (nato)
- "orca" (csat)
- "taru" (csat)
- "mi48" (csat)

example : 
	Hummingbird with CSAT units near player position:
		_null = [getPos player, "hummingbird", east, configNull] execVM "scripts\HeliSupportLanding.sqf";

	Huron that paradrop a BLUFOR squad near player position and follow waypoints set to unit named 'paradropWaypointStorage':
		_null = [getPos player, "huron", nil, configNull,true,true,grpNull,paradropWaypointStorage] execVM "scripts\HeliSupportLanding.sqf";


	Civil M-900 with BLUFOR Recon team on Resistance side near player position:
		_null = [getPos player, "C_Heli_Light_01_civil_F", resistance, configfile >> "CfgGroups" >> "West" >> "BLU_F" >> "Infantry" >> "BUS_ReconTeam"] execVM "scripts\HeliSupportLanding.sqf";

Dependencies:
	in description.ext:
		class CfgFunctions {
			class NNS {
				class missionfunc {
					file = "nns_functions";
					class debugOutput {};
					class AIskill {};
					class FoundNearestEnemy {};
				};
			};
		};

	nns_functions folder:
		fn_debugOutput.sqf
		fn_AIskill.sqf
		fn_FoundNearestEnemy.sqf
		
	script folder:
		LimitEquipment.sqf
		HeliSupportLanding.sqf

*/

params [
["_pos", []], //support position
["_type", "huron"], //helicopter "type"
["_side", nil], //support side, nil to leave script choise, https://community.bistudio.com/wiki/CfgVehicles_Config_Reference#side
["_class", configNull], //support class, configNullto leave script choise, configfile >> "CfgGroups"
["_forceParadrop", false], //force a paradrop
["_allowDamage", true], //allow helicopter to take damage
["_joinGroup", grpNull], //unloaded units join specified group
["_syncUnit", objNull] //unit used as waypoints storage
];

_allowType = ["ghosthawk","hummingbird","huron","orca","taru","mi48"]; //text type
_heliClasses = ["B_Heli_Transport_01_F","B_Heli_Light_01_F","B_Heli_Transport_03_F","O_Heli_Light_02_unarmed_F","O_Heli_Transport_04_covered_F","O_Heli_Attack_02_dynamicLoadout_F"]; //text type
//_defaultSide = [west,west,west,east,east,east]; //side
//_gameSides

if (count _pos < 2) exitWith {[format["HeliSupportLanding.sqf: Invalid position:%1",_pos]] call NNS_fnc_debugOutput}; //invalid position
if (count _pos == 2) then {_pos set [2,0]}; //BIS_fnc_findSafePos need Z position

//if !(_type in _allowType) exitWith {[format["HeliSupportLanding.sqf: Invalid type:%1, allowed:%2",_type,_allowType]] call NNS_fnc_debugOutput}; //invalid type

_heliClass = ""; //helicopter class
_findClass = _allowType find _type; //searchi in class shortcuts
if (_findClass == -1 && isClass (configFile >> "CfgVehicles" >> _type)) then { //provided class is not a shortcut, class exist
	_heliClass = _type; //helicopter class
	[format["HeliSupportLanding.sqf: User defined helicopter class : %1",_heliClass]] call NNS_fnc_debugOutput; //debug
};

if (_heliClass == "" && !(_findClass == -1)) then {_heliClass = _heliClasses select _findClass}; //leave script select from shortcuts helicopter class
if (_heliClass == "") exitWith {["HeliSupportLanding.sqf: Failed to select helicopter class"] call NNS_fnc_debugOutput}; //invalid class

if (isNil "_side") then { //side not set, try to get it from config
	if (isNumber (configfile >> "CfgVehicles" >> _heliClass >> "side")) then { //side set in config
		_side = (getNumber (configfile >> "CfgVehicles" >> _heliClass >> "side")) call BIS_fnc_sideType; //get side id from config, convert to side
		[format["HeliSupportLanding.sqf: Side extracted from config : %1",_side]] call NNS_fnc_debugOutput; //debug
	};
};

//if (isNil "_side") then {if !(_findClass == -1) then {_side = _defaultSide select _findClass}}; //no side set, try select good one
if (isNil "_side") exitWith {["HeliSupportLanding.sqf: Failed to select valid side"] call NNS_fnc_debugOutput}; //invalid side

_cargoLimit = getNumber (configfile >> "CfgVehicles" >> _heliClass >> "transportSoldier"); //units in cargo
_turretLimit = "getNumber (_x >> 'dontCreateAI') == 1" configClasses (configfile >> "CfgVehicles" >> _heliClass >> "Turrets"); //not populated turret
_cargoLimit = _cargoLimit + (count _turretLimit); //cumulate values

if (_cargoLimit == 0) exitWith {[format["HeliSupportLanding.sqf: %1 doesn't allow to transport soldier",_heliClass]] call NNS_fnc_debugOutput}; //invalid transportSoldier

_defaultSupportSide = [west,east,resistance,independent]; //default support sides
_defaultSupportClass = [ //default support units classes
configfile >> "CfgGroups" >> "West" >> "BLU_F" >> "Infantry" >> "BUS_InfSquad",
configfile >> "CfgGroups" >> "East" >> "OPF_F" >> "Infantry" >> "OIA_InfSquad",
configfile >> "CfgGroups" >> "Indep" >> "IND_G_F" >> "Infantry" >> "I_G_InfSquad_Assault",
configfile >> "CfgGroups" >> "Indep" >> "IND_F" >> "Infantry" >> "HAF_InfSquad"];

if (isNull _class) then { //support class not set
	_findClass = _defaultSupportSide find _side; //search side
	if !(_findClass == -1) then {_class = _defaultSupportClass select _findClass}; //side found, select class
};

if (isNull _class) exitWith {["HeliSupportLanding.sqf: invalid support unit class"] call NNS_fnc_debugOutput};

_useWaypoints = false; //droped units waypoints
if !(isNull _syncUnit) then { //sync unit exist
	if (count (waypoints (group _syncUnit)) > 1) then { //at least one real waypoint
		["HeliSupportLanding.sqf: valid sync unit provided for waypoints"] call NNS_fnc_debugOutput; //debug
		_useWaypoints = true;
	} else {
		["HeliSupportLanding.sqf: sync unit doesn't provide any waypoint"] call NNS_fnc_debugOutput; //debug
		deleteVehicle _syncUnit; //delete unit
	};
};

if (!(isNull _joinGroup) && !(_useWaypoints)) then { //join group set and no waypoints
	if !(side _joinGroup == _side) then { //side mismatch
		[format["HeliSupportLanding.sqf: joinGroup side (%1) missmatch selected side (%2), ignored",side _joinGroup, _side]] call NNS_fnc_debugOutput; //debug
		_joinGroup = grpNull; //unset group
	};
};

_wpPos = _pos getPos [(250 + random 250), random 360]; _wpPos set [2,50]; //used if lz selection failed, 50m altitude
_heli_spawn_pos = _pos getPos [2000, random 360]; _heli_spawn_pos set [2,40]; //used to compute insertion to lz, 40m altitude

// Create heli and WPs
_heli = createVehicle [_heliClass, _heli_spawn_pos, [], 0, "FLY"]; //create helicopter
if !(_allowDamage) then {_heli allowDamage false}; //disable damage
createVehicleCrew _heli; //create helicopter crew
_heliCrew = crew _heli; //recover helicopter crew
if !(side (currentPilot _heli) == _side) then { //wrong side
	_tmpgrp = createGroup _side; //tmp group
	{[_x] joinSilent _tmpgrp;} forEach _heliCrew; //convert crew to right side
};
_heliGroup = group (_heliCrew select 0); //helicopter crew group

if !(_allowDamage) then {{_x allowDamage false} forEach (units _heliGroup)}; //disable damage for crew units

_heli setVehicleLock "LOCKEDPLAYER"; //avoid possibility for players to get in
[format["HeliSupportLanding.sqf: %1 created (%2m)",typeOf _heli, _pos distance2d _heli]] call NNS_fnc_debugOutput; //debug

_heliGroup setBehaviour "Careless";
_heliGroup setCombatMode "YELLOW";

// If the heli is disabled, kill the crew
_null = [_heli,_heliCrew] spawn {
	waitUntil {sleep 2.5; !(isNull (_this select 0)) and {!(canMove (_this select 0))}};
	{_x setDamage 1} forEach (_this select 1);
};

_lz_pos = [-10000,-10000,0]; //LZ default position

if !(_forceParadrop) then {
	_lz_ran_pos = [[[_pos, 150]],[]] call BIS_fnc_randomPos; //get initial random pos for LZ
	_lz_pos = [_lz_ran_pos, 0, 150, 20, 0, 0.5, 0] call BIS_fnc_findSafePos; //safe place based on inital LZ pos

	if !(_pos distance2d _lz_pos < 400) then { //if failed to select LZ 400m near target, retry once after 10 sec
		["HeliSupportLanding.sqf: Failed to select proper LZ, retry in 10sec"] call NNS_fnc_debugOutput; //debug
		sleep 10;
		_lz_ran_pos = [[[_pos, 150]],[]] call BIS_fnc_randomPos; //get initial random pos for LZ
		_lz_pos = [_lz_ran_pos, 0, 150, 20, 0, 0.5, 0] call BIS_fnc_findSafePos; //safe place based on inital LZ pos
	};
};

_grp = grpNull;		// Create empty group
if (alive _heli && (_pos distance2d _lz_pos < 400)) then { //LZ 400m near target selected
	_lz = 'Land_HelipadEmpty_F' createVehicle _lz_pos; //create invisible helipad for LZ
	[format["HeliSupportLanding.sqf: LZ created (%1m)", _pos distance2d _lz_pos]] call NNS_fnc_debugOutput; //debug
	
	_heli doMove [_lz_pos select 0,_lz_pos select 1,20]; //start move to lz, note: move looks better than a real waypoint for landing
	
	_null = [_heli,_lz_pos] spawn { //progressive slow down to limit heli pitch
		_heli = _this select 0; _lz_pos = _this select 1;
		_ramp_start = 2000; _ramp_end = 200; //slow down ramp start / end
		_speed_max = 45; _speed_min = 10; //initial / final speed
		_alt_max = 40; _alt_min = 15; //initial / final altitude
		
		_heli forceSpeed _speed_max; _heli flyInHeight _alt_max; //set starting speed / altitude
		
		waitUntil{sleep 1; ((alive _heli) && (_heli distance2D _lz_pos) < _ramp_start) || !(alive _heli)}; //wait until ramp start distance
		while {(_heli distance2D _lz_pos) > _ramp_end && (alive _heli)} do { //while over ramp end
			_distance=_heli distance2D _lz_pos; //current distance to lz
			
			_tmp_speed = (((_distance-_ramp_end)/(_ramp_start-_ramp_end))*(_speed_max-_speed_min))+_speed_min; //compute new speed
			_tmp_alt = (((_distance-_ramp_end)/(_ramp_start-_ramp_end))*(_alt_max-_alt_min))+_alt_min; //compute new altitude
			
			_heli forceSpeed _tmp_speed; _heli flyInHeight _tmp_alt; //set new speed / altitude
			//[format["_tmp_speed: %1 ,_tmp_alt: %2",_tmp_speed,_tmp_alt]] call NNS_fnc_debugOutput; //debug
			sleep 1;
		};
	};
	
	waitUntil{sleep 1; ((_heli distance2D _lz_pos) < 300) || !(alive _heli)}; //wait until ramp start distance
	
	if (alive _heli) then {
		doStop _heli; //stop heli move
		_heli land "GET OUT"; //order pilot to land
		[format["HeliSupportLanding.sqf: Start landing : %1m", _pos distance2d _heli]] call NNS_fnc_debugOutput; //debug
		
		_grp = [[0,0,0], _side, _class, [], [], [0.3, 0.3]] call BIS_fnc_spawnGroup; // Create team onboard, need to be done at the last time or enableDynamicSimulation will fail
		_cargoCurrent = 0;
		{
			_cargoCurrent = _cargoCurrent + 1; //increment 
			if (_cargoCurrent > _cargoLimit) then { //cargo overflow
				deleteVehicle _x; //delete unit
			} else {
				_x moveInCargo _heli; //move in cargo
				_x assignAsCargo _heli; //assign as cargo
				[_x] call NNS_fnc_AIskill; //set skills
			};
		} forEach (units _grp); //units loop
		if (missionNamespace getVariable "BIS_enemyEquipment" == 1) then {{_null = _x execVM "Scripts\LimitEquipment.sqf"} forEach (units _grp)}; //limit equipement
		_grp allowFleeing 0; //not allowed to flee
		_grp deleteGroupWhenEmpty true; //Mark for auto deletion and enable Dynamic simulation
		_grp enableDynamicSimulation true;  // enable Dynamic simulation
	};
	
	waitUntil{sleep 1; ((alive _heli) && ((getPos _heli) select 2) < 1.5/*(isTouchingGround _heli)*/) || !(alive _heli)}; //wait until heli is near ground or heli destroyed
	
	if (alive _heli) then {
		_heli land "GET OUT"; //reissue order to land, needed for some helicopters
		
		if (((getPos _heli) select 2) > 0.5) then {_heli setVelocity [0,0,-0.25]}; //pushdown if altitude over 0.5m
		
		sleep 2;
		[format["HeliSupportLanding.sqf: Touching ground : %1m", _pos distance2d _heli]] call NNS_fnc_debugOutput; //debug
		_heli flyInHeight 0; //pin to ground
		_heli animateDoor ["Door_rear_source", 1, false]; //open cargo door
		sleep 1;
		["HeliSupportLanding.sqf: Start unload"] call NNS_fnc_debugOutput; //debug
		
		{ //disembark units if heli still alive
			_tmpAlt = (getPos (vehicle _x)) select 2; //altitude
			[format["HeliSupportLanding.sqf: Unload unit, altitude:%1m", _tmpAlt]] call NNS_fnc_debugOutput; //debug
			if (canMove _heli && {_tmpAlt < 1.5}) then { //extra secutity to avoid unload when in air
				_x leaveVehicle _heli; sleep 1.5; //force unit to leave vehicle
			} else {deleteVehicle _x}; //delete unit if heli getting off for some reason, usually happen when under fire
		} forEach (units _grp);
	};
	
	sleep 3;
	
	["HeliSupportLanding.sqf: Unloaded"] call NNS_fnc_debugOutput; //debug
	_heli animateDoor ["Door_rear_source", 0, false]; //close cargo door
	_heli flyInHeight 30; //unpin from ground
	
	if ({alive _x} count (units _grp) > 0) then { //at least one unit alive
		if (isNull _joinGroup && {!(_useWaypoints)}) then { //no group to join and no waypoints
			_tmpEnemy = [leader _grp, 1500] call NNS_fnc_FoundNearestEnemy; //search for nearest enemy in 1500m radius
			if !(isNull _tmpEnemy) then {[_grp, group _tmpEnemy] spawn BIS_fnc_stalk; //stalk enemy
			} else { //failed, stalk a random player
				_stalkUnit = selectRandom (allPlayers - (entities "HeadlessClient_F")); //random player
				[_grp, group (selectRandom (allPlayers - (entities "HeadlessClient_F")))] spawn BIS_fnc_stalk; //stalk
			};
		};
		
		if (_useWaypoints) then { //set units waypoints
			_grp copyWaypoints (group _syncUnit); //copy waypoints
			deleteVehicle _syncUnit; //delete unit
		};
	};
	
	deleteVehicle _lz; //clean up LZ
} else { //LZ selection failed, go for paradrop
	["HeliSupportLanding.sqf: Failed to select proper LZ, forced Paradrop"] call NNS_fnc_debugOutput; //debug
	_heli forceSpeed 45; _heli flyInHeight 70;
	_heliGroup setBehaviour "Careless";
	_heliGroup setCombatMode "YELLOW";
	
	//waypoints
	_rndAlt = 130 + (random 50); //try to limit possible colision since AI is super dumb
	_wpPos set [2, _rndAlt]; //waypoint 1 altitude
	
	_tmpDir = _pos getDir _wpPos; //first waypoint direction relative to wanted position
	_wpPos2 = _pos getPos [300, _tmpDir + 90]; _wpPos2 set [2, _rndAlt]; //waypoint 2 position and altitude
	_wpPos3 = _pos getPos [300, _tmpDir + 180]; _wpPos3 set [2, _rndAlt]; //waypoint 3 position and altitude
	_wpPos4 = _pos getPos [300, _tmpDir + 270]; _wpPos4 set [2, _rndAlt]; //waypoint 4 position and altitude
	_wpHeliPara1 = _heliGroup addWaypoint [_wpPos, 0]; //waypoint 1
	_wpHeliPara2 = _heliGroup addWaypoint [_wpPos2, 0]; //waypoint 2
	_wpHeliPara3 = _heliGroup addWaypoint [_wpPos3, 0]; //waypoint 3
	_wpHeliPara4 = _heliGroup addWaypoint [_wpPos4, 0]; //waypoint 4
	_wpCurrent = currentWaypoint _heliGroup; //current waypoint index
	
	_tmpTime = time; //backup time for timeout
	waitUntil {sleep 1; !(alive _heli) || !((currentWaypoint _heliGroup) == _wpCurrent) || (time - _tmpTime) > 60}; //wait until heli destroyed or a waypoint is passed or one minute timeout
	
	if (alive _heli) then { //heli still alive
		_grp = [[0,0,0], _side, _class, [], [], [0.3, 0.3]] call BIS_fnc_spawnGroup; // Create team onboard, need to be done at the last time or enableDynamicSimulation will fail
		{
			_x moveInCargo _heli; //move in cargo
			_x assignAsCargo _heli; //assign as cargo
			[_x] call NNS_fnc_AIskill; //set skills
			removeBackpack _x; //remove unit backpack
			_x addBackpack "B_Parachute"; //add parachute backpack
		} forEach (units _grp); //units loop
		if (missionNamespace getVariable "BIS_enemyEquipment" == 1) then {{_null = _x execVM "Scripts\LimitEquipment.sqf"} forEach (units _grp)}; //limit equipement
		_grp allowFleeing 0; //not allowed to flee
		_grp deleteGroupWhenEmpty true; //Mark for auto deletion and enable Dynamic simulation
		_grp enableDynamicSimulation true; //enable Dynamic simulation
		sleep 2;
		
		{ //paradrop units if heli still alive
			_tmpPos = getPos (vehicle _x); //helicopter position
			[format["HeliSupportLanding.sqf: Paradrop unit, altitude:%1m", _tmpPos select 2]] call NNS_fnc_debugOutput; //debug
			if (canMove _heli) then { //extra secutity
				unassignVehicle _x; //unassign from cargo
				_x setPos [(_tmpPos select 0), (_tmpPos select 1), (_tmpPos select 2) - 3]; //teleport unit under helicopter
				_x action ["OpenParachute", _x]; //open parachute
				sleep 0.5; //wait a bit
			} else {deleteVehicle _x}; //delete unit if heli getting off for some reason, usually happen when under fire
		} forEach (units _grp);
			
		if ({alive _x} count (units _grp) > 0) then { //at least one unit alive
			if (isNull _joinGroup && {!(_useWaypoints)}) then { //no group to join and no waypoints
				_tmpEnemy = [leader _grp, 1500] call NNS_fnc_FoundNearestEnemy; //search for nearest enemy in 1500m radius
				if !(isNull _tmpEnemy) then {[_grp, group _tmpEnemy] spawn BIS_fnc_stalk; //stalk enemy
				} else { //failed, stalk a random player
					_stalkUnit = selectRandom (allPlayers - (entities "HeadlessClient_F")); //random player
					[_grp, group (selectRandom (allPlayers - (entities "HeadlessClient_F")))] spawn BIS_fnc_stalk; //stalk
				};
			};
			
			if (_useWaypoints) then { //set units waypoints
				_grp copyWaypoints (group _syncUnit); //copy waypoints
				deleteVehicle _syncUnit; //delete unit
			};
		};
	};
};

if (!isNull _grp && !isNull _joinGroup) then { //unloaded group exist and group to join specified
	_aliveUnits = {alive _x} count (units _grp); //count alive units in group
	if (_aliveUnits > 0) then { //some alive units
		(units _grp) joinSilent _joinGroup; //joint wanted group
		["HeliSupportLanding.sqf: Unloaded units joined selected group"] call NNS_fnc_debugOutput; //debug
	};
};

if !(canMove _heli) then { //helicopter can't move
	{_x allowDamage true; _x setDamage 1} forEach (units _heliGroup); //kill crew
	_heli allowDamage true; //allow damage
	_heli setDamage 1; //destroy it
	["HeliSupportLanding.sqf: Helicopter destroyed"] call NNS_fnc_debugOutput; //debug
};

if (alive _heli) then { //add escape waypoint if heli still alive
	//delete waypoints
	for "_i" from count waypoints _heliGroup - 1 to 0 step -1 do {deleteWaypoint [_heliGroup, _i]};
	["HeliSupportLanding.sqf: Waypoints cleared"] call NNS_fnc_debugOutput; //debug
	
	_tmpPos = _pos getPos [4000, random 360]; _tmpPos set [2,75]; //escape position
	_heli doMove _tmpPos; //order helicopter to move
	
	//add waypoint as extra security
	_wpHeli03 = _heliGroup addWaypoint [_tmpPos, 0];
	_wpHeli03 setWaypointSpeed "FULL";
	_wpHeli03 setWaypointBehaviour "CARELESS";
	_heli forceSpeed 50; _heli flyInHeight 40;
	
	["HeliSupportLanding.sqf: Escape waypoint added"] call NNS_fnc_debugOutput; //debug
};

_tmpTime = time; //backup time for timeout

// Delete heli when far away
waitUntil {sleep 5; allPlayers findIf {(_x distance _heli) < 3000} == -1 || !(alive _heli) || (time - _tmpTime) > 120}; //helicopter far enough or heli destroyed or 2m timeout

if ((time - _tmpTime) > 90) then { //befause of timeout
	{_x allowDamage true; _x setDamage 1} forEach (units _heliGroup); //kill crew
	_heli allowDamage true; //allow damage
	_heli setDamage 1; //destroy it
	["HeliSupportLanding.sqf: Helicopter destroyed"] call NNS_fnc_debugOutput; //debug
};

if !(alive _heli) then {waitUntil {sleep 5; allPlayers findIf {(_x distance _heli) < 1200} == -1}}; //NNS : Delete if destroyed

{deleteVehicle _x} forEach (_heliCrew + [_heli]);
deleteGroup _heliGroup;
["HeliSupportLanding.sqf: Cleaned"] call NNS_fnc_debugOutput; //debug
