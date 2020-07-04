/*
NNS
Spawn damaged/wreck/untouched vehicles on a road near given position.
Advanced version, Allow more control but more CPU/memory intensive.

Note: 
- This function try to follow road "curves" as best as possible, use n-1 road angle in case of crossroad, does not work with broken road connection, can fail with specific crossroad.
- It is not bulletproof as boundingBoxReal function detect wrong vehicle size for wreck objects.
- Limited to 1999 road objects (over 40km depending on map).
- When _syncUnit is provided, each checkpoints should be placed as close as possible to crossroads to help the function select the right road, use DISMISS type to ignore a specific waypoint.

Marker colors when debug enable:
	Waypoints:
		Active : ColorBlue
		Disabled : ColorBrown
		Ignored : ColorPink
	Roads: ColorYellow
	Roads recovered when failed: ColorRed
	Crossroads: ColorOrange
	Vehicles : ColorBlack (not activated)
	
Dependencies:
	in initServer.sqf:
		BIS_civilCars = ["C_Offroad_01_F","C_SUV_01_F","C_Van_01_transport_F","C_Truck_02_transport_F"];
		BIS_civilWreckCars = ["Land_Wreck_Ural_F","Land_Wreck_Truck_dropside_F","Land_Wreck_Truck_F","Land_Wreck_Van_F","Land_Wreck_Offroad_F","Land_Wreck_Offroad2_F","Land_Wreck_Car_F"];

	in description.ext:
		class CfgFunctions {
			class NNS {
				class missionfunc {
					file = "nns_functions";
					class debugOutput {};
					class randomVehicleDamage {};
					class setAllHitPointsDamage {};
					class spawnVehicleOnRoad_Adv {};
				};
			};
		};

	nns_functions folder:
		fn_debugOutput.sqf
		fn_randomVehicleDamage.sqf
		fn_setAllHitPointsDamage.sqf
		fn_spawnVehicleOnRoad_Adv.sqf

Example: 
_null = [getPos player] call NNS_fnc_spawnVehicleOnRoad_Adv;
_null = [getPos player,25,true,[],500,0,0.5,0.6,0,1,true,[],true] call NNS_fnc_spawnVehicleOnRoad_Adv; //spawn 500 vehicles on road player is in

*/

// Params
params [
	["_pos", []], //center of detection point
	["_radius", 25], //radius detection
	["_reverseDirection", false], //invert road direction, only used for vehicle direction if _syncUnit provided
	["_vehiClasses", []], //default vehicles class
	["_vehiToSpawn", 3], //minimum amount to spawn
	["_vehiToSpawnRandom", 4], //random quantity to add
	["_vehiDamageMin", 0.4], //vehicle min damage
	["_vehiDamageMax", 0.8], //vehicle max damage
	["_vehiFuel", 0], //vehicle fuel
	["_vehiSpacing", 1], //vehicle length overscale (ratio, not meter)
	["_addWreckVehi", true], //allow wreck vehicles
	["_vehiWreckClasses", []], //default wreck vehicles class
	["_simpleObject", false], //create simple objects
	["_syncUnit", objNull], //unit used as paths storage (waypoint)
	["_debug", false] //show road markers on the map
];

getAngle = { //compute angle between 2 object function
	private _pos_start = _this select 0; if !(_pos_start isEqualType []) then {_pos_start = getPos _pos_start};
	private _pos_end = _this select 1; if !(_pos_end isEqualType []) then {_pos_end = getPos _pos_end};
	((_pos_start select 0)-(_pos_end select 0)) atan2 ((_pos_start select 1)-(_pos_end select 1)); //return angle
};

devMrk = { //create a marker: [pos,dir,"ColorRed","mil_destroy"] call devMrk;
	params [["_pos", objNull],["_dir", 0],["_color", "ColorRed"],["_type", "mil_destroy"],["_text", ""]];
	if !(_pos isEqualType []) then {_pos = getPos _pos}; //object
	private _tmpMarkerName = format ["mrk%1%2%3%4", round(random 1000), round(random 1000), round(random 1000), round(random 1000)]; //random name
	private _tmpMarker = createMarker [_tmpMarkerName, _pos]; //create marker
	_tmpMarkerName setMarkerColor _color; //set color
	_tmpMarkerName setMarkerType _type; //set type
	_tmpMarkerName setMarkerDir _dir; //set direction
	_tmpMarkerName setMarkerText _text; //set text
	_tmpMarkerName //return marker name
};

