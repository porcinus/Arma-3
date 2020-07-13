/*
NNS
Populate most buildings on the map.
Work using a chunk system to reduce load as most as possible. But still use a massive amount of memory because script need to store every single buildings pointer.
Choise to use chunks avoid risk of populate or clean same chunk multiple time during the same loop.
Many optimizations need to be done but script look stable for now.

How it work (hope I will not miss to many things):
- The map "split" into chunks of given size (250m² by default).
- When script start, it will look at all objects of kind "House" and apply "filters" :
	- Not in ignore class array.
	- Need to have "positions in building" (buildingPos function).
	- Need to be bigger than specified X-Y size (10m each by default).
- Valid buildings are placed into a array for each chunks.
- Empty chunks are placed into a "ignore array".
- When populate loop start:
	- Position and direction of every players on the map is backup and compare later to compute a displacement vector.
	- A virtual line is drawn and each chunks at given chunk distance (2 by default) are marked as "to populate".
	- Work on unit base, if you have players all over the map, chunks will be populated all over the map. work with ground vehicle, disable for other kinds.
	- Every chunks over populate chunk distance (2 by default) will be marked for reset to avoid useless ressource (and groups) usage.
	- When loop start to populate "to populate" chunks, it will loop at linked objects array and start to do its thing (destroy buildings will be remove at each loop).
	- When a building start to be populated, damage is disable until it is populated.

Notes:
- _class can be parent config path (e.g. configfile >> "CfgGroups" >> "West" >> "BLU_F" >> "Infantry"), in this case, groups will be selected randomly.
- If _class = "", script will use "default" class, only work with west,east,resistance,independent sides.
- Avoid using _chunkSize under 200m², keep in mind the that dividing chunk size by 2 increase ressources usage (CPU,Memory,Network) by a factor of 4.
- Note all selected buildings will be populated, look at _populateChance,_buildingPosMin,_buildingPosMax params for this.
- If groups count on the server goes over _groupsLimit, this script will continue to work but do nothing until everything goes back to normal.
- if _oneGroupPerChunk set to true, weird behave could happen but highly decrease groups count.
- If _populateChance set to -1, script will decide on its own the "right" chance value based on objects in chunk. 60% if objects count = median, 10% for highest objects count.
- To kill the script, set global NNSkillPopulatedMapLoop to true.

Example :
	Populate using default settings:
		_null = execVM "scripts\PopulateMapBuildings.sqf"
	
	Populate using random CSAT units:
		_null = [10, east, configfile >> "CfgGroups" >> "East" >> "OPF_F" >> "Infantry"] execVM "scripts\PopulateMapBuildings.sqf"

	Populate using CSAT units with West side:
		_null = [10, west, [configfile >> "CfgGroups" >> "East" >> "OPF_F" >> "Infantry" >> "OIA_InfSquad"]] execVM "scripts\PopulateMapBuildings.sqf"

Dependencies:
	in description.ext:
		class CfgFunctions {
			class NNS {
				class missionfunc {
					file = "nns_functions";
					class debugOutput {};
					class AIskill {};
				};
			};
		};

	nns_functions folder:
		fn_debugOutput.sqf
		fn_AIskill.sqf
		
	script folder:
		LimitEquipment.sqf
		PopulateMapBuildings.sqf
*/

params [
	["_detectInterval",10], //populate interval
	["_side",west], //spawned units side
	["_class",""], //spawned group class
	["_oneGroupPerChunk",true], //create a single group for a whole chunk
	["_spawnPatrol",true], //allow to sometime spawn one or more patrols
	["_chunkSize",250], //chunk size in m2
	["_classesToIgnore",[]], //objects class to ignore
	["_minObjectWH",10], //minimum X-Y object size
	["_populatePadding",2], //chunk padding to populate, >0 needed
	["_populateChance",-1], //amount of change to spawn units in a building
	["_buildingPosMin",0.3], //minimum used position in building (can be round to 0)
	["_buildingPosMax",0.7], //maximum used position in building
	["_groupsLimit",220], //max 288 since v1.67
	["_debug",false], //enable debug
	["_debugSpawnEveryone",false] //spawn every units possible, use at your own risk
];

if (_detectInterval < 1) then {_detectInterval = 10};

