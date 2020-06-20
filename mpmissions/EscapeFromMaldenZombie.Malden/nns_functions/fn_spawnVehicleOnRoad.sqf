/*
NNS
Spawn damaged/wreck/untouched vehicle on a road near given position.
Note: this function try to follow road "curves" as best as possible.

Dependency: in initServer.sqf
	BIS_civilCars = ["C_Offroad_01_F","C_SUV_01_F","C_Van_01_transport_F","C_Truck_02_transport_F"];
	BIS_civilWreckCars = ["Land_Wreck_Ural_F","Land_Wreck_Truck_dropside_F","Land_Wreck_Truck_F","Land_Wreck_Van_F","Land_Wreck_Offroad_F","Land_Wreck_Offroad2_F","Land_Wreck_Car_F"];


Example: 
_null = [getPos player] call NNS_fnc_spawnVehicleOnRoad;

*/

// Params
params [
	["_pos", []], //center of detection point
	["_radius", 25], //radius detection
	["_reverseDirection", false], //invert road direction
	["_vehiClasses", []], //default vehicles class
	["_vehiToSpawn", 3], //minimum amount to spawn
	["_vehiToSpawnRandom", 4], //random quantity to add
	["_vehiDamageMin", 0.4], //vehicle min damage
	["_vehiDamageMax", 0.8], //vehicle max damage
	["_vehiFuel", 0], //vehicle fuel
	["_addWreckVehi", true], //allow wreck vehicles
	["_vehiWreckClasses", []] //default wreck vehicles class
];


getAngle = {
	_pos_start = getPos (_this select 0);
	_pos_end = getPos (_this select 1);
	((_pos_start select 0)-(_pos_end select 0)) atan2 ((_pos_start select 1)-(_pos_end select 1));
};

//debug note: do not use append func on _vehiClasses/_vehiWreckClasses, this mess BIS_civilCars for whatever reason...

private _vehiClasses;
private _vehiWreckClasses;

if (count _pos < 3) then {_pos = getPos player;}; //use player position if no position set

_roads = _pos nearRoads _radius; //get near roads
if (count _roads == 0) exitWith {[format["NNS_fnc_spawnVehicleOnRoad : no road found around %1, radius:%2",_pos,_radius]] call NNS_fnc_debugOutput;};

if (count _vehiClasses == 0) then {_vehiClasses = missionNamespace getVariable ["BIS_civilCars",[]];}; //default vehicles classes
if (_addWreckVehi && {count _vehiWreckClasses == 0}) then {_vehiWreckClasses = missionNamespace getVariable ["BIS_civilWreckCars",[]];}; //default wreck vehicles classes
if (_addWreckVehi) then {_vehiClasses = _vehiClasses + _vehiWreckClasses}; //merge wreck classes to vehicle classes
_dirCorrection = 0; if (_reverseDirection) then {_dirCorrection = 180;};


_randomVehiCount = _vehiToSpawn + round(random _vehiToSpawnRandom); //amount of vehicle to spawn
_vehiCount = 0; //vehicle already spawned
_lastVehiLength = 0; //backup current vehicle length for next loop
_lastLane = 1; _consecutiveSameLane = 0; //used to shift lane
_tmpVehiClasses = _vehiClasses; //store vehicle classes without last one used

_lastRoad = selectRandom _roads; //select a random neaby road
_connectedRoads = roadsConnectedTo _lastRoad; //find connected road
_angleLast = 0; //starting connected road angle
if (_reverseDirection) then {_angleLast = ([_lastRoad,_connectedRoads select 1] call getAngle);
} else {_angleLast = ([_lastRoad,_connectedRoads select 0] call getAngle);};

_remainDist = 0;
_lastPos = [0,0,0]; //last spawned vehicle position, used to limit collide

