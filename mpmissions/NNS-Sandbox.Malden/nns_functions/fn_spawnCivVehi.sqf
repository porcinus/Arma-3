/*
NNS
Spawn a civilian car, can be wreck or have alarm on.
Note : _alarmClasses is specific to zombie mission.


Dependency: in initServer.sqf
	BIS_civilCars = ["C_Offroad_01_F","C_SUV_01_F","C_Van_01_transport_F","C_Truck_02_transport_F"];
	BIS_civilWreckCars = ["Land_Wreck_Ural_F","Land_Wreck_Truck_dropside_F","Land_Wreck_Truck_F","Land_Wreck_Van_F","Land_Wreck_Offroad_F","Land_Wreck_Offroad2_F","Land_Wreck_Car_F"];

Dependency: in description.ext
	class CfgSFX {
		class CarAlarm01 {sound0[] = {"@A3\Sounds_F_Orange\MissionSFX\Orange_Car_Alarm_Loop_01", 1.4, 1.0, 350, 1, 0, 0, 0}; sounds[] = {sound0}; empty[] = {"", 0, 0, 0, 0, 0, 0, 0};};
	};

	class CfgVehicles {
		class CarAlarmSound01 {sound = "CarAlarm01";};
	};


Example: 
_null = [[500,500],270] call NNS_fnc_spawnCivVehi;

*/

// Params
params [
	["_pos", []], //center position
	["_dir", 0], //vehicle direction
	["_civClasses", []], //civilian vehicle class, use BIS_civilCars if nothing set
	["_civWreckClasses", []], //wreck vehicle class, use BIS_civilWreckCars if nothing set
	["_limitFuel", 0.05], //limit fuel amount
	["_limitFuelRandom", true], //random fuel limiting
	["_allowDamage", true], //add damage to vehicle
	["_wreckChance", 0.35], //probability to spawn a wreck
	["_alarmChance", 0.15], //probability to spawn a vehicle with alarm running
	["_alarmClasses", []], //independante unit class, use BIS_zombieSlowSoldiers and BIS_zombieSlowCivilians if nothing set
	["_alarmMaxDist", 600], //maximum distance before deletion
	["_clearCargo", true] //clear cargo
];

//debug note: do not use append, this mess global vars for whatever reason...

// Check for validity
if (count _pos < 2) exitWith {["NNS_fnc_spawnCivVehi : invalid position"] call NNS_fnc_debugOutput;};

if (count _civClasses == 0) then {_civClasses = missionNamespace getVariable ["BIS_civilCars",[]];};
if (count _civClasses == 0) exitWith {["NNS_fnc_spawnCivVehi : no _civClasses set"] call NNS_fnc_debugOutput;};

if (count _civWreckClasses == 0) then {_civWreckClasses = missionNamespace getVariable ["BIS_civilWreckCars",[]];};
if (count _civWreckClasses == 0) then {_wreckChance = 0; ["NNS_fnc_spawnCivVehi : no _civWreckClasses set, wreck change set to 0"] call NNS_fnc_debugOutput;};

if (count _alarmClasses == 0) then {
	_alarmClasses = missionNamespace getVariable ["BIS_zombieSlowSoldiers",[]];
	_alarmClasses = _alarmClasses + (missionNamespace getVariable ["BIS_zombieSlowCivilians",[]]);
};
//if (count _alarmClasses == 0) then {_wreckChance = 0; ["NNS_fnc_spawnCivVehi : no _alarmClasses set, alarm change set to 0"] call NNS_fnc_debugOutput;};

_wreck = false;
_alarm = false;
if (random 1 < _wreckChance) then {_wreck = true;};
if (random 1 < _alarmChance) then {_alarm = true;};

_veh = objNull;
if (_wreck) then {
	_veh = createVehicle [(selectRandom _civWreckClasses), [0,0,0], [], 0, "CAN_COLLIDE"];
	_veh setDir (_dir + 180);
	_veh setPos _pos;
} else {
	_veh = createVehicle [(selectRandom _civClasses), [0,0,0], [], 0, "CAN_COLLIDE"];
	_veh allowDamage false; //try to limit problems when server hang
	_veh setDir _dir;
	_veh setPos [_pos select 0, _pos select 1, 1];
	
	if (_limitFuelRandom) then {_veh setFuel (random _limitFuel);
	} else {_veh setFuel _limitFuel;};
	
	if (_clearCargo) then {
		clearMagazineCargoGlobal _veh;
		clearWeaponCargoGlobal _veh;
		clearBackpackCargoGlobal _veh;
		clearItemCargoGlobal _veh;
		_veh addItemCargoGlobal ["FirstAidKit",2];
	};
	
	_veh allowDamage true;
	_veh enableDynamicSimulation true;
	if (_allowDamage) then {[_veh,["hitfuel"],0.2,0.8] call NNS_fnc_randomVehicleDamage};
};

if (_alarm && {!(_wreck)}) then {
	_newGrp = grpNull; //init
	if !(count _alarmClasses == 0) then {
		_newGrp = createGroup [independent, true];
		for "_i" from 0 to (5 + round (random 4)) do {_tmpUnit = _newGrp createUnit [(selectRandom _alarmClasses), _pos getPos [5 + random 5, random 360], [], 0, "CAN_COLLIDE"]; sleep 0.5;};
		_newGrp enableDynamicSimulation true; // Enable Dynamic simulation
	};
	
	[_pos,_veh,_newGrp,_alarmMaxDist] spawn {
		_pos = _this select 0;
		_veh = _this select 1;
		_grp = _this select 2;
		_maxdist = _this select 3;
		
		_sound = createSoundSource ["CarAlarmSound01", _pos, [], 0]; //create car alarm sound
		while {((allPlayers findIf {vehicle _x == _veh}) == -1) && {allPlayers findIf {(_x distance2d _pos) < _maxdist} != -1} && {alive _veh}} do {
			player action ["LightOn", _veh]; sleep 0.25;
			player action ["LightOff", _veh]; sleep 0.25;
		};
		player action ["LightOn", _veh]; //shut down lights
		deleteVehicle _sound; //delete sound source
		if !(isNull _grp) then {
			waitUntil {sleep (15); allPlayers findIf {(_x distance2d _pos) > _maxdist} != -1}; //NNS : wait until all players are far away
			if !(isNull _grp) then {{_x setDamage [1, false];} forEach (units _grp);}; //NNS : kill units from group
			[format["'NNS_fnc_spawnCivVehi' group:%1 killed because too far from player",_grp]] call NNS_fnc_debugOutput; //debug
		};
	};
};

_veh