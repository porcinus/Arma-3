/*
NNS
Spawn damaged/wreck/untouched vehicle on a road near given position.

Dependency: in initServer.sqf
	BIS_civilCars = ["C_Offroad_01_F","C_SUV_01_F","C_Van_01_transport_F","C_Truck_02_transport_F"];
	BIS_civilWreckCars = ["Land_Wreck_Ural_F","Land_Wreck_Truck_dropside_F","Land_Wreck_Truck_F","Land_Wreck_Van_F","Land_Wreck_Offroad_F","Land_Wreck_Offroad2_F","Land_Wreck_Car_F"];


Example: 
_null = [getPos player] call BIS_fnc_NNS_spawnVehicleOnRoad;

*/

// Params
params [
	["_pos", []], //center of detection point
	["_radius", 25], //radius detection
	["_dirCorrection", 0], //invert road direction
	["_vehiClasses", []], //default vehicles class
	["_vehiToSpawn", 3], //minimum amount to spawn
	["_vehiToSpawnRandom", 4], //random quantity to add
	["_vehiDamageMin", 0.4], //vehicle min damage
	["_vehiDamageMax", 0.8], //vehicle max damage
	["_vehiFuel", 0], //vehicle fuel
	["_addWreckVehi", true], //allow wreck vehicles
	["_vehiWreckClasses", []] //default wreck vehicles class
];

if (count _pos < 3) then {_pos = getPos player;}; //use player position if no position set

_roads = _pos nearRoads _radius; //get near roads
if (count _roads == 0) exitWith {[format["BIS_fnc_NNS_spawnVehicleOnRoad : no road found around %1, radius:%2",_pos,_radius]] call BIS_fnc_NNS_debugOutput;};

if (count _vehiClasses == 0) then {_vehiClasses = BIS_civilCars;}; //default vehicles classes
if (_addWreckVehi && {count _vehiWreckClasses == 0}) then {_vehiWreckClasses = BIS_civilWreckCars;}; //default wreck vehicles classes
if (_addWreckVehi) then {_vehiClasses append _vehiWreckClasses}; //merge wreck classes to vehicle classes

_road = selectRandom _roads; //select a random road
_connectedRoads = roadsConnectedTo _road; //find connected road, used for road direction

_randomVehiCount = _vehiToSpawn + round(random _vehiToSpawnRandom); //amount of vehicle to spawn
_lastVehiLength = 0; //backup current vehicle length for next loop
_lastLane = 1; _consecutiveSameLane = 0; //used to shift lane
_currentDist = 0; //distance from road center
_roadDir = (_road getDir (_connectedRoads select 0)) + _dirCorrection; //road direction
_tmpVehiClass = selectRandom _vehiClasses; //used to avoid 2 time the same vehicle following each other
_tmpVehiClasses = []; //store vehicle classes without last one used

for "_i" from 1 to _randomVehiCount do { //vehicle loop
	_isWreck = false;
	_tmpVehiClasses = _vehiClasses - [_tmpVehiClass]; //vehicle classes without last one used
	if (count _tmpVehiClasses == 0) then {_tmpVehiClasses = _vehiClasses;}; //only one vehicle in main vehicle classes array
	
	_tmpVehiClass = selectRandom _tmpVehiClasses; //select a random vehicle
	if (_tmpVehiClass in _vehiWreckClasses) then {_isWreck = true;};
	
	_tmpVehi = _tmpVehiClass createVehicle [0,0,0]; //create vehicle
	_tmpVehibox = boundingBoxReal _tmpVehi; _tmpVehiLength = abs (((_tmpVehibox select 1) select 1) - ((_tmpVehibox select 0) select 1)); //vehicle length
	_tmpDirCorr = 0;
	if (_isWreck) then {_tmpVehiLength = _tmpVehiLength * 1.2; _tmpDirCorr = 180;}; //wreck vehicles size is a bit off and direction reversed
	
	_tmpLane = selectRandom [-1,1]; //select a lane
	if (_consecutiveSameLane == 3 && {_tmpLane == _lastLane}) then {_tmpLane = _tmpLane * -1;}; //rnd is a bitch, force other lane
	
	_tmpVehiDist = (_lastVehiLength / 2) + (_tmpVehiLength / 2);
	
	if (_tmpLane != _lastLane) then { //lane has change
		_tmpVehiLength = _tmpVehiLength * (0.4 + random 0.4); //new vehicle length
		_lastLane = _tmpLane; //backup last lane
		_consecutiveSameLane = 0; //reset consecutive lane
	} else {
		_tmpVehiLength = _tmpVehiLength * (1.1 + random 0.2); //new vehicle length
		_consecutiveSameLane = _consecutiveSameLane + 1; //update consecutive lane
	};
	
	_currentDist = _currentDist + _tmpVehiDist;//(_lastVehiLength / 2) + (_tmpVehiLength / 2); //distance from road center
	_lastVehiLength = _tmpVehiLength; //backup current vehicle length for next loop
	
	_tmpPos = _road getPos [2, _roadDir + (90 * _tmpLane)]; //"select" random lane
	
	_tmpNewPos = _tmpPos getPos [_currentdist, _roadDir + 180];
	_tmpVehi setDir ((_roadDir - 45) + (random 45) + (random 45) + _tmpDirCorr); //vehicle direction, more randomness
	_tmpVehi setPos _tmpNewPos; //vehicle position
	
	if (_isWreck) then {
		_tmpVehi enableSimulationGlobal false;
	} else {
		_tmpVehi setFuel _vehiFuel;
		[_tmpVehi,[],_vehiDamageMin,_vehiDamageMax] call BIS_fnc_NNS_randomVehicleDamage;
		clearMagazineCargoGlobal _tmpVehi; clearWeaponCargoGlobal _tmpVehi; clearBackpackCargoGlobal _tmpVehi; clearItemCargoGlobal _tmpVehi;
	};
};
