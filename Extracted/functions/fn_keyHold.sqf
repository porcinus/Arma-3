/*
	Author: Thomas Ryan

	Description:
	Allow for hold button interactions.

	Parameters:
		_this select 0 (Optional): STRING - Description of the performed action, displayed inside the progress bar.
		_this select 1 (Optional): NUMBER - Duration of the action. (Default: 2 seconds)
		_this select 2 (Optional): STRING or CODE - Condition that must be met for the action to display.
		_this select 3 (Optional): ARRAY - Arguments passed to the code executed.

	Returns:
	True if the action was successful, false if it was interrupted.
*/

#include "\a3\ui_f\hpp\defineresincldesign.inc"
#include "\a3\ui_f\hpp\definecommongrids.inc"

private ["_action", "_duration", "_condition", "_arg"];
_action = _this param [0, "", [""]];
_duration = _this param [1, 2, [2]];
_condition = _this param [2, {true}, [{}, ""]];
_arg = _this param [3, [], [[]]];
if (typeName _condition == typeName "") then {_condition = compile _condition};

private ["_loaded"];
_loaded = _this param [4, false, [false]];

if (isNil "BIS_keyHold_initialized" || _loaded) then {
	BIS_keyHold_initialized = false;

	// Handle loading
	if (!(_loaded)) then {addMissionEventHandler ["Loaded", {[nil,nil,nil,nil,true] call BIS_fnc_keyHold}]};

	// Global control variables
	if (isNil "BIS_keyHold_allowed") then {BIS_keyHold_allowed = false};
	if (isNil "BIS_keyHold_prompt") then {BIS_keyHold_prompt = false};
	BIS_keyHold_pressed = false;
	BIS_keyHold_active = false;
	BIS_keyHold_percent = 0;
	BIS_keyHold_action = "";
	BIS_keyHold_running = false;

	// Key control
	[] spawn {
		disableSerialization;

		scriptName "BIS_fnc_keyHold: key control";

		waitUntil {!(isNull ([] call BIS_fnc_displayMission))};

		// Grab mission display
		private ["_display"];
		_display = [] call BIS_fnc_displayMission;

		if (!(isNil {uiNamespace getVariable "BIS_keyHold_keyDownEH"})) then {
			// Remove existing KeyDown eventhandler
			_display displayRemoveEventHandler ["KeyDown", uiNamespace getVariable "BIS_keyHold_keyDownEH"];
			uiNamespace setVariable ["BIS_keyHold_keyDownEH", nil];
		};

		// Add KeyDown eventhandler
		private ["_keyDownEH"];
		_keyDownEH = _display displayAddEventHandler [
			"KeyDown",
			{
				private ["_key"];
				_key = _this select 1;

				if (_key == 57) then {
					if (!(BIS_keyHold_pressed)) then {
						// Register that Space is pressed
						BIS_keyHold_pressed = true;

						if (!(BIS_keyHold_active) && BIS_keyHold_allowed) then {
							// Activate interaction
							BIS_keyHold_active = true;
							true
						};
					};
				};
			}
		];

		// Store KeyDown eventhandler
		uiNamespace setVariable ["BIS_keyHold_keyDownEH", _keyDownEH];

		if (!(isNil {uiNamespace getVariable "BIS_keyHold_keyUpEH"})) then {
			// Remove existing KeyUp eventhandler
			_display displayRemoveEventHandler ["KeyUp", uiNamespace getVariable "BIS_keyHold_keyUpEH"];
			uiNamespace setVariable ["BIS_keyHold_keyUpEH", nil];
		};

		// Add KeyUp eventhandler
		private ["_keyUpEH"];
		_keyUpEH = _display displayAddEventHandler [
			"KeyUp",
			{
				private ["_key"];
				_key = _this select 1;

				if (_key == 57) then {
					// Register that Space was released
					BIS_keyHold_pressed = false;
					BIS_keyHold_active = false;
				};
			}
		];

		// Store KeyDown eventhandler
		uiNamespace setVariable ["BIS_keyHold_keyUpEH", _keyUpEH];
	};

	// UI control
	[] spawn {
		disableSerialization;

		scriptName "BIS_fnc_keyHold: UI control";

		// Create display
		private ["_layer"];
		_layer = "BIS_keyHold_layer" call BIS_fnc_rscLayer;
		_layer cutRsc ["RscRevive", "PLAIN"];
		waitUntil {!(isNull (uiNamespace getVariable ["BIS_revive_progress_display", displayNull]))};

		// Grab mission display
		private ["_display"];
		_display = uiNamespace getVariable "BIS_revive_progress_display";

		// Grab necessary controls
		private ["_promptBG", "_promptKey", "_promptKeyBG", "_actionText", "_progress", "_progressKey", "_obsolete1", "_obsolete2"];
		_promptBG = _display displayCtrl IDC_RSCREVIVE_REVIVEPROGRESSBACKGROUND;
		_promptKey = _display displayCtrl IDC_RSCREVIVE_REVIVEKEY;
		_promptKeyBG = _display displayCtrl IDC_RSCREVIVE_REVIVEKEYBACKGROUND;
		_actionText = _display displayCtrl IDC_RSCREVIVE_REVIVETEXT;
		_progress = _display displayCtrl IDC_RSCREVIVE_REVIVEPROGRESS;
		_progressKey = _display displayCtrl IDC_RSCREVIVE_REVIVEKEYPROGRESS;
		_obsolete1 = _display displayCtrl IDC_RSCREVIVE_REVIVEDEATH;
		_obsolete2 = _display displayCtrl IDC_RSCREVIVE_REVIVEMEDIKIT;

		// Hide everything
		{
			_x ctrlSetFade 1;
			_x ctrlCommit 0;
		} forEach [_promptBG, _promptKey, _promptKeyBG, _actionText, _progress, _progressKey, _obsolete1, _obsolete2];

		// Grab UI highlight color
		private ["_color", "_colorHTML"];
		_color = ["GUI", "BCG_RGB"] call BIS_fnc_displayColorGet;
		_color set [3,1];
		_colorHTML = _color call BIS_fnc_colorRGBAtoHTML;

		// Set up prompt
		private ["_string", "_parsed"];
		_string = format ["<t align = 'center' color = '%1'>%2</t>", _colorHTML, toUpper localize "str_dik_space"];
		_parsed = parseText _string;
		_promptKey ctrlSetStructuredText _parsed;
		_promptBG ctrlSetBackgroundColor [0,0,0,0.5];

		private ["_posBackgroundMax", "_posBackgroundMin"];
		_promptBGMax = ctrlPosition _promptBG;
		_promptBGMin = ctrlPosition _promptKeyBG;
		_promptBG ctrlSetPosition _promptBGMin;

		{_x ctrlCommit 0} forEach [_promptKey, _promptBG];

		// Set up progress bar
		private ["_posProgressMax", "_posProgressMin"];
		_progressMax = ctrlPosition _progress;
		_progressMin = ctrlPosition _progressKey;
		_progress ctrlSetPosition  _progressMin;
		_progress ctrlSetTextColor _color;

		{_x ctrlCommit 0} forEach [_actionText, _progress];

		// Track whether the progress bar is collapsed
		private ["_collapsed"];
		_collapsed = true;

		while {true} do {
			// Wait for interaction to be allowed
			waitUntil {BIS_keyHold_prompt};

			if (!(_collapsed)) then {
				// Collapse progress bar
				_promptBG ctrlSetPosition _promptBGMin;
				_progress ctrlSetPosition _progressMin;

				{
					_x ctrlSetFade 1;
					_x ctrlCommit 0;
				} forEach [_promptKey, _progress, _actionText, _promptBG];

				// Register that it was collapsed
				_collapsed = true;
			};

			// Display key prompt
			{
				_x ctrlSetFade 0;
				_x ctrlCommit 0.2;
			} forEach [_promptKey, _promptBG];

			// Wait for it to be activated
			waitUntil {BIS_keyHold_running || !(BIS_keyHold_prompt)};

			if (BIS_keyHold_prompt) then {
				// Add action text
				private ["_string", "_parsed"];
				_string = format ["<t align = 'center'>%1</t>", BIS_keyHold_action];
				_parsed = parseText _string;
				_actionText ctrlSetStructuredText _parsed;
				_actionText ctrlCommit 0;

				// Expand progress bar
				_promptKey ctrlSetFade 1;
				_actionText ctrlSetFade 0;
				_promptBG ctrlSetPosition _promptBGMax;
				_progress ctrlSetPosition _progressMax;
				_progress ctrlSetFade 0;

				{_x ctrlCommit 0.2} forEach [_promptKey, _actionText, _promptBG, _progress];

				while {BIS_keyHold_running} do {
					// Fill progress bar
					_progress progressSetPosition BIS_keyHold_percent;
					sleep 0.01;
				};

				if (BIS_keyHold_prompt) then {
					// Collapse progress bar
					_promptBG ctrlSetPosition _promptBGMin;
					_progress ctrlSetPosition _progressMin;
					{_x ctrlSetFade 1} forEach [_progress, _actionText];
					_promptKey ctrlSetFade 0;

					{_x ctrlCommit 0.2} forEach [_promptBG, _progress, _actionText, _promptKey];
				};
			};

			if (!(BIS_keyHold_prompt)) then {
				// Fade progress bar
				{
					_x ctrlSetFade 1;
					_x ctrlCommit 0.2;
				} forEach [_promptBG, _progress, _actionText, _promptKey];

				// Register that it was collapsed
				_collapsed = false;
			};
		};
	};

	// Register successful initialization
	BIS_keyHold_initialized = true;
};

