#define SELF 			{ _this call BIS_fnc_moduleHvtObjective; }
#define INSTANCE 		{ _this call BIS_fnc_moduleHvtObjectivesInstance; }
#define CLASS_OBJECTIVES	"CfgHvtObjectives"
#define VAR_INITIALIZED 	"BIS_moduleHvtObjective_initialized"
#define VAR_WINNERS		"BIS_moduleHvtObjective_winners"
#define VAR_LOOSERS		"BIS_moduleHvtObjective_loosers"
#define VAR_IS_DRAW		"BIS_moduleHvtObjective_isDraw"
#define VAR_CANCELED		"BIS_moduleHvtObjective_canceled"
#define VAR_FAILED		"BIS_moduleHvtObjective_failed"
#define VAR_SUCCEEDED		"BIS_moduleHvtObjective_succeeded"
#define VAR_TYPE 		"BIS_moduleHvtObjective_type"
#define VAR_KIND 		"BIS_moduleHvtObjective_kind"
#define VAR_FSM 		"BIS_moduleHvtObjective_fsm"
#define VAR_FSM_PATH		"BIS_moduleHvtObjective_fsmPath"
#define VAR_VISIBLE	 	"BIS_moduleHvtObjective_visible"
#define VAR_REVEALED_TO		"BIS_moduleHvtObjective_revealedTo"
#define VAR_IS_INDEPENDENT	"BIS_moduleHvtObjective_isIndependent"
#define VAR_ENDED		"BIS_moduleHvtObjective_ended"
#define VAR_OBJECTS		"BIS_moduleHvtObjective_objects"
#define VAR_CLUTTER		"BIS_moduleHvtObjective_clutter"
#define VAR_SIMULATIONDISABLED	"BIS_moduleHvtObjective_simulationDisabled"
#define VAR_OBJECTIVE_OWNER	"BIS_moduleHvtObjective_objectiveOwner"
#define VAR_OBJECTIVE_LETTER	"BIS_moduleHvtObjective_objectiveLetter"
#define IS_PUBLIC		true
#define IS_LOCAL		false

// Objective variables
#define VAR_DOWNLOAD_OBJECT	"DownloadObject"
#define VAR_DOWNLOAD_RADIUS	"DownloadRadius"
#define VAR_UPLOAD_RADIUS	"UploadRadius"
#define VAR_TASK_DESCRIPTION	"TaskDescription"
#define VAR_SUCCEED_RADIUS	"SucceedRadius"
#define VAR_TIME_LIMIT		"TimeLimit"
#define VAR_PICKUP_OBJECTS	"PickupObjects"
#define VAR_UPLOAD_OBJECTS	"UploadObjects"
#define VAR_IMEDIATE_DOWNLOAD	"ImmediateDownload"

private ["_action", "_parameters"];
_action		= _this param [0, "", [""]];
_parameters	= _this param [1, [], [[]]];