if (!(_class isEqualType []) || ((count _class) == 0)) then { //_class is not a array or empty array
	if ((count _class) == 0) then { //empty class
		_defaultSide = [west,east,resistance,independent]; //default sides
		_defaultClass = [ //default units classes
		configfile >> "CfgGroups" >> "West" >> "BLU_F" >> "Infantry",
		configfile >> "CfgGroups" >> "East" >> "OPF_F" >> "Infantry",
		configfile >> "CfgGroups" >> "Indep" >> "IND_G_F" >> "Infantry",
		configfile >> "CfgGroups" >> "Indep" >> "IND_F" >> "Infantry"];
		_sideIndex = _defaultSide find _side;
		if !(_sideIndex == -1) then {
			_class = _defaultClass select _sideIndex; //side found, use a default class
			[format["PopulateMapBuildings.sqf: _class set by script : %1", _class]] call NNS_fnc_debugOutput; //debug
		};
	};
};

if (!(_class isEqualType []) && {isClass _class}) then { //_class is a config class, try to get groups entries
	_baseClass = _class; //backup config path
	_baseClassCount = count _class; //entry count
	_foundClasses = []; //"valid" class found
	
	if (_baseClassCount > 0) then { //current config path has entries
		_valid = true; //current entry is valid
		for "_i" from 0 to (_baseClassCount - 1) do { //seek thru entries
			if (_valid) then { //still valid
				_currEntry = _baseClass select _i; //backup current "entry"
				if (isClass _currEntry) then { //not a "field"
					_entryName = configName _currEntry; //get entry name
					_entryCount = count _currEntry; //sub entries count
					for "_j" from 0 to (_entryCount - 1) do { //seek thru entries
						if (_valid) then { //still valid
							_subEntryName = configName (_currEntry select _j); //get sub entry name
							if (toLower (_subEntryName) == "vehicle") then {_valid = false}; //contain vehicle entry, no more valid
						};
					};
					if (_valid) then {_foundClasses pushBack _currEntry}; //not failed so far, add to found classes
				};
			};
		};
	};
	
	if (count _foundClasses > 0) then { //some "valid" classes found
		_class = _foundClasses; //set main class array to found entries
		[format["PopulateMapBuildings.sqf: _class generated via config : %1", _class]] call NNS_fnc_debugOutput; //debug
	};
};

if (!(_class isEqualType []) && {count _class > 0}) then {_class = [_class]}; //class still not a array, convert string to array
if (!(_class isEqualType []) || {(count _class) == 0}) exitWith {["PopulateMapBuildings.sqf: fail to found proper group class"] call NNS_fnc_debugOutput}; //totally failed
[format["PopulateMapBuildings.sqf: _class : %1", _class]] call NNS_fnc_debugOutput; //debug

[format["PopulateMapBuildings.sqf: set to one group per %1", ["building","chunk"] select (_oneGroupPerChunk)]] call NNS_fnc_debugOutput; //debug

_autoPopulateChance = false;
if (_populateChance == -1) then {
	_autoPopulateChance = true;
	["PopulateMapBuildings.sqf: building population based on amount objects in chuck"] call NNS_fnc_debugOutput;
};

if (_populatePadding < 1) then {_populatePadding = 2};
if (_populateChance < 0.1) then {_populateChance = 0.1};
if (_buildingPosMin < 0) then {_buildingPosMin = 0};
if (_buildingPosMax > 1) then {_buildingPosMax = 1};
if (_groupsLimit > 270) then {["PopulateMapBuildings.sqf: warning, very high groups limit (288 max since v1.67)"] call NNS_fnc_debugOutput};

