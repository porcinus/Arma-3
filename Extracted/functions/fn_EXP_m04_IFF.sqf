waitUntil {!(isNil "BIS_supportUnits")};

if (isNil "BIS_fakeTexture") then {
	// Global icon variables
	BIS_fakeTexture = [1,1,1,0] call BIS_fnc_colorRGBAtoTexture;
	BIS_iconColor = [0,125,255];

	// Icon eventhandler
	addMissionEventHandler [
		"Draw3D",
		{
			{
				private _unit = _x;

				// Determine if icon should be shown
				if (_unit getVariable ["BIS_iconShow", false]) then {
					if (player in BIS_extractTruck || { _forEachIndex == 0 || { vehicle player distance _unit < 300 } }) then {
						// Calculate position
						private _pos = _unit selectionPosition "Spine3";
						_pos = _unit modelToWorldVisual _pos;

						// Determine alpha
						private _alpha = _unit getVariable ["BIS_iconAlpha", 0];

						// Draw hex icon
						drawIcon3D [
							"a3\ui_f\data\igui\cfg\cursors\select_ca.paa",
							BIS_iconColor + [_alpha],
							_pos,
							1,
							1,
							0
						];

						if (_forEachIndex == 0) then {
							// Draw arrow for leader
							drawIcon3D [
								BIS_fakeTexture,
								BIS_iconColor + [_unit getVariable ["BIS_elseAlpha", 0]],
								_pos,
								1,
								1,
								0,
								"",
								0,
								0.03, "PuristaLight", "center",	// Redundant font params, required to make the arrow work
								true
							];
						};

						if (
							// Name is allowed
							_unit getVariable ["BIS_iconName", false]
							&&
							{
								// In extraction truck
								player in BIS_extractTruck
								||
								{
									// Team Leader
									_forEachIndex == 0
									||
									// Everyone else
									{ cursorTarget == vehicle _unit }
								}
							}
						) then {
							// Determine name
							private _name = switch (_forEachIndex) do {
								case 0: {localize "STR_A3_ApexProtocol_identity_Riker"};
								case 1: {localize "STR_A3_ApexProtocol_identity_Grimm"};
								case 2: {localize "STR_A3_ApexProtocol_identity_Salvo"};
								case 3: {localize "STR_A3_ApexProtocol_identity_Truck"};
							};

							// Draw name
							drawIcon3D [
								BIS_fakeTexture,
								BIS_iconColor + [_unit getVariable ["BIS_elseAlpha", 0]],
								_pos,
								1,
								-1.8,
								0,
								_name,
								0,
								0.025
							];
						};
					};
				};
			} forEach BIS_supportUnits;
		}
	];
};

// Wait for Support Team status to sync
waitUntil {!(isNil "BIS_supportMoved")};

if (!(BIS_supportMoved)) then {
	// Display Support Team
	{
		private _unit = _x;
		{_unit setVariable [_x, true]} forEach ["BIS_iconShow", "BIS_iconName"];
		_unit setVariable ["BIS_iconAlpha", 0.15];
		_unit setVariable ["BIS_elseAlpha", 0.5];
	} forEach BIS_supportUnits;

	// Wait for them to be moved
	waitUntil {BIS_supportMoved};
};

private _fadeIcons = {
	scriptName format ["BIS_fnc_EXP_m04_IFF: _fadeIcons - %1", _this];

	params ["_units", "_max", "_min"];

	if (typeName _units == typeName objNull) then {_units = [_units]};
	private _range = _max - _min;
	private _dist = vehicle player distance BIS_extractTruck;

	while {true} do {
		if (_dist > _max) then {
			// Hide units
			{
				private _unit = _x;
				{_unit setVariable [_x, false]} forEach ["BIS_iconShow", "BIS_iconName"];
				{_unit setVariable [_x, 0]} forEach ["BIS_iconAlpha", "BIS_elseAlpha"];
			} forEach _units;

			// Wait for player to get close
			waitUntil {vehicle player distance BIS_extractTruck <= _max};
		};

		// Show units
		{
			private _unit = _x;
			{_unit setVariable [_x, true]} forEach ["BIS_iconShow", "BIS_iconName"];
		} forEach _units;

		while {_dist = vehicle player distance BIS_extractTruck; _dist <= _max} do {
			private _diff = _dist - _min;
			private ["_alphaIcon", "_alphaElse"];

			if (_diff <= 0) then {
				// Full visibility
				_alphaIcon = 0.15;
				_alphaElse = 0.5;
			} else {
				// Visibility relative to distance
				private _ratio = 1 - (_diff / _range);
				_alphaIcon = 0.15 * _ratio;
				_alphaElse = 0.5 * _ratio;
			};

			// Set alpha correctly
			{
				_x setVariable ["BIS_iconAlpha", _alphaIcon];
				_x setVariable ["BIS_elseAlpha", _alphaElse];
			} forEach _units;

			sleep 0.01;
		};
	};
};

// Show Support Lead first
[BIS_supportLead, 80, 60] spawn _fadeIcons;

// Show rest afterwards
private _units = BIS_supportUnits - [BIS_supportLead];
[_units, 40, 30] spawn _fadeIcons;

true