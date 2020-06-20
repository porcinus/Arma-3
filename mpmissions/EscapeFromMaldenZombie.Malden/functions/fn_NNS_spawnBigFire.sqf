/*
NNS
Spawn a big fire on a object position with sound and light source, designed to work locally to offload server usage/network.
Note: some destroyed object have Z origin far bellow ground, set _forcePosition to true in this case.

Dependency: in description.ext:
	class CfgSFX {
		class BigFire01 {sound0[] = {"@A3\Sounds_F\sfx\fire1_loop", 8, 1.0, 250, 1, 0, 0, 0}; sounds[] = {sound0}; empty[] = {"", 0, 0, 0, 0, 0, 0, 0};};
		class BigFire02 {sound0[] = {"@A3\Sounds_F\sfx\fire2_loop", 8, 1.0, 250, 1, 0, 0, 0}; sounds[] = {sound0}; empty[] = {"", 0, 0, 0, 0, 0, 0, 0};};
	};

	class CfgVehicles {
		class BigFireSound01 {sound = "BigFire01";};
		class BigFireSound02 {sound = "BigFire02";};
	};


Example: 
_null = [vehi01] call BIS_fnc_NNS_spawnBigFire;

*/

// Params
params [
	["_object", objNull], //object to use as center
	["_deletionRadius", 1000], //radius to delete fire when player not present
	["_waitDestroyed", false], //wait for object to be destroyed
	["_forcePosition", false] //setPos on fire object
];

// Check for validity
if (isNull _object) exitWith {[format["BIS_fnc_NNS_spawnBigFire : Non-existing object %1 used!",_object]] call BIS_fnc_NNS_debugOutput;};

if (_waitDestroyed) then {waitUntil {sleep 1; !(alive _object)};}; //wait until object destroyed, here because of server-client sync

_pos = getPos _object; //get object position

_startTime = time;
waitUntil {sleep 1; ((player distance2d _pos) < (_deletionRadius * 0.9)) || ((time - _startTime) > 600)}; //wait until one player near enough (90% of deletion distance) or time over 10min
if (((time - _startTime) > 600) && ((player distance2d _pos) > (_deletionRadius * 0.9))) exitWith {["BIS_fnc_NNS_spawnBigFire : Failed : 10 minutes timeout"] call BIS_fnc_NNS_debugOutput;};

_fire = "test_EmptyObjectForFireBig" createVehicleLocal _pos; //create local fire
if (_forcePosition) then {_fire setPos _pos;}; //update position

_light = "#lightpoint" createVehicleLocal _pos; //create local light source
_light setLightIntensity 5000; _light setLightAttenuation [0,0,0,0.2];
_light setLightColor [0.95,0.65,0.4]; _light setLightAmbient [0.15,0.05,0];
_light setLightDayLight true;
_light lightAttachObject [_fire, [0,0,0.5]];

_sound = objNull;
_soundSpawner = false;

if !(_object getVariable ["firesnd",false]) then { //nobody created sound source
	_object setVariable ["firesnd",true,true]; _soundSpawner = true;
	_sound = createSoundSource [format["BigFireSound0%1",ceil (random 2)], [_pos select 0,_pos select 1,0], [], 0]; //create fire sound
};

while {sleep 0.1; !isNull _light} do {
	if (alive player) then {
		_dist = player distance2d _fire; //player distance from object
		
		if (_dist < 4.5) then {player setDamage [(damage player) + 0.1, false];}; //playing with fire
		
		if (_dist < 200) then { //player near enought to see light variation
			_light setLightIntensity (5000 + random 150);
			_light setLightColor [(0.93 + random 0.07),0.65,0.4];
			_light setLightAmbient [(0.13 + random 0.05),0.05,0];
			_light setLightAttenuation [0,0,0,(0.18 + random 0.03)];
		};
		
		if (_dist > _deletionRadius) then { //player too far
			deleteVehicle _fire; deleteVehicle _light; //delete fire and light source
			if (_soundSpawner) then {deleteVehicle _sound;}; //delete fire sound if player created it
		};
	};
};

_object