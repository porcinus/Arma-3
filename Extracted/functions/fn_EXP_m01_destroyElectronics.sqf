params [
	["_object", objNull, [objNull]],
	["_shots", 1, [0]],
	["_destroyed", false, [false]]
];

if (!(_destroyed)) then {
	if (isServer) then {
		// Register state
		_object setVariable ["BIS_fnc_EXP_m01_destroyElectronics_destroyed", false];
	};
	
	if (!(isDedicated)) then {
		waitUntil {time > 0};
		
		// Set how many shots it requires
		_object setVariable ["BIS_fnc_EXP_m01_destroyElectronics_shots", _shots];
		
		// Detect when the object is destroyed
		private _hitEH = _object addEventHandler [
			"HitPart",
			{
				private _data = _this select 0;
				private _object = _data select 0;
				private _source = _data select 1;
				
				if (isPlayer _source) then {
					// Increase hit count
					private _hits = _object getVariable ["BIS_fnc_EXP_m01_destroyElectronics_hits", 0];
					_hits = _hits + 1;
					_object setVariable ["BIS_fnc_EXP_m01_destroyElectronics_hits", _hits];
					
					if (_hits >= _object getVariable "BIS_fnc_EXP_m01_destroyElectronics_shots") then {
						// Remove event handler
						_object removeEventHandler ["HitPart", _object getVariable "BIS_fnc_EXP_m01_destroyElectronics_hitEH"];
						_object setVariable ["BIS_fnc_EXP_m01_destroyElectronics_hitEH", nil];
						
						// Handle destruction
						[[_object, nil, true], "BIS_fnc_EXP_m01_destroyElectronics", false] call BIS_fnc_MP;
					};
				};
			}
		];
		
		// Store event handler
		_object setVariable ["BIS_fnc_EXP_m01_destroyElectronics_hitEH", _hitEH];
	};
} else {
	if (!(_object getVariable "BIS_fnc_EXP_m01_destroyElectronics_destroyed")) then {
		// Register object as destroyed
		_object setVariable ["BIS_fnc_EXP_m01_destroyElectronics_destroyed", true];
		
		private _type = typeOf _object;
		_type = toUpper _type;
		
		switch (_type) do {
			case "LAND_PCSET_01_SCREEN_F": {
				// Monitor
				// Swap texture
				_object setObjectTextureGlobal [0, "a3\missions_f_exp\data\img\exp_m01_monitor_ca.paa"];
			};
			
			case "LAND_FMRADIO_F": {
				// Radio
				// Create effect holders
				private _sparksEffect = createVehicle ["#particlesource", position _object, [], 0, "NONE"];
				private _sparksSound = createSoundSource ["Sound_SparklesWreck1", position _object, [], 0];
				private _smokeEffect = createVehicle ["#particlesource", position _object, [], 0, "NONE"];
				private _smokeSound = createSoundSource ["Sound_SmokeWreck1", position _object, [], 0];
				
				// Attach everything to the radio
				{_x attachTo [_object, [0,0,0]]} forEach [_sparksEffect, _sparksSound, _smokeEffect, _smokeSound];
				
				// Play particle effects
				_sparksEffect setParticleClass "AvionicsSparks";
				_smokeEffect setParticleClass "AvionicsSmoke";
				
				sleep 0.25;
				
				// Delete sparks
				deleteVehicle _sparksEffect;
				
				sleep 1.25;
				
				// Delete sound
				deleteVehicle _sparksSound;
			};
			
			case "LAND_CAMPING_LIGHT_F": {
				// Lantern
				// Create new, off light
				private _new = createVehicle ["Land_Camping_Light_off_F", [10,10,10], [], 0, "NONE"];
				_new attachTo [_object, [0,0,0]];
				
				// Hide original lamp
				_object hideObjectGlobal true;
			};
			
			case "LAND_PCSET_01_CASE_F": {
				// Desktop case
				// Create effect holders
				private _sparksEffect = createVehicle ["#particlesource", position _object, [], 0, "NONE"];
				private _sparksSound = createSoundSource ["Sound_SparklesWreck2", position _object, [], 0];
				private _smokeEffect = createVehicle ["#particlesource", position _object, [], 0, "NONE"];
				private _smokeSound = createSoundSource ["Sound_SmokeWreck1", position _object, [], 0];
				
				// Attach everything to the case
				{_x attachTo [_object, [0,0.2,0.2]]} forEach [_sparksEffect, _sparksSound, _smokeEffect, _smokeSound];
				
				// Play particle effects
				_sparksEffect setParticleClass "AvionicsSparks";
				_smokeEffect setParticleClass "AvionicsSmoke";
				
				sleep 1.5;
				
				// Prevent sparks from looping
				{deleteVehicle _x} forEach [_sparksEffect, _sparksSound];
			};
		};
	};
};

true