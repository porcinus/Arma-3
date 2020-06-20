/*
NNS
Basicaly destroy map placed objects using rng, place fire based on rng if wanted.
Only classes with "Ruin1" entry in "DestructionEffects" are considered as destructible.
Also allow if wanted to spawn civilian vehicle into non-destroyed garage.

Example: 
_null = [[5000,5000,0]] call BIS_fnc_NNS_destroyZone;
_null = [[5000,5000,0],500] call BIS_fnc_NNS_destroyZone;
*/

// Params
params [
	["_pos", [0,0,0]], //center position
	["_radius", 500], //radius
	["_allowFire", true], //place random fire
	["_fireDeletionRadius", 1000], //radius to delete fire when players not present
	["_carInGarage", true], //allow to create civilian vehicle in non-destoyed garage
	["_carInGarageChance", 0.6], //radius to delete fire when players not present
	["_garageClasses", ["Land_i_Garage_V1_F", "Land_i_Garage_V2_F"]], //garage building class to search for
	["_civCarClasses", ["C_Offroad_01_F","C_SUV_01_F","C_Van_01_transport_F"]] //civilian classes to spawn
];

{
	_tmp = _x; //object pointer
	if (isClass (configfile >> "CfgVehicles" >> (typeOf _tmp) >> "DestructionEffects" >> "Ruin1") && {!(isObjectHidden _x)}) then { //object class contain a ruin class
		_rnd = 0.5 + random 0.7;
		if (_rnd >= 0.95) then {_rnd = 1;}; //force max damage
		if (_rnd == 1) then {
			_x setDamage [1, false]; //destroy building
			if (_allowFire && {random 1 < 0.1}) then { //allow to place a fire
				[_x,_fireDeletionRadius,true] remoteExec ["BIS_fnc_NNS_spawnBigFire",0,true]; //remoteexec fire
			};
		} else {
			if (_carInGarage && {(typeOf _x) in _garageClasses} && {_rnd < 1} && {(random 1) < _carInGarageChance}) then { //car in garage enable and type in garage array and damage < 1
				_veh = (selectRandom _civCarClasses) createVehicle [0,0,0];
				_veh setDir ((getDir _x) + 270);
				_veh setPos (getPos _x);
				_veh setFuel (random 0.05);
				{clearMagazineCargoGlobal _x; clearWeaponCargoGlobal _x; clearBackpackCargoGlobal _x; clearItemCargoGlobal _x} forEach [_veh];
				_veh addItemCargoGlobal ["FirstAidKit",2];
				_veh enableDynamicSimulation true;
				[_veh,["hitfuel"],0.2,0.8] call BIS_fnc_NNS_randomVehicleDamage;
			};
		};
	};
} foreach (_pos nearObjects ["House", _radius]);
