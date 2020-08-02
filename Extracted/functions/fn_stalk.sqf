/*
	Author: Vaclav "WattyWatts" Oliva

	Description:
	Continuously set WP of one group to a different group to hunt it. It does not change the group's behaviour.
	Script terminates if one of the groups is eliminated or if the optional condition is activated.

	If the optional condition is activated, you can either:
	- return the group to its original waypoints
	- make the group search at current position (cycle in 50m radius)
	- send the group back to position from where it started to stalk (waypoint MOVE)
	- send to position of a marker (waypoint MOVE)
	- send to position of an object (waypoint MOVE)
	- send to [x,y,z] position (waypoint MOVE)

	Parameters:
	Select 0 = GROUP that will stalk
	Select 1 = GROUP that will be stalked
	Select 2 = (OPTIONAL) NUMBER: How often should the WP be refreshed, default 10 seconds, min 5 seconds
	Select 3 = (OPTIONAL) NUMBER: Radius of the WP, default 0 meters
	Select 4 = (OPTIONAL) CODE: Condition for ending the stalking process, default {false}
	Select 5 = (OPTIONAL) STRING or POSITION or OBJECT or NUMBER (0 for return to original waypoints (default), 1 to search at current position, 2 to return to position where they started to stalk)

	Returns:
	Boolean

	Examples:
	_stalking = [BIS_grpStalkers,BIS_grpPlayer] spawn BIS_fnc_stalk;
	_stalking = [BIS_grpStalkers,BIS_grpPlayer,nil,nil,{BIS_player distance BIS_Heli < 100},"BIS_mrkRetreatMarker"] spawn BIS_fnc_stalk;
	_stalking = [BIS_grpStalkers,BIS_grpPlayer,20,10,{BIS_Return},1] spawn BIS_fnc_stalk;
	_stalking = [BIS_grpStalkers,BIS_grpPlayer,5,0,{dayTime > 20},[3600,600,0]] spawn BIS_fnc_stalk;
*/

// Params
params
[
	["_stalkerGroup",grpNull,[grpNull]],
	["_stalkedGroup",grpNull,[grpNull]],
	["_refresh",10,[999]],
	["_radius",0,[999]],
	["_condition",{false},[{}]],
	["_returnWP",0,[999,"",objNull,[]]]
];

// Check for validity
if (isNull _stalkerGroup) exitWith {["STALKING: Non-existing group %1 to stalk used!",_stalkerGroup] call BIS_fnc_logFormat; false};
if (_stalkerGroup getVariable "BIS_Stalk" == 1) exitWith {["STALKING: %1 is already stalking!",_stalkerGroup] call BIS_fnc_logFormat; false};
if (isNull _stalkedGroup) exitWith {["STALKING: Non-existing group %2 to be stalked used!",_stalkedGroup] call BIS_fnc_logFormat; false};
if (_stalkerGroup == _stalkedGroup) exitWith {["STALKING: Group %1 cannot stalk itself!",_stalkerGroup] call BIS_fnc_logFormat; false};
if ((_refresh isEqualType 999) and {_refresh < 5}) exitWith {["STALKING: %1 Delay cannot be lower than 5 seconds!",_stalkerGroup] call BIS_fnc_logFormat; false};
if ((_radius isEqualType 999) and {_radius < 0}) exitWith {["STALKING: %1 Radius cannot be lower than 0 meters!",_stalkerGroup] call BIS_fnc_logFormat; false};
if ((_returnWP isEqualType 999) and {!(_returnWP in [0,1,2])}) exitWith {["STALKING: %1 Incorrect return WP type, only 0, 1 or 2 can be used!",_stalkerGroup] call BIS_fnc_logFormat; false};
if ((_returnWP isEqualType "") and {getMarkerType _returnWP == ""}) exitWith {["STALKING: %1 Non-existent marker for return waypoint used!",_stalkerGroup] call BIS_fnc_logFormat; false};
if ((_returnWP isEqualType objNull) and {isNull _returnWP}) exitWith {["STALKING: %1 Non-existent object for return waypoint used!",_stalkerGroup] call BIS_fnc_logFormat; false};
if ((_returnWP isEqualType []) and {count _returnWP != 3}) exitWith {["STALKING: %1 Wrong [X,Y,Z] format for return waypoint used!",_stalkerGroup] call BIS_fnc_logFormat; false};

// Set variable to be able to check if the unit is stalking or not and to prevent running the script multiple times on the same group
_stalkerGroup setVariable ["BIS_Stalk",1];

// Initial position of the stalking group to enable return
private ["_originalPos"];
_originalPos = (getPos leader _stalkerGroup);

