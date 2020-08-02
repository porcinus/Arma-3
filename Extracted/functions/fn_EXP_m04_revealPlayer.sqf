params ["_player"];

waitUntil {
	// Player disconnected
	isNull _player
	||
	// Shots are being tracked
	missionNamespace getVariable ["BIS_trackShots", false]
};

if (!(isNull _player)) then {
	// Track number of shots
	_player setVariable ["BIS_fnc_EXP_m04_revealPlayer_shots", 0];
	
	// Add event handler to player
	private _firedEH = _player addEventHandler [
		"Fired",
		{
			params ["_player", "_weapon"];
			
			if (_weapon in [primaryWeapon _player, handgunWeapon _player, secondaryWeapon _player]) then {
				// Grab number of shots the system has registered the player as firing
				private _shots = _player getVariable "BIS_fnc_EXP_m04_revealPlayer_shots";
				
				if (_shots < 2) then {
					// Increase shot count
					_player setVariable ["BIS_fnc_EXP_m04_revealPlayer_shots", _shots + 1];
				} else {
					// Reveal units to all attackers
					{_x reveal [_player, 4]} forEach BIS_SF;
					
					// Destroy previous script if necessary
					private _script = _player getVariable "BIS_fnc_EXP_m04_revealPlayer_script";
					if (!(isNil {_script})) then {terminate _script};
					
					// Create countdown script
					_script = _player spawn {
						scriptName format ["BIS_fnc_EXP_m04_revealPlayer: shot cooldown - %1", _this];
						
						// Cool down
						sleep 4;
						
						// Reset shot count
						_this setVariable ["BIS_fnc_EXP_m04_revealPlayer_shots", 0];
					};
					
					// Store script
					_player setVariable ["BIS_fnc_EXP_m04_revealPlayer_script", _script];
				};
			};
		}
	];
	
	waitUntil {
		// Player disconnected
		isNull _player
		||
		// Shots aren't being tracked
		!(BIS_trackShots)
	};
	
	// Remove event handler
	_player removeEventHandler ["Fired", _firedEH];
};

true