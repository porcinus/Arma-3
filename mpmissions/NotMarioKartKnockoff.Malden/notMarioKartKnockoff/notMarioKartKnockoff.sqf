/*
NNS
Not Mario Kart Knockoff
Main script to run on server.
*/

params [
	["_kartsList",[]], //karts array
	["_syncAreaUnits",[]] //unit array used as waypoint storage for auto generation of box and walls
];

missionNamespace setVariable ["MKK_karts", _kartsList, true]; //karts array

//handle players connection
addMissionEventHandler ["PlayerConnected", {
	{
		[] spawn {
			waitUntil {!isNull player && !isNil "MKK_karts"};
			while {sleep 1; (vehicle player) == player} do { //loop until player teleported into a kart
				_availableKart = MKK_karts findIf {isNull (driver _x)}; //search first kart without driver
				if !(_availableKart == -1) then {player moveInDriver (MKK_karts select _availableKart)}; //find one, set player as driver
			};
		};
	} remoteExec ["BIS_fnc_call", _this select 4];
}];

//handle players disconnect
addMissionEventHandler ["HandleDisconnect", {
	_veh = vehicle (_this select 0); //player vehicle
	deleteVehicle (_this select 0); //delete AI
	if !(isNull _veh) then {
		_tmpInitialPos = _veh getVariable ["startPos", getPos _veh]; //backup initial position
		[_veh, _tmpInitialPos] remoteexec ["setPos", _veh]; //reduce vehicle mass by 15%
	};
}];

