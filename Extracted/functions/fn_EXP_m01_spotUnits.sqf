params [
	["_units", [], [objNull, []]],
	["_var", "", [""]],
	["_code", {}, [{}]]
];

if (isServer) then {
	// Establish default state
	missionNamespace setVariable [_var, false, true];
	
	[_var, _code] spawn {
		scriptName format ["BIS_fnc_EXP_m01_spotUnits: server control - %1", _this];
		
		params ["_var", "_code"];
		
		// Wait for variable to be triggered
		waitUntil {missionNamespace getVariable _var};
		
		// Execute code
		call _code;
	};
};

private "_spotted";
waitUntil {
	_spotted = missionNamespace getVariable [_var, false];
	
	// Someone else spotted the units
	_spotted
	||
	// Player spotted the units
	{cursorObject == vehicle _x} count _units > 0
};
	
if (!(_spotted)) then {
	// Trigger variable
	missionNamespace setVariable [_var, true, true];
};

true