for "_i" from 0 to 999 do { //roads loop
	_connectedRoads = roadsConnectedTo _lastRoad; //find connected road
	_selectedRoad = objNull; //reset selected road
	_angleCurr = 0; //new road angle
	//_tmpMarkerName = format ["mrk%1%2%3%4", random 1000, random 1000, random 1000, random 1000]; _tmpMarker = createMarker [_tmpMarkerName, getPos _lastRoad]; _tmpMarkerName setMarkerColor "ColorRed"; _tmpMarker setMarkerType "mil_destroy";
	{
		_angleCurr = [_lastRoad,_x] call getAngle; //road angle
		/*
		_tmpAngles = [_angleLast,_angleCurr]; //angle array for min/max
		_tmpDiff = abs ((selectMax _tmpAngles) - (selectMin _tmpAngles)); //angle difference
		*/
		
		_tmpDiff = abs (_angleLast - _angleCurr); //angle difference
		//if (_i == 0) then {
		//	_tmpDiff = _tmpDiff - _dirCorrection
		//};
		
		//systemChat format ["_i:%1, _tmpDiff:%2",_i,_tmpDiff];
		
		
		if (_tmpDiff < 130) exitWith {_selectedRoad = _x}; //proper road found
	} forEach _connectedRoads; //search right connected road
	
	if (isNull _selectedRoad) then {
		_i = 1000; //no road found, kill loop
		["NNS_fnc_spawnVehicleOnRoad : no valid connected road found"] call NNS_fnc_debugOutput;
	} else {
		//_tmpMarkerName = format ["mrk%1%2%3%4", random 1000, random 1000, random 1000, random 1000]; _tmpMarker = createMarker [_tmpMarkerName, getPos _lastRoad]; _tmpMarkerName setMarkerColor "ColorRed"; _tmpMarker setMarkerType "mil_destroy";
		//_tmpMarkerName = format ["mrk%1%2%3%4", random 1000, random 1000, random 1000, random 1000]; _tmpMarker = createMarker [_tmpMarkerName, getPos _selectedRoad]; _tmpMarkerName setMarkerColor "ColorYellow"; _tmpMarker setMarkerType "mil_destroy"; _tmpMarker setMarkerText format ["%1",_i];
		_remainDist = (_lastRoad distance2d _selectedRoad)/* - _remainDist*/; //center to center distance
		_roadDir = _lastRoad getDir _selectedRoad; //road direction
		_currentDist = 0; //distance from starting road center
		_spaceRemain = true; //reset remaining space
		
		while {_spaceRemain} do { //vehicle loop for current road block
			_isWreck = false;
			_tmpVehiClass = selectRandom _tmpVehiClasses; //select a random vehicle
			_tmpVehiClasses = _vehiClasses - [_tmpVehiClass]; //vehicle classes without last one used
			if (count _tmpVehiClasses == 0) then {_tmpVehiClasses = _vehiClasses;}; //only one vehicle in main vehicle classes array
			if (_tmpVehiClass in _vehiWreckClasses) then {_isWreck = true;};
			
			_tmpVehi = _tmpVehiClass createVehicle [0,0,0]; //create vehicle
			_tmpVehibox = boundingBoxReal _tmpVehi; _tmpVehiLength = abs (((_tmpVehibox select 1) select 1) - ((_tmpVehibox select 0) select 1)) * 1.2; //vehicle length
			_tmpDirCorr = 0; if (_isWreck) then {_tmpVehiLength = _tmpVehiLength * 1.2; _tmpDirCorr = 180;}; //wreck vehicles size is a bit off and direction reversed
			
			_tmpLane = selectRandom [-1,1]; //select a lane
			if (_consecutiveSameLane == 3 && {_tmpLane == _lastLane}) then {_tmpLane = _tmpLane * -1;}; //rnd is a bitch, force other lane
			_tmpVehiDist = (_lastVehiLength / 2) + (_tmpVehiLength / 2);
			
			_remainDist = _remainDist - _tmpVehiDist; //remaining space
			if (_remainDist < 0) then {_spaceRemain = false}; //no space left
			
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
			
			_tmpPos = _lastRoad getPos [2, _roadDir + (90 * _tmpLane)]; //"select" random lane
			_tmpNewPos = _tmpPos getPos [_currentdist, _roadDir];
			//_tmpNewPos = _tmpPos getPos [_currentdist, _roadDir + 180];
			
			if ((_tmpNewPos distance2D _lastPos) > (_tmpVehiLength / 2)) then { //enough space to spawn vehicle
				
				_tmpVehi setDir (180 + (_roadDir - 45) + (random 45) + (random 45) + _tmpDirCorr); //vehicle direction, more randomness
				_tmpVehi setPos _tmpNewPos; //vehicle position
				
				//_tmpMarkerName = format ["mrk%1%2%3%4", random 1000, random 1000, random 1000, random 1000]; _tmpMarker = createMarker [_tmpMarkerName, _tmpNewPos]; _tmpMarkerName setMarkerColor "ColorGreen"; _tmpMarker setMarkerType "mil_destroy"; _tmpMarker setMarkerText format ["%1",_i];
				
				if (_isWreck) then {
					//_tmpVehi setVectorUp surfaceNormal position _tmpVehi;
					//_tmpVehi enableSimulationGlobal false;
				} else {
					_tmpVehi setFuel _vehiFuel;
					[_tmpVehi,[],_vehiDamageMin,_vehiDamageMax] call NNS_fnc_randomVehicleDamage;
					clearMagazineCargoGlobal _tmpVehi; clearWeaponCargoGlobal _tmpVehi; clearBackpackCargoGlobal _tmpVehi; clearItemCargoGlobal _tmpVehi;
				};
				
				_vehiCount = _vehiCount + 1; //increment spawned vehicle count
			};
			
			if ((_vehiCount + 1) > _randomVehiCount) then {_i = 1000; _spaceRemain = false}; //kill all loop
			//if (_remainDist - _tmpVehiDist < 0) then {_spaceRemain = false}; //kill loop, avoid overlap
			_lastPos = _tmpNewPos; //backup vehicle position
		};
		
		if ((_vehiCount + 1) > _randomVehiCount) then {_i = 1000;}; //kill loop
		_angleLast = _angleCurr; //angle backup
		_lastRoad = _selectedRoad; //road backup
	};
};