fn_rectMarker = { //create a rectangular marker: [pos,width,height,color,alpha,text] call fn_rectMarker;
	params [["_pos", objNull],["_w", 0],["_h", 0],["_color", "ColorRed"],["_a", 1],["_name", ""],["_text", ""]];
	missionNamespace setVariable ["NNSPMBmkrCnt", (missionNamespace getVariable ["NNSPMBmkrCnt", 0]) + 1];
	if !(_pos isEqualType []) then {_pos = getPos _pos}; //object
	if (_name == "") then {_name = format ["mrk%1%2%3", round(random 1000), round(random 1000), round(random 1000)]}; //random name if not set
	private _tmpMarker = createMarker [_name, _pos]; //create marker
	_name setMarkerColor _color; //set color
  _name setMarkerAlpha _a; //set alpha
	_name setMarkerShape "RECTANGLE"; //set shape
	_name setMarkerBrush "SolidBorder";
	_name setMarkerSize [_w, _h]; //set size
	if !(_text == "") then { //need a additionnal marker to show text
		private _tmpname = format ["%1txt", _name];
		private _tmpMarkerText = createMarker [_tmpname, _pos]; //create marker
		_tmpname setMarkerColor "ColorRed"; //set color
		_tmpname setMarkerType "mil_dot"; //set type
		_tmpname setMarkerText _text; //set text
	};
	_name //return marker name
};

fn_marker = { //create a marker: [pos,dir,"ColorRed","mil_destroy","foo"] call fn_marker;
	params [["_pos", objNull],["_dir", 0],["_color", "ColorRed"],["_type", "mil_destroy"],["_text", ""]];
	missionNamespace setVariable ["NNSPMBmkrCnt", (missionNamespace getVariable ["NNSPMBmkrCnt", 0]) + 1];
	if !(_pos isEqualType []) then {_pos = getPos _pos}; //object
	private _tmpMarkerName = format ["mrk%1%2%3%4", round(random 1000), round(random 1000), round(random 1000), round(random 1000)]; //random name
	private _tmpMarker = createMarker [_tmpMarkerName, _pos]; //create marker
	_tmpMarkerName setMarkerColor _color; //set color
	_tmpMarkerName setMarkerType _type; //set type
	_tmpMarkerName setMarkerDir _dir; //set direction
	_tmpMarkerName setMarkerText _text; //set text
	_tmpMarkerName //return marker name
};

//players
_playersUID = []; //store players UID, used for unit direction
_playersPos = []; //store players position
_playersDir = []; //store players direction

//world chunks
_worldSize = worldSize; //get world width computed by engine
_worldChunks = ceil (_worldSize/_chunkSize); //W/H map chunks count
_worldChunksX = []; //debug, store X for chunk
_worldChunksY = []; //debug, store Y for chunk
_worldChunksCount = _worldChunks ^ 2; //total amount of chunks for the whole map
_chunksEmpty = []; //store what chunks contain no objects
_chunksPopulated = []; //store what chunks are already populated
_chunksToResetBase = []; //store what chunks that need to be reset, used to avoid useless array creation at each detection loop
_chunksObjects = []; //array pointing to each chunk objects
_chunksObjectsToDelete = []; //array with objects to delete (destroyed of other)
_chunksGroups = []; //array pointing to each chunk groups

//objects detection
_tmpX = 0; //debug, X position for chunk
_tmpY = 0; //debug, Y position for chunk
for "_i" from 0 to (_worldChunksCount - 1) do { //loop to prepare each chunk objects arrays
	_worldChunksX pushback _tmpX; //add X position
	_worldChunksY pushback _tmpY; //add Y position
	_tmpX = _tmpX + 1; //increment X position
	if (_tmpX > _worldChunks - 1) then {_tmpX = 0; _tmpY = _tmpY + 1}; //out of bound, reset X position, increment Y position
	
	_arrayName = format ["chunkObj%1", _i]; //name of array
	missionNamespace setVariable [_arrayName, []]; //define array
	_chunksObjects append [missionNamespace getVariable _arrayName]; //add array pointer to main objects array
	
	_arrayName = format ["chunkGrp%1", _i]; //name of array
	missionNamespace setVariable [_arrayName, []]; //define array
	_chunksGroups append [missionNamespace getVariable _arrayName]; //add array pointer to main groups array
};

