/*
*** Special events for Escape from Tanoa - types and frequency mod
- Pawnees
- Paradrop
- Blackfish gunship

NNS:
available events: 
	Mortar
	Cluster
	Paradrop
	Blackfish
	Pawnee
	Blackfoot
	A10
	Orca
	Huron

Usage:
	BIS_EfM_events = [event];
	[10,15,true] spawn BIS_fnc_EfM_specialEvents;

Usage for a single specific event:
	[0,0,true,"Huron"] spawn BIS_fnc_EfM_specialEvents;
*/

// Params
params
[
	["_delayMin",10,[999]], // min delay in minutes
	["_delayMax",15,[999]], // max delay in minutes
	["_runonce",false], //NNS : run only once
	["_forcedevent",""] //NNS : specific event
];

_signednumber = [-1,1]; // NNS : used for random position

_BIS_EfM_default_events = ["Blackfoot","Pawnee","Paradrop","Orca","Huron"];

if (BIS_EfM_events isEqualTo objNull) then {
	BIS_EfM_events = _BIS_EfM_default_events; publicVariable "BIS_EfM_events";
	[format["BIS_fnc_EfM_specialEvents : BIS_EfM_events set to default : %1",BIS_EfM_events]] call BIS_fnc_NNS_debugOutput; //debug
};

_delayFinal = (((random (_delayMax - _delayMin)) + _delayMin) * 60);
_event = selectRandom BIS_EfM_events;
	
if (_forcedevent != "") then {  //no specific event defined
	_runonce = true; //force to run only once
	_event = _forcedevent;
	[format["BIS_fnc_EfM_specialEvents : Forced event (run once) : %1",_event]] call BIS_fnc_NNS_debugOutput; //debug
};

// Remove the selected event from array so it's not repeated. If all events happened, restart it.
BIS_EfM_events = BIS_EfM_events - [_event];
if (count BIS_EfM_events == 0) then { //NNS : implement additionnal events
	BIS_EfM_events = _BIS_EfM_default_events;
	[format["BIS_fnc_EfM_specialEvents : BIS_EfM_events reset to default : %1",BIS_EfM_events]] call BIS_fnc_NNS_debugOutput; //debug
};

// Trigger next event
sleep _delayFinal;
if(!_runonce) then { //restart after delay
	if (_delayMin < 1) then {_delayMin=1;}; if (_delayMax < 1) then {_delayMax=1;}; //NNS : avoid troubles with infinite spawn
	_null = [_delayMin,_delayMax] spawn BIS_fnc_EfM_specialEvents;
};


// MORTAR - NNS: not used 
if (_event == "Mortar") then {
	[format["BIS_fnc_EfM_specialEvents : %1",_event]] call BIS_fnc_NNS_debugOutput; //debug

	"DistantMortar" remoteExec ["playSound"]; sleep 2;
	"DistantMortar" remoteExec ["playSound"]; sleep 2;
	"DistantMortar" remoteExec ["playSound"]; sleep 2;
	"DistantMortar" remoteExec ["playSound"]; sleep 2;
	"DistantMortar" remoteExec ["playSound"]; sleep 2;
	"DistantMortar" remoteExec ["playSound"];

	sleep 15;
	_target = selectRandom allPlayers;
	_null = [_target,"Sh_82mm_AMOS",200,18,2,nil,nil,nil,nil,["mortar1","mortar2"]] spawn BIS_fnc_fireSupportVirtual;

};

// CLUSTER - not used (Orange has better clusters anyway)
if (_event == "Cluster") then {
	[format["BIS_fnc_EfM_specialEvents : %1",_event]] call BIS_fnc_NNS_debugOutput; //debug

	"DistantHowitzer" remoteExec ["playSound"];
	sleep 5;
	"DistantHowitzer" remoteExec ["playSound"];

	sleep 15;
	_target = selectRandom allPlayers;
	_null = [_target,nil,nil,[2,10],5] spawn BIS_fnc_fireSupportCluster;

};

