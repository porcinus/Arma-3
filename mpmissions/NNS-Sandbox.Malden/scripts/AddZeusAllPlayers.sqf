/*
NNS
Allow all players to zeus.

Notes:
- Should be run during preInit.
- If script is exectuted after server start, some features can't be used (even with proper modules added, trust me, I wasted a whole afternoon on this).
- To kill the script, set global NNSkillZeusLoop to true.
- Amount of Curator slots are can be found by looking at NNSZeusSlot global var.

Usage : _null = execVM "scripts\AddZeusAllPlayers.sqf";

Dependencies:
	in description.ext:
		class CfgFunctions {
			class NNS {
				class missionfunc {
					file = "nns_functions";
					class debugOutput {};
				};
			};
		};

	nns_functions folder:
		fn_debugOutput.sqf
		
	script folder:
		AddZeusAllPlayers.sqf
		
*/

params [
["_maxPlayers", 0] //if set to 0, script will try to detect number of playable slots
];

if !(isServer) exitWith {}; //server only script
if (_maxPlayers == 0) then {_maxPlayers = (playableSlotsNumber west) + (playableSlotsNumber east) + (playableSlotsNumber resistance) + (playableSlotsNumber civilian)}; //try to detect slot amount
if (_maxPlayers == 0) exitWith {["AddZeusAllPlayers.sqf: failed to detect playable slots numbers"] call NNS_fnc_debugOutput};
[format["AddZeusAllPlayers.sqf: detected playable slots amount:%1", _maxPlayers]] call NNS_fnc_debugOutput; //debug
missionNamespace setVariable ["NNSZeusSlot",_maxPlayers,true]; //public var

_curators = []; //curators objects array
_curatorAttributes = []; //curator attributes objects array
_players = []; //store players pointer
_playersUID = []; //store players UID, used to allow new comer to zeus
_playersUIDpresent = []; //store if player UID still present in server, allow freed curator
_playersCurator = []; //players curators link array

_curatorLogicGroup = creategroup sideLogic; //create a logic group for all curator and curator attributes objects
_curatorLogicGroup setGroupIdGlobal ["AddZeusAllPlayers.sqf"]; //set group name
[format["AddZeusAllPlayers.sqf: logic group created:%1",groupId _curatorLogicGroup]] call NNS_fnc_debugOutput; //debug

for [{_i = 0}, {_i < _maxPlayers}, {_i = _i + 1}] do { //curator modules creation
	_tmpCurator = _curatorLogicGroup createunit ["ModuleCurator_F", [0,0,0], [], 0, "CAN_COLLIDE"]; //create new curator module
	_tmpCurator setvariable ["text", format["ZeusCurator%1", _i] ,true]; //module name
	_tmpCurator setvariable ["Addons", 3, true]; //allow all addons, may not work if time > 0
	_tmpCurator setvariable ["owner", "objNull" ,true]; //no owner
	unassignCurator _tmpCurator; objNull assignCurator _tmpCurator;//unassign curator
	_curators pushBack _tmpCurator; //backup curator object
	_playersCurator pushBack objNull; //null player curator link
};

if (time > 0) then {["AddZeusAllPlayers.sqf: warning, time>0, some Zeus feature may not work"] call NNS_fnc_debugOutput}; //debug