angleDiff = { //compute angle difference
	abs (abs ((((_this select 0) - (_this select 1)) + 180) mod 360) - 180); //return angle difference
};

if (count _pos < 3) then {_pos = getPos player;}; //use player position if no position set

_lastRoad = [_pos, _radius] call BIS_fnc_nearestRoad; //get near roads
if (isNull _lastRoad) exitWith {[format["NNS_fnc_spawnVehicleOnRoad_Adv : no road found around %1, radius:%2",_pos,_radius]] call NNS_fnc_debugOutput;};

if (count _vehiClasses == 0) then {_vehiClasses = missionNamespace getVariable ["BIS_civilCars",[]];}; //default vehicles classes
if (_addWreckVehi && {count _vehiWreckClasses == 0}) then {_vehiWreckClasses = missionNamespace getVariable ["BIS_civilWreckCars",[]];}; //default wreck vehicles classes
if (_addWreckVehi) then {_vehiClasses = _vehiClasses + _vehiWreckClasses}; //merge wreck classes to vehicle classes
_dirCorrection = 0; if (_reverseDirection) then {_dirCorrection = 180;};

_randomVehiCount = _vehiToSpawn + round(random _vehiToSpawnRandom); //amount of vehicle to spawn
_vehiCount = 0; //vehicle already spawned
_lastVehiLength = 0; //backup current vehicle length for next loop
_lastLane = 1; _consecutiveSameLane = 0; //used to shift lane
_tmpVehiClasses = _vehiClasses; //store vehicle classes without last one used
_vehiMatIndex = []; //contain already recovered classname for materials
_vehiMats = []; //contain materials, incl damage and destruct if exists

_roadCount = 0; //road count
_roadLength = 0; //road used length

_useSyncUnit = false; //is a unit with valid checkpoint provided
_useSyncUnitIgnore = false; //is system to be ignored
_forcedPath = []; //path to try to follow
_forcedPathIgnore = []; //path index to ignore
_forcedPathIndex = 0; //current path index
if !(isNull _syncUnit) then { //given unit exist
	_useSyncUnit = true; //use checkpoint bool
	_unitGroup = group _syncUnit; //unit group
	_waypoints = waypoints _unitGroup; //group waypoints
	_waypoints deleteAt 0; //remove first index, always group starting position
	{
		_waypointPos = getWPPos [_unitGroup, _x select 1]; //get current waypoint position
		_tmpX = round (_waypointPos select 0);
		_tmpY = round (_waypointPos select 1);
		_forcedPath append [[_tmpX, _tmpY]]; //round values, ignore Z
		if (toLower (waypointType [_unitGroup, _x select 1]) == "dismiss") then { //waypoint to ignore
			_forcedPathIgnore pushBack true;
			if (_debug) then {[[_tmpX, _tmpY],0,"ColorPink","mil_destroy",format["W%1",_x select 1]] call devMrk}; //debug: waypoints to ignore
		} else { //waypoint to be used
			_forcedPathIgnore pushBack false;
			if (_debug) then {[[_tmpX, _tmpY],0,"ColorBlue","mil_destroy",format["W%1",_x select 1]] call devMrk}; //debug: waypoints to use
		};
	} forEach _waypoints; //add waypoint position to array
	deleteVehicle _syncUnit; //delete unit
	if (count (units _unitGroup) == 0) then {deleteGroup _unitGroup}; //empty group, delete it, just by security
	if (count _forcedPath == 0) then {_useSyncUnit = false}; //no waypoint found
};

_connectedRoads = roadsConnectedTo _lastRoad; //find connected road
_angleLast = 0; //starting connected road angle
if (count _connectedRoads == 0) exitWith {[format["NNS_fnc_spawnVehicleOnRoad_Adv : no connected road found around %1, radius:%2",_pos,_radius]] call NNS_fnc_debugOutput;}; //roadsConnectedTo failed
if (count _connectedRoads == 1) then {_connectedRoads set [1, _connectedRoads select 0];}; //only one connected road, add a second one for _reverseDirection

