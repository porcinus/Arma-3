// Wait for status to sync
waitUntil {!(isNil "BIS_droneLocked")};

if (BIS_droneLocked) then {
	if (isServer) then {
		// Unlock drone when appropriate
		[] spawn {
			scriptName "BIS_fnc_EXP_m06_handleLock: server control";
			
			// Wait for drone to unlock
			waitUntil {!(BIS_droneLocked)};
			
			// Unlock the drone
			BIS_UAV1 lockCameraTo [objNull, [0]];
		};
	};
	
	if (!(isDedicated)) then {
		waitUntil {
			// Someone connected to the drone
			!(BIS_droneLocked)
			||
			{
				// Player is controlling the drone directly
				cameraOn == BIS_UAV1
				&&
				// Player is looking through the turret
				{ cameraView == "GUNNER" }
			}
		};
		
		if (BIS_droneLocked) then {
			// Unlock the drone
			BIS_droneLocked = false;
			publicVariable "BIS_droneLocked";
		};
	};
};

true