switch (_action) do
{
	case "Initialize" :
	{
		private ["_objective", "_sideA", "_sideB"];
		_objective 	= _parameters param [0, objNull, [objNull]];
		_sideA		= _parameters param [1, sideUnknown, [sideUnknown]];
		_sideB		= _parameters param [2, sideUnknown, [sideUnknown]];

		if (isNull _objective) exitWith
		{
			"Initialize: Unable to initialize a NULL objective" call BIS_fnc_error;
		};

		// Extract objective info from config
		private ["_cfg", "_type", "_kind", "_isStartGame", "_isEndGame", "_fsmPath", "_isIndependent"];
		_cfg 			= configFile >> CLASS_OBJECTIVES;
		_type			= _objective getVariable ["typeCustom", "StartGame"];
		_kind			= getText (_cfg >> _type >> "kind");
		_isStartGame		= _kind == "StartGame";
		_isEndGame		= _kind == "EndGame";
		_fsmPath		= getText (_cfg >> _type >> "fsmPath");
		_isIndependent		= getNumber (_cfg >> _type >> "isIndependent") > 0;

		_objective setVariable [VAR_INITIALIZED, true, IS_PUBLIC];
		_objective setVariable [VAR_REVEALED_TO, [], IS_PUBLIC];
		_objective setVariable [VAR_IS_INDEPENDENT, _isIndependent];
		_objective setVariable [VAR_TYPE, _type, IS_PUBLIC];
		_objective setVariable [VAR_KIND, _kind, IS_PUBLIC];
		_objective setVariable [VAR_VISIBLE, true];
		_objective setVariable [VAR_FSM_PATH, _fsmPath];

		if (_fsmPath != "") then
		{
			private "_fsm";
			_fsm = [_objective, _sideA, _sideB] execFSM _fsmPath;

			_objective setVariable [VAR_FSM, _fsm];
		};

		if (!_isStartGame && !_isEndGame) then
		{
			// Area
			["InitializeArea", [_objective]] call bis_fnc_moduleMPTypeHvt_areaManager;

			// Reveal objective objects
			["SetObjectsVisibility", [_objective, true]] call SELF;
		};

		(["GetSimpleObjectiveObject", [_objective]] call SELF) setVariable [VAR_OBJECTIVE_OWNER, _objective, true];
		(["GetSimpleObjectiveObject", [_objective]] call SELF) setVariable [VAR_OBJECTIVE_LETTER, ["GetTaskTypeLetter", [_objective]] call SELF, true];

		// Log
		["Initialize: %1 / %2 / %3 / %4 / %5 / %6 / %7", _objective, _type, _kind, _isStartGame, _isEndGame, _fsmPath, _isIndependent] call BIS_fnc_logFormat;
	};

	case "Terminate" :
	{
		private ["_objective"];
		_objective = _parameters param [0, objNull, [objNull]];

		// Public
		_objective setVariable [VAR_INITIALIZED, nil, IS_PUBLIC];
		_objective setVariable [VAR_REVEALED_TO, nil, IS_PUBLIC];

		// Private
		_objective setVariable [VAR_TYPE, nil];
		_objective setVariable [VAR_KIND, nil];
		_objective setVariable [VAR_FSM, nil];
		_objective setVariable [VAR_WINNER, nil];
		_objective setVariable [VAR_VISIBLE, nil];

		// Log
		["Terminate: %1", _objective] call BIS_fnc_logFormat;
	};

	case "IsInitialized" :
	{
		private ["_objective"];
		_objective = _parameters param [0, objNull, [objNull]];
		!isNil { _objective getVariable VAR_INITIALIZED };
	};

	case "GetSimpleObjectiveObject" :
	{
		private ["_objective"];
		_objective = _parameters param [0, objNull, [objNull]];

		if (isNull _objective) exitWith { objNull };

		private ["_string", "_compiled"];
		_string 	= _objective getVariable [VAR_DOWNLOAD_OBJECT, ""];
		_compiled	= call compile _string;

		if (isNil { _compiled }) then
		{
			objNull;
		}
		else
		{
			_compiled;
		};
	};

	case "GetStartGameObjectiveRadius" :
	{
		private ["_objective"];
		_objective = _parameters param [0, objNull, [objNull]];

		if (isNull _objective) exitWith { 150 };

		_objective getVariable [VAR_SUCCEED_RADIUS, 150];
	};

	case "GetEndGameObjectivePickups" :
	{
		private ["_objective"];
		_objective = _parameters param [0, objNull, [objNull]];

		if (isNull _objective) exitWith { [] };

		private ["_string", "_compiled"];
		_string 	= _objective getVariable [VAR_PICKUP_OBJECTS, ""];
		_compiled	= compile _string;

		private "_objects";
		_objects = [] call _compiled;

		_objects;
	};

	case "GetEndGameObjectiveUploads" :
	{
		private ["_objective"];
		_objective = _parameters param [0, objNull, [objNull]];

		if (isNull _objective) exitWith { [] };

		private ["_string", "_compiled"];
		_string 	= _objective getVariable [VAR_UPLOAD_OBJECTS, ""];
		_compiled	= compile _string;

		private "_objects";
		_objects = [] call _compiled;

		_objects;
	};

	case "GetObjectiveObjects" :
	{
		private ["_objective"];
		_objective = _parameters param [0, objNull, [objNull]];

		if (isNull _objective) exitWith { [] };

		private ["_isEndGame", "_hasSimpleObject"];
		_isEndGame 		= ["GetIsEndGame", [_objective]] call SELF;
		_hasSimpleObject	= !isNull (["GetSimpleObjectiveObject", [_objective]] call SELF);

		private "_objects";
		_objects = switch (true) do
		{
			case _isEndGame : 	{ ((["GetEndGameObjectivePickups", [_objective]] call SELF) + (["GetEndGameObjectiveUploads", [_objective]] call SELF)); };
			case _hasSimpleObject : { [["GetSimpleObjectiveObject", [_objective]] call SELF]; };
			default 		{ []; };
		};

		_objects;
	};

	case "HasEnded" :
	{
		private ["_objective"];
		_objective = _parameters param [0, objNull, [objNull]];

		!isNil { _objective getVariable VAR_ENDED };
	};

	case "GetDownloadRadius" :
	{
		private ["_objective"];
		_objective = _parameters param [0, objNull, [objNull]];

		private "_radius";
		_radius = if (!isNil { _objective getVariable VAR_DOWNLOAD_RADIUS }) then
		{
			_objective getVariable [VAR_DOWNLOAD_RADIUS, 20];
		}
		else
		{
			_objective getVariable [VAR_UPLOAD_RADIUS, 20];
		};

		_radius min 100;
	};

	case "IsImediateDownload" :
	{
		private ["_objective"];
		_objective = _parameters param [0, objNull, [objNull]];

		if (isNull _objective) exitWith { false };

		_objective getVariable [VAR_IMEDIATE_DOWNLOAD, false];
	};

	case "GetType" :
	{
		private ["_objective"];
		_objective = _parameters param [0, objNull, [objNull]];
		_objective getVariable [VAR_TYPE, ""];
	};

	case "GetIsIndependent" :
	{
		private ["_objective"];
		_objective = _parameters param [0, objNull, [objNull]];
		_objective getVariable [VAR_IS_INDEPENDENT, false];
	};

	case "GetKind" :
	{
		private ["_objective"];
		_objective = _parameters param [0, objNull, [objNull]];
		_objective getVariable [VAR_KIND, ""];
	};

	case "GetFsmPath" :
	{
		private ["_objective"];
		_objective = _parameters param [0, objNull, [objNull]];
		_objective getVariable [VAR_FSM_PATH, ""];
	};

	case "GetFsm" :
	{
		private ["_objective"];
		_objective = _parameters param [0, objNull, [objNull]];
		_objective getVariable [VAR_FSM, -1];
	};

	case "IsFsmRunning" :
	{
		private ["_objective"];
		_objective = _parameters param [0, objNull, [objNull]];
		(_objective getVariable [VAR_FSM, -1]) != -1;
	};

	case "GetIsStartGame" :
	{
		private ["_objective"];
		_objective = _parameters param [0, objNull, [objNull]];
		if (isNull _objective) exitWith { false };

		["GetKind", [_objective]] call SELF == "StartGame";
	};

	case "GetIsEndGame" :
	{
		private ["_objective"];
		_objective = _parameters param [0, objNull, [objNull]];
		if (isNull _objective) exitWith { false };

		["GetKind", [_objective]] call SELF == "EndGame";
	};

	case "GetTaskTitle" :
	{
		private ["_objective"];
		_objective = _parameters param [0, objNull, [objNull]];
		if (isNull _objective) exitWith { "" };
		"STR_A3_EndGame_Tasks_Title_RetrieveIntel";
	};

	case "GetTaskDescription" :
	{
		private ["_objective"];
		_objective = _parameters param [0, objNull, [objNull]];
		if (isNull _objective) exitWith { "" };
		_objective getVariable [VAR_TASK_DESCRIPTION, ""];
	};

	case "GetTaskMarker" :
	{
		private ["_objective"];
		_objective = _parameters param [0, objNull, [objNull]];
		if (isNull _objective) exitWith { "" };
		getText (configFile >> CLASS_OBJECTIVES >> (_objective getVariable VAR_TYPE) >> "taskMarker");
	};

	case "GetTaskParams" :
	{
		private ["_objective"];
		_objective = _parameters param [0, objNull, [objNull]];

		private ["_taskDescription", "_taskTitle", "_taskMarker"];
		_taskDescription	= ["GetTaskDescription", [_objective]] call SELF;
		_taskTitle		= ["GetTaskTitle", [_objective]] call SELF;
		_taskMarker		= ["GetTaskMarker", [_objective]] call SELF;

		[_taskDescription, _taskTitle, _taskMarker];
	};

	case "GetTaskType" :
	{
		private ["_objective"];
		_objective = _parameters param [0, objNull, [objNull]];
		if (isNull _objective) exitWith { "Default" };
		getText (configFile >> CLASS_OBJECTIVES >> (_objective getVariable VAR_TYPE) >> "taskType");
	};

	case "GetTaskTypeLetter" :
	{
		private _objective = _parameters param [0, objNull, [objNull]];
		if (isNull _objective) exitWith { "A" };

		private _isEndGameObjective = ["GetIsEndGame", [_objective]] call SELF;
		if (_isEndGameObjective) exitWith { "U" };

		private _index = (["GetAllObjectivesOrdered"] call INSTANCE) find _objective;
		switch (_index) do
		{
			case 0 : { "A" };
			case 1 : { "B" };
			case 2 : { "C" };
			case 3 : { "D" };
			case 4 : { "E" };
			case 5 : { "F" };
			case 6 : { "G" };
			case 7 : { "H" };
			case 8 : { "I" };
			case 9 : { "J" };
			case 10 : { "K" };
			case 11 : { "L" };
			case 12 : { "M" };
			case 13 : { "N" };
			case 14 : { "O" };
			case 15 : { "P" };
			case 16 : { "Q" };
			case 17 : { "R" };
			case 18 : { "S" };
			case 19 : { "T" };
			case 20 : { "U" };
			case 21 : { "V" };
			case 22 : { "W" };
			case 23 : { "X" };
			case 24 : { "Y" };
			case 25 : { "Z" };
			case default { "A" };
		};
	};

	case "GetClutter" :
	{
		private ["_objective"];
		_objective = _parameters param [0, objNull, [objNull]];
		if (isNull _objective) exitWith { [] };

		_objective getVariable [VAR_CLUTTER, []];
	};

	case "GetClutterFromManager" :
	{
		private ["_objective", "_blacklisted"];
		_objective 	= _parameters param [0, objNull, [objNull]];
		_blacklisted	= _parameters param [1, [], [[]]];
		if (isNull _objective) exitWith { [] };

		// If clutter was already calculated we use it's result
		if (!isNil { _objective getVariable VAR_CLUTTER }) exitWith
		{
			["GetClutter", [_objective]] call SELF;
		};

		private ["_triggers", "_clutter", "_missionObjects"];
		_triggers 	= [];
		_clutter 	= [];
		_missionObjects = allMissionObjects "All";

		// The triggers synchronized to the objective module
		{
			if (_x isKindOf "EmptyDetector") then
			{
				_triggers pushBack _x;
			};
		} forEach (synchronizedObjects _objective);

		// The trigger objects
		{
			private ["_trigger", "_radius"];
			_trigger 	= _x;
			_radius 	= ((triggerArea _trigger) select 0) max ((triggerArea _trigger) select 1);

			// All objects within the trigger
			{
				if (!(_x in _clutter) && {!(_x in _blacklisted)} && {!(_x isKindOf "Module_F")} && {_x distance _trigger <= _radius}) then
				{
					_clutter pushBack _x;
				};
			} forEach _missionObjects;
		} forEach _triggers;

		// Layers
		private _linkedLayersString = _objective getVariable ["LinkedLayers", "[]"];
		private _linkedLayers = call compile _linkedLayersString;

		{
			{
				_clutter append _x;
			}
			forEach (getMissionLayerEntities _x);
		}
		forEach _linkedLayers;

		// Flag simulation state
		{
			if (!simulationEnabled _x) then
			{
				_x setVariable [VAR_SIMULATIONDISABLED, true];
			};
		} forEach _clutter;

		// Store result so that any other call won't need to re-calculate clutter again
		_objective setVariable [VAR_CLUTTER, _clutter];

		// Log
		["%1 clutter calculated: %2", _objective, _clutter] call BIS_fnc_logFormat;

		_clutter;
	};

	case "UnlockRespawnPositions" :
	{
		if (!isServer) exitWith {};

		private ["_objective", "_side"];
		_objective 	= _parameters param [0, objNull, [objNull]];
		_side		= _parameters param [1, SIDEUNKNOWN, [SIDEUNKNOWN]];

		if (isNull _objective || _side == sideUnknown) exitWith {};

		private "_sideClass";
		_sideClass = switch (_side) do
		{
			case WEST : 		{ "sideblufor_f"; };
			case EAST : 		{ "sideopfor_f"; };
			case EAST : 		{ "sideresistance_f"; };
			case default 		{ ""; };
		};

		if (_sideClass != "") then
		{
			{
				if (toLower (typeOf _x) == _sideClass) then
				{
					[_side, position _x] call bis_fnc_addRespawnPosition;
				};
			} forEach synchronizedObjects _objective;
		};
	};

	case "DeleteObjects" :
	{
		private ["_objective"];
		_objective = _parameters param [0, objNull, [objNull]];
		if (isNull _objective) exitWith {};

		private ["_objects", "_clutter", "_groups"];
		_objects 	= ["GetObjectiveObjects", [_objective]] call SELF;
		_clutter	= ["GetClutterFromManager", [_objective]] call SELF;
		_groups 	= [];

		// Delete objects and store groups to delete
		{
			// If object is a man, store group to delete later
			if (_x isKindOf "Man" && !isNull group _x && !(group _x in _groups)) then {
				_groups pushBack group _x;
			} else {
				deleteVehicle _x;
			};
		} forEach _objects + _clutter;

		// Delete groups
		{
			{
				deleteVehicle _x;
			} forEach units _x;

			// Delete group
			deleteGroup _x;
		} forEach _groups;
	};

	case "AreObjectsVisible" :
	{
		private ["_objective"];
		_objective = _parameters param [0, objNull, [objNull]];
		if (isNull _objective) exitWith { false };
		_objective getVariable [VAR_VISIBLE, false];
	};

	case "SetObjectsVisibility" :
	{
		private ["_objective", "_show"];
		_objective 	= _parameters param [0, objNull, [objNull]];
		_show		= _parameters param [1, true, [true]];
		if (isNull _objective) exitWith {};

		private ["_objects", "_clutter"];
		_objects 	= ["GetObjectiveObjects", [_objective]] call SELF;
		_clutter	= ["GetClutterFromManager", [_objective]] call SELF;

		{
			if (_show) then
			{
				if (!isMultiplayer) then
				{
					if (isNil { _x getVariable VAR_SIMULATIONDISABLED }) then { _x enableSimulation true; };
					_x hideObject false;
				}
				else
				{
					if (isNil { _x getVariable VAR_SIMULATIONDISABLED }) then { _x enableSimulationGlobal true; };
					_x hideObjectGlobal false;
				};

			} else {
				if (!isMultiplayer) then
				{
					if (isNil { _x getVariable VAR_SIMULATIONDISABLED }) then { _x enableSimulation false; };
					_x hideObject true;
				}
				else
				{
					if (isNil { _x getVariable VAR_SIMULATIONDISABLED }) then { _x enableSimulationGlobal false; };
					_x hideObjectGlobal true;
				};
			};
		} forEach _objects + _clutter;

		// Flag
		_objective setVariable [VAR_VISIBLE, _show];

		// log
		//["SetObjectsVisibility: %1 / %2 / %3 / %4", _objective, _show/*, _objects*/, _clutter] call BIS_fnc_logFormat;
	};

	case "GetTaskId" :
	{
		private ["_objective", "_side"];
		_objective 	= _parameters param [0, objNull, [objNull]];
		_side		= _parameters param [1, sideUnknown, [sideUnknown]];

		private "_taskId";
		_taskId = "";

		if (isNull _objective || _side == sideUnknown) exitWith
		{
			_taskId;
		};

		_taskId = format ["%1_%2", [_objective] call BIS_fnc_objectVar, _side];
		_taskId;
	};

	case "WasEverRevealed" :
	{
		private ["_objective"];
		_objective = _parameters param [0, objNull, [objNull]];

		count (_objective getVariable [VAR_REVEALED_TO, []]) > 0;
	};

	case "WasRevealedTo" :
	{
		private ["_objective", "_side"];
		_objective 	= _parameters param [0, objNull, [objNull]];
		_side		= _parameters param [1, sideUnknown, [sideUnknown]];

		_side in (_objective getVariable [VAR_REVEALED_TO, []]);
	};

	case "WasCanceled" :
	{
		private ["_objective", "_side"];
		_objective 	= _parameters param [0, objNull, [objNull]];
		_side		= _parameters param [1, sideUnknown, [sideUnknown]];

		_objective getVariable [format["%1_%2", VAR_CANCELED, _side], false];
	};

	case "WasFailed" :
	{
		private ["_objective", "_side"];
		_objective 	= _parameters param [0, objNull, [objNull]];
		_side		= _parameters param [1, sideUnknown, [sideUnknown]];

		_objective getVariable [format["%1_%2", VAR_FAILED, _side], false];
	};

	case "WasSucceeded" :
	{
		private ["_objective", "_side"];
		_objective 	= _parameters param [0, objNull, [objNull]];
		_side		= _parameters param [1, sideUnknown, [sideUnknown]];

		_objective getVariable [format["%1_%2", VAR_SUCCEEDED, _side], false];
	};

	case "GetWinners" :
	{
		private ["_objective"];
		_objective = _parameters param [0, objNull, [objNull]];
		_objective getVariable [VAR_WINNERS, []];
	};

	case "GetLoosers" :
	{
		private ["_objective"];
		_objective = _parameters param [0, objNull, [objNull]];
		_objective getVariable [VAR_LOOSERS, []];
	};

	case "GetIsDraw" :
	{
		private ["_objective"];
		_objective = _parameters param [0, objNull, [objNull]];
		_objective getVariable [VAR_IS_DRAW, false];
	};

	case "RegisterWinner" :
	{
		if (!isServer) exitWith {};

		private ["_objective", "_side"];
		_objective 	= _parameters param [0, objNull, [objNull]];
		_side 		= _parameters param [1, sideUnknown, [sideUnknown]];

		private "_winners";
		_winners = _objective getVariable [VAR_WINNERS, []];
		_winners pushBack _side;
		_objective setVariable [VAR_WINNERS, _winners, IS_PUBLIC];

		["Succeed", [_objective, _side]] call SELF;
	};

	case "RegisterLooser" :
	{
		if (!isServer) exitWith {};

		private ["_objective", "_side"];
		_objective 	= _parameters param [0, objNull, [objNull]];
		_side 		= _parameters param [1, sideUnknown, [sideUnknown]];

		private "_loosers";
		_loosers = _objective getVariable [VAR_LOOSERS, []];
		_loosers pushBack _side;
		_objective setVariable [VAR_LOOSERS, _loosers, IS_PUBLIC];

		["Fail", [_objective, _side]] call SELF;
	};

	case "RegisterDraw" :
	{
		if (!isServer) exitWith {};

		private ["_objective", "_fail"];
		_objective 	= _parameters param [0, objNull, [objNull]];
		_fail		= _parameters param [1, true, [true]];

		_objective setVariable [VAR_IS_DRAW, true, IS_PUBLIC];

		private "_sides";
		_sides = ["GetSides"] call INSTANCE;

		private "_state";
		_state = if (_fail) then { "Fail" } else { "Cancel" };

		{
			[_state, [_objective, _x]] call SELF;
		} forEach _sides;
	};

	case "Hide" :
	{
		private ["_objective", "_side"];
		_objective 	= _parameters param [0, objNull, [objNull]];
		_side 		= _parameters param [1, sideUnknown, [sideUnknown]];

		private "_taskId";
		_taskId = ["GetTaskId", [_objective, _side]] call SELF;

		[_taskId, [_side]] call BIS_fnc_deleteTask;
	};

	case "Reveal" :
	{
		private ["_objective", "_side"];
		_objective 	= _parameters param [0, objNull, [objNull]];
		_side 		= _parameters param [1, sideUnknown, [sideUnknown]];

		if (isNull _objective) exitWith
		{
			"Reveal: Unable to create a NULL objective" call BIS_fnc_error;
		};

		if (_side == sideUnknown) exitWith
		{
			"Reveal: Reveal to side is sideUnknown" call BIS_fnc_error;
		};

		if (["WasRevealedTo", [_objective, _side]] call SELF) exitWith
		{
			["Reveal: Already revealed to side %1", _side] call BIS_fnc_error;
		};

		if (["HasEnded", [_objective]] call SELF) exitWith
		{
			"Reveal: Objective already ended, ignoring reveal" call BIS_fnc_log;
		};

		if (["HasEndGameStarted"] call INSTANCE) exitWith
		{
			["Reveal: EndGame already started, ignoring updates to prevous objectives", _side] call BIS_fnc_logFormat;
		};

		private ["_isStartGame", "_isEndGame"];
		_isStartGame = ["GetIsStartGame", [_objective]] call SELF;
		_isEndGame = ["GetIsEndGame", [_objective]] call SELF;

		// Flag as revealed to side
		private "_revealedTo";
		_revealedTo = _objective getVariable [VAR_REVEALED_TO, []];
		_revealedTo pushBack _side;
		_objective setVariable [VAR_REVEALED_TO, _revealedTo, IS_PUBLIC];

		// Initial dialogue
		private ["_objectiveId", "_objectiveType", "_sides"];
		_objectiveId	= [_objective] call BIS_fnc_objectVar;
		_objectiveType	= ["GetType", [_objective]] call SELF;
		_sides		= ["GetSides"] call INSTANCE;

		if (!_isStartGame && !_isEndGame) then
		{
			// Task
			private ["_taskId", "_taskParams", "_taskType"];
			_taskId 	= ["GetTaskId", [_objective, _side]] call SELF;
			_taskParams 	= ["GetTaskParams", [_objective]] call SELF;
			_taskType	= ["GetTaskTypeLetter", [_objective]] call SELF;

			_taskParams set [1, _taskParams select 1];

			// Create the task
			[_taskId, _side, _taskParams, [["GetSimpleObjectiveObject", [_objective]] call SELF, true], "CREATED", -1, true, true, _taskType, true] call BIS_fnc_setTask;

			// Conversation
			if (time >= (missionNamespace getVariable ["BIS_hvt_conversationTime", 0]) + 30) then
			{
				missionNamespace setVariable ["BIS_hvt_conversationTime", time];
				["IntelWanted", _side] call bis_fnc_moduleMPTypeHvt_conversations;
			};
		};

		// Show objects if hidden
		//if !(["AreObjectsVisible", [_objective]] call SELF) then
		//{
			["SetObjectsVisibility", [_objective, true]] call SELF;
		//};
	};

	case "Succeed" :
	{
		private ["_objective", "_side"];
		_objective 	= _parameters param [0, objNull, [objNull]];
		_side 		= _parameters param [1, sideUnknown, [sideUnknown]];

		if (isNull _objective) exitWith {};

		if (_side == sideUnknown) exitWith
		{
			"Succeed: Succeed to side is sideUnknown" call BIS_fnc_error;
		};

		if (["GetIsEndGame", [_objective]] call SELF || ["GetIsStartGame", [_objective]] call SELF) exitWith
		{
			"Succeed: Objective is either StartGame or EndGame type" call BIS_fnc_logFormat;
		};

		if !(["WasRevealedTo", [_objective, _side]] call SELF) exitWith
		{
			["Succeed: Not revealed to side %1", _side] call BIS_fnc_logFormat;
		};

		if (["HasEndGameStarted"] call INSTANCE) exitWith
		{
			["Succeed: EndGame already started, ignoring updates to prevous objectives", _side] call BIS_fnc_logFormat;
		};

		// Flag
		_objective setVariable [format["%1_%2", VAR_SUCCEEDED, _side], true];

		private ["_isStartGame", "_isEndGame", "_taskType"];
		_isStartGame	= ["GetIsStartGame", [_objective]] call SELF;
		_isEndGame	= ["GetIsEndGame", [_objective]] call SELF;
		_taskType	= ["GetTaskTypeLetter", [_objective]] call SELF;

		if (!_isStartGame && !_isEndGame) then
		{
			// Task
			private ["_taskId", "_taskParams"];
			_taskId 	= ["GetTaskId", [_objective, _side]] call SELF;
			_taskParams 	= ["GetTaskParams", [_objective]] call SELF;

			_taskParams set [1, _taskParams select 1];

			// Succeed the task
			[_taskId, nil, nil, nil, "SUCCEEDED"] call BIS_fnc_setTask;
		};

		// State changed
		if !(["GetIsIndependent", [_objective]] call SELF) then
		{
			["OnObjectiveStateChanged", [_objective, _side, "Succeed"]] call INSTANCE;
		}
		else
		{
			["OnObjectiveCompleted", [_objective]] call INSTANCE;
		};
	};

	case "Cancel" :
	{
		private ["_objective", "_side"];
		_objective 	= _parameters param [0, objNull, [objNull]];
		_side 		= _parameters param [1, sideUnknown, [sideUnknown]];

		if (isNull _objective) exitWith
		{
			"Cancel: Unable to succeed a NULL objective" call BIS_fnc_error;
		};

		if (_side == sideUnknown) exitWith
		{
			"Cancel: Cancel to side is sideUnknown" call BIS_fnc_error;
		};

		if (["GetIsEndGame", [_objective]] call SELF || ["GetIsStartGame", [_objective]] call SELF) exitWith
		{
			"Cancel: Objective is either StartGame or EndGame type" call BIS_fnc_logFormat;
		};

		if !(["WasRevealedTo", [_objective, _side]] call SELF) exitWith
		{
			["Cancel: Not revealed to side %1", _side] call BIS_fnc_logFormat;
		};

		if (["HasEndGameStarted"] call INSTANCE) exitWith
		{
			["Cancel: EndGame already started, ignoring updates to prevous objectives", _side] call BIS_fnc_logFormat;
		};

		// Flag
		_objective setVariable [format["%1_%2", VAR_CANCELED, _side], true];

		private ["_isStartGame", "_isEndGame", "_taskType"];
		_isStartGame	= ["GetIsStartGame", [_objective]] call SELF;
		_isEndGame	= ["GetIsEndGame", [_objective]] call SELF;
		_taskType	= ["GetTaskTypeLetter", [_objective]] call SELF;

		if (!_isStartGame && !_isEndGame) then
		{
			// Task
			private ["_taskId", "_taskParams"];
			_taskId 	= ["GetTaskId", [_objective, _side]] call SELF;
			_taskParams 	= ["GetTaskParams", [_objective]] call SELF;

			_taskParams set [1, _taskParams select 1];

			// Succeed the task
			[_taskId, nil, nil, nil, "CANCELED"] call BIS_fnc_setTask;
		};

		// State changed
		if !(["GetIsIndependent", [_objective]] call SELF) then
		{
			["OnObjectiveStateChanged", [_objective, _side, "Cancel"]] call INSTANCE;
		}
		else
		{
			["OnObjectiveCompleted", [_objective]] call INSTANCE;
		};
	};

	case "Fail" :
	{
		private ["_objective", "_side"];
		_objective 	= _parameters param [0, objNull, [objNull]];
		_side 		= _parameters param [1, sideUnknown, [sideUnknown]];

		if (isNull _objective) exitWith
		{
			"Fail: Unable to succeed a NULL objective" call BIS_fnc_error;
		};

		if (_side == sideUnknown) exitWith
		{
			"Fail: Fail to side is sideUnknown" call BIS_fnc_error;
		};

		if (["GetIsEndGame", [_objective]] call SELF || ["GetIsStartGame", [_objective]] call SELF) exitWith
		{
			"Fail: Objective is either StartGame or EndGame type" call BIS_fnc_logFormat;
		};

		if !(["WasRevealedTo", [_objective, _side]] call SELF) exitWith
		{
			["Fail: Not revealed to side %1", _side] call BIS_fnc_logFormat;
		};

		if (["HasEndGameStarted"] call INSTANCE) exitWith
		{
			["Fail: EndGame already started, ignoring updates to prevous objectives", _side] call BIS_fnc_logFormat;
		};

		// Flag
		_objective setVariable [format["%1_%2", VAR_FAILED, _side], true];

		private ["_isStartGame", "_isEndGame", "_taskType"];
		_isStartGame	= ["GetIsStartGame", [_objective]] call SELF;
		_isEndGame	= ["GetIsEndGame", [_objective]] call SELF;
		_taskType	= ["GetTaskTypeLetter", [_objective]] call SELF;

		if (!_isStartGame && !_isEndGame) then
		{
			// Task
			private ["_taskId", "_taskParams"];
			_taskId 	= ["GetTaskId", [_objective, _side]] call SELF;
			_taskParams 	= ["GetTaskParams", [_objective]] call SELF;

			_taskParams set [1, _taskParams select 1];

			// Succeed the task
			[_taskId, nil, nil, nil, "FAILED"] call BIS_fnc_setTask;
		};

		// State changed
		if !(["GetIsIndependent", [_objective]] call SELF) then
		{
			["OnObjectiveStateChanged", [_objective, _side, "Fail"]] call INSTANCE;
		}
		else
		{
			["OnObjectiveCompleted", [_objective]] call INSTANCE;
		};
	};

	case "EndObjective" :
	{
		private ["_objective"];
		_objective = _parameters param [0, objNull, [objNull]];

		// Flag
		_objective setVariable [VAR_ENDED, true, IS_PUBLIC];

		// Let the objectives instance know about this
		["OnObjectiveEnded", [_objective]] call INSTANCE;

		// Area
		["TerminateArea", [_objective]] call bis_fnc_moduleMPTypeHvt_areaManager;
	};

	case default
	{
		["Invalid action: %1", _action] call BIS_fnc_error;
	};
};