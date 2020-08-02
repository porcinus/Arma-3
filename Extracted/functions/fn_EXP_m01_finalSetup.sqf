// Unhide the units
["BIS_hidden2", 1] call BIS_fnc_EXP_m01_hideUnits;

{
	// Move into position
	private _marker = (str _x) + "Pos1";
	_x setPos markerPos _marker;
	_x setDir markerDir _marker;
	
	// Unhide
	_x hideObjectGlobal false;
	_x enableSimulationGlobal true;
	
	// Go prone
	_x setUnitPos "DOWN";
} forEach [BIS_supportLead, BIS_support1];

{
	_x setBehaviour "COMBAT";
	_x enableAI "AUTOCOMBAT";
} forEach BIS_supportUnits;

// Make tower guard sit down
BIS_finalPlayers12 playAction "SitDown";

// Show Support Team
["ReadoutHideClick2", "BIS_fnc_EXP_m01_playSound"] call BIS_fnc_MP;
BIS_supportLead setVariable ["BIS_iconAlways", true, true];
{
	private _unit = _x;
	{_unit setVariable [_x, true, true]} forEach ["BIS_iconShow", "BIS_iconName"];
} forEach BIS_supportUnits;

// Defend the location
{[_x, "BIS_playersDefend", "BIS_finalAlerted"] spawn BIS_fnc_EXP_m01_defend} forEach BIS_finalPlayers;
{[_x, "BIS_supportDefend", "BIS_finalAlerted"] spawn BIS_fnc_EXP_m01_defend} forEach BIS_finalSupport;

true