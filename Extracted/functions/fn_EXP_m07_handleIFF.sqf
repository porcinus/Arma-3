private _units = [
	BIS_ai_1, BIS_ai_2, BIS_ai_3, BIS_ai_4,
	BIS_james, BIS_falcon1, BIS_falcon2, BIS_falcon3,
	BIS_miller
];

if (isServer) then {
	{
		// Disable IFF globally
		private _unit = _x;
		{_unit setVariable [_x, false, true]} forEach ["BIS_iconAlways", "BIS_iconShow", "BIS_iconName", "BIS_fnc_EXP_m07_handleIFF_active"];
	} forEach _units;
};

// Initialize IFF
if (!(isDedicated)) then {
	waitUntil {
		{
			private _unit = _x;
			{isNil {_unit getVariable _x}} count ["BIS_iconAlways", "BIS_iconShow", "BIS_iconName", "BIS_fnc_EXP_m07_handleIFF_active"] > 0
		} count _units == 0
	};
	
	// Initialize IFF for all friendlies
	[_units] call BIS_fnc_EXP_camp_IFF;
	
	{
		_x spawn {
			scriptName format ["BIS_fnc_EXP_m07_handleIFF: IFF control - %1", _this];
			
			params ["_unit"];
			
			waitUntil {
				// Wait for the unit's IFF to be enabled
				_unit getVariable ["BIS_fnc_EXP_m07_handleIFF_active", false]
				&&
				// And player to be close enough
				{ (vehicle _unit) distance (vehicle player) <= 170 }
			};
			
			// Enable IFF, play sound
			{_unit setVariable [_x, true]} forEach ["BIS_iconShow", "BIS_iconName", "BIS_iconAlways"];
			playSound "ReadoutHideClick2";
			
			if (!(_unit in [BIS_ai_1, BIS_miller])) then {
				// Wait 2 seconds
				sleep 2;
				
				// Remove permanent name
				_unit setVariable ["BIS_iconAlways", false];
			};
		};
	} forEach _units;
};