//disable specific actions for all players
{inGameUISetEventHandler ["Action", "
_disableActionsArr = ['gear', 'engineoff', 'eject', 'getout'];
if (toLower (_this select 3) in _disableActionsArr) then {true};
"]} remoteExec ["BIS_fnc_call", 0, true];

//notify players of area generation
[] spawn {
	while {missionNamespace getVariable ["MKK_areaGenerated", 0] != -1} do { //while areas not generated
		{[localize "STR_MKK_server", format[localize "STR_MKK_waitareagenerated", missionNamespace getVariable ["MKK_areaGenerated", 0]]] call MKK_fnc_displaySubtitle} remoteExec ["BIS_fnc_call", 0]; //notify all players
		sleep 5; //wait a bit
	};
};

//General config
_minPlayers = 1;
if (isMultiplayer) then {_minPlayers = 2}; //minimum amount of player before vote start

_itemboxRespawn = 10; //time before item box respawn

_modePointsArr = [ //game mode starting points
	[0,0,0],	//here for safety, do not edit
	[3,5,10],	//balloon
	[0,0,0],	//deathmatch
	[0,0,0],	//team deathmatch
	[0,0,0]		//free play
];

_modePointsLimitArr = [ //game mode point limit
	[9999,9999,9999],	//here for safety, do not edit
	[9999,9999,9999],	//balloon
	[10,20,30],				//deathmatch
	[15,30,45],				//team deathmatch
	[9999,9999,9999]	//free play
];

_modeDurationArr = [ //game mode duration in sec
	[1,1,1],				//here for safety, do not edit
	[300,600,900],	//balloon: 5,10,15min
	[300,600,900],	//deathmatch: 5,10,15min
	[300,600,900],	//team deathmatch: 5,10,15min
	[300,600,900]		//free play: 5,10,15min
];

_modeCount = count _modePointsArr; //number of game modes

//autogeneration config
_itemboxDensity = 350; //one itembox per given square unit

_avoidSoilArr = ["#GdtGrassDry", "#GdtGrassGreen", "#GdtSoil"]; //not allowed surface kind

_wallClass = "VR_Billboard_01_F"; //wall class
_wallLength = 2; //wall length
_wallDirCorr = 90; //wall direction correction
_obstaclePadding = 2; //obstacle padding for area generation
_exclusionRadius = 8; //delete possible position around karts positions and itemboxs
_ignoreClasses = ["PowerLines_base_F", "PowerLines_Small_base_F", "PowerLines_Wires_base_F", "Signs_base_F", "Land_NavigLight"]; //object classes to ignore
_openDoorsClass = ["Land_i_Shed_Ind_F", "Land_i_Shed_Ind_old_F"]; //open all door

_areaDebug = true; if (isMultiplayer) then {_areaDebug = false}; //enable area debug on solo, disable in multiplayer

//game mode global vars
missionNamespace setVariable ["MKK_modePointArr", _modePointsArr, true]; //game mode starting points array
missionNamespace setVariable ["MKK_modeLimitArr", _modePointsLimitArr, true]; //game mode point limit array
missionNamespace setVariable ["MKK_modeDuraArr", _modeDurationArr, true]; //game mode duration in sec array

_areaVoteDuration = 20; //area vote duration
_voteDuration = 15; //game mode vote duration
_teamDuration = 20; //team selection duration
_introDuration = 10; //intro duration
_scoreDuration = 20; //score screen duration

missionNamespace setVariable ["MKK_time", -1, true]; //current day time
missionNamespace setVariable ["MKK_area", -1, true]; //current area
missionNamespace setVariable ["MKK_mode", -1, true]; //current game mode
missionNamespace setVariable ["MKK_modeRules", -1, true]; //current game mode rules
/*
missionNamespace setVariable ["MKK_time", 0, true]; //debug: day
missionNamespace setVariable ["MKK_area", 0, true]; //debug: area 1
missionNamespace setVariable ["MKK_mode", 1, true]; //debug: free mode
missionNamespace setVariable ["MKK_modeRules", 1, true]; //debug: max time
*/
missionNamespace setVariable ["MKK_voteTimeEnd", -1, true]; //end time for day time vote screen
missionNamespace setVariable ["MKK_voteAreaEnd", -1, true]; //end time for area selection vote screen
missionNamespace setVariable ["MKK_voteModeEnd", -1, true]; //end time for game mode vote screen
missionNamespace setVariable ["MKK_voteRulesEnd", -1, true]; //end time for parameters vote screen
missionNamespace setVariable ["MKK_teamEnd", -1, true]; //end time for team selection screen (team deathmatch)
missionNamespace setVariable ["MKK_introEnd", -1, true]; //end time for intro screen
missionNamespace setVariable ["MKK_roundEnd", -1, true]; //end time for current round
missionNamespace setVariable ["MKK_scoreEnd", -1, true]; //end time for score screen

setViewDistance 400; //limit view distance

//play areas vars
_areaPolygonsArr = []; //all polygons area array
_areaSafePolygonsArr = []; //debug
_areaPolygonsBlacklistArr = []; //debug
_areaItemboxsArr = []; //all item box per area array
_areaKartsPosArr = []; //all karts initial position per area array
_areaPosArr = []; //all areas position array
_areaSizesArr = []; //all areas size array
_areaGridSize = 3; //grid spacing for valid position generation

//auto generation of itembox and walls
//important note: this whole part use polygon instead of rectangular trigger because some objects center position and bounding box center doesn't match
_areaCount = 0; //amount of play areas
_tmpObjClassArr = []; //store already class with recovered sizes
_tmpObjSizeArr = []; //store class size

{ //synchronized units loop for zones generation
	if !(isNull _x) then {
		missionNamespace setVariable ["MKK_areaGenerated", _areaCount + 1, true]; //area that will be generated

		_areaPolygon = []; //reset polygon points array
		_areaSafePolygon = []; //reset polygon safe points array
		_areaPolygonTmp = []; //reset polygon temporary array
		_areaPolygonBacklist = []; //reset polygon blacklist points array
		_areaPolygonBacklistXmax = []; //reset polygon blacklist max x array
		_areaPolygonRoads = []; //reset roads polygon points, needed since roads related function fail to detect most roads
		_areaSize = 0; //reset area size in without blacklist
		_kartPosArr = []; //reset initial teleport position for karts array
		_itemPosArr = []; //reset item position array
		_itemObjArr = []; //reset item boxs array
		_debugTickStart = 0; _debugTick = 0; //debug, for generation duration
		
		_syncUnitGroup = group _x; //unit group
		_syncUnitWaypoints = waypoints _syncUnitGroup; //group waypoints
		
		{ //waypoint loop
			_waypointPos = getWPPos [_syncUnitGroup, _x select 1]; //get current waypoint position
			_areaPolygon pushBack [round ((_waypointPos select 0) * 10) / 10, round ((_waypointPos select 1) * 10) / 10, 0]; //round to one decimal, ignore Z
		} forEach _syncUnitWaypoints; //add waypoint position to array
		
		_polygonCount = (count _areaPolygon) - 1; //current area polygon points count
		if (_polygonCount > 1) then { //polygon is at least a triangle (3 points)
			deleteVehicle _x; //delete unit
			if (count (units _syncUnitGroup) == 0) then {deleteGroup _syncUnitGroup}; //empty group, delete it
			if (_areaDebug) then {_debugTickStart = diag_tickTime}; //debug
			
			_lastPoint = _areaPolygon select _polygonCount; //last point of the array
			_lastDir = (_areaPolygon select (_polygonCount - 1)) getDir _lastPoint; //last wall direction
			
			_minX = 99999; _maxX = 0; _minY = 99999; _maxY = 0; //polygon limits
			_tmpCrossProduct = 0;
			_tmpArr = []; //store temporary safe zone polygon point
			_tmpSafePaddingDir = 90; //padding direction
			for "_i" from 0 to _polygonCount do { //wall generation loop
				_currentPoint = _areaPolygon select _i; //current point of the array
				if !(isMultiplayer) then {[_currentPoint, 0, "ColorRed", "mil_destroy", str _i] call MKK_fnc_createMarker}; //solo player add debug marker
				
				_currentPointX = _currentPoint select 0; _currentPointY = _currentPoint select 1; //backup XY point position
				if (_currentPointX < _minX) then {_minX = _currentPointX}; //under min X
				if (_currentPointX > _maxX) then {_maxX = _currentPointX}; //over max X
				if (_currentPointY < _minY) then {_minY = _currentPointY}; //under min Y
				if (_currentPointY > _maxY) then {_maxY = _currentPointY}; //over max Y
				
				_currentWallDir = _currentPoint getDir _lastPoint; //wall direction
				_currentWallLength = _lastPoint distance2D _currentPoint; 
				_currentWallsCount = _currentWallLength / _wallLength; //amount of wall to generate for current line
				_currentPointOffset = _currentPoint getPos [(_wallLength * (ceil (_currentWallsCount) - _currentWallsCount)) / 2, _currentWallDir + 180]; //offset start point to center full wall
				_currentWallsCount = ceil (_currentWallsCount); //ceiled amount of wall
				
				for "_j" from 0 to (_currentWallsCount - 1) do { //current section
					_wallPos = _currentPointOffset getPos [(_wallLength / 2) + _wallLength * _j, _currentWallDir]; //current wall position
					_wallPos set [2, getTerrainHeightASL _wallPos]; //convert to ASL position
					_tmpObj = createSimpleObject [_wallClass, _wallPos]; //create wall
					_tmpObj setDir (_currentWallDir + _wallDirCorr); //correct wall direction
					_tmpObj setPosASL _wallPos; //re-set wall position
				};
				
				//prepare safe zone polygon point, real polygon area inner padded by obstacle padding value
				if (_i == 0) then {if ((_currentPoint getDir (_areaPolygon select (_i + 1))) > 180) then {_tmpSafePaddingDir = -90}}; //detect right padding direction on first point
				
				_tmpPoint = (_currentPoint getPos [-1000, _currentWallDir]) getPos [_obstaclePadding, _currentWallDir + _tmpSafePaddingDir]; //start position of current wall - 1000m
				_tmpArr pushBack _tmpPoint; //padded position of current wall
				_tmpArr pushBack (_tmpPoint getPos [_currentWallLength + 2000, _currentWallDir]); //end position of current wall + 1000m
				
				//cross product of last point and current point for area surface
				_tmpCrossProduct = _tmpCrossProduct + (((_lastPoint select 0) * (_currentPoint select 1)) - ((_lastPoint select 1) * (_currentPoint select 0)));
				
				_lastPoint = _currentPoint; //update last position var
				_lastDir = _currentWallDir; //update last wall direction var
			};
			
			//safe zone polygon
			_tmpArrCount = count _tmpArr; //padded lines array size
			if (_tmpArrCount > 0) then { //valid safe polygon _areaSafePolygon
				_tmpArrCount = _tmpArrCount - 1; //padded polygon points array size - 1
				_intersectPos = [_tmpArr select (_tmpArrCount - 1), _tmpArr select _tmpArrCount, _tmpArr select 0, _tmpArr select 1] call MKK_fnc_lineIntersection; //intersection of first point
				if (count _intersectPos > 0) then {_areaSafePolygon pushback _intersectPos}; //valid point, add to safe array
				for "_i" from 0 to (_tmpArrCount - 2) step 2 do { //lines loop
					_intersectPos = [_tmpArr select (_i), _tmpArr select (_i + 1), _tmpArr select (_i + 2), _tmpArr select (_i + 3)] call MKK_fnc_lineIntersection; //intersection point
					if (count _intersectPos > 0) then {_areaSafePolygon pushback _intersectPos}; //valid point, add to safe array
				};
			};
			
			if ((count _areaPolygon) == (count _areaSafePolygon)) then {_areaPolygonTmp = _areaSafePolygon; //valid safe polygon array, use as safe array
			} else {_areaPolygonTmp = _areaPolygon}; //use main polygon array
			_tmpArr = nil; _tmpArrCount = nil; //free useless var
			
			_areaSize = abs (_tmpCrossProduct / 2); //polygon area size in m2
			
			if (_areaDebug) then { //debug
				_debugTick = diag_tickTime - _debugTickStart;
				diag_log format ["area%1: polygon/wall generation: %2ms", _areaCount, _debugTick * 1000];
				_debugTickStart = diag_tickTime;
			};
			
			if (_minX != 99999) then { //polygon should be valid
				_areaPolygonCenter = [(_maxX + _minX) / 2, (_maxY + _minY) / 2, 0]; //polygon center
				_areaPolygonRadius = _areaPolygonCenter distance2D [_minX, _minY, 0]; //polygon radius
				
				_tmpObjSize = []; //current object size
				
				_houseInArea = _areaPolygonCenter nearObjects ["House", _areaPolygonRadius]; //recover house kind in area
				_objectsInArea = nearestTerrainObjects [_areaPolygonCenter, ["FENCE", "WALL"], _areaPolygonRadius, false, true]; //recover fences and walls in area
				_roadsInArea = [_areaPolygonCenter select 0, _areaPolygonCenter select 1] nearRoads _areaPolygonRadius; //recover all roads in area

				{ //generate polygon blacklist loop
					_tmpObj = _x; //backup current object
					if (_ignoreClasses findIf {_tmpObj isKindOf _x} == -1) then { //object class not in ignore array
						_tmpPosASL = getPosASL _tmpObj; //backup object ASL position
						_tmpObjSize = []; //reset object size
						_tmpDir = 0; //reset object direction
						_tmpObjClass = ""; //reset object class
						
						if (_tmpObj in _roadsInArea) then { //object is road
							_tmpConnectedRoad = roadsConnectedTo _tmpObj; //road connected to current road
							if (count _tmpConnectedRoad > 0) then { //has connected road
								if (count _tmpConnectedRoad < 2) then {_tmpConnectedRoad set [1, _tmpObj]}; //miss a connected road, replace missing end by current road
								_tmpRoadEnd0 = _tmpConnectedRoad select 0; _tmpRoadEnd1 = _tmpConnectedRoad select 1; //road ends
								_tmpObjSize = [[((_tmpObj distance2D _tmpRoadEnd0) / 2) * -1, -2, 0], [((_tmpObj distance2D _tmpRoadEnd1) / 2), 2, 0]]; //min, max
								_tmpDir = (_tmpRoadEnd0 getDir _tmpRoadEnd1) - 90; //road direction
							};
						};
						
						if (count _tmpObjSize == 0) then { //no object size
							_tmpObjClass = typeOf _tmpObj; //object class
							_tmpClassIndex = _tmpObjClassArr find _tmpObjClass; //search object class index
							if (_tmpClassIndex == -1) then { //object class not in array
								_tmpObjSize = 0 boundingBoxReal _tmpObj; //bounding box of object
								
								//oversize bounding box by 2m in all directions
								_tmpObjSize set [0, [((_tmpObjSize select 0) select 0) - _obstaclePadding, ((_tmpObjSize select 0) select 1) - _obstaclePadding, ((_tmpObjSize select 0) select 2) - _obstaclePadding]]; //min
								_tmpObjSize set [1, [((_tmpObjSize select 1) select 0) + _obstaclePadding, ((_tmpObjSize select 1) select 1) + _obstaclePadding, ((_tmpObjSize select 1) select 2) + _obstaclePadding]]; //max
								
								_tmpObjClassArr pushBack _tmpObjClass; //add class to array
								_tmpObjSizeArr pushBack _tmpObjSize; //add size to array
							} else {_tmpObjSize = _tmpObjSizeArr select _tmpClassIndex}; //recover size from array
							_tmpDir = getDir _tmpObj; //object direction
						};
						
						//bounding box corners
						_tmpArr = [	[(_tmpObjSize select 0) select 0, (_tmpObjSize select 0) select 1, 0], //point 0: xmin, ymin
												[(_tmpObjSize select 0) select 0, (_tmpObjSize select 1) select 1, 0], //point 1: xmin, ymax
												[(_tmpObjSize select 1) select 0, (_tmpObjSize select 1) select 1, 0], //point 2: xmax, ymax
												[(_tmpObjSize select 1) select 0, (_tmpObjSize select 0) select 1, 0]]; //point 3: xmax, ymin
						
						_tmpPointInArea = false;
						for "_i" from 0 to 3 do { //rotate bounding box loop
							_tmpRelPos = _tmpArr select _i; //point position
							_tmpRelDir = (_tmpRelPos select 1) atan2 (_tmpRelPos select 0); //relative direction between object center and current point
							_tmpRelDist = [0, 0] distance2D _tmpRelPos; //distance between object center and current point
							_tmpPointPos = [(_tmpPosASL select 0) + (_tmpRelDist * cos (_tmpRelDir - _tmpDir)), (_tmpPosASL select 1) + (_tmpRelDist * sin (_tmpRelDir - _tmpDir)), 0]; //current point position
							_tmpArr set [_i, _tmpPointPos]; //update XY point position
							if !(_tmpPointInArea) then {_tmpPointInArea = _tmpPointPos inPolygon _areaPolygonTmp}; //is current point in main area
						};
						
						if (_tmpPointInArea) then { //at least a point in main area
							_areaPolygonBacklistXmax pushBack selectMax [(_tmpArr select 0) select 0, (_tmpArr select 1) select 0, (_tmpArr select 2) select 0, (_tmpArr select 3) select 0];
							
							if (_tmpObj in _roadsInArea) then { //object in road array
								_areaPolygonRoads pushBack _tmpArr; //add current object polygon area to road polygon array
							} else {
								_areaPolygonBacklist pushBack _tmpArr; //add current object polygon area to blacklist polygon array
							};
							
							if (_tmpObjClass in _openDoorsClass) then { //force open all doors
								_tmpClassArr = getArray (configfile >> "CfgVehicles" >> _tmpObjClass >> "SimpleObject" >> "animate"); //class animate array
								_tmpArrCount = (count _tmpClassArr) - 1; //array count - 1
								_tmpDoor = 1; //current door
								for "_i" from 0 to _tmpArrCount do { //animate array loop
									_tmpDoorName = format ["door_%1_rot", _tmpDoor]; //parse current door name
									if (_tmpDoorName in (_tmpClassArr select _i)) then { //current door in array
										[_tmpObj, [_tmpDoorName, 1]] remoteExec ["animate", 0, true]; //global open door
										_tmpDoor = _tmpDoor + 1; //increment door index
									};
								};
							};
						};
					};
				} foreach _houseInArea + _objectsInArea + _roadsInArea;
				_houseInArea = nil; _objectsInArea = nil; _roadsInArea = nil; //unset unused array
				
				if (_areaDebug) then { //debug
					_debugTick = diag_tickTime - _debugTickStart;
					diag_log format ["area%1: blacklist polygons (%3) array generated: %2ms", _areaCount, _debugTick * 1000, count _areaPolygonBacklist];
					_debugTickStart = diag_tickTime;
				};
				
				//generate valid positions array, optimized as possible but still take a huge amount of time
				_tmpValidPosArr = []; //store temporary positions for item boxs and karts
				for "_tmpX" from _minX to _maxX step _areaGridSize do { //X loop
					for "_tmpY" from _minY to _maxY step _areaGridSize do { //Y loop
						_tmpPos = [_tmpX, _tmpY, 0]; //current position
						if (_tmpPos inPolygon _areaPolygonTmp && {_areaPolygonBacklist findIf {_tmpPos inPolygon _x} == -1}) then { //in main polygon and not in blacklisted polygons
							if !(((surfaceType _tmpPos) in _avoidSoilArr) && {_areaPolygonRoads findIf {_tmpPos inPolygon _x} == -1}) then { //allowed soil
								_tmpValidPosArr pushBack _tmpPos; //add current position to array
							};
						};
					};
					
					//delete no more needed blacklist polygon based on max X position
					if !(_areaDebug) then {
						_tmpArrOffset = 0; //element offset
						for "_i" from 0 to (count _areaPolygonBacklist) - 1 do { //array loop
							if ((_areaPolygonBacklistXmax select (_i - _tmpArrOffset)) < _tmpX) then { //element to delete
								_areaPolygonBacklist deleteAt (_i - _tmpArrOffset); //delete element
								_areaPolygonBacklistXmax deleteAt (_i - _tmpArrOffset); //delete element
								_tmpArrOffset = _tmpArrOffset + 1; //increment index offset
							};
						};
					};
				};
				
				if (_areaDebug) then { //debug
					_debugTick = diag_tickTime - _debugTickStart;
					diag_log format ["area%1: valid positions (%3) array generated : %2ms", _areaCount, _debugTick * 1000, count _tmpValidPosArr];
					_debugTickStart = diag_tickTime;
				};
				
				//extract only needed positions for item boxs
				_tmpItemBoxToExtract = ceil (_areaSize / _itemboxDensity); //final amount of item boxs
				_tmpItemBoxCount = 0; //element count
				while {_tmpItemBoxCount < _tmpItemBoxToExtract && {count _tmpValidPosArr > 0}} do {
					_tmpPos = selectRandom _tmpValidPosArr; //select a random position
					_itemPosArr pushBack _tmpPos; //add position to main array
					
					//delete positions around current item box
					_tmpArrOffset = 0; //element offset
					for "_i" from 0 to (count _tmpValidPosArr) - 1 do { //array loop
						if ((_tmpValidPosArr select (_i - _tmpArrOffset)) inArea [_tmpPos, _exclusionRadius, _exclusionRadius, 0, false]) then { //element in deletion area
							_tmpValidPosArr deleteAt (_i - _tmpArrOffset); //delete element
							_tmpArrOffset = _tmpArrOffset + 1; //increment index offset
						};
					};
					_tmpItemBoxCount = _tmpItemBoxCount + 1; //increment count
				};
				
				if (_areaDebug) then { //debug
					_debugTick = diag_tickTime - _debugTickStart;
					diag_log format ["area%1: itemboxs positions (%3) array generated: %2ms", _areaCount, _debugTick * 1000, count _itemPosArr];
					_debugTickStart = diag_tickTime;
				};
				
				//extract only needed positions for kart teleport
				_tmpKartCount = 0; //element count
				_kartCount = count _kartsList; //amount of karts
				while {_tmpKartCount < _kartCount && {count _tmpValidPosArr > 0}} do {
					_tmpPos = selectRandom _tmpValidPosArr; //select a random position
					_tmpPos set [2, 2]; //set Z to 2m
					_kartPosArr pushBack _tmpPos; //add position to main array
					
					//delete positions around current kart
					_tmpArrOffset = 0; //element offset
					for "_i" from 0 to (count _tmpValidPosArr) - 1 do { //array loop
						if ((_tmpValidPosArr select (_i - _tmpArrOffset)) inArea [_tmpPos, _exclusionRadius, _exclusionRadius, 0, false]) then { //element in deletion area
							_tmpValidPosArr deleteAt (_i - _tmpArrOffset); //delete element
							_tmpArrOffset = _tmpArrOffset + 1; //increment index offset
						};
					};
					
					_tmpKartCount = _tmpKartCount + 1; //increment count
				};
				
				if (_areaDebug) then { //debug
					_debugTick = diag_tickTime - _debugTickStart;
					diag_log format ["area%1: karts positions (%3) array generated: %2ms", _areaCount, _debugTick * 1000, count _kartPosArr];
					_debugTickStart = diag_tickTime;
				};
				
				if ((count _itemPosArr) > 0 && {(count _kartPosArr) == _kartCount}) then { //area have items and right amount of karts position
					for "_i" from 0 to (count _itemPosArr) - 1 do { //generate itembox for current area loop
						_tmpPos = _itemPosArr select _i; //item box position
						_tmpPos set [2, (getTerrainHeightASL _tmpPos) + 0.5]; //proper ASL position
						_tmpObj = createSimpleObject ["Land_Balloon_01_air_F", _tmpPos]; //create item box
						[_tmpObj, [0,"notMarioKartKnockoff\img\objs\itembox.paa"]] remoteExec ["setObjectTexture", 0, true]; //set global texture
						_tmpObj setPosASL _tmpPos; //re-set object position
						_tmpObj setDir (random 360); //random starting direction
						_tmpObj setVariable ["picked", false, true]; //item already picked var
						_tmpObj setVariable ["MKK_triggered", false]; //item triggered var
						_tmpObj setVariable ["MKK_triggerTime", 0]; //item triggered time var
				    _itemObjArr pushBack _tmpObj; //add item box to array
					};
					
					//create marker in center of area polygon
					_tmpMarker = createMarker [format ["MKK_area%1", _areaCount], _areaPolygonCenter]; //create marker
					_tmpMarker setMarkerColor "ColorGreen"; //set color
					_tmpMarker setMarkerType "mil_dot"; //set type
					_tmpMarker setMarkerText format [localize "STR_MKK_Area_title", _areaCount + 1]; //set text
					
					_areaPolygonsArr pushBack _areaPolygon; //add polygons array to area array
					if (_areaDebug) then {_areaSafePolygonsArr pushBack _areaSafePolygon}; //debug
					if (_areaDebug) then {_areaPolygonsBlacklistArr pushBack _areaPolygonBacklist}; //debug
					_areaPosArr pushBack _areaPolygonCenter; //add polygons center to area array
					_areaItemboxsArr pushBack _itemObjArr; //add item box array to area array
					_areaKartsPosArr pushBack _kartPosArr; //add karts initial position to area array
					_areaSizesArr pushBack _areaSize; //add area size to area array
					_areaCount = _areaCount + 1; //increment area count
				};
				
				//unset not more used vars
				_areaPolygon = nil;
				_areaSafePolygon = nil;
				_areaPolygonTmp = nil;
				_areaPolygonBacklist = nil;
				_areaPolygonRoads = nil;
				_areaSize = nil;
				_kartPosArr = nil;
				_itemObjArr = nil;
				_itemPosArr = nil;
				_tmpValidPosArr = nil;
				
				if (_areaDebug) then { //debug
					_debugTick = diag_tickTime - _debugTickStart;
					diag_log format ["area%1: itemboxs objects, public globals and cleanup generated: %2ms", _areaCount - 1, _debugTick * 1000];
				};
			};
		} else {[format ["notMarioKartKnockoff.sqf: Unit '%1', not enough waypoints, got %2, need at least 3", _x, count _areaPolygon]] call NNS_fnc_debugOutput}; //debug
	};
} forEach _syncAreaUnits;

//unset not more used vars
_tmpObjClassArr = nil;
_tmpObjSizeArr = nil;

if (_areaDebug) then { //area debug feature enable
	areaCount = _areaCount; //area count
	areaSafePolygonsArr = _areaSafePolygonsArr; //area safe polygons array
	areaPolygonsBlacklistArr = _areaPolygonsBlacklistArr; //area blacklists polygons array

	findDisplay 12 displayCtrl 51 ctrlAddEventHandler ["Draw", { //draw on map event handler
		params ["_control"]; //control var
		for "_i" from 0 to (areaCount - 1) do { //areas loop
			_tmpSafePolygonArr = areaSafePolygonsArr select _i; //current area safe polygon
			_tmpBlacklistArr = areaPolygonsBlacklistArr select _i; //current area blacklists polygons
			_control drawPolygon [_tmpSafePolygonArr, [0,0,1,1]]; //draw area safe polygon
			{_control drawPolygon [_x, [1,0,0,1]]} forEach _tmpBlacklistArr; //draw area blacklists polygons
		};
	}];
};

missionNamespace setVariable ["MKK_areaGenerated", -1, true]; //area generated, warn players while not -1

//unset not more used vars
_tmpObjClassArr = nil;
_tmpObjSizeArr = nil;

if (_areaCount == 0) exitWith {["notMarioKartKnockoff.sqf: Failed, no play area generated"] call NNS_fnc_debugOutput};
missionNamespace setVariable ["MKK_areaSizesArr", _areaSizesArr, true]; //areas size array
missionNamespace setVariable ["MKK_areaPosArr", _areaPosArr, true]; //areas position array
missionNamespace setVariable ["MKK_areaKartsPosArr", _areaKartsPosArr, true]; //karts position in areas array
missionNamespace setVariable ["MKK_areaPolyArr", _areaPolygonsArr, true]; //areas polygons array

//Itembox routine
missionNamespace setVariable ["MKK_boxs", _areaItemboxsArr, true]; //item boxs array
[_areaItemboxsArr, _itemboxRespawn] spawn {
	params ["_areaItemboxsArr", "_itemboxRespawn"];
	_loop = 0; //count loop to avoid useless checks
	while {sleep 0.2; true} do { //spawn for item box interaction
		if (MKK_area != -1 && {MKK_mode != -1} && {MKK_modeRules != -1}) then { //area selected and round in progress
			_itemboxArr = _areaItemboxsArr select MKK_area; //recover itemboxs array
			_itemboxCount = (count _itemboxArr) - 1; //itemboxs count - 1
			for "_i" from 0 to _itemboxCount do { //objects loop
				_tmpItembox = _itemboxArr select _i; //recover object
				_triggered = (_tmpItembox getVariable "MKK_triggered"); //trigger var from array
				
				if (_loop == 1 && {!(_tmpItembox getVariable "MKK_triggered")} && {_tmpItembox getVariable "picked"}) then { //0.2sec loop, not triggered but picked var set
					_tmpItembox setVariable ["MKK_triggered", true]; //update trigger bool
					_tmpItembox setVariable ["MKK_triggerTime", ceil ((call MKK_fnc_time) + _itemboxRespawn)]; //update trigger time
					_tmpItembox hideObjectGlobal true; //hide object
					[format ["notMarioKartKnockoff.sqf: %1 picked", _tmpItembox]] call NNS_fnc_debugOutput; //debug
				};
				
				if (_loop == 2) then { //0.6sec loop and box is triggered
					if ((_tmpItembox getVariable "MKK_triggered") && {(call MKK_fnc_time) > (_tmpItembox getVariable "MKK_triggerTime")}) then { //box is triggered and trigger expired
						_tmpItembox hideObjectGlobal false; //show object
						_tmpItembox setVariable ["picked", false, true]; //reset picked var
						_tmpItembox setVariable ["MKK_triggered", false]; //reset trigger bool
						[format ["notMarioKartKnockoff.sqf: %1 available again", _tmpItembox]] call NNS_fnc_debugOutput; //debug
					};
				};
			};
		};
		
		if (_loop == 2) then {_loop = 0} else {_loop = _loop + 1}; //reset loop count or increment
	};
};

//kart and players routine
[_kartsList, _areaKartsPosArr, _modePointsArr, _areaPolygonsArr] spawn {
	params ["_kartsList", "_areaKartsPosArr", "_modePointsArr", "_areaPolygonsArr"];
	
	_kartCount = (count _kartsList) - 1; //vehicle count -1
	
	for "_i" from 0 to _kartCount do { //kart loop
		_kart = _kartsList select _i; //recover kart object
		//_kart lock 3; //lock vehicle
		_kart allowDamage false; //disable damage
		(driver _kart) allowDamage false; //disable driver damage
		[_kart, 0] remoteexec ["setFuel", _kart]; //empty tank
		[_kart, (getMass _kart) * 0.85] remoteexec ["setMass", _kart]; //reduce vehicle mass by 15%
		_kart setVariable ["startPos", getPos _kart, true]; //backup initial position
		_kart setVariable ["index", _i, true]; //backup kart index
	};
	
	while {sleep 1; true} do { //main loop
		for "_i" from 0 to _kartCount do {
			_veh = _kartsList select _i; //recover vehicle object
			if (damage _veh > 0.97) then {
				_tmpVar = vehicleVarName _veh; //backup vehicle variable name
				_tmpPos = getPos _veh; //backup vehicle position
				_tmpDir = getDir _veh; //backup vehicle direction
				_tmpClass = typeOf _veh; //backup vehicle class
				_tmpInitialPos = _veh getVariable ["startPos", _tmpPos]; //backup initial position
				_veh setPos [0,0,0]; //move vehicle far away
				
				_tmpVeh = createVehicle [_tmpClass, _tmpPos, [], 0, "CAN_COLLIDE"]; //create vehicle
				_tmpVeh setDir _tmpDir; //restore direction
				_tmpVeh allowDamage false; //disable vehicle damage
				_tmpVeh setVariable ["startPos", _tmpInitialPos, true]; //backup initial position
				if !(_tmpVar == "") then {[_tmpVeh, _tmpVar] remoteexec ["setVehicleVarName", _tmpVeh]}; //set global name
				_kartsList set [_i, _tmpVeh]; //update kart array
				missionNamespace setVariable ["MKK_karts", _kartsList, true]; //karts global array
				deleteVehicle _veh; //delete destroyed vehicle
				
				[format ["notMarioKartKnockoff.sqf: '%1' restored", _tmpVar]] call NNS_fnc_debugOutput; //debug
			};
			
			_vehDriver = driver _veh; //recover driver object
			if (!(isNull _vehDriver) && {_vehDriver in allPlayers}) then { //vehicle has a driver, driver is a player
				if (!(_vehDriver getVariable ["MKK_inKart", false])) then { //player not initialized
					_vehDriver setVariable ["MKK_inKart", true, true]; //set player in kart var
					_vehDriver setVariable ["MKK_vote", 0, true]; //set player vote var
					_vehDriver setVariable ["MKK_team", -1, true]; //set player team var
					_vehDriver setVariable ["MKK_points", 0, true]; //set default player points var
					{_null = execVM "notMarioKartKnockoff\notMarioKartKnockoff_player.sqf"} remoteExec ["call", _vehDriver]; //remote exec vm on client
					
					[format ["notMarioKartKnockoff.sqf: %1 entered kart %2", _vehDriver, _veh]] call NNS_fnc_debugOutput; //debug
				} else { //player initialized
					_vehPos = getPos _veh; //vehicle position
					if (MKK_area != -1 && {!(_vehPos inPolygon (_areaPolygonsArr select MKK_area))}) then { //vehicle not in play area
						_veh setDir (random 360); //random direction
						_veh setPos ((_areaKartsPosArr select MKK_area) select _i); //teleport
					};
					
					if (!(canMove _veh) || {(_vehPos select 2) < -0.5}) then { //player vehicle can't move or under ground
						_vehPos set [2, 2]; //update Z position
						_veh setPos _vehPos; //put back on wheel
					};
				};
			};
		};
	};
};

//game mode routine
[_kartsList, _areaKartsPosArr, _minPlayers, _modeCount, _areaCount, _modePointsArr, _modePointsLimitArr, _modeDurationArr, _areaVoteDuration, _voteDuration, _teamDuration, _introDuration, _scoreDuration] spawn {
	params ["_kartsList", "_areaKartsPosArr", "_minPlayers", "_modeCount", "_areaCount", "_modePointsArr", "_modePointsLimitArr", "_modeDurationArr", "_areaVoteDuration", "_voteDuration", "_teamDuration", "_introDuration", "_scoreDuration"];
	
	waitUntil {sleep 1; !isNil "MKK_mode" && {!isNil "MKK_modeRules"}}; //wait for global to be set
	
	_timeResult = 0; //default time vote result
	_areaResult = 1; //default area vote result
	_modeResult = 1; //default mode vote result
	_modeParamsResult = 0; //default parameters vote result
	_kartCount = (count _kartsList) - 1; //kart count - 1
	
	while {sleep 1; true} do { //main loop
		_validPlayersCount = {(vehicle _x) in _kartsList && {(_x getVariable ["MKK_init", false])}} count allPlayers; //valid players count
		if (_validPlayersCount < _minPlayers) then { //not enough players
			[[_minPlayers - _validPlayersCount], {[localize "STR_MKK_server", format [localize "STR_MKK_waitforplayers", _this select 0]] call MKK_fnc_displaySubtitle}] remoteExec ["BIS_fnc_call", 0];
			sleep 5; //wait a bit
		} else {
			//vote : day time
			if (MKK_time == -1) then { //not forced day time
				["notMarioKartKnockoff.sqf: start day time vote"] call NNS_fnc_debugOutput; //debug
				missionNamespace setVariable ["MKK_voteTimeEnd", ceil ((call MKK_fnc_time) + _voteDuration), true]; //set end time for vote
				waitUntil {sleep 1; (call MKK_fnc_time) >  MKK_voteTimeEnd}; //vote expired
				_timeResult = ["MKK_vote", allPlayers, 2] call MKK_fnc_votes; //get vote result
				missionNamespace setVariable ["MKK_time", _timeResult, true]; //set new area
			} else {_timeResult = MKK_time}; //forced
			if (_timeResult == 0) then {skipTime (12 - daytime + 24) % 24}; //day, set to 12:00
			if (_timeResult == 1) then {skipTime (22 - daytime + 24) % 24}; //night, set to 22:00
			[0] call BIS_fnc_setOvercast; //clear weather
			
			//vote : area
			if (MKK_area == -1) then { //not forced game mode
				["notMarioKartKnockoff.sqf: start area vote"] call NNS_fnc_debugOutput; //debug
				missionNamespace setVariable ["MKK_voteAreaEnd", ceil ((call MKK_fnc_time) + _areaVoteDuration), true]; //set end time for vote
				waitUntil {sleep 1; (call MKK_fnc_time) >  MKK_voteAreaEnd}; //vote expired
				_areaResult = ["MKK_vote", allPlayers, _areaCount] call MKK_fnc_votes; //get vote result
				missionNamespace setVariable ["MKK_area", _areaResult, true]; //set new area
				
				for "_i" from 0 to _kartCount do { //teleport karts to new area
					_veh = _kartsList select _i; //recover vehicle object
					if ((driver _veh) getVariable ["MKK_init", false]) then { //player in kart
						_veh setDir (random 360); _veh setPos ((_areaKartsPosArr select MKK_area) select _i); //random direction and teleport
					};
				};
			} else {_areaResult = MKK_area}; //forced
			
			//vote : game mode
			if (MKK_mode == -1) then { //not forced game mode
				["notMarioKartKnockoff.sqf: start game mode vote"] call NNS_fnc_debugOutput; //debug
				missionNamespace setVariable ["MKK_voteModeEnd", ceil ((call MKK_fnc_time) + _voteDuration), true]; //set end time for vote
				waitUntil {sleep 1; (call MKK_fnc_time) > MKK_voteModeEnd}; //vote expired
				_modeResult = ["MKK_vote", allPlayers, _modeCount] call MKK_fnc_votes; //get vote result
				if (_modeResult == 0) then {_modeResult = round (1 + random (_modeCount - 2))}; //random mode
				missionNamespace setVariable ["MKK_mode", _modeResult, true]; //set new game mode
			} else {_modeResult = MKK_mode}; //forced
			
			//vote : game mode parameters
			if (MKK_modeRules == -1) then { //not forced game parameters
				["notMarioKartKnockoff.sqf: start parameters vote"] call NNS_fnc_debugOutput; //debug
				missionNamespace setVariable ["MKK_voteRulesEnd", ceil ((call MKK_fnc_time) + _voteDuration), true]; //set end time for vote
				_modeParamsCount = count (_modePointsArr select _modeResult); //count available parameters for current mode
				waitUntil {sleep 1; (call MKK_fnc_time) > MKK_voteRulesEnd}; //vote expired
				_modeParamsResult = ["MKK_vote", allPlayers, _modeParamsCount] call MKK_fnc_votes; //get vote result
			} else {_modeParamsResult = MKK_modeRules}; //forced
			
			//game mode parameters
			_modeDuration = (_modeDurationArr select _modeResult) select _modeParamsResult; //new game mode duration
			_modePointsLimit = (_modePointsLimitArr select _modeResult) select _modeParamsResult; //points limit before round end
			missionNamespace setVariable ["MKK_modeRules", _modeParamsResult, true]; //set new game mode rules
			
			//team deathmatch
			if (_modeResult == 3) then {
				["notMarioKartKnockoff.sqf: start team selection"] call NNS_fnc_debugOutput; //debug
				missionNamespace setVariable ["MKK_teamEnd", ceil ((call MKK_fnc_time) + _teamDuration), true]; //set end time for team selection
				waitUntil {sleep 1; (call MKK_fnc_time) > MKK_teamEnd}; //selection expired
			};
			
			//intro
			["notMarioKartKnockoff.sqf: start intro"] call NNS_fnc_debugOutput; //debug
			missionNamespace setVariable ["MKK_introEnd", ceil ((call MKK_fnc_time) + _introDuration), true]; //set end time for intro
			missionNamespace setVariable ["MKK_roundEnd", MKK_introEnd + _modeDuration, true]; //set end time for current round
			
			waitUntil {sleep 1; (call MKK_fnc_time) > MKK_introEnd}; //wait for intro to finish
			
			//round
			["notMarioKartKnockoff.sqf: start round"] call NNS_fnc_debugOutput; //debug
			_roundFinished = false; //used to kill loop when points limit hit
			while {sleep 1; !((call MKK_fnc_time) > MKK_roundEnd) && {!_roundFinished}} do { //end of round loop
				if (isMultiplayer) then { //only apply mode specific rules to multiplayer
					if (_modeResult == 1) then {_roundFinished = {_x getVariable ["MKK_init", false] && {_x getVariable ["MKK_points", 0] > 0}} count allPlayers < 2}; //balloon mode, 1 player remain
					if (_modeResult == 2) then {_roundFinished = {_x getVariable ["MKK_init", false] && {_x getVariable ["MKK_points", 0] > (_modePointsLimit - 1)}} count allPlayers > 0}; //deathmatch, a player over points limit
					if (_modeResult == 3) then { //team deathmatch
						_teamsPointsArr = [-999,-999,-999,-999]; //reset teams scores array, -999 used to identify empty teams
						{ //all players loop
							if (_x getVariable ["MKK_init", false] && {_x getVariable ["MKK_team", -1] != -1}) then { //player in a kart, team set with points over 0
								_tmpTeam = _x getVariable "MKK_team"; _tmpPoints = _x getVariable "MKK_points"; //recover player selected team and points
								_tmpTeamPoints = _teamsPointsArr select _tmpTeam; if (_tmpTeamPoints == -999) then {_tmpTeamPoints = 0}; //init team score if needed
								_teamsPointsArr set [_tmpTeam, _tmpTeamPoints + _tmpPoints]; //add player points to its team
							};
						} forEach allPlayers;
						if (({_x == -999} count _teamsPointsArr) == 3) then {_roundFinished = true; //3 empty team, finish
						} else {_teamsPointsArr sort false; _roundFinished = (_teamsPointsArr select 0) > (_modePointsLimit - 1)}; //first team over points limit
					};
				};
			};
			
			if (_roundFinished) then {missionNamespace setVariable ["MKK_roundEnd", call MKK_fnc_time, true]}; //round finished because limits hit, update round end time
			
			//score
			["notMarioKartKnockoff.sqf: start score"] call NNS_fnc_debugOutput; //debug
			missionNamespace setVariable ["MKK_scoreEnd", ceil ((call MKK_fnc_time) + _scoreDuration), true]; //end time for score screen
			waitUntil {sleep 1; (call MKK_fnc_time) > MKK_scoreEnd}; //score screen expired
			
			//reset variables
			["notMarioKartKnockoff.sqf: reset global vars"] call NNS_fnc_debugOutput; //debug
			missionNamespace setVariable ["MKK_voteTimeEnd", -1, true];
			missionNamespace setVariable ["MKK_voteAreaEnd", -1, true];
			missionNamespace setVariable ["MKK_voteModeEnd", -1, true];
			missionNamespace setVariable ["MKK_voteRulesEnd", -1, true];
			missionNamespace setVariable ["MKK_teamEnd", -1, true];
			missionNamespace setVariable ["MKK_introEnd", -1, true];
			missionNamespace setVariable ["MKK_roundEnd", -1, true];
			missionNamespace setVariable ["MKK_time", -1, true];
			missionNamespace setVariable ["MKK_area", -1, true];
			missionNamespace setVariable ["MKK_mode", -1, true];
			missionNamespace setVariable ["MKK_modeRules", -1, true];
			missionNamespace setVariable ["MKK_scoreEnd", -1, true];
		};
	};
};
