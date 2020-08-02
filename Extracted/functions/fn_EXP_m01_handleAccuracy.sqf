private _info = param [0, objNull, [objNull, []]];

if (typeName _info != typeName []) then {
	private _unit = _info;
	private _min = param [1, 0.01, [0]];
	private _max = param [2, 0.1, [0]];
	private _limit = param [3, 3, [0]];
	private _cooldown = param [4, 3, [0]];
	
	// Reduce accuracy by default
	_unit setSkill ["aimingAccuracy", _min];
	
	// Set variables
	{
		private _suffix = _x select 0;
		private _value = _x select 1;
		
		// Compose variable
		private _var = "BIS_fnc_EXP_m01_handleAccuracy" + _suffix;
		
		// Set variable
		_unit setVariable [_var, _value];
	} forEach [
		["_min", _min],
		["_max", _max],
		["_limit", _limit],
		["_cooldown", _cooldown]
	];
	
	// Add event handler
	_unit addEventHandler ["Fired", {[_this] call BIS_fnc_EXP_m01_handleAccuracy}];
} else {
	private _unit = _info select 0;
	private _weapon = _info select 1;
	
	// Grab variables
	private _min = _unit getVariable "BIS_fnc_EXP_m01_handleAccuracy_min";
	private _max = _unit getVariable "BIS_fnc_EXP_m01_handleAccuracy_max";
	private _limit = _unit getVariable "BIS_fnc_EXP_m01_handleAccuracy_limit";
	private _cooldown = _unit getVariable "BIS_fnc_EXP_m01_handleAccuracy_cooldown";

	if (_weapon in [primaryWeapon _unit, handgunWeapon _unit]) then {
		// Increase shot count
		private _shots = _unit getVariable ["BIS_fnc_EXP_m01_handleAccuracy_shots", 0];
		_shots = _shots + 1;
		_unit setVariable ["BIS_fnc_EXP_m01_handleAccuracy_shots", _shots];
		
		if (_shots >= _limit) then {
			// Terminate previous cooldown
			private _script = _unit getVariable "BIS_fnc_EXP_m01_handleAccuracy_script";
			if (!(isNil "_script")) then {terminate _script};
			
			// Increase accuracy
			_unit setSkill ["aimingAccuracy", _max];
			
			// Start cooldown
			_script = [_unit, _min, _cooldown] spawn {
				scriptName (format ["BIS_fnc_EXP_m01_handleAccuracy: cooldown - %1", _this]);
				
				params ["_unit", "_min", "_cooldown"];
				
				// Cooldown
				sleep _cooldown;
				
				// Reset shots and accuracy
				_unit setVariable ["BIS_fnc_EXP_m01_handleAccuracy_shots", 0];
				_unit setSkill ["aimingAccuracy", _min];
			};
			
			// Store script
			_unit setVariable ["BIS_fnc_EXP_m01_handleAccuracy_script", _script];
		};
	};
};

true