// PARADROP
if (_event == "Paradrop") then {
	[format["BIS_fnc_EfM_specialEvents : %1",_event]] call BIS_fnc_NNS_debugOutput; //debug

	_target = selectRandom allPlayers;
	_targetPos = getPosATL _target;
	_wpPos = [(_targetPos select 0) + ((250 + random 250) * (selectRandom _signednumber)), (_targetPos select 1) + ((250 + random 250) * (selectRandom _signednumber)), 100]; //NNS : random position

	// Create heli and WPs
	_heli = createVehicle ["B_T_VTOL_01_infantry_F", [(_targetPos select 0) + ((250 + random 250) * (selectRandom _signednumber)),(_targetPos select 1) - (2000 * (selectRandom _signednumber)), 100], [], 0, "FLY"]; //NNS : random position
	createVehicleCrew _heli;
	_heliCrew = crew _heli;
	_heliGroup = group (_heliCrew select 0);
	_heli animateDoor ["Door_1_source",1,false];
	[format["BIS_fnc_EfM_specialEvents : %1 : %2 created (%3m)",_event, typeOf _heli, player distance _heli]] call BIS_fnc_NNS_debugOutput; //debug

	_heli flyInHeight 100;
	_heli forceSpeed 50;
	_heli setVehicleLock "LOCKEDPLAYER";
	_heliGroup setBehaviour "Careless";
	_heliGroup setCombatMode "Blue";
	{_x disableAI "FSM"; _x disableAI "Target", _x disableAI "Autotarget"} forEach _heliCrew;

	_wpHeli01 = _heliGroup addWaypoint [_wpPos, 0];
	_wpHeli02 = _heliGroup addWaypoint [[100,100,150], 0];

	// Naval camo
	[_heli,["Blue",1],true] call BIS_fnc_initVehicle;

	// If the heli is disabled, kill the crew
	_null = [_heli,_heliCrew] spawn {
		waitUntil {sleep 2.5; !(isNull (_this select 0)) and {!(canMove (_this select 0))}};
		{_x setDamage 1} forEach (_this select 1);
	};

	// Paradrop
	waitUntil {sleep 1; (_heli distance2D _targetPos) < 400};

	[format["BIS_fnc_EfM_specialEvents : %1 : Starting script",_event]] call BIS_fnc_NNS_debugOutput; //debug
	_null = _heli execVM "Scripts\Paratroopers.sqf";

	// Delete heli when far away
	waitUntil {sleep 5; allPlayers findIf {(_x distance _heli) < 3000} == -1 || {!(alive _heli)}}; //NNS : rework condition
	if(!(alive _heli)) then {waitUntil {sleep 5; allPlayers findIf {(_x distance _heli) < 1200} == -1}}; //NNS : Delete if destroyed
	//waitUntil {sleep 5; ({(_x distance _heli) < 3000} count (allPlayers) == 0) || !(alive _heli)}; //NNS : rework condition
	//if(!(alive _heli)) then {waitUntil {sleep 5; ({(_x distance _heli) < 1200} count (allPlayers) == 0)};}; //NNS : Delete if destroyed
	
	{deleteVehicle _x} forEach (_heliCrew + [_heli]);
	deleteGroup _heliGroup;
	[format["BIS_fnc_EfM_specialEvents : %1 : Cleaned",_event]] call BIS_fnc_NNS_debugOutput; //debug
};

// BLACKFISH GUNSHIP
if (_event == "Blackfish") then {
	[format["BIS_fnc_EfM_specialEvents : %1",_event]] call BIS_fnc_NNS_debugOutput; //debug

	_target = selectRandom allPlayers;
	_targetPos = getPosATL _target;
	_wpPos = [(_targetPos select 0) + ((250 + random 250) * (selectRandom _signednumber)), (_targetPos select 1) + ((250 + random 250) * (selectRandom _signednumber)), 250]; //NNS : random position

	_heli = createVehicle ["B_T_VTOL_01_armed_F", [0,0,500], [], 0, "FLY"];
	createVehicleCrew _heli;
	_heliCrew = crew _heli;
	_heliGroup = group (_heliCrew select 0);
	_heli setPosATL [(_targetPos select 0) + ((250 + random 250) * (selectRandom _signednumber)),(_targetPos select 1) - (2000 * (selectRandom _signednumber)), 500]; //NNS : random position
	_heli flyInHeight 500;
	_heliGroup allowFleeing 0;
	_heli setVehicleLock "LOCKEDPLAYER";
	[format["BIS_fnc_EfM_specialEvents : %1 : %2 created (%3m)",_event, typeOf _heli, player distance _heli]] call BIS_fnc_NNS_debugOutput; //debug
	
	_wpHeli01 = _heliGroup addWaypoint [_targetPos, 0];
	_wpHeli01 setWaypointType "Loiter";
	_wpHeli01 setWaypointLoiterType "CIRCLE_L";

	sleep 1;

	// Reveal all players
	//{(driver _heli) reveal [_x,4]} forEach (allPlayers);

	// If the heli is disabled, kill the crew
	_null = [_heli,_heliCrew] spawn {
		waitUntil {sleep 2; !(isNull (_this select 0)) and {!(canMove (_this select 0))}};
		{_x setDamage 1} forEach (_this select 1);
	};

	// Retreat if damaged or after timeout
	_null = [_heliGroup,_heli] spawn {
		_t = time;

		waitUntil {sleep 5; (damage (_this select 1) > 0.35) or (time > _t + 300)};

		_escGroup = createGroup west;
		_unit01 = _escGroup createUnit ["B_Soldier_F", [10,10,0], [], 0, "CAN_COLLIDE"];

		_wp01 = _escGroup addWaypoint [getPosATL _unit01, 0];
		deleteVehicle _unit01;

		(_this select 0) copyWaypoints (_escGroup);
		(_this select 0) setCombatMode "Blue";
		deleteGroup _escGroup;
	};

	// Delete when far away
	waitUntil {sleep 5; allPlayers findIf {(_x distance _heli) < 3000} == -1 || {!(alive _heli)}}; //NNS : rework condition
	if(!(alive _heli)) then {waitUntil {sleep 5; allPlayers findIf {(_x distance _heli) < 1200} == -1}}; //NNS : Delete if destroyed
	//waitUntil {sleep 5; ({(_x distance _heli) < 3000} count (allPlayers) == 0) || !(alive _heli)}; //NNS : rework condition
	//if(!(alive _heli)) then {waitUntil {sleep 5; ({(_x distance _heli) < 1200} count (allPlayers) == 0)};}; //NNS : Delete if destroyed
	
	{deleteVehicle _x} forEach (_heliCrew + [_heli]);
	deleteGroup (_heliGroup);
	[format["BIS_fnc_EfM_specialEvents : %1 : Cleaned",_event]] call BIS_fnc_NNS_debugOutput; //debug
};

