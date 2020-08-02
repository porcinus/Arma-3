#define SELF 					{ _this call BIS_fnc_moduleHvtObjectivesInstance; }
#define OBJECTIVE 				{ _this call BIS_fnc_moduleHvtObjective; }
#define VAR_INITIALIZED 			"BIS_moduleHvtObjectivesInstance_initialized"
#define VAR_LOGIC				"BIS_moduleHvtObjectivesInstance_logic"
#define VAR_SIDES_WITH_FOB			"BIS_moduleHvtObjectivesInstance_sidesWithFob"
#define VAR_ENDGAME_OBJECTIVE			"BIS_moduleHvtObjectivesInstance_endGameObjective"
#define VAR_ENDGAME_THRESHOLD			"BIS_moduleHvtObjectivesInstance_endGameThreshold"
#define VAR_RANDOMISERS				"BIS_moduleHvtObjectivesInstance_randomisers"
#define VAR_OBJECTIVES				"BIS_moduleHvtObjectivesInstance_objectives"
#define VAR_OBJECTIVES_ORDERED			"BIS_moduleHvtObjectivesInstance_objectivesOrdered"
#define VAR_COMPLETED_OBJECTIVES		"BIS_moduleHvtObjectivesInstance_completedObjectives"
#define VAR_SIDES				"BIS_moduleHvtObjectivesInstance_sides"
#define VAR_BASES				"BIS_moduleHvtObjectivesInstance_bases"
#define VAR_BASE_SIDE				"BIS_moduleHvtObjectivesInstance_baseSide"
#define VAR_MISSION_FLOW_FSM			"BIS_moduleHvtObjectivesInstance_fsm"
#define CLASS_OBJECTIVE_RANDOMISER		"ModuleHvtObjectiveRandomiser_F"
#define CLASS_SIMPLE_OBJECTIVE			"ModuleHvtSimpleObjective_F"
#define CLASS_STARTGAME_OBJECTIVE		"ModuleHvtStartGameObjective_F"
#define CLASS_ENDGAME_OBJECTIVE			"ModuleHvtEndGameObjective_F"
#define LOG_NETWORK_TRAFFIC			cheatsEnabled

private ["_action", "_parameters"];
_action		= _this param [0, "", [""]];
_parameters	= _this param [1, [], [[]]];

