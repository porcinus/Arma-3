// Spawn explosion
"Bo_GBU12_LGB" createVehicle [13678.9,11256.9,0.0];
sleep 5;

// Destroy backup lights
[2, [3]] call BIS_fnc_portLights;

true