// Do not duplicate serialized scripts
if (_loaded) exitWith {};

// Wait for successful initialization
waitUntil {missionNamespace getVariable ["BIS_keyHold_initialized", false]};

// Ensure the condition is met
waitUntil {_arg call _condition && !(BIS_keyHold_allowed)};

// Allow key press
BIS_keyHold_allowed = true;
BIS_keyHold_prompt = true;

// Track completion
private ["_completed", "_success"];
_completed = false;
_success = false;

while {_arg call _condition && !(_completed)} do {
	// Wait for the key to be pressed
	waitUntil {BIS_keyHold_active || !(_arg call _condition)};

	private "_result";
	_result = _arg call _condition;

	if (_result) then {
		// Start action
		BIS_keyHold_action = _action;
		BIS_keyHold_percent = 0;
		BIS_keyHold_running = true;

		// Calculate when it should end
		private ["_timeEnd"];
		_timeEnd = time + _duration;
		
		while {BIS_keyHold_active} do {
			// Calculate where it's at
			private ["_timeLeft"];
			_timeLeft = _timeEnd - time;
			BIS_keyHold_percent = 1 - (_timeLeft / _duration);
			
			_result = _arg call _condition;

			// Exit if completed or interrupted
			if (BIS_keyHold_percent >= 1 || !(_result)) exitWith {};

			sleep 0.01;
		};

		if (BIS_keyHold_percent >= 1) then {
			BIS_keyHold_prompt = false;
			_completed = true;
			if (_result) then {_success = true};
		};
	}
	else
	{
		BIS_keyHold_prompt = false;
		_completed = true;
	};

	// Stop action
	BIS_keyHold_running = false;
};

// Reset variables
BIS_keyHold_action = "";
BIS_keyHold_percent = 0;
BIS_keyHold_active = false;
BIS_keyHold_prompt = false;
BIS_keyHold_allowed = false;

// Return whether it was successful or not
_success