// CAS - 2 Littlebirds
if (_event == "Pawnee") then {
	[format["BIS_fnc_EfM_specialEvents : %1",_event]] call BIS_fnc_NNS_debugOutput; //debug

	_target = selectRandom allPlayers;
	_targetPos = getPosATL _target;
	_cas_rndpos = [(_targetPos select 0) + ((250 + random 250) * (selectRandom _signednumber)),(_targetPos select 1) - (2000 * (selectRandom _signednumber)), 75]; //NNS : random position

	// 1st Pawnee
	_cas = createVehicle ["B_Heli_Light_01_armed_F", [0,0,75], [], 0, "FLY"];
	createVehicleCrew _cas;
	_casCrew = crew _cas;
	_casGroup = group (_casCrew select 0);
	{[_x,"sniper"] call BIS_fnc_NNS_AIskill;} forEach units _casGroup; //NNS : set skills
	//{ _x setSkill .9; } forEach units _casGroup; //NNS : set skills
	_cas setPosATL _cas_rndpos;
	_cas flyInHeight 75;
	_cas setVehicleLock "LOCKEDPLAYER";
	[format["BIS_fnc_EfM_specialEvents : %1 : %2 created (%3m)",_event, typeOf _cas, player distance _cas]] call BIS_fnc_NNS_debugOutput; //debug

	// 2nd Pawnee
	_cas2 = createVehicle ["B_Heli_Light_01_armed_F", [50,50,75], [], 0, "FLY"];
	createVehicleCrew _cas2;
	_casCrew2 = crew _cas2;
	_casGroup2 = group (_casCrew2 select 0);
	{[_x,"sniper"] call BIS_fnc_NNS_AIskill;} forEach units _casGroup2; //NNS : set skills
	//{ _x setSkill .9; } forEach units _casGroup2; //NNS : set skills
	[_casGroup2] join _casGroup;
	_cas2 setPosATL [(_cas_rndpos select 0) + 100,(_cas_rndpos select 1) + 100,(_cas_rndpos select 2)]; //NNS : align on random pos
	_cas2 flyInHeight 75;
	_cas2 setVehicleLock "LOCKEDPLAYER";
	[format["BIS_fnc_EfM_specialEvents : %1 : %2 created (%3m)",_event, typeOf _cas2, player distance _cas2]] call BIS_fnc_NNS_debugOutput; //debug

	// Waypoints
	_wpCAS01 = _casGroup addWaypoint [_targetPos, 0];
	_wpCAS02 = _casGroup addWaypoint [_targetPos, 250];
	_wpCAS02 setWaypointType "SaD";
	_wpCAS03 = _casGroup addWaypoint [_targetPos, 250];
	_wpCAS03 setWaypointType "SaD";
  _wpCAS04 = _casGroup addWaypoint [_targetPos, 0];
	_wpCAS04 setWaypointType "Cycle";

	//detect stuck unit
	_null = [driver _cas,15,5,[[_targetPos], [_targetPos getPos [250,random 360],"SaD"], [_targetPos getPos [250,random 360],"SaD"], [_targetPos,"Cycle"]]] call BIS_fnc_NNS_unstuckAI;

	// If the cas is disabled, kill the crew
	_null = [_cas,_casCrew] spawn {
		waitUntil {sleep 2; !(isNull (_this select 0)) and {!(canMove (_this select 0))}};
		{_x setDamage 1} forEach (crew (_this select 0));
	};

	// If the cas2 is disabled, kill the crew
	_null = [_cas2,_casCrew] spawn {
		waitUntil {sleep 2; !(isNull (_this select 0)) and {!(canMove (_this select 0))}};
		{_x setDamage 1} forEach (crew (_this select 0));
	};

	// Reveal players to pilots
	//{(driver _cas) reveal [_x,4]} forEach allPlayers;
	//{(driver _cas2) reveal [_x,4]} forEach allPlayers;

	// Delete when far away
	waitUntil {sleep 5; (allPlayers findIf {(_x distance _cas) < 3000} == -1 || !(alive _cas)) && (allPlayers findIf {(_x distance _cas2) < 3000} == -1 || !(alive _cas2))}; //NNS : rework condition
	if(!(alive _cas) || !(alive _cas2)) then {waitUntil {sleep 5; allPlayers findIf {(_x distance _cas) < 1200} == -1 && allPlayers findIf {(_x distance _cas2) < 1200} == -1}}; //NNS : Delete if destroyed
	//waitUntil {sleep 5; (({(_x distance _cas) < (3000)} count (allPlayers) == 0) || !(alive _cas)) and (({(_x distance _cas2) < (3000)} count (allPlayers) == 0) || !(alive _cas2))}; //NNS : rework condition
	//if(!(alive _cas) || !(alive _cas2)) then {waitUntil {sleep 5; ({(_x distance _cas) < 1200} count (allPlayers) == 0) && ({(_x distance _cas2) < 1200} count (allPlayers) == 0)};}; //NNS : Delete if destroyed
	
	{deleteVehicle _x} forEach (_casCrew) + [_cas,_cas2];
	deleteGroup _casGroup;
	[format["BIS_fnc_EfM_specialEvents : %1 : Cleaned",_event]] call BIS_fnc_NNS_debugOutput; //debug
};

