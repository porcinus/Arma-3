params ["_radio"];

if (isServer) then {
	private _tracks = [1,2];
	
	// Select a random track
	private _track = _tracks call BIS_fnc_selectRandom;
	_tracks = _tracks - [_track];
	_radio setVariable ["BIS_fnc_EXP_m01_radioMusic_tracks", _tracks];
	
	// Set as the current track
	_radio setVariable ["BIS_fnc_EXP_m01_radioMusic_track", _track, true];
	
	// Create logic to play the music on
	private _group = createGroup sideLogic;
	BIS_fnc_EXP_m01_radioMusic_logic = _group createUnit ["Logic", [10,10,10], [], 0, "NONE"];
	BIS_fnc_EXP_m01_radioMusic_logic attachTo [_radio, [0,0,0]];
	
	// Broadcast everywhere
	publicVariable "BIS_fnc_EXP_m01_radioMusic_logic";
	
	// Register state
	_radio setVariable ["BIS_fnc_EXP_m01_radioMusic_destroyed", false, true];
};

// Wait for info to sync
private ["_destroyed", "_track"];
waitUntil {
	_destroyed = _radio getVariable "BIS_fnc_EXP_m01_radioMusic_destroyed";
	_track = _radio getVariable "BIS_fnc_EXP_m01_radioMusic_track";
	{isNil _x} count ["_destroyed", "_track"] == 0
};

if (!(_destroyed)) then {
	// Wait for the logic to sync
	waitUntil {
		_destroyed = _radio getVariable "BIS_fnc_EXP_m01_radioMusic_destroyed";
		_track = _radio getVariable "BIS_fnc_EXP_m01_radioMusic_track";
		_destroyed || !(isNil "BIS_fnc_EXP_m01_radioMusic_logic")
	};
	
	if (!(_destroyed)) then {
		// Compose track name, play
		_track = "radio_track_0" + (str _track);
		BIS_fnc_EXP_m01_radioMusic_logic say3D _track;
		
		if (isServer) then {
			waitUntil {!(isNil {_radio getVariable "BIS_fnc_EXP_m01_destroyElectronics_destroyed"})};
			
			while {!(_radio getVariable "BIS_fnc_EXP_m01_destroyElectronics_destroyed")} do {
				// Find duration
				private _duration = (getNumber (configFile >> "CfgSounds" >> _track >> "duration") + (3 + random 7));
				private _time = time + _duration;
				
				waitUntil {
					_destroyed = _radio getVariable "BIS_fnc_EXP_m01_destroyElectronics_destroyed";
					_destroyed || time >= _time
				};
				
				if (_destroyed) then {
					// Register destruction, delete logic
					_radio setVariable ["BIS_fnc_EXP_m01_radioMusic_destroyed", true, true];
					deleteVehicle BIS_fnc_EXP_m01_radioMusic_logic;
				} else {
					// Grab remaining tracks
					private _tracks = _radio getVariable "BIS_fnc_EXP_m01_radioMusic_tracks";
					if (count _tracks == 0) then {_tracks = [1,2]};
					
					// Select a track at random
					_track = _tracks call BIS_fnc_selectRandom;
					_tracks = _tracks - [_track];
					_radio setVariable ["BIS_fnc_EXP_m01_radioMusic_tracks", _tracks];
					
					// Set as the current track
					_radio setVariable ["BIS_fnc_EXP_m01_radioMusic_track", _track, true];
					
					// Compose track, play
					_track = "radio_track_0" + (str _track);
					[[_track, BIS_fnc_EXP_m01_radioMusic_logic], "BIS_fnc_EXP_m01_playSound"] call BIS_fnc_MP;
				};
			};
		};
	};
};

true