switch (_action) do
{
	case "Initialize" :
	{
		private ["_logic", "_endGameThreshold"];
		_logic 			= _parameters param [0, objNull, [objNull]];
		_endGameThreshold	= _parameters param [1, 3, [0]];

		// Validate the logic itself
		if (isNull _logic) exitWith
		{
			"Initialize: Logic cannot be null" call BIS_fnc_error;
		};

		// Make sure module doesn't initialize multiple times
		if (["IsInitialized"] call SELF) exitWith
		{
			["Initialize: Multiple initialization detected: %1 / Only one module can be placed", _logic] call BIS_fnc_error;
		};

		// Compile functions and send them to clients
		["CompileFunctions"] call SELF;

		// EndGame threshold
		["SetEndGameThreshold", [_endGameThreshold]] call SELF;

		// Flag as initialized and store logic
		missionNamespace setVariable [VAR_INITIALIZED, true];
		missionNamespace setVariable [VAR_LOGIC, _logic, true];
		missionNamespace setVariable [VAR_SIDES, [WEST, EAST], true];

		// Gather objectives and randomisers
		private ["_objectives", "_randomisers", "_bases", "_endGameObjectives"];
		_objectives 		= ["GetAllSyncedObjectives", [_logic]] call SELF;
		_randomisers 		= ["GetAllSyncedRandomisers"] call SELF;
		_bases			= ["GetAllSyncedBases"] call SELF;
		_endGameObjectives	= ["GetSyncedEndGameObjectives"] call SELF;

		// Validate EndGame objective
		if ({ !isNull _x } count _endGameObjectives < 1) exitWith
		{
			["Initialize: EndGame objectives not valid (%1), at least one must be added to mission", _endGameObjectives] call BIS_fnc_error;
			["Terminate"] call SELF;
		};

		private "_endGameObjective";
		_endGameObjective = _endGameObjectives call BIS_fnc_selectRandom;
		_endGameObjectives = _endGameObjectives - [_endGameObjective];

		// Go through all randomiser modules and gather a random objective from each
		{
			private "_randomObjective";
			_randomObjective = ["GetRandomObjectiveFromRandomiser", [_x]] call SELF;

			if (!isNull _randomObjective) then
			{
				_objectives pushBack _randomObjective;
			};
		} forEach _randomisers;

		// Validate number of middle game objectives
		if (count _objectives < _endGameThreshold) exitWith
		{
			["Initialize: Not enough objectives", _endGameThreshold, _objectives] call BIS_fnc_error;
			["Terminate"] call SELF;
		};

		private ["_countBasesWest", "_countBasesEast"];
		_countBasesWest = { _x getVariable ["AttackingSide", "SideUnknown"] == "WEST" } count _bases;
		_countBasesEast = { _x getVariable ["AttackingSide", "SideUnknown"] == "EAST" } count _bases;

		// Validate number of bases per side
		if
		(
			_countBasesWest < 1
			||
			_countBasesEast < 1
		) exitWith
		{
			["Not enough bases were set: West (%1) / East (%2)", _countBasesWest, _countBasesEast] call BIS_fnc_error;
		};

		private ["_basesWest", "_basesEast"];
		_basesWest = [];
		_basesEast = [];

		// Go through all the bases and retrieve a random one for each side
		{
			private "_ownerSide";
			_ownerSide = _x getVariable ["AttackingSide", "WEST"];

			switch (_ownerSide) do
			{
				case "WEST" : 		{ _basesWest pushBack _x; };
				case "EAST" : 		{ _basesEast pushBack _x; };
				case "RESISTANCE" : 	{ RESISTANCE };
				case default 		{ CIVILIAN };
			};
		} forEach _bases;

		// Select a random base for each side
		private ["_baseWest", "_baseEast"];
		_baseWest = _basesWest call BIS_fnc_selectRandom;
		_baseEast = _basesEast call BIS_fnc_selectRandom;

		// Get each side base
		{
			private "_ownerSide";
			_ownerSide = _x getVariable ["AttackingSide", "WEST"];

			// Convert the side string to actual side object
			private "_side";
			_side = switch (_ownerSide) do
			{
				case "WEST" : 		{ WEST };
				case "EAST" : 		{ EAST };
				case "RESISTANCE" : 	{ RESISTANCE };
				case default 		{ CIVILIAN };
			};

			// Flag the objective with the owner side
			_x setVariable [VAR_BASE_SIDE, _side, true];

			// Initialize objective
			["InitializeObjective", [_x, _side, ["GetOppositeSide", [_side]] call SELF]] call SELF;
			["Reveal", [_x, _side]] call OBJECTIVE;
			["SetObjectsVisibility", [_x, true]] call OBJECTIVE;

			// Log
			["Initialize: Base (%1) registered for (%2)", _x, _side] call BIS_fnc_logFormat;
		} forEach [_baseWest, _baseEast];

		// Delete objects and clutter from bases which were not used
		private "_toDeleteBases";
		_toDeleteBases = _bases - [_baseWest, _baseEast];

		{
			["DeleteObjects", [_x]] call OBJECTIVE;
		} forEach _toDeleteBases;

		// Store data
		missionNamespace setVariable [VAR_RANDOMISERS, _randomisers];
		missionNamespace setVariable [VAR_BASES, [_baseWest, _baseEast], true];
		missionNamespace setVariable [VAR_OBJECTIVES, _objectives, true];
		missionNamespace setVariable [VAR_ENDGAME_OBJECTIVE, _endGameObjective, true];
		missionNamespace setVariable [VAR_COMPLETED_OBJECTIVES, []];

		// Hide all objectives
		{
			["SetObjectsVisibility", [_x, false]] call OBJECTIVE;
		} forEach _objectives + [_endGameObjective];

		// Delete objects from unwanted objectives
		{
			["DeleteObjects", [_x]] call OBJECTIVE;
		} forEach (["GetAllUnwantedObjectives"] call SELF) + _endGameObjectives;

		// Suflle objectives
		private "_shuffledObjectives";
		_shuffledObjectives = _objectives call bis_fnc_arrayShuffle;
		missionNamespace setVariable [VAR_OBJECTIVES_ORDERED, _shuffledObjectives];

		// Init server and players
		[[], "BIS_fnc_moduleHvtInit", true, true] call BIS_fnc_mp;

		// Music
		["PlayMusic", [1, sideUnknown]] call SELF;

		// Log
		["Initialize: %1 / %2 / %3 / %4", _logic, _randomisers, _objectives] call BIS_fnc_logFormat;
	};

	case "Terminate" :
	{
		// Reset data
		missionNamespace setVariable [VAR_INITIALIZED, nil];
		missionNamespace setVariable [VAR_LOGIC, nil, true];
		missionNamespace setVariable [VAR_RANDOMISERS, nil];
		missionNamespace setVariable [VAR_SIDES, nil, true];
		missionNamespace setVariable [VAR_BASES, nil, true];
		missionNamespace setVariable [VAR_OBJECTIVES, nil, true];
		missionNamespace setVariable [VAR_ENDGAME_OBJECTIVE, nil];
		missionNamespace setVariable [VAR_COMPLETED_OBJECTIVES, nil];
		missionNamespace setVariable [VAR_MISSION_FLOW_FSM, nil];

		// Log
		"Terminate" call BIS_fnc_log;
	};

	case "IsInitialized" :
	{
		!isNil { missionNamespace getVariable VAR_INITIALIZED };
	};

	case "GetLogic" :
	{
		missionNamespace getVariable [VAR_LOGIC, objNull];
	};

	case "GetStage" :
	{
		if (isNil { BIS_hvt_stage }) then
		{
			[-1, -1];
		}
		else
		{
			BIS_hvt_stage;
		};
	};

	case "GetStageMain" :
	{
		if (isNil { BIS_hvt_stage }) then
		{
			-1;
		}
		else
		{
			(BIS_hvt_stage select 0) max (BIS_hvt_stage select 1);
		};
	};

	case "GetStageSide" :
	{
		private ["_side"];
		_side	= _parameters param [0, sideUnknown, [sideUnknown]];

		private "_index";
		_index = if (_side == WEST) then { 0 } else { 1 };

		if (isNil { BIS_hvt_stage }) then
		{
			-1;
		}
		else
		{
			BIS_hvt_stage select _index;
		};
	};

	case "SetStage" :
	{
		private ["_stageOfSide", "_side"];
		_stageOfSide 	= _parameters param [0, 0, [0]];
		_side		= _parameters param [1, sideUnknown, [sideUnknown]];

		// Do not allow setting the same stage
		if (_stageOfSide != ["GetStageSide", [_side]] call SELF) then
		{
			private "_stage";
			_stage = ["GetStage"] call SELF;

			private "_index";
			_index = if (_side == WEST) then { 0 } else { 1 };

			_stage set [_index, _stageOfSide];
			BIS_hvt_stage = _stage;
			publicVariable "BIS_hvt_stage";

			// Update stage on the clients of side
			[["OnStageChanged", [_stageOfSide, _side]], "BIS_fnc_moduleHvtObjectivesInstance", _side, false] call BIS_fnc_mp;

			// Update stage for every one
			[["OnStageChangedGlobal", [_stageOfSide, _side]], "BIS_fnc_moduleHvtObjectivesInstance", true, false] call BIS_fnc_mp;
		};
	};

	case "OnStageChanged" :
	{
		disableSerialization;
		["SetStage", [_parameters select 0, _parameters select 1]] call (uiNamespace getVariable ["RscHvtPhase_script", {}]);
	};

	case "OnStageChangedGlobal" :
	{
		disableSerialization;
		[missionNamespace, "EndGame_OnStageChanged", [_parameters select 0, _parameters select 1], false] call BIS_fnc_callScriptedEventHandler;

		if (LOG_NETWORK_TRAFFIC) then
		{
			call compile
			"
				format['EndGameLogs\%1_(%2)_(%3)_(%4-%5-%6).txt', [] call BIS_fnc_getNetMode, _parameters select 0, profileName, missionStart select 3, missionStart select 4, missionStart select 5] diag_exportMessageDetails [];
				diag_clearMessageDetails [];
			";
		};
	};

	case "CompileFunctions" :
	{
		[
			"\a3\Modules_F_MP_Mark\Objectives\scripts\",
			"bis_fnc_moduleMPTypeHvt_",
			[
				"areaManager",
				"conversations",
				"spawnParticleEffect",
				"downloadObject",
				"downloadProgress",
				"laptopParticles",
				"carrier",
				"carrier_canPickup",
				"carrier_canUpload",
				"carrier_draw",
				"rules",
				"postPreload",
				"createFobMarker"
			],
			true
		] call bis_fnc_loadFunctions;
	};

	case "GetAllUnwantedObjectives" :
	{
		private ["_objectives", "_randomisers", "_objectivesFromRandomisers"];
		_objectives 				= ["GetAllObjectives"] call SELF;
		_randomisers 				= ["GetAllSyncedRandomisers"] call SELF;
		_objectivesFromRandomisers	= [];

		{
			private "_objectivesOfRandomiser";
			_objectivesOfRandomiser = ["GetAllSyncedObjectives", [_x]] call SELF;

			{
				_objectivesFromRandomisers pushBack _x;
			} forEach _objectivesOfRandomiser;
		} forEach _randomisers;

		_objectivesFromRandomisers - _objectives;
	};

	case "GetRandomObjectiveFromRandomiser" :
	{
		private ["_randomiser"];
		_randomiser = _parameters param [0, objNull, [objNull]];

		private ["_syncedObjectives", "_objective"];
		_syncedObjectives = ["GetAllSyncedObjectives", [_randomiser]] call SELF;
		_objective = objNull;

		if (count _syncedObjectives > 0) then
		{
			_objective = _syncedObjectives call BIS_fnc_selectRandom;
			_randomiser setVariable ["BIS_selectedObjective", _objective];
		};

		_objective;
	};

	case "GetAllSyncedRandomisers" :
	{
		private ["_objects", "_randomisers"];
		_objects 	= synchronizedObjects (["GetLogic"] call SELF);
		_randomisers	= [];

		{
			if (_x isKindOf CLASS_OBJECTIVE_RANDOMISER) then
			{
				_randomisers pushBack _x;
			};
		} forEach _objects;

		_randomisers;
	};

	case "GetAllSyncedBases" :
	{
		private ["_objects", "_bases"];
		_objects 	= synchronizedObjects (["GetLogic"] call SELF);
		_bases		= [];

		{
			if (_x isKindOf CLASS_STARTGAME_OBJECTIVE) then
			{
				_bases pushBack _x;
			};
		} forEach _objects;

		_bases;
	};

	case "GetAllSyncedObjectives" :
	{
		private ["_root"];
		_root = _parameters param [0, ["GetLogic"] call SELF, [objNull]];

		private ["_objects", "_objectives"];
		_objects 	= synchronizedObjects _root;
		_objectives	= [];

		{
			if (_x isKindOf CLASS_SIMPLE_OBJECTIVE) then
			{
				_objectives pushBack _x;
			};
		} forEach _objects;

		_objectives;
	};

	case "GetSyncedStartGameObjective" :
	{
		private ["_root"];
		_root = _parameters param [0, objNull, [objNull]];

		private ["_objects", "_objective"];
		_objects 	= synchronizedObjects _root;
		_objective	= objNull;

		{
			if (_x isKindOf CLASS_STARTGAME_OBJECTIVE) exitWith
			{
				_objective = _x;
			};
		} forEach _objects;

		_objective;
	};

	case "GetSyncedEndGameObjectives" :
	{
		private ["_root"];
		_root = _parameters param [0, ["GetLogic"] call SELF, [objNull]];

		private ["_objects", "_objectives"];
		_objects 	= synchronizedObjects _root;
		_objectives	= [];

		{
			if (_x isKindOf CLASS_ENDGAME_OBJECTIVE) then
			{
				_objectives pushBack _x;
			};
		} forEach _objects;

		_objectives;
	};

	case "GetAllSyncedUnitsOfSide" :
	{
		private ["_root", "_side"];
		_root = _parameters param [0, ["GetLogic"] call SELF, [objNull]];
		_side = _parameters param [1, SIDEUNKNOWN, [SIDEUNKNOWN]];

		private ["_objects", "_units"];
		_objects 	= synchronizedObjects _root;
		_units		= [];

		{
			if (_x isKindOf "Man" && side group _x == _side) then
			{
				_units pushBack _x;
			};
		} forEach _objects;

		_units;
	};

	case "GetBases" :
	{
		missionNamespace getVariable [VAR_BASES, []];
	};

	case "GetBaseOfSide" :
	{
		private ["_side"];
		_side = _parameters param [0, SIDEUNKNOWN, [SIDEUNKNOWN]];

		private ["_bases", "_base"];
		_bases	= ["GetBases"] call SELF;
		_base	= objNull;

		{
			if (_x getVariable [VAR_BASE_SIDE, SIDEUNKNOWN] == _side) exitWith
			{
				_base = _x;
			};
		} forEach _bases;

		_base;
	};

	case "GetOppositeSide" :
	{
		private ["_side"];
		_side = _parameters param [0, SIDEUNKNOWN, [SIDEUNKNOWN]];

		private "_sides";
		_sides = [] + (["GetSides"] call SELF);
		_sides deleteAt (_sides find _side);

		_sides select 0;
	};

	case "GetAllObjectives" :
	{
		missionNamespace getVariable [VAR_OBJECTIVES, []];
	};

	case "GetAllObjectivesOrdered" :
	{
		missionNamespace getVariable [VAR_OBJECTIVES_ORDERED, []];
	};

	case "GetStartGameObjective" :
	{
		missionNamespace getVariable [VAR_STARTGAME_OBJECTIVE, objNull];
	};

	case "GetEndGameObjective" :
	{
		missionNamespace getVariable [VAR_ENDGAME_OBJECTIVE, objNull];
	};

	case "GetAllCompletedObjectives" :
	{
		missionNamespace getVariable [VAR_COMPLETED_OBJECTIVES, []];
	};

	case "GetAllIncompleteObjectives" :
	{
		(["GetAllObjectives"] call SELF) - (["GetAllCompletedObjectives"] call SELF);
	};

	case "GetSideCompletedObjectives" :
	{
		private ["_side"];
		_side = _parameters param [0, SIDEUNKNOWN, [SIDEUNKNOWN]];

		private "_completed";
		_completed = [];

		// Go through all completed objectives and gather those which belong to the given side
		{
			if (_side in (["GetWinners", [_x]] call OBJECTIVE)) then {
				_completed pushBack _x;
			};
		} forEach (["GetAllObjectives"] call SELF);

		_completed;
	};

	case "GetSideCompletedObjectivesCount" :
	{
		private ["_side"];
		_side = _parameters param [0, SIDEUNKNOWN, [SIDEUNKNOWN]];

		count (["GetSideCompletedObjectives", [_side]] call SELF);
	};

	case "GetSideHasFob" :
	{
		private ["_side"];
		_side = _parameters param [0, sideUnknown, [sideUnknown]];

		_side in (missionNamespace getVariable [VAR_SIDES_WITH_FOB, []]);
	};

	case "InitializeObjective" :
	{
		private ["_objective", "_sideA", "_sideB"];
		_objective 	= _parameters param [0, objNull, [objNull]];
		_sideA		= _parameters param [1, (["GetSides"] call SELF) select 0, [sideUnknown]];
		_sideB		= _parameters param [2, (["GetSides"] call SELF) select 1, [sideUnknown]];

		if (isNull _objective) exitWith
		{
			"InitializeObjective: Unable to initialize a NULL objective" call BIS_fnc_error;
		};

		["Initialize", [_objective, _sideA, _sideB]] call OBJECTIVE;
	};

	case "OnStartGameObjectiveCompleted" :
	{
		private _side = _parameters param [0, sideUnknown, [sideUnknown]];
		private _sidesWithFob = missionNamespace getVariable [VAR_SIDES_WITH_FOB, []];

		if !(_side in _sidesWithFob) then
		{
			_sidesWithFob pushBack _side;
			missionNamespace setVariable [VAR_SIDES_WITH_FOB, _sidesWithFob, true];

			private "_shuffledObjectives";
			_shuffledObjectives = ["GetAllObjectivesOrdered"] call SELF;

			// Initialize all objectives if not done yet
			if (isNil { missionNamespace getVariable "BIS_moduleHvtObjectivesInstance_objectivesInitialized" }) then
			{
				missionNamespace setVariable ["BIS_moduleHvtObjectivesInstance_objectivesInitialized", true];
				{ ["Initialize", [_x]] call OBJECTIVE; } forEach _shuffledObjectives;
			};

			// Delay revealing objectives to side
			if (isNil { missionNamespace getVariable format["BIS_moduleHvtObjectivesInstance_objectivesRevealed_%1", _side] }) then
			{
				missionNamespace setVariable [format["BIS_moduleHvtObjectivesInstance_objectivesRevealed_%1", _side], true];
				["DelayObjectivesReveal", [_shuffledObjectives, _side]] call SELF;
			};

			// The opposing side
			private "_opposingSide";
			_opposingSide = ["GetOppositeSide", [_side]] call SELF;

			// Show notification to the oposite side
			[["HVT_FobEstablished"], "bis_fnc_shownotification", _opposingSide, false] call BIS_fnc_mp;

			// Set stage
			["SetStage", [1, _side]] call SELF;

			// Music
			["PlayMusic", [2, _side]] call SELF;

			// Conversation
			["FobControl", _side] call bis_fnc_moduleMPTypeHvt_conversations;

			// Trigger event handler
			[missionNamespace, "EndGame_OnStartGameObjectiveCompleted", [_side], false] call BIS_fnc_callScriptedEventHandler;
		};
	};

	case "OnObjectiveStateChanged" :
	{
		private ["_objective", "_side", "_newStateFor"];
		_objective 	= _parameters param [0, objNull, [objNull]];
		_side		= _parameters param [1, sideUnknown, [sideUnknown]];
		_newStateFor	= _parameters param [2, "", [""]];

		// Is it time to initialize the end game?
		if (_newStateFor == "Succeed") then
		{
			if (["IsEndGameThresholdReached"] call SELF && !(["HasEndGameStarted"] call SELF)) then
			{
				// Initialize end game
				["InitializeEndGame"] call SELF;
			}
			else
			{
				// Conversation about retrieving an intel point
				["IntelRetrieved", _side] call bis_fnc_moduleMPTypeHvt_conversations;
			};
		};

		// Trigger event handler
		[missionNamespace, "EndGame_OnObjectiveStateChanged", [_objective, _side, _newStateFor], false] call BIS_fnc_callScriptedEventHandler;

		// Log
		["OnObjectiveStateChanged: (%1) changed state for side (%2) with (%3) and EndGame threshold was reached (%4)", _objective, _side, _newStateFor] call BIS_fnc_logFormat;
	};

	case "OnObjectiveCompleted" :
	{
		private ["_objective"];
		_objective = _parameters param [0, objNull, [objNull]];

		// Add to completed objectives
		private "_completed";
		_completed = missionNamespace getVariable [VAR_COMPLETED_OBJECTIVES, []];
		_completed pushBack _objective;
		missionNamespace setVariable [VAR_COMPLETED_OBJECTIVES, _completed];

		// Trigger event handler
		[missionNamespace, "EndGame_OnObjectiveCompleted", [_objective], false] call BIS_fnc_callScriptedEventHandler;

		["OnObjectiveCompleted: (%1) completed", _objective] call BIS_fnc_logFormat;
	};

	case "OnObjectiveEnded" :
	{
		private ["_objective"];
		_objective = _parameters param [0, objNull, [objNull]];

		if (["GetIsEndGame", [_objective]] call OBJECTIVE) then
		{
			["EndMission", [_objective]] call SELF;
		};

		// Trigger event handler
		[missionNamespace, "EndGame_OnObjectiveEnded", [_objective], false] call BIS_fnc_callScriptedEventHandler;

		["OnObjectiveEnded: (%1) objective ended", _objective] call BIS_fnc_logFormat;
	};

	case "GetEndGameThreshold" :
	{
		missionNamespace getVariable [VAR_ENDGAME_THRESHOLD, 3];
	};

	case "SetEndGameThreshold" :
	{
		private ["_threshold"];
		_threshold = _parameters param [0, 3, [0]];
		missionNamespace setVariable [VAR_ENDGAME_THRESHOLD, _threshold];
	};

	case "GetLeadingSide" :
	{
		private ["_blufor", "_opfor"];
		_blufor 	= 0;
		_opfor		= 0;

		private "_objectives";
		_objectives = ["GetAllObjectives"] call SELF;

		{
			if (WEST in (["GetWinners", [_x]] call OBJECTIVE)) then
			{
				_blufor = _blufor + 1;
			};

			if (EAST in (["GetWinners", [_x]] call OBJECTIVE)) then
			{
				_opfor = _opfor + 1;
			};
		} forEach _objectives;

		switch (true) do
		{
			case (_blufor > _opfor) : { WEST };
			case (_opfor > _blufor) : { EAST };
			case default { SIDEUNKNOWN };
		};
	};

	case "IsEndGameThresholdReached" :
	{
		private ["_all", "_westWinner", "_eastWinner", "_ended"];
		_all		= ["GetAllObjectives"] call SELF;
		_westWinner	= [];
		_eastWinner	= [];
		_ended		= [];

		{
			private ["_isStartGame", "_isEndGame"];
			_isStartGame 	= ["GetIsStartGame", [_x]] call OBJECTIVE;
			_isEndGame 	= ["GetIsEndGame", [_x]] call OBJECTIVE;

			if (!_isStartGame && !_isEndGame) then
			{
				if (WEST in (["GetWinners", [_x]] call OBJECTIVE)) then {
					_westWinner pushBack _x;
				};

				if (East in (["GetWinners", [_x]] call OBJECTIVE)) then {
					_eastWinner pushBack _x;
				};

				if (["HasEnded", [_objective]] call OBJECTIVE) then
				{
					_ended pushBack _x;
				};
			};
		} forEach _all;

		private "_threshold";
		_threshold = ["GetEndGameThreshold"] call SELF;

		count _westWinner >= _threshold || count _eastWinner >= _threshold;
	};

	case "HasEndGameStarted" :
	{
		!isNil { BIS_hvt_endGame };
	};

	case "InitializeEndGame" :
	{
		private ["_leadingSide", "_endGameObjective"];
		_leadingSide 		= ["GetLeadingSide"] call SELF;
		_endGameObjective	= ["GetEndGameObjective"] call SELF;

		// Public variable end game objective
		// Also serves as a flag that last phase of end game started
		BIS_hvt_endGame = _endGameObjective;
		publicVariable "BIS_hvt_endGame";

		// If we have no leading side, set it here
		// We might have been called from debug where no side is leading
		if (_leadingSide == SIDEUNKNOWN) then
		{
			_leadingSide = WEST;
		};

		// The losing side
		private "_loosingSide";
		_loosingSide = ["GetOppositeSide", [_leadingSide]] call SELF;

		// End mission if requested and losing side did not yet completed FOB task
		if ((["GetLogic"] call SELF) getVariable ["EndWhenSideHasNoFob", true] && !(["GetSideHasFob", [_loosingSide]] call SELF)) exitWith
		{
			["InitializeEndGame: Opposing side (%1) has not yet revealed any objectives, ending mission", _loosingSide] call BIS_fnc_logFormat;
			["EndMissionPrematurely", [_leadingSide, _loosingSide]] call SELF;
		};

		// Set timer
		if (!isNil { BIS_missionLastPhaseTimer }) then
		{
			if (BIS_missionLastPhaseTimer > 0) then
			{
				BIS_hvt_timeoutTarget = time + BIS_missionLastPhaseTimer;
				publicVariable "BIS_hvt_timeoutTarget";
			};
		}
		else
		{
			BIS_hvt_timeoutTarget = time + (_endGameObjective getVariable ["TimeLimit", 1200]);
			publicVariable "BIS_hvt_timeoutTarget";
		};

		// Hide all objectives
		["HideAllObjectives"] call SELF;

		// Start EndGame objective
		["Initialize", [_endGameObjective, _leadingSide, _loosingSide]] call OBJECTIVE;
		["SetObjectsVisibility", [_endGameObjective, true]] call OBJECTIVE;

		// Reveal objective
		["Reveal", [_endGameObjective, _leadingSide]] call OBJECTIVE;
		["Reveal", [_endGameObjective, _loosingSide]] call OBJECTIVE;

		// Set stage
		["SetStage", [2, west]] call SELF;
		["SetStage", [2, east]] call SELF;

		// Calculate end game respawn delay
		private "_respawnDelay";
		_respawnDelay = 45;

		if (!isNil { BIS_endGameRespawnDelay }) then
		{
			_respawnDelay = BIS_endGameRespawnDelay;
		};

		// Set respawn time for end game phase
		missionNamespace setVariable ["BIS_selectRespawnTemplate_delay", _respawnDelay];
		publicVariable "BIS_selectRespawnTemplate_delay";

		// Music
		["PlayMusic", [3, sideUnknown]] call SELF;

		// Log
		["InitializeEndGame: Initialized (%1)", _endGameObjective] call BIS_fnc_logFormat;
	};

	case "HideAllObjectives" :
	{
		private ["_allObjectives", "_sides"];
		_allObjectives 	= ["GetAllObjectives"] call SELF;
		_sides		= ["GetSides"] call SELF;

		["HideAllObjectives: Deleting objectives (%1) for sides (%2)", _allObjectives, _sides] call BIS_fnc_logFormat;

		{
			private "_objective";
			_objective = _x;

			{
				["Hide", [_objective, _x]] call OBJECTIVE;
			} forEach _sides;
		} forEach _allObjectives;
	};

	case "DelayObjectivesReveal" :
	{
		_parameters spawn
		{
			scriptName "fn_moduleHvtObjectivesInstance.sqf: DelayObjectiveInitialization";

			private ["_objectives", "_side"];
			_objectives 	= _this param [0, [], [[]]];
			_side		= _this param [1, sideUnknown, [sideUnknown]];

			{
				sleep (missionNamespace getVariable ["BIS_hvt_delayBetweenObjectiveReveal", 10]);

				if !(["HasEndGameStarted"] call SELF) then
				{
					["Reveal", [_x, _side]] call OBJECTIVE;
				};
			} forEach _objectives;
		};
	};

	case "GetSides" :
	{
		missionNamespace getVariable [VAR_SIDES, [WEST, EAST]];
	};

	case "EndMission" :
	{
		private ["_endGameObjective"];
		_endGameObjective = _parameters param [0, objNull, [objNull]];

		// Draw
		if (["GetIsDraw", [_endGameObjective]] call OBJECTIVE) exitWith
		{
			[["DRAW", true, true], "BIS_fnc_endMission", [WEST, EAST, RESISTANCE, civilian], true] call BIS_fnc_mp;
			[["SPECTATOR_DRAW", true, true], "BIS_fnc_endMission", sideLogic, true] call BIS_fnc_mp;

			if (isDedicated) then
			{
				["DRAW", true, true] call BIS_fnc_endMission;
			};
		};

		private ["_endGameWinners", "_endGameLoosers"];
		_endGameWinners = ["GetWinners", [_endGameObjective]] call OBJECTIVE;
		_endGameLoosers = ["GetLoosers", [_endGameObjective]] call OBJECTIVE;

		if (count _endGameWinners < 1 || count _endGameLoosers < 1) then
		{
			"EndMission: EndGame winners or loosers is empty, unable to detect winner/looser sides" call BIS_fnc_error;
		};

		private ["_winnerSide", "_looserSide"];
		_winnerSide	= _endGameWinners select 0;
		_looserSide	= _endGameLoosers select 0;

		[["WINNER", true, true], "BIS_fnc_endMission", _winnerSide, true] call BIS_fnc_mp;
		[["LOOSER", true, true], "BIS_fnc_endMission", _looserSide, true] call BIS_fnc_mp;
		[["LOOSER", true, true], "BIS_fnc_endMission", [RESISTANCE, CIVILIAN], true] call BIS_fnc_mp;

		if (_winnerSide == WEST) then
		{
			[["SPECTATOR_WEST", true, true], "BIS_fnc_endMission", sideLogic, true] call BIS_fnc_mp;
		}
		else
		{
			[["SPECTATOR_EAST", true, true], "BIS_fnc_endMission", sideLogic, true] call BIS_fnc_mp;
		};

		if (isDedicated) then
		{
			["WINNER", true, true] call BIS_fnc_endMission;
		};

		["EndGood", _winnerSide] call bis_fnc_moduleMPTypeHvt_conversations;
		["EndBad", _looserSide] call bis_fnc_moduleMPTypeHvt_conversations;

		[[[], {	("RscHvtPhase" call BIS_fnc_rscLayer) cutText ["", "PLAIN"]; }], "BIS_fnc_spawn", true, true] call BIS_fnc_mp;

		[["OnEndGameEnded", [_winnerSide, _looserSide, ["GetIsDraw", [_endGameObjective]] call OBJECTIVE]], "BIS_fnc_moduleHvtObjectivesInstance", true, true] call BIS_fnc_mp;
	};

	case "EndMissionPrematurely" :
	{
		private ["_winnerSide", "_looserSide"];
		_winnerSide = _parameters param [0, sideUnknown, [sideUnknown]];
		_looserSide = _parameters param [1, sideUnknown, [sideUnknown]];

		[["AMAZING_WINNER", true, true], "BIS_fnc_endMission", _winnerSide, true] call BIS_fnc_mp;
		[["AMAZING_LOOSER", true, true], "BIS_fnc_endMission", _looserSide, true] call BIS_fnc_mp;
		[["AMAZING_LOOSER", true, true], "BIS_fnc_endMission", [RESISTANCE, CIVILIAN], true] call BIS_fnc_mp;

		if (_winnerSide == WEST) then
		{
			[["SPECTATOR_WEST", true, true], "BIS_fnc_endMission", sideLogic, true] call BIS_fnc_mp;
		}
		else
		{
			[["SPECTATOR_EAST", true, true], "BIS_fnc_endMission", sideLogic, true] call BIS_fnc_mp;
		};

		if (isDedicated) then
		{
			["WINNER", true, true] call BIS_fnc_endMission;
		};

		["EndGood", _winnerSide] call bis_fnc_moduleMPTypeHvt_conversations;
		["EndBad", _looserSide] call bis_fnc_moduleMPTypeHvt_conversations;

		[[[], {	("RscHvtPhase" call BIS_fnc_rscLayer) cutText ["", "PLAIN"]; }], "BIS_fnc_spawn", true, true] call BIS_fnc_mp;

		[["OnEndGameEnded", [_winnerSide, _looserSide, false]], "BIS_fnc_moduleHvtObjectivesInstance", true, true] call BIS_fnc_mp;
	};

	case "EndMissionCarrier" :
	{
		private ["_winnerSide", "_looserSide"];
		_winnerSide = _parameters param [0, sideUnknown, [sideUnknown]];
		_looserSide = _parameters param [1, sideUnknown, [sideUnknown]];

		[["CARRIER_WINNER", true, true], "BIS_fnc_endMission", _winnerSide, true] call BIS_fnc_mp;
		[["CARRIER_LOOSER", true, true], "BIS_fnc_endMission", _looserSide, true] call BIS_fnc_mp;
		[["CARRIER_LOOSER", true, true], "BIS_fnc_endMission", [RESISTANCE, CIVILIAN], true] call BIS_fnc_mp;

		if (_winnerSide == WEST) then
		{
			[["SPECTATOR_WEST", true, true], "BIS_fnc_endMission", sideLogic, true] call BIS_fnc_mp;
		}
		else
		{
			[["SPECTATOR_EAST", true, true], "BIS_fnc_endMission", sideLogic, true] call BIS_fnc_mp;
		};

		if (isDedicated) then
		{
			["WINNER", true, true] call BIS_fnc_endMission;
		};

		[[[], {	("RscHvtPhase" call BIS_fnc_rscLayer) cutText ["", "PLAIN"]; }], "BIS_fnc_spawn", true, true] call BIS_fnc_mp;

		[["OnEndGameEnded", [_winnerSide, _looserSide, false]], "BIS_fnc_moduleHvtObjectivesInstance", true, true] call BIS_fnc_mp;
	};

	case "EndMissionSchematics" :
	{
		private ["_winnerSide", "_looserSide"];
		_winnerSide = _parameters param [0, sideUnknown, [sideUnknown]];
		_looserSide = _parameters param [1, sideUnknown, [sideUnknown]];

		[["SCHEMATICS_WINNER", true, true], "BIS_fnc_endMission", _winnerSide, true] call BIS_fnc_mp;
		[["SCHEMATICS_LOOSER", true, true], "BIS_fnc_endMission", _looserSide, true] call BIS_fnc_mp;
		[["SCHEMATICS_LOOSER", true, true], "BIS_fnc_endMission", [RESISTANCE, CIVILIAN], true] call BIS_fnc_mp;

		if (_winnerSide == WEST) then
		{
			[["SPECTATOR_WEST", true, true], "BIS_fnc_endMission", sideLogic, true] call BIS_fnc_mp;
		}
		else
		{
			[["SPECTATOR_EAST", true, true], "BIS_fnc_endMission", sideLogic, true] call BIS_fnc_mp;
		};

		if (isDedicated) then
		{
			["WINNER", true, true] call BIS_fnc_endMission;
		};

		[[[], {	("RscHvtPhase" call BIS_fnc_rscLayer) cutText ["", "PLAIN"]; }], "BIS_fnc_spawn", true, true] call BIS_fnc_mp;

		[["OnEndGameEnded", [_winnerSide, _looserSide, false]], "BIS_fnc_moduleHvtObjectivesInstance", true, true] call BIS_fnc_mp;
	};

	case "OnEndGameEnded" :
	{
		[missionNamespace, "EndGame_Ended", [_parameters select 0, _parameters select 1, _parameters select 2], false] call BIS_fnc_callScriptedEventHandler;

		if (LOG_NETWORK_TRAFFIC) then
		{
			call compile
			"
				format['EndGameLogs\%1_(%2)_(%3)_(%4-%5-%6).txt', [] call BIS_fnc_getNetMode, 'Ended', profileName, missionStart select 3, missionStart select 4, missionStart select 5] diag_exportMessageDetails [];
				diag_clearMessageDetails [];
			";
		};
	};

	case "PlayMusic" :
	{
		private ["_phase", "_side"];
		_phase = _parameters param [0, 0, [0]];
		_side  = _parameters param [1, sideUnknown, [sideUnknown]];

		private "_musicClass";
		_musicClass = switch (_phase) do
		{
			case 1 : { (["GetLogic"] call SELF) getVariable ["PhaseOneMusic", ""]; };
			case 2 : { (["GetLogic"] call SELF) getVariable ["PhaseTwoMusic", ""]; };
			case 3 : { (["GetLogic"] call SELF) getVariable ["PhaseThreeMusic", ""]; };
			default  { ""; };
		};

		if (_musicClass != "") then
		{
			private "_target";
			_target = if (_side == sideUnknown) then { true } else { _side };

			// Play music
			[_musicClass, "playMusic", _target, _phase == 1] call BIS_fnc_mp;
		};
	};

	case "SkipToStage" :
	{
		private _newStage = _parameters param [0, -1, [0]];
		private _currentStage = ["GetStageMain"] call SELF;

		if (_currentStage < _newStage) then
		{
			switch (_newStage) do
			{
				case 0 :
				{
					BIS_skipWarmup = true; publicVariable "BIS_skipWarmup";
				};

				case 1 :
				{
					BIS_skipWarmup = true; publicVariable "BIS_skipWarmup";
					BIS_hvt_skipFob = true; publicVariable "BIS_hvt_skipFob";
				};

				case 2 :
				{
					BIS_skipWarmup = true; publicVariable "BIS_skipWarmup";
					BIS_hvt_skipFob = true; publicVariable "BIS_hvt_skipFob";
					["InitializeEndGame"] call SELF;
				};
			};
		};
	};

	case default
	{
		["Invalid action: %1", _action] call BIS_fnc_error;
	};
};