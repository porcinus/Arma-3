/*
	Author: Jiri Wainar

	Description:
	Local task management executed by BIS_fnc_setTask
	Not to be called independently!
*/
#include "defines.inc"

//stop if dedicated
if (isDedicated) exitwith {false};

private _id  		= _this param [0,"",[""]];  if (_id == "") exitWith {["[x] Task ID cannot be an empty string!"] call bis_fnc_error;};
private _notification 	= _this param [1,true,[true]];
private _init		= _this param [2,true,[true]];

private _taskVar 	= _id call bis_fnc_taskVar;

/*--------------------------------------------------------------------------------------------------

	INIT GLOBAL FLAGS

--------------------------------------------------------------------------------------------------*/
if (isNil "bis_fnc_sharedObjectives_propagate") then
{
	bis_fnc_sharedObjectives_propagate = false;
};

//init required gvar, if not already initialized
private _key = format["%1_units",_taskVar];

if (isNil{missionNamespace getVariable _key}) then
{
	missionNamespace setVariable [_key,[]];
};

/*--------------------------------------------------------------------------------------------------

	Init the task data and units the task needs to be created/adjusted for

--------------------------------------------------------------------------------------------------*/
if (_init) then
{
	/*--------------------------------------------------------------------------------------------------

		INIT PARAMS

	--------------------------------------------------------------------------------------------------*/
	private _owners = GET_DATA(_taskVar,OWNERS);

	/*
	private _parent = GET_DATA(_taskVar,PARENT);
	private _children = GET_DATA(_taskVar,CHILDREN);
	private _destination = GET_DATA(_taskVar,DESTINATION);
	private _priority = GET_DATA(_taskVar,PRIORITY);
	private _description = GET_DATA(_taskVar,DESCRIPTION);
	private _title = GET_DATA(_taskVar,TITLE);
	private _marker = GET_DATA(_taskVar,MARKER);
	private _state = toupper(GET_DATA(_taskVar,STATE));
	private _type = GET_DATA(_taskVar,TYPE);
	private _alwaysVisible = GET_DATA(_taskVar,CORE);

	["[!] _id: %1",_id] call bis_fnc_logFormat;
	["[!] _notification: %1",_notification] call bis_fnc_logFormat;
	["[!] _parent: %1",_parent] call bis_fnc_logFormat;
	["[!] _children: %1",_children] call bis_fnc_logFormat;
	["[!] _owners: %1",_owners] call bis_fnc_logFormat;
	["[!] _destination: %1",_destination] call bis_fnc_logFormat;
	["[!] _title: %1",_title] call bis_fnc_logFormat;
	["[!] _description: %1",_description] call bis_fnc_logFormat;
	["[!] _marker: %1",_marker] call bis_fnc_logFormat;
	["[!] _state: %1",_state] call bis_fnc_logFormat;
	["[!] _type: %1",_type] call bis_fnc_logFormat;
	["[!] _alwaysVisible: %1",_alwaysVisible] call bis_fnc_logFormat;
	*/

	//creates the task units array
	private _units = [];
	{
		private _owner = _x;

		switch (typename _owner) do
		{
			case (typename ""):
			{
				private _unit = missionnamespace getvariable [_owner,objnull];
				private _curatorUnit = getassignedcuratorunit _unit;
				if !(isnull _curatorUnit) then {_unit = _curatorUnit;};

				_units pushBackUnique _unit;
			};
			case (typename grpnull):
			{
				_units = _units + units _owner;
			};
			case (typename sideunknown):
			{
				{
					if ((_x call bis_fnc_objectSide) == _owner) then {_units pushBackUnique _x;};
				}
				foreach (allunits + alldead);
			};
			case (typename []):
			{
				_units = _units + _owner;
			};
			case (typename true):
			{
				if (_owner) then
				{
					_units = _units + ([] call bis_fnc_listplayers);
				};
			};
		};
	}
	foreach _owners;

	//remove duplicities and NULL objects
	_units = (_units arrayIntersect _units) - [objNull];

	//handle jipping player
	if (didJip && {isRemoteExecutedJIP && {isNil{player getvariable _taskVar} && {player in _units}}}) then
	{
		//["[i] Executed from JIP: %1",_this] call bis_fnc_logFormat;

		private _targets = _owners apply {if (_x isEqualType true) then {[player,0] select _x} else {_x}};
		[_id,_notification,false,[player],false] remoteExecCall ["bis_fnc_setTaskLocal",_targets,false];

		_units = _units - [player];
	};

	//create/adjust task localy for given unit
	[_id,_notification,false,_units] call bis_fnc_setTaskLocal;
}
/*--------------------------------------------------------------------------------------------------

	Create the task and setup attributes

--------------------------------------------------------------------------------------------------*/
else
{
	//["[i] this: %1",_this] call bis_fnc_logFormat;

	private _units		= _this param [3,[player],[[]]];
	private _updateState 	= _this param [4,true,[true]];

	/*--------------------------------------------------------------------------------------------------

		INIT PARAMS

	--------------------------------------------------------------------------------------------------*/
	private _parent = GET_DATA(_taskVar,PARENT);
	private _children = GET_DATA(_taskVar,CHILDREN);
	private _owners = GET_DATA(_taskVar,OWNERS);
	private _destination = GET_DATA(_taskVar,DESTINATION);
	private _priority = GET_DATA(_taskVar,PRIORITY);
	private _description = GET_DATA(_taskVar,DESCRIPTION);
	private _title = GET_DATA(_taskVar,TITLE);
	private _marker = GET_DATA(_taskVar,MARKER);
	private _state = toupper(GET_DATA(_taskVar,STATE));
	private _type = GET_DATA(_taskVar,TYPE);
	private _alwaysVisible = GET_DATA(_taskVar,CORE);

	/*
	["[!] _id: %1",_id] call bis_fnc_logFormat;
	["[!] _notification: %1",_notification] call bis_fnc_logFormat;
	["[!] _parent: %1",_parent] call bis_fnc_logFormat;
	["[!] _children: %1",_children] call bis_fnc_logFormat;
	["[!] _owners: %1",_owners] call bis_fnc_logFormat;
	["[!] _destination: %1",_destination] call bis_fnc_logFormat;
	["[!] _title: %1",_title] call bis_fnc_logFormat;
	["[!] _description: %1",_description] call bis_fnc_logFormat;
	["[!] _marker: %1",_marker] call bis_fnc_logFormat;
	["[!] _state: %1",_state] call bis_fnc_logFormat;
	["[!] _type: %1",_type] call bis_fnc_logFormat;
	["[!] _alwaysVisible: %1",_alwaysVisible] call bis_fnc_logFormat;
	*/

	/*--------------------------------------------------------------------------------------------------

		Local functions

	--------------------------------------------------------------------------------------------------*/
	private _fnc_localize =
	{
		if (typeName _this == typeName "") then
		{
			if (isLocalized _this) then {localize _this} else {_this};
		}
		else
		{
			private _array =+ _this;
			private _text = _array select 0;

			if (islocalized _text) then {_array set [0,localize _text];};

			if (count _array > 1) then
			{
				_array = format _array;
			}
			else
			{
				_array = _array select 0;
			};

			_array
		};
	};

	private _fnc_setDest = if (count _destination == 2) then
	{
		if (isnull (_destination select 0)) then {{cancelsimpletaskdestination _task;}} else {{_task setsimpletasktarget _destination;}};
	}
	else
	{
		{_task setsimpletaskdestination _destination;}
	};

	private _fnc_setState = switch _state do
	{
		case "ASSIGNED":
		{
			{
				_unit setcurrenttask _task;
			}
		};
		case "AUTOASSIGNED":
		{
			{
				if !((taskstate currenttask _unit) in ["Created","Assigned"]) then
				{
					_stateNew = "ASSIGNED";
					_unit setcurrenttask _task;
				}
				else
				{
					_stateNew = "CREATED";
					_task settaskstate _stateNew;
				};
			}
		};
		default
		{
			{
				_task settaskstate _stateNew;
			}
		};
	};

	/*--------------------------------------------------------------------------------------------------

		Preprocess data

	--------------------------------------------------------------------------------------------------*/

	//localize task texts
	_description = _description call _fnc_localize;
	_title = _title call _fnc_localize;
	_marker = "";

	/*--------------------------------------------------------------------------------------------------

		Create task for individual units (not only players)

	--------------------------------------------------------------------------------------------------*/
	{
		private _unit = _x;
		private _task = _unit getvariable _taskVar;
		private _stateNew = _state;
		private _tasks = _unit getvariable ["BIS_fnc_setTaskLocal_tasks",[]];

		//["[!] Creating/adjusting task id %1 for unit %2.",_id,_unit] call bis_fnc_logFormat;

		//create the task
		_stateOld = if (isnil{_task}) then
		{
			private _parentVar  = _parent call bis_fnc_taskVar;
			private _taskParent = _unit getvariable [_parentVar,tasknull];

			if (isNull _taskParent && {_parentVar != ""}) then
			{
				["[x][%3] ERROR: creating task '%1' under non-existent parent task '%2'!",_taskVar,_parentVar,_unit] call bis_fnc_logFormat;
			};

			//create the task
			_task = _unit createSimpleTask [_id,_taskParent];
			_unit setVariable [_taskVar,_task];

			//register to the unit's task list
			if ({_x == _id} count _tasks == 0) then
			{
				_tasks pushBack _id;
				_unit setVariable ["BIS_fnc_setTaskLocal_tasks",_tasks];
			};

			//force state update
			_updateState = true;

			""
		}
		else
		{
			taskState _task
		};


		/*--------------------------------------------------------------------------------------------------

			Process the attributes

		--------------------------------------------------------------------------------------------------*/

		//set task texts
		_task setsimpletaskdescription [_description,_title,_marker];

		//set task state
		if (_updateState) then
		{
			call _fnc_setState;
		};

		//set the task destination
		call _fnc_setDest;

		//set task type
		_task setSimpleTaskType _type;

		//set always visible
		_task setSimpleTaskAlwaysVisible _alwaysVisible;

		//show notification
		if (_notification && {!isRemoteExecutedJIP && {_unit == player && {_title != ""}}}) then
		{
			if (_updateState && {_stateNew != _stateOld}) then
			{
				private _typeTexture = [_type] call bis_fnc_taskTypeIcon;

				if (_typeTexture != "") then
				{
					if (_stateNew == "CREATED" && _stateOld != "") then
					{
						["taskUnassignedIcon",[_typeTexture,_title]] call bis_fnc_showNotification;
					}
					else
					{
						["task" + _stateNew + "Icon",[_typeTexture,_title]] call bis_fnc_showNotification;
					};
				}
				else
				{
					["task" + _stateNew,[_description,_title,_marker]] call bis_fnc_showNotification;
				};
			};
		};

		//select next current task
		if (!bis_fnc_sharedObjectives_propagate && {_unit == player} && {_stateOld == "ASSIGNED"} && {{_x == _stateNew} count ["SUCCEEDED","FAILED","CANCELED"] > 0}) then
		{
			private _maxPrio = -1;
			private _nextTask = "";

			{
				private _xTaskVar = _x call bis_fnc_taskVar;
				private _xState = GET_DATA(_xTaskVar,STATE);

				if ({_x == _xState} count ["SUCCEEDED","FAILED","CANCELED"] == 0) then
				{
					_xPrio = GET_DATA(_xTaskVar,PRIORITY);

					if (_xPrio > _maxPrio) then
					{
						_nextTask = _x;
						_maxPrio = _xPrio;
					};
				};
			}
			foreach (_unit getvariable ["BIS_fnc_setTaskLocal_tasks",[]]);

			if (_nextTask != "") then
			{
				[_nextTask,nil,nil,nil,true,nil,nil,false] call bis_fnc_setTask;
			};
		};
	}
	forEach _units;
};

true