// CAS - Comanche
if (_event == "Blackfoot") then {
	[format["BIS_fnc_EfM_specialEvents : %1",_event]] call BIS_fnc_NNS_debugOutput; //debug

	_target = selectRandom allPlayers;
	_targetPos = getPosATL _target;

	_cas = createVehicle ["B_Heli_Attack_01_F", [0,0,100], [], 0, "FLY"];
	createVehicleCrew _cas;
	_casCrew = crew _cas;
	_casGroup = group (_casCrew select 0);
	_cas setPosATL [(_targetPos select 0) + ((250 + random 250) * (selectRandom _signednumber)),(_targetPos select 1) - (2000 * (selectRandom _signednumber)), 100]; //NNS : random position
	_cas flyInHeight 100;
	_cas setVehicleLock "LOCKEDPLAYER";
	[format["BIS_fnc_EfM_specialEvents : %1 : %2 created (%3m)",_event, typeOf _cas, player distance _cas]] call BIS_fnc_NNS_debugOutput; //debug

	// Waypoints
	_wpCAS01 = _casGroup addWaypoint [_targetPos, 0];
	_wpCAS02 = _casGroup addWaypoint [_targetPos, 250];
	_wpCAS02 setWaypointType "SaD";
	_wpCAS03 = _casGroup addWaypoint [_targetPos, 250];
	_wpCAS03 setWaypointType "SaD";
  _wpCAS04 = _casGroup addWaypoint [_targetPos, 0];
	_wpCAS04 setWaypointType "Cycle";
	
	//detect stuck unit
	_null = [driver _cas,15,5,[[_targetPos], [_targetPos getPos [250,random 360],"SaD"], [_targetPos getPos [250,random 360],"SaD"], [_targetPos,"Cycle"]]] call BIS_fnc_NNS_unstuckAI;

	// If the cas is disabled, kill the crew
	_null = [_cas,_casCrew] spawn {
		waitUntil {sleep 2; !(isNull (_this select 0)) and {!(canMove (_this select 0))}};
		{_x setDamage 1} forEach (_this select 1);
	};

	// Remove missiles
  {_cas removeWeaponGlobal _x} forEach ["missiles_DAGR"];

	// Reveal players to pilot
	//{(driver _cas) reveal [_x,4]} forEach allPlayers;

	// Retreat if damaged or after timeout
	_null = [_casGroup,_cas] spawn {
		_t = time;

		waitUntil {sleep 5; (damage (_this select 1) > 0.35) or (time > _t + 300)};

		_escGroup = createGroup west;
		_unit01 = _escGroup createUnit ["B_Soldier_F", [10,10,0], [], 0, "CAN_COLLIDE"];

		_wp01 = _escGroup addWaypoint [getPosATL _unit01, 0];
		deleteVehicle _unit01;

		(_this select 0) copyWaypoints (_escGroup);
		(_this select 0) setCombatMode "Blue";
		deleteGroup _escGroup;
	};

	// Delete when far away
	waitUntil {sleep 5; allPlayers findIf {(_x distance _cas) < 3000} == -1 || {!(alive _cas)}}; //NNS : rework condition
	if(!(alive _cas)) then {waitUntil {sleep 5; allPlayers findIf {(_x distance _cas) < 1200} == -1}}; //NNS : Delete if destroyed
	//waitUntil {sleep 5; ({(_x distance _cas) < (3000)} count (allPlayers) == 0)}; //NNS : rework condition
	//if(!(alive _cas)) then {waitUntil {sleep 5; ({(_x distance _cas) < 1200} count (allPlayers) == 0)};}; //NNS : Delete if destroyed
	
	{deleteVehicle _x} forEach (_casCrew) + [_cas];
	deleteGroup _casGroup;
	[format["BIS_fnc_EfM_specialEvents : %1 : Cleaned",_event]] call BIS_fnc_NNS_debugOutput; //debug
};

