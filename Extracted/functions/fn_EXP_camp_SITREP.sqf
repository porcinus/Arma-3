/*
	Author: Thomas Ryan
	
	Description:
	Display situation text, typically used at the start of a mission.
	
	Parameters:
	- Each array you pass represents a line that should be displayed
	- Lines will be displayed in the order you define them
	- Each line's array consists of the following information
		_array select 0: STRING - Contents of the line to be displayed
		_array select 1: NUMBER (Optional) - Fade-in duration
		_array select 2: NUMBER (Optional) - How long it should wait before showing the next line
		_array select 3: NUMBER (Optional) - Fade-out duration (only used by the last line, fades all other lines as well)
	
	Returns:
	True if successful, false if not.
*/

disableSerialization;

private _info = _this;
//if (count _info == 0) then {_info = ["DATE", "TIME"]};

// Store created controls
private _ctrls = [];

{
	// Grab information
	_x params [
		["_text", "", [""]],
		["_fadeIn", 2, [2]],
		["_dur", 1, [1]]
	];
	
	// Create display
	private _layer = ("BIS_fnc_EXP_camp_SITREP_layer" + (str (_forEachIndex + 1))) call BIS_fnc_rscLayer;
	_layer cutRsc ["RscDynamicText", "PLAIN"];
	private _display = displayNull;
	waitUntil {_display = uiNamespace getVariable "BIS_dynamicText"; !(isNull _display)};
	uiNamespace setVariable ["BIS_dynamicText", displayNull];
	
	// Select control
	private _ctrl = _display displayCtrl 9999;
	_ctrls = _ctrls + [_ctrl];
	
	// Position control
	_ctrl ctrlSetPosition [
		-0.025 * safeZoneW + safeZoneX,
		(0.72 + (_forEachIndex * 0.03)) * safeZoneH + safeZoneY,
		safeZoneW,
		safeZoneH
	];
	
	// Commit & hide
	_ctrl ctrlSetFade 1;
	_ctrl ctrlCommit 0;
	
	// Grab current date
	private _date = date;
	_date params ["_year", "_month", "_day", "_hour", "_minute"];
	
	// Handle templates
	/*_text = switch (_text) do {
		// Custom text
		default {_text};
		
		// Squad name
		case "SQUAD": {"CTRG Group 15, 2nd Squad - ""Prowler 2"""};	// ToDo: localize
		
		// Date
		case "DATE": {
			// Compose date in correct format (only English is supported!)
			private _dayYear = (_day call BIS_fnc_ordinalNumber) + ", " + (str _year);
			([] call BIS_fnc_dayName) + ", " + ([] call BIS_fnc_monthName) + " " + _dayYear
		};
		
		// Time
		case "TIME": {
			// Ensure correct formatting (only English is supported!)
			_hour = if (_hour < 10) then {"0" + (str _hour)} else {str _hour};
			_minute = if (_minute < 10) then {"0" + (str _minute)} else {str _minute};
			
			// Compose time
			_hour + ":" + _minute + " Hours"	// ToDo: localize
		};
	};*/
	
	// Compose text, add to control
	private _formatted = "<t align = 'right' size = '0.75' shadow = '0'>" + _text + "</t>";
	private _parsed = parseText _formatted;
	_ctrl ctrlSetStructuredText _parsed;
	
	// Show text
	_ctrl ctrlSetFade 0;
	_ctrl ctrlCommit _fadeIn;
	
	// Wait
	sleep (_fadeIn + _dur);
} forEach _info;

// Grab final fade-out
private _fadeOut = (_info select (count _info - 1)) param [3, 2, [2]];

// Fade out all controls
{
	_x ctrlSetFade 1;
	_x ctrlCommit _fadeOut;
} forEach _ctrls;

true