_nearestIndex = -1; //nearest connected road index
if (_useSyncUnit) then { //used waypoint data
	_nearestDiff = 360; //nearest connected road angle difference
	_angleToTrack = [_lastRoad, _forcedPath select 0] call getAngle; //first waypoint angle
	for "_i" from 0 to ((count _connectedRoads) - 1) do { //connected roads
		_angleCurr = [_lastRoad, _connectedRoads select _i] call getAngle; //connected road angle
		_tmpDiff = [_angleToTrack,_angleCurr] call angleDiff; //angle difference
		if (_tmpDiff < _nearestDiff) then { //most probable so far
			_nearestDiff = _tmpDiff; //backup angle
			_nearestIndex = _i; //backup index
		};
	};
	_angleLast = [_lastRoad,_connectedRoads select _nearestIndex] call getAngle; //"right" road angle
};

if (_nearestIndex == -1) then { //basic method
	_useSyncUnit = false;
	if (_reverseDirection) then {_angleLast = ([_lastRoad,_connectedRoads select 1] call getAngle);
	} else {_angleLast = ([_lastRoad,_connectedRoads select 0] call getAngle);};
};

_angleLast1 = _angleLast; //angle n-1, used for crossroads
_lastRoad1 = _lastRoad; //road n-1, used for crossroads
_lastWaypointDist = 25000; //last distance from next waypoint, stupid high distance for security
_remainDist = 0; //road center to center distance
_lastPos = [0,0,0]; //last spawned vehicle position, used to limit collide
_failedDetection = 0; //connected roads retry

