params [
	["_units", [], [[], ""]],
	["_mode", 0, [0]],
	["_var", "", [""]]
];

if (_mode == 0) then {
	// Hide units and store them in variable
	private _hidden = [];
	
	{
		private _unit = _x;
		
		if ({_unit isKindOf _x} count ["Man", "Car", "Air"] > 0) then {
			// Only hide units and vehicles
			_unit hideObjectGlobal true;
			_unit enableSimulationGlobal false;
			_unit allowDamage false;
			_unit setCaptive true;
			
			if (_unit getVariable ["BIS_setHeight", true]) then {
				// Move high into the air if allowed
				_unit setVariable ["BIS_alt", getPosATL _unit select 2];
				[_unit, 10e10] call BIS_fnc_setHeight;
			};
			
			// Add to array
			_hidden = _hidden + [_unit];
		};
	} forEach _units;
	
	// Store under variable
	private _existing = missionNamespace getVariable [_var, []];
	_existing = _existing + _hidden;
	missionNamespace setVariable [_var, _existing];
} else {
	// Grab units if necessary
	if (typeName _units == typeName "") then {_units = missionNamespace getVariable _units};
	
	{
		if (_x getVariable ["BIS_setHeight", true]) then {
			// Move back to their altitude if allowed
			private _alt = _x getVariable "BIS_alt";
			if (!(isNil {_alt})) then {[_x, _alt] call BIS_fnc_setHeight};
		};
		
		// Unhide units
		_x hideObjectGlobal false;
		_x enableSimulationGlobal true;
		
		// Enable damage if allowed
		if (_x getVariable ["BIS_damageAllowed", true]) then {_x allowDamage true};
		
		// Take off captive if allowed
		if (_x getVariable ["BIS_removeCaptive", true]) then {_x setCaptive false};
	} forEach _units;
};

true