_objectList = nearestTerrainObjects [[_worldSize/2, _worldSize/2], ["House"], _worldSize, false, true]; //get all objects on map, oversized detection radius
//_objectList = [_worldSize/2, _worldSize/2] nearObjects ["House", _worldSize]; //get all objects on map, oversized detection radius
_buildingsClasses = []; //building classes with "position in building"
{ //object to chunk loop
	_tmpType = typeOf _x; //backup object type
	if !(_tmpType in _classesToIgnore) then { //object class not in ignore array
		_toAdd = false; //add in chuck list bool
		if (damage _x < 1) then { //object not destroyed
			if !(_tmpType in _buildingsClasses) then { //object class not in valid classes array
				if (count (_x buildingPos -1) == 0) then {_classesToIgnore pushBack _tmpType; //building has no "position in building", add to ignore array
				} else { //building has "position in building"
					_tmpSize = (boundingBox _x); //get object size
					_tmpXsize = abs (((_tmpSize select 1) select 0) - ((_tmpSize select 0) select 0)); //x size
					_tmpYsize = abs (((_tmpSize select 1) select 1) - ((_tmpSize select 0) select 1)); //y size
					if (_tmpXsize > _minObjectWH && _tmpYsize > _minObjectWH) then { //object big enough
						_buildingsClasses pushBack _tmpType; //add to array
						_toAdd = true; //set to valid
					};
				};
			} else {_toAdd = true}; //class in valid list
		};
		
		_tmpPos = getPos _x; //object position
		_tmpX = floor ((_tmpPos select 0) / _chunkSize); //X chunk position
		_tmpY = floor ((_tmpPos select 1) / _chunkSize); //Y chunk position
		_tmp = ((_tmpY * _worldChunks) + _tmpX); //cumulative chunk
		if (_toAdd) then { //contain objects
			_currChunkArray = _chunksObjects select _tmp; //array pointer
			_currChunkArray pushBack _x; //add object to right array
			if (_debug) then {[_tmpPos,0,"ColorPink","mil_dot"] call fn_marker}; //debug: object marker
		} else { //no object
			missionNamespace setVariable [format ["chunkObj%1", _tmp], nil]; //unset chunk objects array variable
			missionNamespace setVariable [format ["chunkGrp%1", _tmp], nil]; //unset chunk groups array variable
		};
	};
} forEach _objectList;

_objectList = nil; _buildingsClasses = nil; _classesToIgnore = nil; //no more used, free memory

//mark empty chunk
_chunksWithObjectsCount = 0; //amount of chunks with objects detected
_biggestChunkCount = 0; //biggest amount of objects in a chunk
_objectsCount = 0; //amount of objects detected
for "_i" from 0 to (_worldChunksCount - 1) do {
	_tmpCount = count (_chunksObjects select _i); //amount of objects in current chunk
	_tmpName = format ["mrkChunk%1", _i]; //marker name, used for debug
	_tmpText = ""; //marker name, used for debug
	if (_debug) then { //debug enable
		_tmpPos = [(((_worldChunksX select _i) * _chunkSize) + (_chunkSize / 2)),(((_worldChunksY select _i) * _chunkSize) + (_chunkSize / 2))]; //center position of current chunk
		if (_tmpCount > 0) then {_tmpText = format ["%1: %2", _i, _tmpCount]};
		[_tmpPos, _chunkSize/2, _chunkSize/2, "ColorGreen", 0.7, _tmpName, _tmpText] call fn_rectMarker; //create marker
	};
	
	if (_tmpCount == 0) then { //no object, mark chunk as populated
		_chunksEmpty pushBack _i; //add to empty chunk
		_chunksToResetBase pushback false; //don't allow current chunk to be reset
		if (_debug) then {_tmpName setMarkerColor "ColorRed"}; //change marker color
	} else { //has objects
		_chunksToResetBase pushback true; //allow current chunk to be reset
		_objectsCount = _objectsCount + _tmpCount; //increment objects count
		_chunksWithObjectsCount = _chunksWithObjectsCount + 1; //increment chunks with objects count
		if (_tmpCount > _biggestChunkCount) then {_biggestChunkCount = _tmpCount}; //update biggest amount of objects in a chunk
	};
};

_medianObjectsPerChunk = round (_objectsCount / _chunksWithObjectsCount); //median amount of objects per chunk