for "_i" from 1 to 2000 do { //roads loop
	_roadCount = _i; //roads count
	if (_useSyncUnit) then { //use waypoints
		_tmpDist = _lastRoad1 distance2d (_forcedPath select _forcedPathIndex); //distance to waypoint
		_angleCurr = [_lastRoad1, _forcedPath select _forcedPathIndex] call getAngle; //waypoint angle
		_tmpDiff = [_angleLast1,_angleCurr] call angleDiff; //angle difference
		
		if (_tmpDist < 5) then { //last road closer than 5m to current waypoint, delete it
			if (_debug) then {[_forcedPath select _forcedPathIndex,0,"ColorBrown","mil_destroy"] call devMrk}; //debug: waypoints disabled
			_forcedPathIndex = _forcedPathIndex + 1; //increment path index
			//systemChat format ["waypoint delete0 _i:%1",_i];
		} else {
			if (_tmpDist < _lastWaypointDist) then { //getting closer to waypoint and waypoint in front
				_lastWaypointDist = _tmpDist;  //backup distance
			} else { //moving away from waypoint
				if (_tmpDiff > 150 && _tmpDist < 200) then { //waypoint beyond road, under 200m away
					if (_debug) then {[_forcedPath select _forcedPathIndex,0,"ColorBrown","mil_destroy"] call devMrk}; //debug: waypoints disabled
					_forcedPathIndex = _forcedPathIndex + 1; //increment path index
					_lastWaypointDist = 25000; //stupid high distance for security
					//systemChat format ["waypoint delete1 _i:%1, _tmpDist:%2, _tmpDiff:%3",_i,_tmpDist,_tmpDiff];
				};
			};
		};
		
		if (_forcedPathIndex > ((count _forcedPath) - 1)) then { //it was the last one, disable usage of waypoints
			_useSyncUnit = false; //disable
		} else {
			_tmp = (_forcedPathIgnore select _forcedPathIndex); //check if current waypoint need to be ignored
			if !(_tmp isEqualTo _useSyncUnitIgnore) then {_useSyncUnitIgnore = _tmp}; //update bool if changed
		};
	};
	
	_connectedRoads = roadsConnectedTo _lastRoad; //find connected road
	_connectedRoadsCount = count _connectedRoads; //connected road count
	_selectedRoad = objNull; //reset selected road
	_angleCurr = 0; //new road angle
	_distHighest = 0; //store road distance
	_angleLowest = 179; //store lower angle found, start value limit max angle allowed
	_angleRoad = 0; //store new road right angle
	_tmpAngleLast = _angleLast; //last road angle to use
	_tmpDiff = 0; //reset angle diffenrence var
	
	if (_debug) then {
		if (_connectedRoadsCount > 2) then { //debug: crossroad
			[_lastRoad,_angleLast,"ColorYellow","mil_destroy","C"] call devMrk;
			for "_j" from 0 to (_connectedRoadsCount - 1) do {
				_angleCurr = [_connectedRoads select _j, _lastRoad] call getAngle; //connected road angle
				[_connectedRoads select _j,_angleCurr,"ColorOrange","mil_arrow",format ["%1",_j]] call devMrk;
			};
		} else {[_lastRoad,_angleLast,"ColorYellow","mil_destroy"] call devMrk}; //debug: road
	};
	
	if (_connectedRoadsCount > 2 && _useSyncUnit && !_useSyncUnitIgnore) then { //crossroad and checkpoint enabled
		_nearestIndex = -1; //reset nearest connected road index
		_nearestDiff = 360; //reset nearest connected road angle difference
		//_angleToTrack = [_lastRoad1, _forcedPath select _forcedPathIndex] call getAngle; //waypoint angle
		_angleToTrack = [_lastRoad, _forcedPath select _forcedPathIndex] call getAngle; //waypoint angle
		
		for "_j" from 0 to (_connectedRoadsCount - 1) do { //connected roads
			//_angleCurr = [_lastRoad1, _connectedRoads select _j] call getAngle; //connected road to waypoint
			//_tmpDiff = [_angleToTrack,_angleCurr] call angleDiff; //angle difference
			_angleCurr = [_lastRoad, _connectedRoads select _j] call getAngle; //connected road to waypoint
			_tmpDiff = [_angleToTrack,_angleCurr] call angleDiff; //angle difference
			//diag_log format ["cross : _i:%1, _j:%2, _angleCurr:%3, _tmpDiff:%4",_i,_j,_angleCurr,_tmpDiff];
			//systemChat format ["cross : _i:%1, _j:%2, _angleCurr:%3, _tmpDiff:%4, _useSyncUnitIgnore:%5",_i,_j,_angleCurr,_tmpDiff, _useSyncUnitIgnore];
			if (_tmpDiff < _nearestDiff) then { //most probable so far
				_nearestDiff = _tmpDiff; //backup angle
				_nearestIndex = _j; //backup index
				_angleRoad = _angleCurr; //backup current road angle
			};
		};
		
		_selectedRoad = _connectedRoads select _nearestIndex; //road selected
	} else { //default method of selection
		if (_connectedRoadsCount > 2) then {_tmpAngleLast = _angleLast1;}; //crossroad, use n-1 road as reference angle
		
		{
			_angleCurr = [_lastRoad, _x] call getAngle; //connected road angle
			_tmpDiff = [_tmpAngleLast,_angleCurr] call angleDiff; //angle difference
			if (_tmpDiff < _angleLowest) then { //current angle diff lower than lowest angle detected
				_angleLowest = _tmpDiff; //backup angle diff
				_angleRoad = _angleCurr; //backup current road angle
				_selectedRoad = _x; //backup object
			};
		//diag_log format ["_useSyncUnit _i:%7, _i:%1, _connectedRoadsCount:%2, _angleLast:%3, _angleCurr:%4, _angleLowest:%5, _tmpDiff:%6",_i,_connectedRoadsCount,_angleLast,_angleCurr,_angleLowest,_tmpDiff,_useSyncUnit];
		} forEach _connectedRoads; //search right connected road
		
		if (_connectedRoadsCount > 2 && _angleLowest > 5) then { //crossroad and lowest angle over 5deg
			//diag_log format ["_useSyncUnit _i:%7, _i:%1, _connectedRoadsCount:%2, _angleLast:%3, _angleCurr:%4, _angleLowest:%5, _tmpDiff:%6",_i,_connectedRoadsCount,_angleLast,_angleCurr,_angleLowest,_tmpDiff,_useSyncUnit];
			{
				_tmpDiff = _lastRoad1 distance2D _x; //distance between roads center
				_angleCurr = [_lastRoad1,_x] call getAngle; //connected road angle
				_tmpAngleDiff = [_angleLast1,_angleCurr] call angleDiff; //angle difference
				if (_tmpDiff > _distHighest && _tmpAngleDiff < 20) then { //highest distance but diff angle under 20deg
					_distHighest = _tmpDiff; //backup distance diff
					_angleRoad = _angleCurr; //backup current road angle
					_selectedRoad = _x; //backup object
				};
			} forEach _connectedRoads; //search right connected road
		};
	};
	
	if (isNull _selectedRoad) then { //failed to select a raod
		_failedDetection = _failedDetection + 1; //increment retry counter
		if !(_failedDetection == 3) then { //allow 3 retry
			//systemChat "try to fix broken";
			_searchPos = _lastRoad getPos [10, _lastRoad1 getDir _lastRoad];
			_lastRoad = [_searchPos, 20, [_lastRoad, _lastRoad1]] call BIS_fnc_nearestRoad; //try to found a "connected" broken road
			if (_debug && {!isNull _lastRoad}) then {[_lastRoad,0,"ColorRed","mil_destroy"] call devMrk}; //debug: recovered raod
		} else {_lastRoad = objNull;}; //destroy last road object
		
		if (isNull _lastRoad) then { //failed to detect proper road
			_i = 10000; //no road found, kill loop
			//systemChat "broken";
			["NNS_fnc_spawnVehicleOnRoad_Adv : no valid connected road found"] call NNS_fnc_debugOutput;
		} else { //need to reroute
			//systemChat format ["_useSyncUnit:%1, _useSyncUnitIgnore:%2",_useSyncUnit,_useSyncUnitIgnore];
			if (_useSyncUnit && !_useSyncUnitIgnore) then {
				_angleLast = [_lastRoad, _forcedPath select _forcedPathIndex] call getAngle; //angle backup
				//systemChat format ["_angleLast:%1",_angleLast];
				_angleLast1 = _angleLast; //angle n-1 backup
			};
			_lastRoad1 = _lastRoad; //road n-1, backup
		};
	} else {
		//[_lastRoad, "ColorRed", "mil_destroy"] call devMrk; //debug marker
		//[_selectedRoad, "ColorYellow", "mil_destroy", format ["%1",_i]] call devMrk; //debug marker
		//_tmpMarkerName = format ["mrk%1%2%3%4", random 1000, random 1000, random 1000, random 1000]; _tmpMarker = createMarker [_tmpMarkerName, getPos _lastRoad]; _tmpMarkerName setMarkerColor "ColorRed"; _tmpMarker setMarkerType "mil_destroy";
		//_tmpMarkerName = format ["mrk%1%2%3%4", random 1000, random 1000, random 1000, random 1000]; _tmpMarker = createMarker [_tmpMarkerName, getPos _selectedRoad]; _tmpMarkerName setMarkerColor "ColorYellow"; _tmpMarker setMarkerType "mil_destroy"; _tmpMarker setMarkerText format ["%1",_i];
		_remainDist = (_lastRoad distance2d _selectedRoad); //center to center distance
		_roadLength = _roadLength + _remainDist; //add to road length
		_roadDir = _lastRoad getDir _selectedRoad; //road direction
		_currentDist = 0; //distance from starting road center
		_spaceRemain = true; //reset remaining space
		
		while {_spaceRemain} do { //vehicle loop for current road block
			_isWreck = false;
			_tmpVehiClass = selectRandom _tmpVehiClasses; //select a random vehicle
			_tmpVehiClasses = _vehiClasses - [_tmpVehiClass]; //vehicle classes without last one used
			if (count _tmpVehiClasses == 0) then {_tmpVehiClasses = _vehiClasses;}; //only one vehicle in main vehicle classes array
			if (_tmpVehiClass in _vehiWreckClasses) then {_isWreck = true;};
			_tmpVehi = objNull;
			if (_simpleObject) then {_tmpVehi = createSimpleObject [_tmpVehiClass, [0,0,0]]; //create simple object
			} else {_tmpVehi = _tmpVehiClass createVehicle [0,0,0];}; //create vehicle
			_tmpVehi allowDamage false; //disable in case server is having hard time
			
			_tmpVehibox = boundingBoxReal _tmpVehi; _tmpVehiLength = abs (((_tmpVehibox select 1) select 1) - ((_tmpVehibox select 0) select 1)) * 1.3; //vehicle length
			_tmpDirCorr = 0; if (_isWreck) then {_tmpVehiLength = _tmpVehiLength * 1.6; _tmpDirCorr = 180;}; //wreck vehicles size is a bit off and direction reversed
			_tmpVehiLength = _tmpVehiLength * _vehiSpacing; //apply spacing ratio
			
			_tmpLane = selectRandom [-1,1]; //select a lane
			if (_consecutiveSameLane == 3 && {_tmpLane == _lastLane}) then {_tmpLane = _tmpLane * -1;}; //rnd is a bitch, force other lane
			_tmpVehiDist = (_lastVehiLength / 2) + (_tmpVehiLength / 2);
			
			_remainDist = _remainDist - _tmpVehiDist; //remaining space
			if (_remainDist < 0) then {_spaceRemain = false}; //no space left
			
			if (_tmpLane != _lastLane) then { //lane has change
				_tmpVehiLength = _tmpVehiLength * (0.5 + random 0.5); //new vehicle length
				_lastLane = _tmpLane; //backup last lane
				_consecutiveSameLane = 0; //reset consecutive lane
			} else {
				_tmpVehiLength = _tmpVehiLength * (1.1 + random 0.2); //new vehicle length
				_consecutiveSameLane = _consecutiveSameLane + 1; //update consecutive lane
			};
			
			_currentDist = _currentDist + _tmpVehiDist; //distance from road center
			_lastVehiLength = _tmpVehiLength; //backup current vehicle length for next loop
			
			_tmpPos = _lastRoad getPos [2 + random 0.3, _roadDir + (90 * _tmpLane)]; //"select" random lane
			_tmpNewPos = _tmpPos getPos [_currentdist, _roadDir];
			if ((_tmpNewPos distance2D _lastPos) > (_tmpVehiLength / 2)) then { //enough space to spawn vehicle
				_tmpVehi setDir (180 + (_roadDir - 45) + (random 45) + (random 45) + _tmpDirCorr); //vehicle direction, more randomness
				if (_simpleObject) then { //simple object
					_tmpNewPos set [2, getTerrainHeightASL _tmpNewPos]; //proper height
					_tmpVehi setPosASL _tmpNewPos; //set position
					_tmpVehi setVectorUp surfaceNormal position _tmpVehi; //proper vector up
					if (_addWreckVehi && !_isWreck) then { //yes, this whole part is only here to add damaged effect to simple objects
						_tmpVehiHasDamaged = false;
						_tmpVehiHasDestroyed = false;
						if !(_tmpVehiClass in _vehiMatIndex) then { //need to extract vehicle usable materials
							if (isArray (configfile >> "CfgVehicles" >> _tmpVehiClass >> "hiddenSelectionsTextures") && {isArray (configfile >> "CfgVehicles" >> _tmpVehiClass >> "Damage" >> "mat")}) then {
								_vehiHiddenSelec = getArray (configfile >> "CfgVehicles" >> _tmpVehiClass >> "hiddenSelectionsTextures"); //extract hiddenSelectionsTextures, array index should be linked to materials
								_vehiDamagedMats = getArray (configfile >> "CfgVehicles" >> _tmpVehiClass >> "Damage" >> "mat"); //get class damaged materials
								if (count _vehiHiddenSelec > 0 && count _vehiDamagedMats > 0) then {
									_tmpVehiMatsArray = []; //"main" material array
									{
										_tmpVehiMats = []; //tmp array to store materials
										_cleanFilename = _x splitString ""; //split all caracters
										_cleanFilenameCount = (count _cleanFilename) - 1; //char count
										_cleanFilename deleteRange [_cleanFilenameCount - 6, _cleanFilenameCount]; //remove "_co.paa", if filename doesn't follow this rules, that sucks
										if (_cleanFilename select 0 == "\\") then {_cleanFilename deleteAt 0}; //remove first char if start with \
										_cleanFilename = toLower (_cleanFilename joinString ""); //convert to string, lowercase
										
										_vehiDamagedMats apply {toLower _x}; //damaged materials lowercase
										//_vehiMatNormal = format ["%1.rvmat",_cleanFilename]; //non damaged material filename
										_vehiMatDamaged = format ["%1_damage.rvmat",_cleanFilename]; //damaged material filename
										_vehiMatDestruct = format ["%1_destruct.rvmat",_cleanFilename]; //destruct material filename
										
										//if !(_vehiDamagedMats findIf {[_x, _vehiMatNormal, false] call BIS_fnc_inString} == -1) then {_tmpVehiMats pushBack _vehiMatNormal;}; //non damaged material is listed
										if !(_vehiDamagedMats findIf {[_x, _vehiMatDamaged, false] call BIS_fnc_inString} == -1) then {_tmpVehiMats pushBack _vehiMatDamaged;}; //damaged material is listed
										if !(_vehiDamagedMats findIf {[_x, _vehiMatDestruct, false] call BIS_fnc_inString} == -1) then {_tmpVehiMats pushBack _vehiMatDestruct;}; //destruct material is listed
										
										if (count _tmpVehiMats > 0) then {_tmpVehiMatsArray append [_tmpVehiMats]; //found some usable material
										} else {_tmpVehiMatsArray append [];}; //found nothing
									} forEach _vehiHiddenSelec; //hiddenSelectionsTextures loop
									
									if (count _tmpVehiMatsArray > 0) then { //found some usable material
										_vehiMatIndex pushBack _tmpVehiClass; //add vehicle class to index
										_vehiMats append [_tmpVehiMatsArray]; //add vehicle material to index
									};
								};
							};
						};
						
						if (_tmpVehiClass in _vehiMatIndex && {isArray (configfile >> "CfgVehicles" >> _tmpVehiClass >> "hiddenSelectionsTextures")}) then { //material entry exist
							_vehiHiddenSelec = getArray (configfile >> "CfgVehicles" >> _tmpVehiClass >> "hiddenSelectionsTextures"); //extract hiddenSelectionsTextures, array index should be linked to materials
							_tmpVehiMats = _vehiMats select (_vehiMatIndex find _tmpVehiClass); //get vehicle extracted materials
							
							for "_j" from 0 to ((count _vehiHiddenSelec) - 1) do { //material loop
								_tmpMats = (_tmpVehiMats select _j); //current index materials
								if (count _tmpMats > 0) then {_tmpVehi setObjectMaterialGlobal [_j, selectRandom _tmpMats];}; //materials exists for current index, apply random material
							};
						};
					};
				} else {_tmpVehi setPos _tmpNewPos;}; //set vehicle position
				_tmpVehi allowDamage true; //re-enable damage
				
				if !(_isWreck) then { //not wreck
					_tmpVehi setFuel _vehiFuel; //set fuel
					[_tmpVehi,[],_vehiDamageMin,_vehiDamageMax] call NNS_fnc_randomVehicleDamage; //set hitpoint damage
					clearMagazineCargoGlobal _tmpVehi; clearWeaponCargoGlobal _tmpVehi; clearBackpackCargoGlobal _tmpVehi; clearItemCargoGlobal _tmpVehi; //empty vehicle
				};
				
				//if (_debug) then {[_tmpNewPos,getDir _tmpVehi,"ColorBlack","mil_arrow"] call devMrk}; //debug: vehicle
				
				_vehiCount = _vehiCount + 1; //increment spawned vehicle count
			};
			
			if ((_vehiCount + 1) > _randomVehiCount) then {_i = 10000; _spaceRemain = false}; //kill all loop
			_lastPos = _tmpNewPos; //backup vehicle position
		};
		
		if ((_vehiCount + 1) > _randomVehiCount) then {_i = 10000;}; //kill loop
		_angleLast1 = _angleLast; //angle n-1 backup
		_angleLast = _angleRoad; //angle backup
		_lastRoad1 = _lastRoad; //road n-1, backup
		_lastRoad = _selectedRoad; //road backup
	};
};

[format["NNS_fnc_spawnVehicleOnRoad_Adv : spawned vehicles:%1",_vehiCount]] call NNS_fnc_debugOutput;
[format["NNS_fnc_spawnVehicleOnRoad_Adv : roads:%1, length:%2m",_roadCount,_roadLength]] call NNS_fnc_debugOutput;

if (_debug) then {[[100, 250],0,"ColorBlack","mil_unknown",format["NNS_fnc_spawnVehicleOnRoad_Adv : spawned vehicles:%1",_vehiCount]] call devMrk}; //debug: vehicle count
if (_debug) then {[[100, 100],0,"ColorBlack","mil_unknown",format["NNS_fnc_spawnVehicleOnRoad_Adv : roads:%1, length:%2m",_roadCount,_roadLength]] call devMrk}; //debug: road length

_roadLength

