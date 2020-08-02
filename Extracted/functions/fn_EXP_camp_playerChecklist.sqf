/*
	Author: Thomas Ryan

	Description:
	Display a checklist of players that don't meet the given condition, thus preventing mission progress.

	Parameters:
		_this select 0: CODE - General condition that must be met to proceed. Will not list player names.
		_this select 1: CODE - Condition that must be met by each player. Use _player to reference the player unit.
		_this select 2: CODE - Code to be executed when all players meet the defined condition.

	Returns:
	True if successful, false if not.
*/

params [
	["_condGen", {true}, [{}]],
	["_condPlayers", {true}, [{}]],
	["_code", {}, [{}]],
	["_mode", 0, [0]]
];

// Ensure it's only initialized on the server
if (!(isServer) && { _mode == 0 }) exitWith {false};

// Set the default state of the checklist if necessary, wait for it to sync
if (isServer && { isNil {missionNamespace getVariable "#xpca"} }) then {missionNamespace setVariable ["#xpca", false, true]};

if (_mode == 0) then {
	// Checklist activated
	[_condGen, _condPlayers, _code] spawn {
		scriptName "BIS_fnc_EXP_camp_playerChecklist: server control";
		params ["_condGen", "_condPlayers", "_code"];
		
		// Store players that aren't ready
		private _notReady = [];
		
		// Check conditions on each player
		{
			private _player = _x;
			if (!(alive _player) || !(call _condPlayers)) then {_notReady pushBack _player};
		} forEach allPlayers;
		
		if ({alive _x} count allPlayers > 0 && { call _condGen && { {alive _x} count _notReady == 0 } }) then {
			// All conditions were met instantly, execute code
			call _code;
		} else {
			// Give them 2 seconds to ready-up
			private _timeOut = time + 2;
			
			private "_allReady";
			waitUntil {
				// Perform the checks again
				_notReady = [];
				
				{
					private _player = _x;
					if (!(alive _player) || !(call _condPlayers)) then {_notReady pushBack _player};
				} forEach allPlayers;
				
				// Check whether conditions are met
				_allReady = call {{alive _x} count allPlayers > 0 && { call _condGen && { {alive _x} count _notReady == 0 } }};
				
				// Timeout was reached
				time >= _timeOut
				||
				// Or everyone readied-up
				_allReady
			};
			
			if (_allReady) then {
				// Everyone got ready in time, execute code
				call _code;
			} else {
				private _player1 = missionNamespace getVariable ["#xpcp1", objNull];
				private _player2 = missionNamespace getVariable ["#xpcp2", objNull];
				private _player3 = missionNamespace getVariable ["#xpcp3", objNull];
				private _player4 = missionNamespace getVariable ["#xpcp4", objNull];
				
				// Assign initial offenders
				{if (alive _x) then {missionNamespace setVariable [("#xpcp" + (str (_forEachIndex + 1))), _x]}} forEach _notReady;
				
				{
					private _var = "#xpcp" + (str (_forEachIndex  + 1));
					private _new = missionNamespace getVariable [_var, objNull];
					
					// Only broadcast the necessary units
					if (isNull _new && { !(isNull _x) }) then {
						// Reset variable
						missionNamespace setVariable [_var, objNull, true];
					} else {
						// Set to new unit
						if (!(isNull _new) && { _new != _x }) then {missionNamespace setVariable [_var, _new, true]};
					};
				} forEach [_player1, _player2, _player3, _player4];
				
				// Activate the checklist
				missionNamespace setVariable ["#xpca", true, true];
				
				while {missionNamespace getVariable "#xpca"} do {
					// Perform the checks again
					_notReady = [];
					
					{
						private _player = _x;
						if (!(alive _player) || !(call _condPlayers)) then {_notReady pushBack _player};
					} forEach allPlayers;
					
					if ({alive _x} count _notReady == 0 && { call _condGen }) then {
						// Deactivate the checklist, call code
						missionNamespace setVariable ["#xpca", false, true];
						call _code;
					} else {
						// Process again
						// Remove dead units
						private _players = +_notReady;
						{if (!(alive _x)) then {_players = _players - [_x]}} forEach _players;
						
						// Grab current assignments
						private _player1 = missionNamespace getVariable ["#xpcp1", objNull];
						private _player2 = missionNamespace getVariable ["#xpcp2", objNull];
						private _player3 = missionNamespace getVariable ["#xpcp3", objNull];
						private _player4 = missionNamespace getVariable ["#xpcp4", objNull];
						
						// Reset variables, assign initial offenders
						{missionNamespace setVariable [("#xpcp" + (str (_forEachIndex + 1))), objNull]} forEach [0,1,2,3];
						{missionNamespace setVariable [("#xpcp" + (str (_forEachIndex + 1))), _x]} forEach _players;
						
						{
							private _var = "#xpcp" + (str (_forEachIndex  + 1));
							private _new = missionNamespace getVariable [_var, objNull];
							
							// Only broadcast the necessary units
							if (isNull _new && { !(isNull _x) }) then {
								// Reset variable
								missionNamespace setVariable [_var, objNull, true];
							} else {
								// Set to new unit
								if (!(isNull _new) && { _new != _x }) then {missionNamespace setVariable [_var, _new, true]};
							};
						} forEach [_player1, _player2, _player3, _player4];
						
						sleep 0.05;
					};
				};
				
				// Reset the player variables globally
				{missionNamespace setVariable [("#xpcp" + (str (_forEachIndex + 1))), objNull, true]} forEach [0,1,2,3];
			};
		};
	};
};

if (hasInterface && { _mode == 1 }) then {
	// Checklist setup
	private _color = (["GUI", "BCG_RGB"] call BIS_fnc_displayColorGet) call BIS_fnc_colorRGBtoHTML;
	private _icon = "a3\ui_f\data\map\markers\military\warning_ca.paa";
	
	// Compose header text
	private _formatting = format ["<t align = 'right' color = '%1' shadow = '0'>", _color];
	private _image = format ["<img image = '%1'/>", _icon];
	private _text = toUpper localize "STR_A3_ApexProtocol_notification_AO";
	private _header = (_formatting + _image + "  " + _text + "</t><br/>");
	
	while {true} do {
		// Wait for the checklist to be activated
		waitUntil {missionNamespace getVariable ["#xpca", false]};
		
		private _first = true;
		while {missionNamespace getVariable "#xpca"} do {
			// Compose string out of player names
			private _players = "<t align = 'right' shadow = '0'>";
			
			{
				private _player = missionNamespace getVariable [_x, objNull];
				
				if (!(isNull _player)) then {
					// Grab the player's name
					private _name = name _player;
					
					// Add their squad name, if necessary
					private _squad = squadParams _player;
					if (count _squad > 0) then {_name = _name + " [" + ((_squad select 0) select 0) + "]"};
					
					// Add to string
					_players = _players + (_name + "<br/>");
				};
			} forEach ["#xpcp1", "#xpcp2", "#xpcp3", "#xpcp4"];
			
			// Complete the string, combine with header, parse
			_players = _players + "</t>";
			_checklist = _header + _players;
			private _parsed = parseText _checklist;
			
			if (!(_first)) then {
				// Silent hint
				hintSilent _parsed;
			} else {
				// Make a noise
				_first = false;
				hint _parsed;
			};
			
			sleep 0.05;
		};
		
		// Clear the hint
		hintSilent "";
		
		// Clear the player variables locally
		{missionNamespace setVariable [_x, objNull]} forEach ["#xpcp1", "#xpcp2", "#xpcp3", "#xpcp4"];
	};
};

true