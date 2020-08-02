/*
	Author: Jiri Wainar

	Meant to be run by the framework in MP scenarions in postInit. Do not run it by it's own.
*/

#define DEBUG_LOG			{}
#define CMD_SLEEP			uisleep
#define IS_SPECTATOR(unit)		((side group unit) == sideLogic)			//todo: replace by proper function for detecting spectator unit

#define MODE_DISABLED			0
#define MODE_ENABLED			1
#define MODE_ENABLED_WITH_PROPAGATION	2
#define MODE_UPDATE			3
#define MODE_ADD			4
#define MODE_REMOVE			5
#define MODE_REASSIGN			6

#define MODES				["MODE_DISABLED","MODE_ENABLED","MODE_ENABLED_WITH_PROPAGATION","MODE_UPDATE","MODE_ADD","MODE_REMOVE","MODE_REASSIGN"]

private _mode = _this select 0;

["[ ] %1 (%2)",MODES select _mode,_mode] call DEBUG_LOG;

//check termination conditions
if (_mode == MODE_DISABLED || {!isMultiplayer || {isDedicated || {!hasInterface}}}) exitWith {};

switch (_mode) do
{
	//localy un-registers player from one task and registers him into another
	case MODE_UPDATE:
	{
		private ["_new","_unit","_unitVar","_prev","_key","_units"];

		_new = _this select 1;
		_unit = _this select 2;
		_prev = _unit getVariable ["@local",""];
		_unitVar = _unit call bis_fnc_objectVar;

		if (_new == _prev) exitWith {};

		//un-register localy _unit from prev _task
		if (_prev != "") then
		{
			["[ ] Player '%1' un-registered from task '%2'.",_unitVar,_prev] call DEBUG_LOG;

			_key = format["%1_units",_prev call bis_fnc_taskVar];
			_units = missionNamespace getVariable [_key,[]];
			_units = _units - [_unitVar];
			missionNamespace setVariable [_key,+_units];

			//update custom data for previous task
			(_prev call bis_fnc_taskReal) setSimpleTaskCustomData (_units call bis_fnc_sharedObjectives_getCustomData);
		};

		//register localy _unit to new _task
		if (_new != "") then
		{
			["[ ] Player '%1' registered to task '%2'.",_unitVar,_new] call DEBUG_LOG;

			_key = format["%1_units",_new call bis_fnc_taskVar];
			_units = missionNamespace getVariable [_key,[]];
			_units = _units - [_unitVar] + [_unitVar];
			missionNamespace setVariable [_key,+_units];

			//update custom data for previous task
			(_new call bis_fnc_taskReal) setSimpleTaskCustomData (_units call bis_fnc_sharedObjectives_getCustomData);
		};

		//update the previous task with current task
		_unit setVariable ["@local",_new];

		//check the task propagation
		if (bis_fnc_sharedObjectives_propagate && {leader group player == _unit} && {count units group player > 0} && {currentTask player != currentTask _unit}) then
		{
			[MODE_REASSIGN,_new] call bis_fnc_sharedObjectives;
		};


	};

	//add event handler (localy) to the given player
	case MODE_ADD:
	{
		//init required gvar, if not already initialized
		if (isNil "bis_fnc_sharedObjectives_handledPlayers") then
		{
			["[x] Adding EH on player '%1' before 'bis_fnc_sharedObjectives_handledPlayers' is initialized!!! Hotfix was applied, but pls contact Warka.",player] call bis_fnc_error;

			bis_fnc_sharedObjectives_handledPlayers = [];
		};

		private["_units","_unit","_unitVar"];

		if (count _this == 1) then
		{
			_units = [] call bis_fnc_listPlayers;
		}
		else
		{
			_unit = _this param [1,"",[""]];
			_units = [missionNamespace getVariable [_unit,objNull]];
		};

		_units = _units - [player,objNull];

		{
			_unitVar = _x call bis_fnc_objectVar;

			if !(_unitVar in bis_fnc_sharedObjectives_handledPlayers) then
			{
				bis_fnc_sharedObjectives_handledPlayers pushBack _unitVar;

				//add event handler for monitoring other players assigned tasks
				"@" addPublicVariableEventHandler [_x,
				{
					_this set [0,MODE_UPDATE];
					_this call bis_fnc_sharedObjectives;
				}];
			};
		}
		forEach _units;
	};

	case MODE_REMOVE:
	{
		_t = diag_tickTime + 5;

		waitUntil{!isNil "bis_fnc_sharedObjectives_handledPlayers" || {diag_tickTime > _t}};

		if !(isNil "bis_fnc_sharedObjectives_handledPlayers") then
		{
			bis_fnc_sharedObjectives_handledPlayers = bis_fnc_sharedObjectives_handledPlayers - [_this select 1];
		};
	};

	case MODE_REASSIGN:
	{
		private["_task","_key","_i","_data","_texture","_share","_desc"];

		_task = _this param [1,"",[""]];

		//handle un-assign
		if (_task == "") then
		{
			//get player's current task and exit if already un-assigned
			private _currentTask = [] call bis_fnc_taskCurrent; if (_currentTask == "") exitWith {};

			//un-assign task
			player setCurrentTask taskNull;
			[_currentTask,"CREATED",true] call bis_fnc_taskSetState;

			//display notification
			//[_currentTask,"Unassigned"] call bis_fnc_taskHint;
		}
		//handle re-assign
		else
		{
			private _currentTask = [] call bis_fnc_taskCurrent; if (_currentTask == _task) exitWith {};

			//assign task & display notification
			[_task,"ASSIGNED",true] call bis_fnc_taskSetState;

			//display notification
			//[_currentTask,"Assigned"] call bis_fnc_taskHint;
		};
	};

	case MODE_ENABLED;
	case MODE_ENABLED_WITH_PROPAGATION:
	{
		waitUntil{CMD_SLEEP 0.05; !isNull player};

		if (IS_SPECTATOR(player)) exitWith {};

		private _playerVar = [player] call bis_fnc_objectVar;

		bis_fnc_sharedObjectives_propagate = _mode == MODE_ENABLED_WITH_PROPAGATION;

		//init required gvar, if not already initialized
		if (isNil "bis_fnc_sharedObjectives_handledPlayers") then
		{
			bis_fnc_sharedObjectives_handledPlayers = [];
		};

		//get initial data
		private["_xTask","_xKey","_xUnits","_xVar"];

		{
			_xTask = _x getVariable ["@",""];
			_xVar = [_x] call bis_fnc_objectVar;
			_x setVariable ["@local",_xTask];

			if (_xTask != "") then
			{
				_xKey = format["%1_units",_xTask call bis_fnc_taskVar];
				_xUnits =+ (missionNamespace getVariable [_xKey,[]]);
				_xUnits pushBack _xVar;
				missionNamespace setVariable [_xKey,_xUnits];
			};
		}
		forEach (([] call bis_fnc_listPlayers) - [player]);

		//register JIP player to everyone ingame
		if (didJIP) then
		{
			[[MODE_ADD,_playerVar],"bis_fnc_sharedObjectives"] call bis_fnc_mp;
		};

		//register everyone localy to player
		[MODE_ADD] call bis_fnc_sharedObjectives;

		//handle disconnect
		if (isServer) then
		{
			addMissionEventHandler ["HandleDisconnect",
			{
				private["_player"];

				_player = _this select 0;
				_player setVariable["@","",true];

				//run localy on server (as trigger won't fire on server)
				[MODE_UPDATE,"",_player] call bis_fnc_sharedObjectives;

				[[MODE_REMOVE,_player call bis_fnc_objectVar],"bis_fnc_sharedObjectives"] call bis_fnc_mp;
			}];
		};

		/*----------------------------------------------------------------------------------

			GET CUSTOM DATA

			Example:
			_customData = _units call bis_fnc_sharedObjectives_getCustomData;

		--------------------------------------- -------------------------------------------*/
		bis_fnc_sharedObjectives_getCustomData =
		{
			#define MAX_LISTED	5
			#define TAG_NAME	"<font color='#ff00e3ff'>%1</font>"
			#define TAG_COUNTER	"<font color='#ff00e3ff'>+%1</font>"

			private _units = (_this apply {missionNamespace getVariable [_x, objNull]}) select {!isNull _x};
			private _count = count _units; if (_count == 0) exitWith {[]};

			_units = _units select [0,MAX_LISTED];
			private _more = format[TAG_COUNTER,_count - MAX_LISTED];

			private _template = if (_count > MAX_LISTED) then
			{
				format["<br/>%1<br/>- %2",localize "STR_A3_AssignedPlayers1","%1 ... +%2"];
			}
			else
			{
				format["<br/>%1<br/>- %2",localize "STR_A3_AssignedPlayers1","%1"];
			};

			private _names = "";

			{
				if (_forEachIndex > 0) then
				{
					_names = _names + ", ";
				};

				_names = _names + format[TAG_NAME,[_x,true,16] call bis_fnc_getName];
			}
			forEach _units;

			private _descriptionText = format[_template,_names,_more];
			private _icon = "a3\ui_f\data\map\diary\icons\taskcustom_ca.paa";
			private _iconText = str _count;

			[_icon,_iconText,_descriptionText]
		};


		/*----------------------------------------------------------------------------------

			BROADCAST ASSIGNED TASK

		----------------------------------------------------------------------------------*/
		bis_fnc_sharedObjectives_taskAssignedCode =
		{
			["[ ] bis_fnc_sharedObjectives_taskAssignedCode: %1",_this] call DEBUG_LOG;

			if (IS_SPECTATOR(player)) exitWith {};

			bis_fnc_sharedObjectives_taskAssignedCodeExecuted = true;

			["[ ] Task assigned: %1",_this] call DEBUG_LOG;

			bis_fnc_sharedObjectives_broadcastTime = diag_tickTime;

			private["_current"];

			_current = [player] call bis_fnc_taskCurrent;

			//inst-update localy
			[MODE_UPDATE,_current,player] call bis_fnc_sharedObjectives;

			if !(isNil "bis_fnc_sharedObjectives_broadcastCurrent" || {scriptDone bis_fnc_sharedObjectives_broadcastCurrent}) exitWith {};

			bis_fnc_sharedObjectives_broadcastCurrent = [] spawn
			{
				scriptName "fnc_sharedObjectives_broadcastCurrent";
				_fnc_scriptName = "bis_fnc_sharedObjectives";

				//throttle countermeasure
				waitUntil {diag_tickTime > bis_fnc_sharedObjectives_broadcastTime + 1.0};

				private["_current","_prev"];

				_current = [player] call bis_fnc_taskCurrent;
				_prev = player getVariable ["@",""];

				//stop if no change was detected
				if (_current == _prev) exitWith {};

				//broadcast
				player setVariable ["@",_current,true];
			};
		};

		player addEventHandler ["TaskSetAsCurrent",bis_fnc_sharedObjectives_taskAssignedCode];

		//make sure that the eh code gets run even for the very 1st task assigned (when unit joins)
		[] spawn
		{
			CMD_SLEEP 1;

			if (isNil "bis_fnc_sharedObjectives_taskAssignedCodeExecuted") then
			{
				[player,currentTask player] call bis_fnc_sharedObjectives_taskAssignedCode;
			};
		};

		/*----------------------------------------------------------------------------------

			MONITOR GROUP JOIN

		----------------------------------------------------------------------------------*/
		if (!bis_fnc_sharedObjectives_propagate) exitWith {};

		[] spawn
		{
			scriptName "fnc_sharedObjectives_monitorGroupJoin";

			private["_group","_leader","_leaderTask"];

			while {true} do
			{
				CMD_SLEEP 0.5;

				_group = group player;
				_leader = leader _group;

				waitUntil
				{
					CMD_SLEEP 0.5;

					(group player) != _group || {(leader group player) != _leader}
				};

				//reassign localy according to leader
				_leaderTask = (leader group player) getVariable ["@","***"];

				if (_leaderTask != "***") then
				{
					[MODE_REASSIGN,_leaderTask] call bis_fnc_sharedObjectives;
				};
			};
		};
	};

	default
	{
	};
};