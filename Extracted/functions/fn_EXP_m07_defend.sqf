params ["_unit"];

if (!(_unit in [BIS_ai_1, BIS_james])) then {
	// Separate from group if necessary
	private _group = createGroup WEST;
	[_unit] joinSilent _group;
	_unit allowFleeing 0;
};

// Ensure they don't engage while moving
{_unit disableAI _x} forEach ["AUTOCOMBAT", "AUTOTARGET", "TARGET"];
_unit setCombatMode "BLUE";
_unit setSpeedMode "FULL";

// Disable collisions with players
_unit setVariable ["BIS_collisionsDisabled", true, true];

switch (_unit) do {
	case BIS_james: {
		// Move to tower position
		_unit doMove [13754.9,12287.3,4.14148];
		waitUntil {!(unitReady _unit)};
		waitUntil {unitReady _unit};
		
		// Ensure he isn't walking on his own
		waitUntil {(velocity _unit) distance [0,0,0] == 0};
		
		// Move into position
		{_unit disableAI _x} forEach ["ANIM", "PATH"];
		_unit setPosASL [13755.2,12287.2,6.69148];
		_unit setDir 293.742;
		
		// Start walking
		_unit playActionNow "WalkF";
		
		sleep 2;
		
		// Stop moving
		{_unit enableAI _x} forEach ["ANIM", "AUTOCOMBAT", "AUTOTARGET", "TARGET"];
		
		// Get ready
		_unit setBehaviour "COMBAT";
		_unit setCombatMode "YELLOW";
		_unit setUnitPos "UP";
		
		// Lower accuracy
		_unit setSkill ["aimingAccuracy", 0.05];
		
		// Watch correct direction
		_unit doWatch ([_unit, 200, 293.742] call BIS_fnc_relPos);
		
		// Let enemies engage
		_unit setCaptive false;
	};
	
	default {
		private _marker = (str _unit) + "Pos";
		private _pos = markerPos _marker;
		
		// Move to defend
		_unit doMove _pos;
		waitUntil {!(unitReady _unit)};
		waitUntil {unitReady _unit};
		
		// Stop moving
		_unit disableAI "PATH";
		{_unit enableAI _x} forEach ["AUTOCOMBAT", "AUTOTARGET", "TARGET"];
		
		// Get ready
		_unit setBehaviour "COMBAT";
		_unit setCombatMode "YELLOW";
		_unit setUnitPos "MIDDLE";
		
		// Lower accuracy for Support Lead
		if (_unit == BIS_ai_1) then {_unit setSkill ["aimingAccuracy", 0.05]};
		
		// Watch correct direction
		_unit doWatch ([_unit, 50, markerDir _marker] call BIS_fnc_relPos);
		
		// Let enemies engage
		_unit setCaptive false;
	};
};

true