// CAS - A10
if (_event == "A10") then {
	[format["BIS_fnc_EfM_specialEvents : %1",_event]] call BIS_fnc_NNS_debugOutput; //debug

	_target = selectRandom allPlayers;
	_targetPos = getPosATL _target;

	_cas = createVehicle ["B_Plane_CAS_01_F", [(_targetPos select 0) + ((250 + random 250) * (selectRandom _signednumber)),(_targetPos select 1) - (2000 * (selectRandom _signednumber)), 125], [], 0, "FLY"]; //NNS : random position
	createVehicleCrew _cas;
	_casCrew = crew _cas;
	_casGroup = group (_casCrew select 0);
	// _cas setPosATL [(_targetPos select 0),(_targetPos select 1) - 1750, 125];
	_cas flyInHeight 125;
	_cas setVehicleLock "LOCKEDPLAYER";
	_wpCAS01 = _casGroup addWaypoint [_targetPos, 0];
	_wpCAS01 setWaypointType "Guard";
	[format["BIS_fnc_EfM_specialEvents : %1 : %2 created (%3m)",_event, typeOf _cas, player distance _cas]] call BIS_fnc_NNS_debugOutput; //debug

	{_cas reveal [_x,4]} forEach (allPlayers);

	// Remove missiles
  {_cas removeWeaponGlobal _x} forEach [/*"Missile_AA_04_Plane_CAS_01_F",*/"Missile_AGM_02_Plane_CAS_01_F"];

	// Limit speed
	_cas forceSpeed 125;

	// If the cas is disabled, kill the crew
	_null = [_cas,_casCrew] spawn {
		waitUntil {sleep 2; !(isNull (_this select 0)) and {!(canMove (_this select 0))}};
		{_x setDamage 1} forEach (_this select 1);
	};

	// Retreat if damaged or after timeout
	_null = [_casGroup, _cas] spawn {
		_t = time;

		waitUntil {sleep 5; (damage (_this select 1) > 0.35) or (time > _t + 600)};

		_escGroup = createGroup west;
		_unit01 = _escGroup createUnit ["B_Soldier_F", [10,10,0], [], 0, "CAN_COLLIDE"];

		_wp01 = _escGroup addWaypoint [getPosATL _unit01, 0];
		deleteVehicle _unit01;

		(_this select 0) copyWaypoints (_escGroup);
		(_this select 0) setCombatMode "Blue";
		deleteGroup _escGroup;
	};

	// Delete when far away
	waitUntil {sleep 5; allPlayers findIf {(_x distance _cas) < 5000} == -1 || {!(alive _cas)}}; //NNS : rework condition
	if(!(alive _cas)) then {waitUntil {sleep 5; allPlayers findIf {(_x distance _cas) < 1200} == -1}}; //NNS : Delete if destroyed
	//waitUntil {sleep 5; ({(_x distance _cas) < (5000)} count (allPlayers) == 0)}; //NNS : rework condition
	//if(!(alive _cas)) then {waitUntil {sleep 5; ({(_x distance _cas) < 2000} count (allPlayers) == 0)};}; //NNS : Delete if destroyed
	
	{deleteVehicle _x} forEach (_casCrew) + [_cas];
	deleteGroup _casGroup;
	[format["BIS_fnc_EfM_specialEvents : %1 : Cleaned",_event]] call BIS_fnc_NNS_debugOutput; //debug
};

 //NNS : CAS - Orca, imported from excape tanoa