[format["PopulateMapBuildings.sqf: _worldSize:%1, _worldChunks:%2, _worldChunksCount:%3", _worldSize, _worldChunks, _worldChunksCount]] call NNS_fnc_debugOutput; //debug
[format["PopulateMapBuildings.sqf: %1 chunks with objects", _chunksWithObjectsCount]] call NNS_fnc_debugOutput; //debug
[format["PopulateMapBuildings.sqf: %1 objects detected via chunk", _objectsCount]] call NNS_fnc_debugOutput; //debug
[format["PopulateMapBuildings.sqf: biggest object count in a chunk:%1", _biggestChunkCount]] call NNS_fnc_debugOutput; //debug
[format["PopulateMapBuildings.sqf: median objects count per chunk:%1", _medianObjectsPerChunk]] call NNS_fnc_debugOutput; //debug
//[format["PopulateMapBuildings.sqf: %1 classes with 'position in building'", count _buildingsClasses]] call NNS_fnc_debugOutput; //debug
[format["PopulateMapBuildings.sqf: %1 markers created", missionNamespace getVariable ["NNSPMBmkrCnt", 0]]] call NNS_fnc_debugOutput; //debug

//debug: count units/groups on the map each 60sec
if (_debug) then {
	[] spawn {
		while {sleep 60; true} do {
			[format["PopulateMapBuildings.sqf: group counts on server:%1", count allGroups]] call NNS_fnc_debugOutput;
			[format["PopulateMapBuildings.sqf: units counts on server:%1", count allUnits]] call NNS_fnc_debugOutput;
			[format["PopulateMapBuildings.sqf: %1 markers created", missionNamespace getVariable ["NNSPMBmkrCnt", 0]]] call NNS_fnc_debugOutput;
		};
	};
};