while {!(missionNamespace getVariable ["NNSkillZeusLoop", false])} do { //main loop
	_playersUIDpresent = []; {_playersUIDpresent pushBack false} forEach _playersUID; //reset player UID still present in server array
	
	{ //all players - headless server loop
		_playerUID = getPlayerUID _x; //recover player UID
		if (_playerUID in _playersUID) then {_playersUIDpresent set [(_playersUID find _playerUID), true]}; //player UID still present
		
		if (!(_playerUID == "") && {!(_playerUID in _playersUID)}) then { //player has UID and no in array
			_curatorSlot = _playersCurator find objNull; //search free curator slot
			if !(_curatorSlot == -1) then { //curator slot available
				_players pushBack _x; //add player object pointer to array
				_playersUID pushBack _playerUID; //add UID to array
				_playersCurator set [_curatorSlot, _x]; //add player object pointer in players curators link
				_x assignCurator (_curators select _curatorSlot); //assign current player to right curator
				[format["AddZeusAllPlayers.sqf: player:%1, UID:%2, index:%3 added to curators list", _x, _playerUID, _playersUID find _playerUID]] call NNS_fnc_debugOutput; //debug
			} else {[format["AddZeusAllPlayers.sqf: player:%1, UID:%2, no curator slot available for now", _x, _playerUID]] call NNS_fnc_debugOutput}; //debug
		} else {
			if (!(_playerUID == "") && {_playerUID in _playersUID}) then { //current player in array
				_index = _playersUID find _playerUID; //recover player index
				if (!((_players select _index) isEqualTo _x)) then { //player object missmatch (died?)
					_oldPlayer = _players select _index; //recover old player object
					_curatorSlot = _playersCurator find _oldPlayer; //search player curator index
					if !(_curatorSlot == -1) then { //player curator index found
						unassignCurator (_curators select _curatorSlot); //unassign curator
						_players set [_index, _x]; //update player object
						_playersCurator set [_curatorSlot, _x]; //update player curator object
						_x assignCurator (_curators select _curatorSlot); //assign current player to right curator
						[format["AddZeusAllPlayers.sqf: player:%1, UID:%2, curator link updated", _x, _playerUID]] call NNS_fnc_debugOutput; //debug
					} else { //player curator index not found
						_curatorSlot = _playersCurator find objNull; //search free curator slot
						if !(_curatorSlot == -1) then { //curator slot available
							_playersCurator set [_curatorSlot, _x]; //add player object pointer in players curators link
							_x assignCurator (_curators select _curatorSlot); //assign current player to right curator
						[format["AddZeusAllPlayers.sqf: player:%1, UID:%2, index:%3 added to curators list", _x, _playerUID, _playersUID find _playerUID]] call NNS_fnc_debugOutput; //debug
						} else {[format["AddZeusAllPlayers.sqf: player:%1, UID:%2, no curator slot available for now", _x, _playerUID]] call NNS_fnc_debugOutput}; //debug
					};
				};
			};
		};
	} forEach allPlayers - (entities "HeadlessClient_F"); //all players - headless server
	
	playerUIDcount = count _playersUID;
	for [{_i = 0}, {_i < playerUIDcount}, {_i = _i + 1}] do { //player UID no more present loop
		if !(_playersUIDpresent select _i) then { //player no more in server
			_oldPlayer = _players select _i; //recover old player object
			_curatorSlot = _playersCurator find _oldPlayer; //search player curator index
			if !(_curatorSlot == -1) then { //player curator index found
				[format["AddZeusAllPlayers.sqf: UID:%1 not more on server, curator:%2 freed", _playersUID select _i, _curators select _curatorSlot]] call NNS_fnc_debugOutput; //debug
				unassignCurator (_curators select _curatorSlot); //unassign curator
				_playersCurator set [_curatorSlot, objNull]; //null player curator link
			};
		};
	};
	
	sleep 5; //wait a bit
	
	_curatorsCount = count _curators; //curator amount
	_allObjects = allMissionObjects "all"; //all mission objects
	for [{_i = 0}, {_i < _curatorsCount}, {_i = _i + 1}] do { //curators editable objects loop
		if !(isNull (_playersCurator select _i)) then { //player curator link not null
			(_curators select _i) addCuratorEditableObjects [_allObjects, true]; //allow edit of all mission objects, incl crew
			(_curators select _i) removeCuratorEditableObjects [_curators]; //disable edit of curator objects
		};
	};
};

