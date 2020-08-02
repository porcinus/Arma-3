params [
	["_unit", objNull, [objNull]],
	["_varLead", "", [""]],
	["_varAlert", "", [""]],
	["_pos", -1, ["", [], 0], 3]
];

if (typeName _pos == typeName "") then {_pos = markerPos _pos};

waitUntil {
	// Unit was killed
	!(alive _unit)
	||
	// Unit was alerted
	behaviour _unit == "COMBAT"
	||
	// Everyone was alerted
	missionNamespace getVariable [_varAlert, false]
};

if (alive _unit) then {
	private _leader = missionNamespace getVariable [_varLead, objNull];
	
	if (!(alive _leader)) then {
		// Register as the leader for units to join
		missionNamespace setVariable [_varLead, _unit];
		
		// Determine position if needed
		if (typeName _pos == typeName 0) then {_pos = getPosATL vehicle _unit};
		
		// Defend themselves
		private _group = group _unit;
		private _wp = _group addWaypoint [_pos, 0];
		_wp setWaypointBehaviour "COMBAT";
		_wp setWaypointCombatMode "RED";
		_wp setWaypointSpeed "NORMAL";
		_wp setWaypointType "GUARD";
		_group setCurrentWaypoint _wp;
	} else {
		// Join to group
		[_unit] joinSilent _leader;
		_unit allowFleeing 0;
	};
	
	// Ensure AI is enabled
	{_unit enableAI _x} forEach ["ANIM", "AUTOCOMBAT", "AUTOTARGET", "MOVE", "TARGET"];
	
	// Ensure correct behaviour
	_unit setBehaviour "COMBAT";
	_unit setCombatMode "RED";
	_unit setSpeedMode "NORMAL";
	_unit setUnitPos "AUTO";
	
	[_unit, _varAlert] spawn {
		scriptName format ["BIS_fnc_EXP_m01_firstDefend: alert control - %1", _this];
		
		params ["_unit", "_varAlert"];
		
		sleep 4;
		
		if (alive _unit) then {
			// Alert everyone
			missionNamespace setVariable [_varAlert, true];
		};
	};
};

true;