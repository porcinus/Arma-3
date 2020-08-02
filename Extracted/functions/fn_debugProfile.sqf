/*
	Author: Julien `Tom_48_97` VIDA

	Description:
	Function to purge user profile from unwanted data.
	Support for only BIS_fnc_diagAAR_data.

	Parameter(s):
	None

	Returns:
	None
*/
private ["_saveNeeded"];
_saveNeeded = false;
if (count (profilenamespace getvariable ["BIS_fnc_diagAAR_data",[]]) > 0) then
{
	// Don't run if a diagAAR is running
	// Todo: Just show the warning if a diagAAR is recording
	if (getnumber (missionconfigfile >> "diagAAR") > 0) exitWith {};

	private ["_countEntries", "_showDialog"];
	_countEntries = 0;
	_showDialog = false;

	// Count the elements in BIS_fnc_diagAAR_data
	{
		if (typeName _x == "ARRAY") then
		{
			_top = _x;
			// This is where the mess is:
			{
				_countEntries = _countEntries + count _x;
				// More than 7500 elements is too much (~10MB)
				if (_countEntries > 7500) exitWith {_showDialog = true;};
			} forEach _top;
		};
	} forEach (profilenamespace getvariable ["BIS_fnc_diagAAR_data",[]]);

	// BIS_fnc_diagAAR_data is too big, make decision
	if (_showDialog) then
	{
		private ["_dialogResult"];
		diag_log format["The profile has more than %1 entries.", _countEntries];
		_dialogResult = false;
		_dialogResult = ["Your profile contains a huge variable 'BIS_fnc_diagAAR_data'; large profile data can cause menu freezes. Do you want to clear this variable?", "Performance warning", "Yes", "No"] call bis_fnc_GUImessage;

		// Take action!
		if (_dialogResult) then
		{
			profileNamespace setVariable ["BIS_fnc_diagAAR_data", nil];
			_saveNeeded = true;
			diag_log "BIS_fnc_diagAAR_data dropped";
		};
	};
};

// Save only if needed
if (_saveNeeded) then
{
	saveprofilenamespace;
};