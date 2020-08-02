/*
	Author: Thomas Ryan
	
	Description:
	Simple handling of the Support Team's scripted IFF.
	Must be executed locally.
	
	Notes:
	- To always show the icon and name of a unit, use:	<unit> setVariable ["BIS_iconAlways", true]
	- Otherwise, icons can be hidden with: 				<unit> setVariable ["BIS_iconShow", false]
	- And names can be hidden with: 					<unit> setVariable ["BIS_iconName", false]
	
	Parameters:
		_this: ARRAY - Array of Support Team units.
	
	Returns:
	True if successfully initialized, false if not.
*/

params [["_units", [], [[]]]];

if (!(isNil "BIS_fakeTexture")) exitWith {"IFF cannot be initialized more than once." call BIS_fnc_error; false};

// Global icon variables
BIS_fakeTexture = [1,1,1,0] call BIS_fnc_colorRGBAtoTexture;
BIS_iconColor = [0,125,255];
BIS_iconUnits = +_units;

// Icon eventhandler
addMissionEventHandler [
	"Draw3D",
	{
		{
			private _unit = _x;
			private _showAlways = _unit getVariable ["BIS_iconAlways", false];
			private _showIcon = _unit getVariable ["BIS_iconShow", false];
			private _showName = _unit getVariable ["BIS_iconName", false];
			
			// Determine if icon should be shown
			if (_showAlways || { _showIcon }) then {
				if (_showAlways || { vehicle player distance _unit < 300 }) then {
					// Calculate position
					private _pos = _unit selectionPosition "Spine3";
					_pos = _unit modelToWorldVisual _pos;
					
					// Draw hex icon
					drawIcon3D [
						"a3\ui_f\data\igui\cfg\cursors\select_ca.paa",
						BIS_iconColor + [0.15],
						_pos,
						1,
						1,
						0
					];
					
					if (_showAlways) then {
						// Draw arrow if icon goes out of the screen
						drawIcon3D [
							BIS_fakeTexture,
							BIS_iconColor + [0.5],
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
						// Icon is forced
						_showAlways
						||
						{
							// Name is allowed
							_showName
							&&
							// Unit is highlighted
							{ cursorTarget == vehicle _unit }
						}
					) then {
						// Determine name
						private _name = switch (typeOf _unit) do {
							default								{name _unit};
							case "B_CTRG_soldier_M_medic_F"	:	{localize "STR_A3_B_CTRG_soldier_M_medic_F0"};
							case "B_Soldier_TL_F"			:	{localize "STR_A3_ApexProtocol_identity_Riker"};
							case "B_soldier_M_F"			:	{localize "STR_A3_ApexProtocol_identity_Grimm"};
							case "B_soldier_AR_F"			:	{localize "STR_A3_ApexProtocol_identity_Salvo"};
							case "B_soldier_LAT_F"			:	{localize "STR_A3_ApexProtocol_identity_Truck"};
							case "B_Story_SF_Captain_F"		:	{localize "STR_A3_ApexProtocol_identity_Miller"};
						};
						
						// Draw name
						drawIcon3D [
							BIS_fakeTexture,
							BIS_iconColor + [0.5],
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
		} forEach BIS_iconUnits;
	}
];

// Display units
{
	private _unit = _x;
	{if (isNil {_unit getVariable _x}) then {_unit setVariable [_x, true]}} forEach ["BIS_iconShow", "BIS_iconName"];
} forEach BIS_iconUnits;

true