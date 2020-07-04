/*
NNS
Spawn a flare in the sky with light source, designed to work locally to offload server usage/network.

Example: 
_null = [pos] call NNS_fnc_spawnFlare;
*/

// Params
params [
	["_pos", []], //position
	["_altitude", 130], //start altitude
	["_radius", 25] //placement radius
];
if (count _pos < 2) exitWith {["NNS_fnc_spawnFlare : Invalid position"] call NNS_fnc_debugOutput;};

_flarePos = _pos getPos [random _radius, random 360]; //flare position
_flarePos set [2, _altitude]; //set Z position
_flare = "F_40mm_White" createVehicleLocal _flarePos; //spawn flare

_flarelight = "#lightpoint" createVehicleLocal _pos; //create local light source
_flarelight setLightIntensity 3000;
_flarelight setLightAttenuation [0,0,0,0.15];
_flarelight setLightColor [0.95,0.95,1.00];
_flarelight setLightDayLight false;
_flarelight lightAttachObject [_flare, [0,0,0]];

_flare setVelocity [0,0,-0.01]; //pushdown flare
sleep 25; //wait for the flare to die
if (!isNull _flare) then {deleteVehicle _flare}; //delete flare object
if (!isNull _flarelight) then {deleteVehicle _flarelight}; //delete flare object
