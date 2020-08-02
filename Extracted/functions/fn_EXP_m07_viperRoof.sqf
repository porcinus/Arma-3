params ["_unit"];

// Unhide unit
_unit setPosASL (_unit getVariable "BIS_alt");
_unit hideObjectGlobal false;
_unit enableSimulationGlobal true;
_unit allowDamage true;
_unit setCaptive false;

// Crawl forward
_unit playAction "WalkF";

// Calculate duration of crawl
private _duration = switch (_unit) do {
	default {11};
	case BIS_viper2_4: {4};
};

// Wait
sleep _duration;

// Re-enable AI
{_unit enableAI _x} forEach ["ANIM", "AUTOCOMBAT", "AUTOTARGET", "MOVE", "TARGET"];

// Engage players
_unit setBehaviour "COMBAT";
_unit setCombatMode "YELLOW";

if (_unit == BIS_viper2_4) then {
	// Crouched unit
	_unit setUnitPos "MIDDLE";
	_unit doWatch [13756.9,12290.5,0];
} else {
	// Prone units
	_unit doWatch BIS_intel_device;
};

// Turn on laser
_unit enableIRLasers true;

true