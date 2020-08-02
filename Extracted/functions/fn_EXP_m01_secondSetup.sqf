// Unhide the units
["BIS_hidden1", 1] call BIS_fnc_EXP_m01_hideUnits;

// Set up captured cop
BIS_cop1 playMove "Acts_AidlPsitMstpSsurWnonDnon03";

// Turn on vehicle's flashers
BIS_cop1 action ["LightOn", BIS_copTruck1];
BIS_copTruck1 animate ["BeaconsStart", 1];

// Damage the vehicle
BIS_copTruck1 setDamage 0.7;
BIS_copTruck1 setHitPointDamage ["HitLFWheel", 1];
{BIS_copTruck1 setHitPointDamage [_x, 0]} forEach ["HitLF2Wheel", "HitRFWheel", "HitRF2Wheel"];

// Force flashlights for patrols
{_x call BIS_fnc_EXP_m01_forceFlashlights} forEach (units BIS_patrolGroup1 + units BIS_patrolGroup2);

// Handle the second location
{[_x, BIS_secondDefend, "BIS_secondAlerted"] spawn BIS_fnc_EXP_m01_defend} forEach (BIS_secondUnits + BIS_reinfUnits + units BIS_patrolGroup1);

// Handle the QRF
[BIS_QRFGroup1, BIS_QRFTruck1, "BIS_QRFDest1"] call BIS_fnc_EXP_m01_handleQRF;
[BIS_QRFGroup2, BIS_QRFTruck2, "BIS_QRFDest2"] call BIS_fnc_EXP_m01_handleQRF;

// Handle the tower
{[_x, "BIS_towerDefend", "BIS_towerAlerted"] spawn BIS_fnc_EXP_m01_defend} forEach BIS_towerUnits;
[] call BIS_fnc_EXP_m01_handleTower;

// Let players spot the paramilitaries
BIS_spotParas = true;
publicVariable "BIS_spotParas";

true