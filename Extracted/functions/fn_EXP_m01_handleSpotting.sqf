private _unit = param [0, objNull, [objNull]];
private _dist = param [1, [0.005, 0.1], [[]], 2];
private _time = param [2, [0.005, 0.1], [[]], 2];

// Split up defines
_dist params ["_distMin", "_distMax"];
_time params ["_timeMin", "_timeMax"];

// Reduce spotting ability
_unit setSkill ["spotDistance", _distMin];
_unit setSkill ["spotTime", _timeMin];

// Wait until they enter combat
waitUntil {!(alive _unit) || behaviour _unit == "COMBAT"};

if (alive _unit) then {
	// Increase spotting ability
	_unit setSkill ["spotDistance", _distMax];
	_unit setSkill ["spotTime", _timeMax];
	
	while {alive _unit} do {
		waitUntil {
			sleep 0.5;
			
			// Unit was killed
			!(alive _unit)
			||
			// Players are too close
			{(vehicle _x) distance _unit < 5} count (call BIS_fnc_listPlayers) > 0
		};
		
		if (alive _unit) then {
			// Increase spotting to full
			{_unit setSkill [_x, 1]} forEach ["spotDistance", "spotTime"];
			
			waitUntil {
				sleep 0.5;
				
				// Unit was killed
				!(alive _unit)
				||
				// Players are far away
				{(vehicle _x) distance _unit < 5} count (call BIS_fnc_listPlayers) == 0
			};
			
			if (alive _unit) then {
				// Decrease to maximum again
				_unit setSkill ["spotDistance", _distMax];
				_unit setSkill ["spotTime", _timeMax];
			};
		};
	};
};



true