//populate loop
["PopulateMapBuildings.sqf: starting populate loop"] call NNS_fnc_debugOutput; //debug
while {sleep _detectInterval; !(missionNamespace getVariable ["NNSkillPopulatedMapLoop", false])} do { //loop until kill var set to true
	_chunksToPopulate = []; //chunks to populate array
	_chunksBlacklist = []; //chunks blacklisted (contain players)
	_chunksToReset = +(_chunksToResetBase); //copy chunk to reset initial array
	
	if !(_debugSpawnEveryone) then {
		{ //players loop
			_playerUID = getPlayerUID _x; //recover player UID
			if (!(_playerUID == "") && {alive _x} && {!((vehicle _x) isKindOf "Ship")} && {!((vehicle _x) isKindOf "Air")}) then { //ignore dead players or players in air or ship kind vehicle
				_playerPos = getPos (vehicle _x); //player position
				if !(_playerUID in _playersUID) then {
					_playersUID pushBack _playerUID; //store player UID
					_playersPos pushBack _playerPos; //store player position
					_playersDir pushBack 1000; //store fake direction
				};
				
				_playerIndex = _playersUID find _playerUID; //recover player index
				_playerLastPos = _playersPos select _playerIndex; //recover last position
				_playerDir = _playersDir select _playerIndex; //recover last direction
				
				if ((_playerLastPos distance2D _playerPos) > 50) then { //update player direction only if moved over 50m
					_playerDir = _playerLastPos getDir _playerPos; //compute new direction
					_playersPos set [_playerIndex, _playerPos]; //update old player position
					_playersDir set [_playerIndex, _playerDir]; //update old player direction
					//[format["PopulateMapBuildings.sqf: %1 position/direction updated (%2m)", _playerUID, _playerLastPos distance2D _playerPos]] call NNS_fnc_debugOutput; //debug
				};
				
				if (_debug) then {[format ["mrkPlayerDir%1",_playerIndex],_playerPos,_playerPos getPos [1000, _playerDir],"ColorYellow",1,1] call NNS_fnc_MapDrawLine}; //debug: draw direction line
				
				if !(_playerDir == 1000) then { //valid direction
					_playerChunksX = floor ((_playerPos select 0) / _chunkSize); //X chunk position
					_playerChunksY = floor ((_playerPos select 1) / _chunkSize); //Y chunk position
					_playerChunk = (_playerChunksY * _worldChunks) + _playerChunksX; //cumulative chunk position
					_playerChunksXmin = _playerChunksX - _populatePadding; _playerChunksXmax = _playerChunksX + _populatePadding;
					_playerChunksYmin = _playerChunksY - _populatePadding; _playerChunksYmax = _playerChunksY + _populatePadding;
					
					for [{_tmpY = _playerChunksYmin}, {_tmpY < _playerChunksYmax + 1}, {_tmpY = _tmpY + 1}] do { //Y loop
						if (_tmpY > -1 && _tmpY < _worldChunks) then { //Y not out of bound
							for [{_tmpX = _playerChunksXmin}, {_tmpX < _playerChunksXmax + 1}, {_tmpX = _tmpX + 1}] do { //X loop
								if (_tmpX > -1 && _tmpX < _worldChunks) then { //X not out of bound
									_tmpChunk = (_tmpY * _worldChunks) + _tmpX; //current chunk
									_chunksToReset set [_tmpChunk, false]; //disable reset for current chunk
									if ((_tmpX == _playerChunksX) && (_tmpY == _playerChunksY)) then {_chunksBlacklist pushBack _tmpChunk}; //blacklist player chuck
									if (abs (_playerChunksX - _tmpX) == _populatePadding || abs (_playerChunksY - _tmpY) == _populatePadding) then { //one chunk padding
										if (!(_tmpChunk in _chunksEmpty) && {!(_tmpChunk in _chunksBlacklist)} && {!(_tmpChunk in _chunksToPopulate)} && {!(_tmpChunk in _chunksPopulated)}) then { //chunk not empty, blacklisted, to populate, populated
											_tmpChunkPos = [((_tmpX * _chunkSize) + (_chunkSize / 2)), ((_tmpY * _chunkSize) + (_chunkSize / 2)), 0]; //center position of current chunk
											_tmpChunkDist = _playerPos distance2D _tmpChunkPos; //player distance from current chunk
											if ((_playerPos getPos [_tmpChunkDist, _playerDir]) inArea [_tmpChunkPos, _chunkSize / 2, _chunkSize / 2, 0, true]) then { //player direction cross current chunk
												_chunksToPopulate pushBack _tmpChunk;
											};
										};
									};
								};
							};
						};
					};
				};
			};
		} forEach allPlayers;
	} else { //spawn everyone on the map, mark all chunks as "to populate"
		for "_i" from 0 to (_worldChunksCount - 1) do {if (!(_i in _chunksEmpty) && {!(_i in _chunksBlacklist)} && {!(_i in _chunksPopulated)}) then {_chunksToPopulate pushBack _i}};
	};
	
	_newGrp = grpNull; //define group variable
	if (_debugSpawnEveryone) then {_oneGroupPerChunk = true; _newGrp = createGroup [_side, true]}; //create a single massive group
	
	{ //chunks to populate loop
		_tmpChunkIndex = _x; //backup current chunk
		_tmpChunkCenter = [(((_worldChunksX select _x) * _chunkSize) + (_chunkSize / 2)), (((_worldChunksY select _x) * _chunkSize) + (_chunkSize / 2)), 0]; //center position of current chunk
		
		if ((count allGroups) < (_groupsLimit + 1)) then { //under groups limit
			_currentChunkObjects = _chunksObjects select _tmpChunkIndex; //pointer to chunk objects
			_currentChunkObjectsCount = count _currentChunkObjects; //current chunk object count
			
			if !(_debugSpawnEveryone) then { //not spawn everyone on the map
				_newGrp = grpNull; //reset group variable
				if (_oneGroupPerChunk) then {_newGrp = createGroup [_side, true]}; //create group for whole chunk
				
				if (_spawnPatrol && ((count allGroups) < (_groupsLimit * 0.8))) then { //can spawn patrols and groups count on server under 80% of limit set on script param
					_patrolLoops = round (linearConversion [_medianObjectsPerChunk, _biggestChunkCount, _currentChunkObjectsCount, 1, 4]); //bigger chunk mean more patrols loop
					if (_patrolLoops > 0) then { //some patrols loop
						_nearestRoad = objNull; //road object
						_nearestRoadPos = [0,0,0]; //tmp position
						_rad = (_chunkSize / 2) * 0.9; //radius limit
						for "_i" from 0 to _patrolLoops do { //spawn patrol loop
							if (random 1 > 0.5) then { //50% chance to spawn a patrol
								_nearestRoad = [_tmpChunkCenter, _rad, [_nearestRoad]] call BIS_fnc_nearestRoad; //search nearest road
								if !(isNull _nearestRoad) then {_nearestRoadPos = getPos _nearestRoad; //road found, use its position
								} else {_nearestRoadPos = _tmpChunkCenter getPos [random 100, random 360]}; //failed to found a road, use generic position
								_nearestRoadPos set [2,0]; //reset Z position
								_patrolGrp = [_nearestRoadPos, _side, selectRandom (_class), [], [], [0.3, 0.3]] call BIS_fnc_spawnGroup; //patrol group
								{_wp = _patrolGrp addWaypoint [_nearestRoadPos, _rad]; _wp setWaypointType "MOVE"; _wp setWaypointSpeed "LIMITED"; _wp setWaypointBehaviour "SAFE"} forEach [1, 2, 3, 4, 5]; //add waypoints
								_wp = _patrolGrp addWaypoint [waypointPosition [_patrolGrp, 1], 0]; _wp setWaypointType "CYCLE"; //cycle waypoint
								_patrolGrp enableDynamicSimulation true; //Enable Dynamic simulation
								(_chunksGroups select _tmpChunkIndex) pushBack _patrolGrp; //add group to current chunk groups array
							};
						};
					};
				};
			};
			
			if (_autoPopulateChance) then { //compute proper amount of chance for building populate
				_populateChance = linearConversion [_medianObjectsPerChunk, _biggestChunkCount, _currentChunkObjectsCount, 0.6, 0.1]; //linear conversion
			};
			
			{ //objects loop
				if (damage _x < 1) then { //object not destroyed
					if (_populateChance > random 1) then { //lucky enough to spawn units in building
						_damageAllowed = local _x && isDamageAllowed _x; //is damage allowed on building
						if (_damageAllowed) then {_x allowDamage false}; //disable damage during spawn progress
						_buildingPosList = _x buildingPos -1; //positions in building, done here to avoid massive memory usage
						_buildingPosNewList = []; //new positions array
						_buildingPosLimit = round ((count _buildingPosList) * (_buildingPosMin + (random (_buildingPosMax - _buildingPosMin)))); //limited position count
						
						if (_buildingPosLimit > 0) then { //building has position
							while {(count _buildingPosNewList) < _buildingPosLimit} do { //fill new array
								_tmpIndex = round (random ((count _buildingPosList) - 1)); //select random index
								_buildingPosNewList pushBack (_buildingPosList select _tmpIndex); //add to new array
								_buildingPosList deleteAt _tmpIndex; //delete from old array
							};
							
							if !(_oneGroupPerChunk) then {_newGrp = createGroup [_side, true]}; //per building group
							_tmpGrp = [_tmpChunkCenter, _side, selectRandom (_class), [], [], [0.3, 0.3]] call BIS_fnc_spawnGroup; //temporary group
							
							while {(_buildingPosLimit / (count (units _tmpGrp))) > 2.5} do { //building have enough positions for multiple groups
								_tmpGrp01 = [_tmpChunkCenter, _side, selectRandom (_class), [], [], [0.3, 0.3]] call BIS_fnc_spawnGroup; //additionnal group
								(units _tmpGrp01) joinSilent _tmpGrp; //move units to main group
								deleteGroup _tmpGrp01; //delete old group
							};
							
							_limit = _buildingPosLimit; //set limit to building position count
							if (_limit > count (units _tmpGrp)) then {_limit = count (units _tmpGrp)}; //more position that units in group, set limit to group units count
							
							for "_i" from 0 to (_limit - 1) do { //position in building loop
								_tmpPosIndex = round (random ((count _buildingPosNewList) - 1)); //position index
								_tmpPos = _buildingPosNewList select _tmpPosIndex; //position in building
								_buildingPosNewList deleteAt _tmpPosIndex; //delete index
								
								_tmpUnit = selectRandom (units _tmpGrp); //select random unit
								if !(isNil "_tmpUnit") then { //avoid glitch
									[_tmpUnit] joinSilent (_newGrp); //join new group
									_tmpUnit setPosASL (AGLToASL _tmpPos); //set position
									_tmpUnit setUnitPos "Up"; //stand up
									_tmpUnit disableAI "Path"; //can't move
									_tmpUnit setDir ((_tmpUnit getDir _tmpPos) + 180); //try to face opening
									[_tmpUnit] call NNS_fnc_AIskill; //limit AI skills
									if (missionNamespace getVariable "BIS_enemyEquipment" == 1) then {_tmpUnit execVM "Scripts\LimitEquipment.sqf"}; //limit equipements
								} else {[format["PopulateMapBuildings.sqf: GLITCH : chunk:%1 : non-existing unit, count _tmpGrp:%2, count _newGrp:%3, _buildingPosLimit:%4", _tmpChunkIndex,count (units _tmpGrp),count (units _newGrp),_buildingPosLimit]] call NNS_fnc_debugOutput}; //debug
							};
							
							{deleteVehicle _x} forEach (units _tmpGrp); deleteGroup _tmpGrp; //delete old group
							
							if !(_oneGroupPerChunk) then { //per building group
								if (count units _newGrp > 0) then { //new group have units
									_newGrp enableDynamicSimulation true; //Enable Dynamic simulation
									_newGrp setCombatMode "YELLOW";
									(_chunksGroups select _tmpChunkIndex) pushBack _newGrp; //add group to current chunk groups array
								} else { //delete new group because empty
									deleteGroup _newGrp;
									[format["PopulateMapBuildings.sqf: GLITCH : chunk:%1 : empty new group", _tmpChunkIndex]] call NNS_fnc_debugOutput;
								};
							};
						};
						
						if (_debug) then {[_x,0,"ColorBlue","mil_dot"] call fn_marker}; //debug: object marker
						
						if (_damageAllowed) then {_x allowDamage true}; //enable damage again
					};
				} else { //building is destroyed
					if (_debug) then {[_x,0,"ColorRed","mil_dot"] call fn_marker}; //debug: object marker
					_chunksObjectsToDelete pushBack _x; //add to delete array
				};
			} forEach _currentChunkObjects;
			
			if (_oneGroupPerChunk && {!isNull _newGrp}) then { //whole chunk group
				if (count units _newGrp > 0) then { //new group have units
					_newGrp enableDynamicSimulation true; //Enable Dynamic simulation
					_newGrp setCombatMode "YELLOW";
					(_chunksGroups select _tmpChunkIndex) pushBack _newGrp; //add group to current chunk groups array
				} else { //delete new group because empty
					deleteGroup _newGrp;
					[format["PopulateMapBuildings.sqf: GLITCH : chunk:%1 : empty new group", _tmpChunkIndex]] call NNS_fnc_debugOutput;
				};
			};
			
			{ //delete destroyed objects loop
				_tmpIndex = _currentChunkObjects find _x;
				if !(_tmpIndex == -1) then {_currentChunkObjects deleteAt _tmpIndex}; //remove object from array
			} forEach _chunksObjectsToDelete;
			_chunksObjectsToDelete = []; //reset array
		} else {[format["PopulateMapBuildings.sqf: warning, groups (%1) on the server exceed limits defined on script (%2)", count allGroups, _groupsLimit]] call NNS_fnc_debugOutput};
		
		if (_debug) then {format ["mrkChunk%1", _tmpChunkIndex] setMarkerColor "ColorOrange"}; //debug: change chunk marker color
		_chunksPopulated pushBack _tmpChunkIndex; //add to populated array
		//_chunksObjects set [_tmpChunkIndex, nil]; //chunk no more used, free memory
	} forEach _chunksToPopulate;
	
	if !(_debugSpawnEveryone) then { //don't reset chunks if spawn every units possible
		for "_i" from 0 to (_worldChunksCount - 1) do { //chunks to reset loop
			_tmpGroups = _chunksGroups select _i; //recover current chunk groups
			if ((_chunksToReset select _i) && {count _tmpGroups > 0}) then { //chunk marked for reset and contain groups
				{
					{deleteVehicle _x} forEach units _x; //delete units from group
					deleteGroup _x; //delete group
				} forEach _tmpGroups; //groups loop
				
				missionNamespace setVariable [format ["chunkGrp%1", _i], []]; //reset array
				
				_tmpIndex = _chunksPopulated find _i; //search if current chunk in populated chunk array
				if !(_tmpIndex == -1) then {_chunksPopulated deleteAt _tmpIndex}; //delete chunk from populated array
				
				if (_debug) then {format ["mrkChunk%1", _i] setMarkerColor "ColorBlue"}; //debug: change chunk marker color
			};
		};
	};
};
