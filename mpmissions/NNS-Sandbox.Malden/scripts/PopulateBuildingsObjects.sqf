/*

WIP script, could end up as automated objects (or units) placement in building on whole map.
Cut map into "chunk" to limit performance impact on server and client.
Chunk detection work with all players on the map, grouped or not, disable if player(s) in vehicle.




buildings must have "position in building" (reported using buildingPos).

execVM "scripts\PopulateBuildingsObjects.sqf"
*/

openmap true;


_detectInterval = 1; //sec
_chunkSize = 500; //m2
_classesToIgnore = []; //objects class to ignore
_minObjectWH = 10; //minimum X-Y object size
_debug = true; //enable debug

fn_rectMarker = { //create a rectangular marker: [pos,width,height,color,alpha,text] call fn_rectMarker;
	params [["_pos", objNull],["_w", 0],["_h", 0],["_color", "ColorRed"],["_a", 1],["_name", ""],["_text", ""]];
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
	if !(_pos isEqualType []) then {_pos = getPos _pos}; //object
	private _tmpMarkerName = format ["mrk%1%2%3%4", round(random 1000), round(random 1000), round(random 1000), round(random 1000)]; //random name
	private _tmpMarker = createMarker [_tmpMarkerName, _pos]; //create marker
	_tmpMarkerName setMarkerColor _color; //set color
	_tmpMarkerName setMarkerType _type; //set type
	_tmpMarkerName setMarkerDir _dir; //set direction
	_tmpMarkerName setMarkerText _text; //set text
	_tmpMarkerName //return marker name
};

//world chunks
_worldSize = worldSize; //get world width computed by engine
_worldChunks = ceil (_worldSize/_chunkSize); //W/H map chunks count
_worldChunksX = []; //debug, store X for chunk
_worldChunksY = []; //debug, store Y for chunk
_worldChunksCount = _worldChunks ^ 2; //total amount of chunks for the whole map
_chunksPopulated = []; //store what chunks are already populated
_chunksObjects = []; //array pointing to each chunk objects

[format["PopulateBuildingsObjects.sqf: _worldSize:%1, _worldChunks:%2, _worldChunksCount:%3", _worldSize, _worldChunks, _worldChunksCount],false,true] call NNS_fnc_debugOutput; //debug

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
};

_objectList = nearestTerrainObjects [[_worldSize/2, _worldSize/2], ["House"], _worldSize, false, true]; //get all objects on map, oversized detection radius
//_objectList = [_worldSize/2, _worldSize/2] nearObjects ["House", _worldSize]; //get all objects on map, oversized detection radius
_buildingsClasses = []; //building classes with "position in building"
_positionsInBuildingsMarkers = 0; //debug
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
		
		if (_toAdd) then {
			_tmpPos = getPos _x; //object position
			_tmpX = floor ((_tmpPos select 0) / _chunkSize); //X chunk position
			_tmpY = floor ((_tmpPos select 1) / _chunkSize); //Y chunk position
			_tmp = ((_tmpY * _worldChunks) + _tmpX); //cumulative chunk
			_currChunkArray = _chunksObjects select _tmp; //array pointer
			_currChunkArray pushBack _x; //add object to right array
		};
	};
} forEach _objectList;

_objectList = nil; /*_buildingsClasses = nil;*/ _classesToIgnore = nil; //no more used, free memory

//mark empty chunk as poputated
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
		_chunksPopulated pushBack _i;
		if (_debug) then {_tmpName setMarkerColor "ColorRed"}; //change marker color
	} else {_objectsCount = _objectsCount + _tmpCount}; //increment objects count
};

[format["PopulateBuildingsObjects.sqf: %1 objects detected via chunk", _objectsCount],false,true] call NNS_fnc_debugOutput; //debug
[format["PopulateBuildingsObjects.sqf: %1 classes with 'position in building'", count _buildingsClasses],false,true] call NNS_fnc_debugOutput; //debug

//objects in buidings array generation


























//populate loop
while {sleep _detectInterval; (count _chunksPopulated < _worldChunksCount + 1)} do { //loop until all chunks populated
	_chunksToPopulate = []; //chunks to populate array
	_playersChunks = []; //chunks where players are
	
	{ //players loop
		if (alive _x && {vehicle player == player}) then { //ignore dead players or players in vehicle
			_playerPos = getPos _x; //player position
			_playerChunksX = floor ((_playerPos select 0) / _chunkSize); //X chunk position
			_playerChunksY = floor ((_playerPos select 1) / _chunkSize); //Y chunk position
			_playerChunk = (_playerChunksY * _worldChunks) + _playerChunksX; //cumulative chunk position
			if !(_playerChunk in _playersChunks) then { //current chunk not in players chunks array, avoid re-run in current loop
				_playersChunks pushBack _playerChunk; //add chunk to players chunks array
				for [{_tmpY = _playerChunksY - 1}, {_tmpY < _playerChunksY + 2}, {_tmpY = _tmpY + 1}] do { //Y loop
					if (_tmpY > -1 && _tmpY < _worldChunks) then { //Y not out of bound
						for [{_tmpX = _playerChunksX - 1}, {_tmpX < _playerChunksX + 2}, {_tmpX = _tmpX + 1}] do { //X loop
							if (_tmpX > -1 && _tmpX < _worldChunks) then { //X not out of bound
								_tmpChunk = (_tmpY * _worldChunks) + _tmpX; //current chunk
								if (!(_tmpChunk in _chunksToPopulate) && !(_tmpChunk in _chunksPopulated)) then {_chunksToPopulate pushBack _tmpChunk}; //add chunk to chunks to populate array if not populated
							};
						};
					};
				};
			};
		};
	} forEach allPlayers;
	
	{ //chunks to populate loop
		_tmpChunkIndex = _x; //backup current chunk
		{ //objects loop
			_tmpObject = _x; //backup current object
			_tmpType = typeOf _x; //backup type
			
			
			
			
			
			
			
			
			
			
			/*
			_buildingPosList = _x buildingPos -1; //positions in building, done here to avoid massive memory usage
			if (count _buildingPosList > 0) then { //building has position, extra security
				{ //position in building loop
					_tmpPosition = _x; //current position
					if (_debug) then { //debug
						_tmpArrow = createSimpleObject ["Sign_Arrow_Large_Pink_F", [0,0,0]]; //create arrow simple object
						_tmpArrow setPosASL (AGLToASL _tmpPosition); //set arrow position
						[_tmpPosition,0,"ColorPink","mil_dot"] call fn_marker; //create marker
						_positionsInBuildingsMarkers = _positionsInBuildingsMarkers + 1;
					};
				} forEach _buildingPosList;
			};
			*/
			
			
			
			
			
			
			
			
			
			
			
			if (_debug) then {[_tmpObject,0,"ColorBlue","mil_dot"] call fn_marker}; //debug: object marker
		} forEach (_chunksObjects select _tmpChunkIndex);
		
		if (_debug) then {format ["mrkChunk%1", _tmpChunkIndex] setMarkerColor "ColorOrange"}; //debug: change chunk marker color
		_chunksPopulated pushBack _tmpChunkIndex; //add to populated array
		_chunksObjects set [_tmpChunkIndex, nil]; //chunk no more used, free memory
	} forEach _chunksToPopulate;
};

[format["PopulateBuildingsObjects.sqf: %1 'position in building' markers/arrows created", _positionsInBuildingsMarkers],false,true] call NNS_fnc_debugOutput; //debug
