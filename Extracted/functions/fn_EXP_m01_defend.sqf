params [
	["_unit", objNull, [objNull]],
	["_pos", "", [""]],
	["_var", "", [""]]
];

// Store the variable on the unit
_unit setVariable ["BIS_fnc_EXP_m01_defend_var", _var];

// Detect when the unit fires
private _firedEH = _unit addEventHandler [
	"Fired",
	{
		params ["_unit"];
		
		// Remove event handler
		private _firedEH = _unit getVariable "BIS_fnc_EXP_m01_defend_firedEH";
		if (!(isNil {_firedEH})) then {
			_unit removeEventHandler ["Fired", _firedEH];
			_unit setVariable ["BIS_fnc_EXP_m01_defend_firedEH", nil];
		};
		
		// Activate the assigned variable
		private _var = _unit getVariable "BIS_fnc_EXP_m01_defend_var";
		if (!(isNil {_var})) then {missionNamespace setVariable [_var, true]};
	}
];

// Store the event handler
_unit setVariable ["BIS_fnc_EXP_m01_defend_firedEH", _firedEH];

waitUntil {
	// Unit was killed
	!(alive _unit)
	||
	// Unit was alerted
	behaviour _unit == "COMBAT"
	||
	// Everyone was alerted
	missionNamespace getVariable [_var, false]
};

if (_var == "BIS_finalAlerted") then {
	// Start the final attack
	BIS_finalEngaged = true;
};

if (alive _unit) then {
	// Adjust behavior
	_unit setBehaviour "AWARE";
	_unit enableAI "MOVE";
	
	if (_unit == BIS_finalPlayers12) then {
		// Make the tower guard kneel
		_unit setUnitPos "MIDDLE";
	} else {
		if (leader _unit == _unit) then {
			// Have others defend the position
			private _group = group _unit;
			private _pos = markerPos _pos;
			
			for "_i" from 1 to 2 do {
				// Create waypoint
				private _wp = _group addWaypoint [_pos, 0];
				
				// Move first
				private _type = "MOVE";
				
				if (_i == 2) then {
					// Guard the position after reaching it
					_type = "GUARD";
					if (_var == "BIS_finalAlerted") then {_type = "SAD"};
					_wp setWaypointBehaviour "COMBAT";
				};
				
				// Assign type
				_wp setWaypointType _type;
				
				// Start moving
				if (_i == 1) then {_group setCurrentWaypoint _wp};
			};
		};
	};
};

true