// Create dummy group to enable returning to original waypoints
_grpOriginalWP = createGroup Civilian;
"C_man_1" createUnit [(position leader _stalkerGroup),_grpOriginalWP];
_grpOriginalWP copyWaypoints _stalkerGroup;
{deleteVehicle _x} forEach (units _grpOriginalWP);

// Set Waypoint, loop and check for casualties
_wp = _stalkerGroup addWaypoint [(leader _stalkerGroup),0];
// ["%1 starting to stalk %2",_stalkerGroup,_stalkedGroup] call BIS_fnc_logFormat;

While
{
	({alive _x} count (units _stalkerGroup) > 0) and
	({alive _x} count (units _stalkedGroup) > 0)
}
Do
{
	if (simulationEnabled (leader _stalkerGroup)) then {
		while {(count (waypoints _stalkerGroup)) > 0} do {deleteWaypoint ((waypoints _stalkerGroup) select 0)};
		_wp = _stalkerGroup addWaypoint [(leader _stalkedGroup),_radius];
	};
	sleep _refresh;

	if (!(isNil _condition) and (_condition)) exitWith {/*["STALKING: Condition to end stalking for group %1 activated.",_stalkerGroup] call BIS_fnc_logFormat*/};
};

// Stalking ended, if by the optional condition, then decide where to put the next WP
if (!(isNil _condition) and (_condition)) then
{
	// Group is available for another stalking
	_stalkerGroup setVariable ["BIS_Stalk",0];

	if ({alive _x} count (units _stalkerGroup) > 0) then
	{
		{_x commandTarget objNull} forEach (units _stalkerGroup);
                while {(count (waypoints _stalkerGroup)) > 0} do {deleteWaypoint ((waypoints _stalkerGroup) select 0)};

		if (_returnWP isEqualType 999) then
		{
			if (_returnWP == 0) then
			{
				_stalkerGroup copyWaypoints _grpOriginalWP;
				// ["STALKING: Stalker group %1 returning to original waypoints.",_stalkerGroup] call BIS_fnc_logFormat;
			};
			if (_returnWP == 1) then
			{
				_pos01 = [(position leader _stalkerGroup), 50, 0] call BIS_fnc_relPos;
				_pos02 = [(position leader _stalkerGroup), 50, 90] call BIS_fnc_relPos;
				_pos03 = [(position leader _stalkerGroup), 50, 180] call BIS_fnc_relPos;
				_pos04 = [(position leader _stalkerGroup), 50, 270] call BIS_fnc_relPos;
				_wp01 = _stalkerGroup addWaypoint [_pos01,0];
				_wp02 = _stalkerGroup addWaypoint [_pos02,0];
				_wp03 = _stalkerGroup addWaypoint [_pos03,0];
				_wp04 = _stalkerGroup addWaypoint [_pos04,0];
				_wp05 = _stalkerGroup addWaypoint [_pos04,0];
				_wp05 setWaypointType "Cycle";
				// ["STALKING: Stalker group %1 searching at current position.",_stalkerGroup] call BIS_fnc_logFormat;
			};
			if (_returnWP == 2) then
			{
				_wp = _stalkerGroup addWaypoint [_originalPos,0];
				// ["STALKING: Stalker group %1 returning to original position.",_stalkerGroup] call BIS_fnc_logFormat;
			};
		};
		if (_returnWP isEqualType "") then
		{
			_wp = _stalkerGroup addWaypoint [(getMarkerPos _returnWP),0];
                                    // ["STALKING: Stalker group %1 moving to marker %2.",_stalkerGroup,_returnWP] call BIS_fnc_logFormat;
		};
		if (_returnWP isEqualType objNull) then
		{
			_wp = _stalkerGroup addWaypoint [(getPos _returnWP),0];
                                    // ["STALKING: Stalker group %1 moving to object %2.",_stalkerGroup,_returnWP] call BIS_fnc_logFormat;
		};
		if (_returnWP isEqualType []) then
		{
			_wp = _stalkerGroup addWaypoint [_returnWP,0];
                                    // ["STALKING: Stalker group %1 moving to coordinates %2.",_stalkerGroup,_returnWP] call BIS_fnc_logFormat;
		};
	};
};

if ({alive _x} count (units _stalkerGroup) == 0) then {/*["Stalker group %1 was eliminated",_stalkerGroup] call BIS_fnc_logFormat;*/ _stalkerGroup setVariable ["BIS_Stalk",nil]};
if ({alive _x} count (units _stalkedGroup) == 0) then {/*["Stalked group %1 was eliminated",_stalkedGroup] call BIS_fnc_logFormat*/};

// Delete the dummy group
deleteGroup _grpOriginalWP;

// Returns
true
