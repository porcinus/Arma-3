params [
	["_unit", objNull, [objNull]],
	["_dest", 0, [0]],
	["_duration", 0, [0]],
	["_wave", true, [true]]
];

if (_wave) then {
	// Play first animation
	_unit playMoveNow "Acts_PercMstpSlowWrflDnon_handup1";

	// Detect when animation finishes
	private _animEH = _unit addEventHandler [
		"AnimDone",
		{
			private _unit = _this select 0;
			private _anim = _this select 1;

			if (_anim == "Acts_PercMstpSlowWrflDnon_handup1") then {
				// Remove eventhandler
				_unit removeEventHandler ["AnimDone", _unit getVariable "BIS_animEH"];

				// Register as ready to move
				_unit setVariable ["BIS_readyToMove", true];
			};
		}
	];

	// Store eventhandler
	_unit setVariable ["BIS_animEH", _animEH];

	// Wait for him to be ready
	waitUntil {_unit getVariable ["BIS_readyToMove", false]};
};

if (_wave) then {
	sleep 1;
};

// Stop procedural animations from interfering
_unit disableAI "ANIM";

// Calculate the difference between desired azimuth and current
private _current = direction _unit;
private _diff = _dest - _current;

// Attach to fake logic
private _group = createGroup sideLogic;
private _logic = _group createUnit ["Logic", [10,10,10], [], 0, "NONE"];
_logic setPosATL getPosATL _unit;
_logic setDir _current;
_unit attachTo [_logic, [0,0,0]];

// Calculate what the time should be when the transformations finishes
private _time = time + _duration;

// Play animation
_unit playActionNow "TurnLRelaxed";

if (_duration > 0) then {
	while {time < _time} do {
		// Calculate where we are along the transformation
		private _percent = 1 - ((_time - time) / _duration);

		// Calculate correct azimuth based on percentage completion
		private _dir = _current + (_diff * _percent);

		// Update the unit's direction
		_logic setDir _dir;

		sleep 0.01;
	};
};

// Apply final transformation
_logic setDir _dest;

// Detach unit, delete logic
detach _unit;
_unit setDir _dest;
deleteVehicle _logic;
deleteGroup _group;

// Move forward
_unit playActionNow "WalkF";

// Wait for him to be in position
private _dest = markerPos "BIS_RV";
waitUntil {BIS_supportLead distance _dest <= 9};

// Detect when the animation starts
private _animEH = BIS_supportLead addEventHandler [
	"AnimStateChanged",
	{
		params ["_unit", "_anim"];

		if (_anim == "Acts_Briefing_SC_StartLoop") then {
			// Remove event handler
			private _animEH = _unit getVariable "BIS_animEH";

			if (!(isNil "_animEH")) then {
				_unit removeEventHandler ["AnimStateChanged", _unit getVariable "BIS_animEH"];
				_unit setVariable ["BIS_animEH", nil];
			};

			// Reposition
			_unit setPos (markerPos "BIS_leadPos");
			_unit setDir (markerDir "BIS_leadPos");
			_unit setVelocity [0,0,0];
		};
	}
];

// Store event handler
BIS_supportLead setVariable ["BIS_animEH", _animEH];

// Stop fake movement, start animation
_unit enableAI "ANIM";
BIS_supportLead playMove "Acts_Briefing_SC_StartLoop";

true