if (_event == "Orca") then {
	[format["BIS_fnc_EfM_specialEvents : %1",_event]] call BIS_fnc_NNS_debugOutput; //debug

	_target = selectRandom allPlayers;
	_targetPos = getPosATL _target;


	_cas = createVehicle ["O_Heli_Light_02_v2_F", [0,0,75], [], 0, "FLY"];
	createVehicleCrew _cas;
	_casCrew = crew _cas;
	_tmpgrp = createGroup west; {[_x] joinSilent _tmpgrp;} forEach _casCrew; //NNS : convert crew to west side
	_casGroup = group (_casCrew select 0);
	{[_x,"sniper"] call BIS_fnc_NNS_AIskill;} forEach units _casGroup; //NNS : set skills
	//{ _x setSkill .9; } forEach units _casGroup; //NNS : set skills
	_cas setPosATL [(_targetPos select 0) + ((250 + random 250) * (selectRandom _signednumber)),(_targetPos select 1) - (2000 * (selectRandom _signednumber)), 75]; //NNS : random position
	_cas flyInHeight 75;
	_cas setVehicleLock "LOCKEDPLAYER";
	[format["BIS_fnc_EfM_specialEvents : %1 : %2 created (%3m)",_event, typeOf _cas, player distance _cas]] call BIS_fnc_NNS_debugOutput; //debug

	// Waypoints
	_wpCAS01 = _casGroup addWaypoint [_targetPos, 0];
	_wpCAS02 = _casGroup addWaypoint [_targetPos, 400];
	_wpCAS02 setWaypointType "SaD";
	_wpCAS03 = _casGroup addWaypoint [_targetPos, 400];
	_wpCAS03 setWaypointType "SaD";
  _wpCAS04 = _casGroup addWaypoint [_targetPos, 0];
	_wpCAS04 setWaypointType "Cycle";
	
	//detect stuck unit
	_null = [driver _cas,15,5,[[_targetPos], [_targetPos getPos [400,random 360],"SaD"], [_targetPos getPos [400,random 360],"SaD"], [_targetPos,"Cycle"]]] call BIS_fnc_NNS_unstuckAI;

	// Reveal players to pilot
	//{(driver _cas) reveal [_x,4]} forEach allPlayers;

	// If the cas is disabled, kill the crew
	_null = [_cas,_casCrew] spawn
	{
		waitUntil {sleep 2; !(isNull (_this select 0)) and {!(canMove (_this select 0))}};
		{_x setDamage 1} forEach (_this select 1);
	};

	// Retreat if damaged or after timeout
	_null = [_casGroup,_cas] spawn
	{
		_t = time;

		waitUntil {sleep 5; (damage (_this select 1) > 0.35) or (time > _t + 300)};

		_escGroup = createGroup west;
		_unit01 = _escGroup createUnit ["B_soldier_F", [10,10,0], [], 0, "CAN_COLLIDE"];

		_wp01 = _escGroup addWaypoint [getPosATL _unit01, 0];
		deleteVehicle _unit01;

		(_this select 0) copyWaypoints (_escGroup);
		(_this select 0) setCombatMode "Blue";
		deleteGroup _escGroup;
	};

	// Delete when far away
	waitUntil {sleep 5; allPlayers findIf {(_x distance _cas) < 3000} == -1 || {!(alive _cas)}}; //NNS : rework condition
	if(!(alive _cas)) then {waitUntil {sleep 5; allPlayers findIf {(_x distance _cas) < 1200} == -1}}; //NNS : Delete if destroyed
	//waitUntil {sleep 5; ({(_x distance _cas) < (3000)} count (allPlayers) == 0) || !(alive _cas)}; //NNS : rework condition
	//if(!(alive _cas)) then {waitUntil {sleep 5; ({(_x distance _cas) < 1200} count (allPlayers) == 0)};}; //NNS : Delete if destroyed
	
	{deleteVehicle _x} forEach (_casCrew) + [_cas];
	deleteGroup _casGroup;
	[format["BIS_fnc_EfM_specialEvents : %1 : Cleaned",_event]] call BIS_fnc_NNS_debugOutput; //debug
};

 //NNS : Huron - Paradrop, will try to land if possible, paradrop 8 soldier if can't
 
