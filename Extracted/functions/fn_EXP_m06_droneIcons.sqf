waitUntil {!(isNil "BIS_drones")};

BIS_droneIcon = "a3\ui_f\data\igui\cfg\cursors\lock_target_ca.paa";
BIS_droneFakeTexture = [1,1,1,0] call BIS_fnc_colorRGBAtoTexture;
BIS_droneColorInactive = [1,1,1,0.5];
BIS_droneColorActive = [0,125,255,0.5];

// Handle 3D icons
addMissionEventHandler [
	"Draw3D",
	{
		// Drones must be revealed first
		if (!(missionNamespace getVariable ["BIS_dronesRevealed", false])) exitWith {};
		
		{
			private _drone = _x;
			
			// Don't show if the drone is dead or the player is controlling it
			if (alive _drone && { cameraOn != _drone }) then {
				// Grab drone's position
				private _pos = getPosATLVisual _drone;
				
				// Determine altitude offset
				private _offset = 1;
				
				if (!(_drone isKindOf "Car") && { !(_drone isKindOf "Air") }) then {
					// Either an air drone or turret
					// Grab classname
					private _class = typeOf _drone;
					_class = toUpper _class;
					
					if (_class in ["O_UAV_01_F", "O_UAV_02_F"]) then {
						// Air drone
						switch (_class) do {
							case "O_UAV_01_F": {
								// Quadrotor
								_offset = 0.2;
							};
							
							case "O_UAV_02_F": {
								// Fixed wing
								_offset = 0;
							};
						};
					} else {
						// Turret
						switch (_class) do {
							case "O_HMG_01_A_F": {
								// MG turret
								_pos = [_drone, 0.3, direction _drone] call BIS_fnc_relPos;
								_offset = 0.35;
							};
							
							case "O_GMG_01_A_F": {
								// GMG turret
								_pos = [_drone, 0.4, direction _drone] call BIS_fnc_relPos;
								_offset = 0.3;
							};
						};
					};
				};
				
				// Adjust position
				_pos set [2, ((getPosATLVisual _drone) select 2) + _offset];
				
				private _color = BIS_droneColorInactive;
				if (_drone getVariable ["BIS_droneActive", false]) then {_color = BIS_droneColorActive};
				
				// Draw icon
				drawIcon3D [
					BIS_droneIcon,
					_color,
					_pos,
					1,
					1,
					0
				];
				
				if (_drone getVariable ["BIS_droneActive", false]) then {
					// Drone activated
					private _pilot = (UAVControl _drone) select 0;
					
					if (!(isNull _pilot)) then {
						// Someone is controlling the drone
						// Draw name
						drawIcon3D [
							BIS_droneFakeTexture,
							_color,
							_pos,
							1,
							-1.8,
							0,
							name _pilot,
							0,
							0.025
						];
						
						if (!(isNull player) && { _pilot == player }) then {
							// Player is controlling the drone
							private _arrowColor = +_color;
							_arrowColor set [3,1];
							
							// Draw arrow if icon goes out of the screen
							drawIcon3D [
								BIS_droneFakeTexture,
								_arrowColor,
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
					};
				} else {
					// Drone inactive
					// Determine distance
					private _dist = vehicle cameraOn distance _drone;
					_dist = round _dist;
					
					if (_dist >= 1000) then {
						// Drone is a kilometer or more away from player
						_dist = _dist / 1000;
						_dist = [_dist, 1] call BIS_fnc_cutDecimals;
						_dist = (str _dist) + " km";
					} else {
						// Drone is under a kilometer from player
						_dist = (str _dist) + " m";
					};
					
					// Draw distance
					drawIcon3D [
						BIS_droneFakeTexture,
						_color,
						_pos,
						1,
						-1.8,
						0,
						_dist,
						0,
						0.025
					];
				};
			};
		} forEach BIS_drones;
	}
];

// Handle map markers
{
	_x spawn {
		scriptName format ["BIS_fnc_EXP_m06_droneIcons: marker control - %1", _this];
		
		private _drone = _this;
		
		waitUntil {
			// Drone was destroyed
			!(alive _drone)
			||
			// Drones were revealed
			{ missionNamespace getVariable ["BIS_dronesRevealed", false] }
		};
		
		if (alive _drone) then {
			// Create marker
			private _marker = (str _drone) + "_marker";
			createMarkerLocal [_marker, position _drone];
			_marker setMarkerTypeLocal "b_uav";
			_marker setMarkerSizeLocal [0.5,0.5];
			_marker setMarkerColorLocal "ColorWhite";
			
			// Control color
			[_drone, _marker] spawn {
				scriptName format ["BIS_fnc_EXP_m06_droneIcons: marker color control - %1", _this];
				
				params ["_drone", "_marker"];
				
				waitUntil {
					// Drone was destroyed
					!(alive _drone)
					||
					// Drone was activated
					{ _drone getVariable ["BIS_droneActive", false] }
				};
				
				if (alive _drone) then {
					// Switch marker color
					_marker setMarkerColorLocal "ColorBLUFOR";
				};
			};
			
			// Control position
			while {alive _drone} do {
				sleep 0.1;
				_marker setMarkerPosLocal (position _drone);
			};
			
			// Delete marker when drone is destroyed
			deleteMarkerLocal _marker;
		};
	};
} forEach BIS_drones;

true