/*
//keep this part, could be useful for other scripts
_players = []; //store players pointer
_playersUID = []; //store players UID, used to allow new comer to zeus
_playersZeus = []; //zeus instance already created
_playersCurator = []; //curator objects array
_playersCuratorAttributes = []; //curator attributes objects array

_curatorAttribClasses = ["ModuleCuratorSetAttributesGroup_F", "ModuleCuratorSetAttributesPlayer_F", "ModuleCuratorSetAttributesMarker_F", "ModuleCuratorSetAttributesObject_F", "ModuleCuratorSetAttributesWaypoint_F"]; //curator attribute modules classes
_curatorAttribArgs = []; //curator attributes arguments

{ //extract boolean arguments for all attributes modules defined
	_tmpArgArray = []; //store valid arguments found
	_configClass = configfile >> "CfgVehicles" >> _x >> "Arguments"; //config path to arguments
	for "_i" from 0 to ((count _configClass) - 1) do { //seek thru entries
		_entry = _configClass select _i; //current entry
		if (isClass _entry) then { //current entry is a class
			if (toLower (getText (_entry >> "typeName")) == "bool") then {_tmpArgArray pushBack configName _entry}; //contain typeName entry that is Bool, add entry name to temp array
		};
	};
	_curatorAttribArgs pushBack _tmpArgArray; //add to arg array
} forEach _curatorAttribClasses;

{ //output all attribute modules arguments to debug
	[format["AddZeusAllPlayers.sqf: arguments found for attributes module (%1) : %2", _x, _curatorAttribArgs select (_curatorAttribClasses find _x)]] call NNS_fnc_debugOutput; //debug
} forEach _curatorAttribClasses;

_curatorLogicGroup = grpNull; //declare null group for logic

while {true} do {
	_logicGroupExist = false; //reset logic group exist bool
	{if (!(_logicGroupExist) && {groupId (group _x) == "AddZeusAllPlayers.sqf"}) then {_logicGroupExist = true};} forEach (allMissionObjects "logic"); //search if group exist
	
	if !(_logicGroupExist) then { //logic group not already created or deleted
		deleteGroup _curatorLogicGroup; //silly but needed
		_curatorLogicGroup = creategroup sideLogic; //create a logic group for all curator and curator attributes objects
		_curatorLogicGroup setGroupIdGlobal ["AddZeusAllPlayers.sqf"]; //set group name
		[format["AddZeusAllPlayers.sqf: logic group created:%1",groupId _curatorLogicGroup]] call NNS_fnc_debugOutput; //debug
		
		_players = []; //reset players pointer array
		_playersUID = []; //reset players UID, used to allow new comer to zeus array
		_playersZeus = []; //reset zeus instance already created array
		{unassignCurator _x; deleteVehicle _x} forEach _playersCurator; _playersCurator = []; //unassign, delete curator objects and reset array
		{{deleteVehicle _x} forEach _x} forEach _playersCuratorAttributes; _playersCuratorAttributes = []; //delete curator attributes objects and reset array
	};
	
	{ //all players - headless server loop
		_playerUID = getPlayerUID _x; //recover player UID
		if (!(_playerUID == "") && {!(_playerUID in _playersUID)}) then { //player has UID and no in array
			_players pushBack _x; //add player pointer to array
			_playersUID pushBack _playerUID; //add UID to array
			_playersZeus pushBack false; //zeus instance not created
			_playersCurator pushBack objNull; //empty curator for now
			_playersCuratorAttributes pushBack []; //empty curator attributes for now
			[format["AddZeusAllPlayers.sqf: player:%1, UID:%2, index:%3 added to players list", _x, _playerUID, _playersUID find _playerUID]] call NNS_fnc_debugOutput; //debug
		} else {
			if (!(_playerUID == "") && {_playerUID in _playersUID}) then { //current player in array
				_index = _playersUID find _playerUID; //recover player index
				if (!(_index == -1) && {!((_players select _index) isEqualTo _x)}) then {//player in array and player object missmatch (died?)
					_players set [_index, _x]; //update player pointer in array
					_tmpCurator = _playersCurator select _index; //recover old player curator
					unassignCurator _tmpCurator; //unassign old curator
					_x assignCurator _tmpCurator; //assign current player to old curator
					[format["AddZeusAllPlayers.sqf: player:%1, UID:%2, index:%3 missmatch, curator updated", _x, _playerUID, _index]] call NNS_fnc_debugOutput; //debug
				};
			};
		};
	} forEach allPlayers - (entities "HeadlessClient_F"); //all players - headless server
	
	_playersZeusCount = count _playersZeus; //zeus amount
	_allObjects = allMissionObjects "all"; //all mission objects
	
	for [{_index = 0}, {_index < _playersZeusCount}, {_index = _index + 1}] do { //zeus creation/update loop
		if !(_playersZeus select _index) then { //zeus modules not already created for current player
			_player = _players select _index; //recover current player pointer
			_zeusName = format["ZeusCurator%1", _index]; //module name
			
			//curator module
			_tmpCurator = _curatorLogicGroup createunit ["ModuleCurator_F", [0,0,0], [], 0, "CAN_COLLIDE"]; //create new curator module
			_tmpCurator setvariable ["text", _zeusName]; //module name
			_tmpCurator setvariable ["Addons", 3, true]; //allow all addons, may not work if time > 0
			_tmpCurator setvariable ["owner", "objnull"]; //no owner
			_playersCurator set [_index, _tmpCurator]; //backup curator object
			
			//attibutes modules, some may not work if time > 0, objects edit broken if so
			_tmpAttibutesModules = []; //contain all curator attibutes modules for current player
			{ //curator attributes modules loop
				_moduleClass = _x; //backup class name
				_tmpIndex = _curatorAttribClasses find _moduleClass; //index used for attibutes arguments array
				_tmpVars = [format ["this setvariable ['curator', '%1'];", _player]]; //add curator to vars list
				{_tmpVars pushBack format ["this setvariable ['%1', true];", _x]} forEach (_curatorAttribArgs select _tmpIndex); //arguments loop
				_tmpVar = _tmpVars joinString ""; //array to string
				_tmpModule = _curatorLogicGroup createunit [_moduleClass, [0,0,0], [], 0, "NONE"]; //create curator attibutes module
				_tmpModule setvariable ["curator", format ["'%1'",_zeusName], true]; //curator name
				{_tmpModule setvariable [_x, true, true]} forEach (_curatorAttribArgs select _tmpIndex); //arguments loop, all to true, public
				_tmpModule setvariable ["vehicleinit", _tmpVar]; //need to be done right after module creation
				_tmpCurator synchronizeObjectsAdd [_tmpModule]; //sync module with curator module
				_tmpModule setvariable ["BIS_fnc_initModules_disableAutoActivation", false, true]; //activate module
				_tmpAttibutesModules pushBack _tmpModule; //add module to array
			} forEach _curatorAttribClasses;
			
			_playersCuratorAttributes set [_index, _tmpAttibutesModules]; //backup curator attributes modules
			_playersZeus set [_index, true]; //zeus modules for current player created
			
			_player assignCurator _tmpCurator; //assign current player to curator
			
			[format["AddZeusAllPlayers.sqf: player:%1, index:%2 : curator and attributes modules created", _player, _index]] call NNS_fnc_debugOutput; //debug
		};
		
		_tmpCurator = _playersCurator select _index; //recover current player curator
		_tmpCurator addCuratorEditableObjects [_allObjects, true]; //allow edit of all mission objects, incl crew, TO OPTIMIZE
		
		sleep 5; //wait a bit
	};
};
*/