if (_event == "Huron") then {
	[format["BIS_fnc_EfM_specialEvents : %1",_event]] call BIS_fnc_NNS_debugOutput; //debug

	_target = selectRandom allPlayers;
	_targetPos = getPosATL _target;
	_wpPos = [(_targetPos select 0) + ((250 + random 250) * (selectRandom _signednumber)), (_targetPos select 1) + ((250 + random 250) * (selectRandom _signednumber)), 50]; //used if lz selection failed
	_heli_spawn_pos = [(_targetPos select 0) + ((250 + random 250) * (selectRandom _signednumber)),(_targetPos select 1) - (2000 * (selectRandom _signednumber)), 40]; //used to compute insertion to lz

	// Create heli and WPs
	_heli = createVehicle ["B_Heli_Transport_03_F", _heli_spawn_pos, [], 0, "FLY"]; //NNS : random position
	createVehicleCrew _heli;
	_heliCrew = crew _heli;
	_heliGroup = group (_heliCrew select 0);
	_heli setVehicleLock "LOCKEDPLAYER";
	[format["BIS_fnc_EfM_specialEvents : %1 : %2 created (%3m)",_event, typeOf _heli, player distance _heli]] call BIS_fnc_NNS_debugOutput; //debug

	_heliGroup setBehaviour "Careless";
	_heliGroup setCombatMode "YELLOW";
	
	// Naval camo
	[_heli,["Blue",1],true] call BIS_fnc_initVehicle;
	
	// If the heli is disabled, kill the crew
	_null = [_heli,_heliCrew] spawn {
		waitUntil {sleep 2.5; !(isNull (_this select 0)) and {!(canMove (_this select 0))}};
		{_x setDamage 1} forEach (_this select 1);
	};
	
	_lz_ran_pos = [[[getPos _target, 150]],[]] call BIS_fnc_randomPos; //get initial random pos for LZ
	_lz_pos = [_lz_ran_pos, 0, 150, 20, 0, 0.5, 0] call BIS_fnc_findSafePos; //safe place based on inital LZ pos

	if !(_target distance _lz_pos < 400) then { //if failed to select LZ 400m near target, retry once after 10 sec
		[format["BIS_fnc_EfM_specialEvents : %1 : Failed to select proper LZ, retry in 10sec",_event]] call BIS_fnc_NNS_debugOutput; //debug
		sleep 10;
		_lz_ran_pos = [[[getPos _target, 150]],[]] call BIS_fnc_randomPos; //get initial random pos for LZ
		_lz_pos = [_lz_ran_pos, 0, 150, 20, 0, 0.5, 0] call BIS_fnc_findSafePos; //safe place based on inital LZ pos
	};
	
	//{(driver _heli) reveal [_x,4]} forEach allPlayers; //reveal real player position to AI
	
	if (alive _heli && (_target distance _lz_pos < 400)) then { //LZ 400m near target selected
		_lz = 'Land_HelipadEmpty_F' createVehicle _lz_pos; //create invisible helipad for LZ
		[format["BIS_fnc_EfM_specialEvents : %1 : LZ created (%2m)",_event, player distance _lz_pos]] call BIS_fnc_NNS_debugOutput; //debug
		
		_heli doMove [_lz_pos select 0,_lz_pos select 1,20]; //start move to lz, note: move looks better than a real checkpoint for landing
		
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
				//[format["_tmp_speed: %1 ,_tmp_alt: %2",_tmp_speed,_tmp_alt]] call BIS_fnc_NNS_debugOutput; //debug
				sleep 1;
			};
		};
		
		//waitUntil{sleep 1; ((alive _heli) && (unitReady _heli) && (currentWaypoint _heliGroup)==2) || !(alive _heli)}; //wait until heli ready to land or heli destroyed
		waitUntil{sleep 1; ((_heli distance2D _lz_pos) < 300) || !(alive _heli)}; //wait until ramp start distance
		_grp = grpNull;		// Create empty group
		if (alive _heli) then {
			doStop _heli; //stop heli move
			_heli land "GET OUT"; //order pilot to land
			[format["BIS_fnc_EfM_specialEvents : %1 : Start landing : %2m",_event,player distance _heli]] call BIS_fnc_NNS_debugOutput; //debug
		};
		
		waitUntil{sleep 1; ((alive _heli) && (isTouchingGround _heli)) || !(alive _heli)}; //wait until heli is touching ground or heli destroyed
		if (alive _heli) then {
			_grp = [[0,0,0], west, missionConfigFile >> "CfgGroups" >> "West" >> "BLU_F" >> "Infantry" >> "EfM_W_Squad01", [], [], [0.3, 0.3]] call BIS_fnc_spawnGroup; // Create team onboard, need to be done at the last time or enableDynamicSimulation will fail
			{_x moveInCargo _heli; _x assignAsCargo _heli;} forEach (units _grp); //set units as heli cargo
			if (missionNamespace getVariable "BIS_enemyEquipment" == 1) then {{_null = _x execVM "Scripts\LimitEquipment.sqf"} forEach (units _grp)}; //limit equipement
			_grp deleteGroupWhenEmpty true;  // Mark for auto deletion and enable Dynamic simulation
			_grp enableDynamicSimulation true;  // enable Dynamic simulation
			{[_x,"specops"] call BIS_fnc_NNS_AIskill;} forEach units _grp; //set skills
			//{_x setSkill .75;} forEach units _grp; //set skills
			sleep 2;
			[format["BIS_fnc_EfM_specialEvents : %1 : Touching ground : %2m",_event,player distance _heli]] call BIS_fnc_NNS_debugOutput; //debug
			_heli flyInHeight 0; //pin to ground
			_heli animateDoor ["Door_rear_source", 1, false]; //open cargo door
			sleep 1;
			[format["BIS_fnc_EfM_specialEvents : %1 : Start unload",_event]] call BIS_fnc_NNS_debugOutput; //debug
			
			{ //disembark units if heli still alive
				if (alive _heli && isTouchingGround _heli) then { //extra secutity to avoid unload when in air
					_x leaveVehicle _heli; //force unit to leave vehicle
					sleep 2;
				};
			} forEach (units _grp);
		};
		
		sleep 3;
		
		//if(({(_x in _heli)} count (units _grp)) > 0) then {{moveOut _x;} forEach units _grp;}; //if some units didn't get out, huron does glitch some time 
		
		[format["BIS_fnc_EfM_specialEvents : %1 : Unloaded",_event]] call BIS_fnc_NNS_debugOutput; //debug
		//waitUntil{sleep 1; ({!(_x in _heli)} count (units _grp) == {alive _x} count (units _grp)) || !(alive _heli)}; //no more units in heli or heli destroyed
		_heli animateDoor ["Door_rear_source", 0, false]; //close cargo door
		_heli flyInHeight 30; //unpin from ground
		
		if ({alive _x} count (units _grp) > 0) then {_stalk = [_grp,group (allPlayers select 0)] spawn BIS_fnc_stalk;}; //stalk if alive
		
		deleteVehicle _lz; //clean up LZ
	} else { //LZ selection failed, go for paradrop
		[format["BIS_fnc_EfM_specialEvents : %1 : Failed to select proper LZ, forced Paradrop",_event]] call BIS_fnc_NNS_debugOutput; //debug
		_heli forceSpeed 45; _heli flyInHeight 70;
		_heliGroup setBehaviour "Careless";
		_heliGroup setCombatMode "YELLOW";
		_wpHeli01 = _heliGroup addWaypoint [_wpPos, 0];
		_wpHeli02 = _heliGroup addWaypoint [[100,100,150], 0];
		waitUntil {sleep 1; (_heli distance2D _targetPos) < 400};
		_null = _heli execVM "Scripts\Paratroopers.sqf";
	};
	
	if (alive _heli) then { //add escape checkpoint if heli still alive
		_wpHeli03 = _heliGroup addWaypoint [[(_targetPos select 0) + (4000 * (selectRandom _signednumber)), (_targetPos select 1) + (4000 * (selectRandom _signednumber)), 75], 0];
		_wpHeli03 setWaypointSpeed "FULL";
		_wpHeli03 setWaypointBehaviour "CARELESS";
		_heli forceSpeed 50; _heli flyInHeight 40;
		[format["BIS_fnc_EfM_specialEvents : %1 : Escape waypoint added",_event]] call BIS_fnc_NNS_debugOutput; //debug
	};

	// Delete heli when far away
	waitUntil {sleep 5; allPlayers findIf {(_x distance _heli) < 3000} == -1 || {!(alive _heli)}}; //NNS : rework condition
	if(!(alive _heli)) then {waitUntil {sleep 5; allPlayers findIf {(_x distance _heli) < 1200} == -1}}; //NNS : Delete if destroyed
	//waitUntil {sleep 5; ({(_x distance _heli) < 3000} count (allPlayers) == 0) || !(alive _heli)};
	//if(!(alive _heli)) then {waitUntil {sleep 5; ({(_x distance _heli) < 1200} count (allPlayers) == 0)};};
	
	{deleteVehicle _x} forEach (_heliCrew + [_heli]);
	deleteGroup _heliGroup;
	[format["BIS_fnc_EfM_specialEvents : %1 : Cleaned",_event]] call BIS_fnc_NNS_debugOutput; //debug
};


