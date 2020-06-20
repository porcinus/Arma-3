/*
NNS
Try to detect and unstuck AI, apply to unit or group
Warning, will remove all existing waypoints of unit group if waypoint array given

Maybe temporary fix to solve Littlebird sometime stoping to move.

Example: 
_null = [aiunit,15,5,[
getPos target, //waypoint position
[target getPos [250,random 360],"SaD"], //waypoint position, type
[target getPos [250,random 360],"SaD"], //waypoint position, type
[getPos target,"Cycle"] //cycle waypoint
]] call BIS_fnc_NNS_unstuckAI;

*/

// Params
params
[
	["_target",objNull], //unit to check
	["_interval",60], //check interval
	["_threshold",2], //tolerance to trigger
	["_new_waypoint_set",[]], //waypoint list, format [[pos,type],...]
	["_distance",100], //teleport distance to unstick unit
	["_restart",true] //restart process if unit teleported
];

// Check for validity
if (isNull _target) exitWith {[format["BIS_fnc_NNS_unstuckAI : Non-existing unit %1 used!",_target]] call BIS_fnc_NNS_debugOutput;};

_running = true;

_group = grpNull;
if (typeName _target != "GROUP") then {_group = group _target;} else {_group = _target;}; //detect if group or unit
[format["BIS_fnc_NNS_unstuckAI : %1 : Starting stuck detection",_group]] call BIS_fnc_NNS_debugOutput; //debug

{_x setVariable ["unstuck_oldpos", getPosATL _x];} forEach units _group; //save position of each unit in group

while {_running} do {
	sleep (_interval);
	{
		_unit = _x;
		if (alive _unit) then { //alive unit
			_new_pos = getPosATL _unit; //unit new position
			_old_pos = _x getVariable ["unstuck_oldpos",[0,0,0]];; //get old position
			_x setVariable ["unstuck_oldpos", _new_pos]; //backup new position
			
			if ((_old_pos distance _new_pos) <= _threshold) then { //unit didn't moved enough in given interval
				[format["BIS_fnc_NNS_unstuckAI : %1 : %2 look to be stuck",_group,_unit]] call BIS_fnc_NNS_debugOutput; //debug
				
				if !(isNull objectParent _unit) then { //unit is in a vehicle
					(objectParent _unit) setPosATL [(_new_pos select 0) + (random _distance),(_new_pos select 1) + (random _distance),_new_pos select 2]; //teleport vehicle
					[format["BIS_fnc_NNS_unstuckAI : %1 : Vehicle (%2) teleported at %3m",_group,_unit,_unit distance (getPosATL _unit)]] call BIS_fnc_NNS_debugOutput; //debug
				} else {
					_unit setPosATL [(_new_pos select 0) + (random _distance),(_new_pos select 1) + (random _distance),_new_pos select 2]; //teleport unit
					[format["BIS_fnc_NNS_unstuckAI : %1 : Unit (%2) teleported at %3m",_group,_unit,_unit distance (getPosATL _unit)]] call BIS_fnc_NNS_debugOutput; //debug
				};
				_running = false;
			};
		};
	} forEach units _group;
};

if(count _new_waypoint_set > 0) then { //set of waypoint given
	for "_i" from count waypoints _group - 1 to 0 step -1 do {deleteWaypoint [_group, _i];}; //clear all waypoints

	{
		_tmp_waypoint = objNull; //reset
		if (typeName _x == "ARRAY") then { // contain position and type
			_tmp_waypoint = _group addWaypoint [_x select 0, 0]; //add waypoint
			if !((_x select 1) isEqualTo objNull) then {_tmp_waypoint setWaypointType (_x select 1);}; //add type if set
		} else { // contain position only
			_tmp_waypoint = _group addWaypoint [_x, 0]; //add waypoint
		};
		
		[format["BIS_fnc_NNS_unstuckAI : %1 : Waypoint added : %2",_group,_x]] call BIS_fnc_NNS_debugOutput; //debug
	} forEach _new_waypoint_set;
};

//add a double check in case vehicle destroyed but units still alive
_alive_vehicle = true; //tmp
_alive_units = 0;
{
	if (alive _x && {_alive_vehicle}) then {_alive_units=_alive_units+1; //unit still alive
		if !(isNull objectParent _x) then { //unit is in a vehicle
			if !(alive (objectParent _x)) then {_alive_vehicle=false;}; //vehicle destroyed
		};
	};
} forEach units _group;

if(_alive_units > 0 && {_alive_vehicle} && {_restart}) then {_null = [_target,_interval,_threshold,_new_waypoint_set,_distance,_restart] call BIS_fnc_NNS_unstuckAI;}; //restart if set

[format["BIS_fnc_NNS_unstuckAI : %1 : Detection end",_group]] call BIS_fnc_NNS_debugOutput; //debug

objNull