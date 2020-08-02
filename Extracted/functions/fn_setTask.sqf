/*
	Author: Jiri Wainar

	Description:
	Set a task parameters.
	Create the task when it doesn't exist.

	Parameters:
		0: STRING or ARRAY - Task ID or array in the format [task ID, parent task ID]
		1: Task owner(s)
			BOOL - true to set task of all playable units
			OBJECT - set task of a specific object
			GROUP - set tasks of all objects in the group
			SIDE - set tasks of all objects of the given side
			ARRAY - collection of above types
		2: ARRAY or STRING - Task description in the format ["description", "title", "marker"] or CfgTaskDescriptions class
		3: Task destination
			OBJECT
			ARRAY - either position in format [x,y,z], or [object,precision] as used by setSimpleTaskTarget command
		4: Task state
			STRING - can be one of following:
				"CREATED"
				"ASSIGNED"
				"AUTOASSIGNED" ("ASSIGNED" when no task is assigned yet, otherwise "CREATED")
				"SUCCEEDED"
				"FAILED"
				"CANCELED"
			BOOL - true to set the task as current
		5: NUMBER - priority. When a current task is completed, system select a next one with the larges priority >= 0
		6: BOOL - true to show notification (default), false to disable it
		7: BOOL - true to set task globally (default), false to set it only locally
		8: STRING - task type from CfgTaskTypes, if not defined, type "Default" is being used
		9: BOOL - true to make task always visible in 3D (default: false)

	Returns:
	STRING - Task ID
*/
#include "defines.inc"

//["[ ] this: %1",_this] call bis_fnc_logFormat;
/*--------------------------------------------------------------------------------------------------

	0: IDS

--------------------------------------------------------------------------------------------------*/
private["_ids","_id","_taskVar","_parent","_children","_prevData","_index"];

//init the input: task id & task var
_ids	 = _this param [0,"",["",[]]]; if (typeName _ids == typeName "") then {_ids = [_ids]};
_id	 = _ids param [0,"",[""]]; if (_id == "") exitWith {["[x] Task ID cannot be an empty string!"] call bis_fnc_error;""};
_taskVar = _id call bis_fnc_taskVar;

//store previous data & check if the task is created (called for the very first time)
_prevData = [];
for "_index" from 0 to 11 do {_prevData pushBack (GET_DATA(_taskVar,_index));};

//get remaining ids
_parent   = _ids param [1,GET_DATA(_taskVar,PARENT),[""]];
_children = _ids param [2,GET_DATA(_taskVar,CHILDREN),[[]]];

SET_DATA(_taskVar,ID,_id);
SET_DATA(_taskVar,PARENT,_parent);
SET_DATA(_taskVar,CHILDREN,_children);


/*--------------------------------------------------------------------------------------------------

	1: OWNERS

--------------------------------------------------------------------------------------------------*/
private["_fnc_addOwner","_newOwner","_owners","_thisVar"];

_fnc_addOwner =
{
	switch (typename _this) do
	{
		case (typename true):
		{
			if (_this) then {_owners pushBackUnique _this;};
		};
		case (typename grpnull);
		case (typename "");
		case (typename sideunknown):
		{
			_owners pushBackUnique _this;
		};
		case (typename objnull):
		{
			_thisVar = _this call bis_fnc_objectVar;
			_owners pushBackUnique _thisVar;
		};
		case (typename []):
		{
			{_x call _fnc_addOwner;} foreach _this;
		};
	};
};

_owners = GET_DATA(_taskVar,OWNERS);
_newOwner = _this param [1,GET_DATA(_taskVar,OWNERS),[true,sideunknown,grpnull,objnull,[],""]];
_newOwner call _fnc_addOwner;

SET_DATA(_taskVar,OWNERS,_owners);

/*--------------------------------------------------------------------------------------------------

	3: DESTINATION

--------------------------------------------------------------------------------------------------*/
private _dest 		= _this param [3,GET_DATA(_taskVar,DESTINATION),[objnull,[]]];
private _destTarget 	= _dest param [0,objnull,[objnull,0]];

if (typename _destTarget == typename objnull) then
{
	_dest =
	[
		_destTarget,
		_dest param [1,false,[false]]
	]
}
else
{
	if (typeName _destTarget == typeName objNull) then
	{
		_dest =
		[
			_destTarget,
			_dest param [1,false,[false]]
		]
	}
	else
	{
		_dest =
		[
			_destTarget,
			_dest param [1,0,[0]],
			_dest param [2,0,[0]]
		]
	};
};

SET_DATA(_taskVar,DESTINATION,_dest);


/*--------------------------------------------------------------------------------------------------

	5: PRIORITY

--------------------------------------------------------------------------------------------------*/
private _priority = _this param [5,GET_DATA(_taskVar,PRIORITY),[0]];

SET_DATA(_taskVar,PRIORITY,_priority);


/*--------------------------------------------------------------------------------------------------

	7: GLOBAL

--------------------------------------------------------------------------------------------------*/
private _global = _this param [7,true,[true]]; if !(isMultiplayer) then {_global = false;};


/*--------------------------------------------------------------------------------------------------

	8: TYPE

--------------------------------------------------------------------------------------------------*/
private _taskType = _this param [8,GET_DATA(_taskVar,TYPE),[""]];

SET_DATA(_taskVar,TYPE,_taskType);

/*--------------------------------------------------------------------------------------------------

	2: TXT

--------------------------------------------------------------------------------------------------*/
private _txt = _this param [2,[GET_DATA(_taskVar,DESCRIPTION),GET_DATA(_taskVar,TITLE),GET_DATA(_taskVar,MARKER)],[[],""]];

if (typename _txt == typename "") then
{
	//load description from CfgTaskDescriptions
	private _cfgTaskDescription = if (_txt == "") then
	{
		[["CfgTaskDescriptions",_id],configfile >> ""] call bis_fnc_loadClass;
	}
	else
	{
		[["CfgTaskDescriptions",_txt],configfile >> ""] call bis_fnc_loadClass;
	};

	_txt =
	[
		if (isArray (_cfgTaskDescription >> "description")) then {
			format getarray (_cfgTaskDescription >> "description")
		} else {
			gettext (_cfgTaskDescription >> "description")
		},
		gettext (_cfgTaskDescription >> "title"),
		gettext (_cfgTaskDescription >> "marker")
	];
}
else
{
	_txt = +_txt;
};

private ["_text"];

{
	_text = _txt param [_forEachIndex,"",["",[]]];
	if (typename _text != typename []) then {_text = [_text]};

	SET_DATA(_taskVar,_x,_text);
}
forEach [DESCRIPTION,TITLE,MARKER];


/*--------------------------------------------------------------------------------------------------

	4: STATE

--------------------------------------------------------------------------------------------------*/
private _state = _this param [4,GET_DATA(_taskVar,STATE),["",true]];

if (typename _state == typename true) then {_state = toupper([GET_DATA(_taskVar,STATE),"ASSIGNED"] select _state)};

SET_DATA(_taskVar,STATE,_state);


/*--------------------------------------------------------------------------------------------------

	9: ALWAYS VISIBLE / CORE

--------------------------------------------------------------------------------------------------*/
private _core = _this param [9,GET_DATA(_taskVar,CORE),[true]];

SET_DATA(_taskVar,CORE,_core);


/*--------------------------------------------------------------------------------------------------

	PROCESS CHILD TASKS
	- set their state according to the parent task

--------------------------------------------------------------------------------------------------*/
if (_state != "CREATED" && {_state != "ASSIGNED"}) then
{
	private ["_xTaskVar","_xId","_xState"];

	{
		_xTaskVar = _x call bis_fnc_taskVar;

		_xId 	  = GET_DATA_NIL(_xTaskVar,ID);
		_xState   = GET_DATA_NIL(_xTaskVar,STATE);

		if !(isNil "_xId") then				//child task exists
		{
			if (isNil "_xState") then
			{
				_xState = "CREATED";
			};

			if (_xState == "CREATED" || {_xState == "ASSIGNED" || {_xState == "AUTOASSIGNED"}}) then
			{
				//["[i][%1] Changing state for child task %3 to %2",_id,_state,_x] call bis_fnc_logFormat;

				[_x,nil,nil,nil,_state,nil,false] call bis_fnc_setTask;
			};
		};
	}
	foreach _children;
};


/*--------------------------------------------------------------------------------------------------

	REGISTER TO PARENT TASK

--------------------------------------------------------------------------------------------------*/
if (_parent != "") then
{
	private ["_parentVar","_parentId","_parentChildren","_added"];

	_parentVar  = _parent call bis_fnc_taskVar;
	_parentId = GET_DATA_NIL(_parentVar,ID);
	_parentChildren = GET_DATA(_parentVar,CHILDREN);
	_added = false;

	if ({_x == _id} count _parentChildren == 0) then
	{
		_parentChildren pushBack _id;
		_added = true;
	};

	//create parent task & add this child to it
	if (isNil "_parentId") exitWith
	{
		[[_parent,"",_parentChildren],_owners] call bis_fnc_setTask;
	};

	//extend list of the child task in this task parent
	if (_added) then
	{
		SET_DATA(_parentVar,CHILDREN,_parentChildren);

		//broadcast changed data to everyone and JIP
		if (_global) then
		{
			publicvariable GET_VAR(_parentVar,CHILDREN);
		};
	};
};


/*--------------------------------------------------------------------------------------------------

	COMPARE CHANGES

--------------------------------------------------------------------------------------------------*/
private["_current","_prev","_var"];

//broadcast changed data to everyone and JIP
if (_global) then
{
	for "_index" from 0 to 11 do
	{
		_current = GET_DATA(_taskVar,_index);
		_prev 	 = _prevData select _index;

		//["[ ] Evaluating attribute [%1] ... previous: %2 vs. current: %3",_index,_prev,_current] call bis_fnc_logFormat;

		if !(_current isEqualTo _prev) then
		{
			//["[x] Attribute [%1] change detected: %2 -> %3",_index,_prev,_current] call bis_fnc_logFormat;

			//SET_DATA_BROADCAST(_taskVar,_index,_current)
			publicVariable GET_VAR(_taskVar,_index);
		};
	};
};

private _notification = _this param [6,true,[true]];

//update or create task
if (_global) then
{
	[_id,_notification] remoteExecCall ["BIS_fnc_setTaskLocal",0,true];
}
else
{
	[_id,_notification] call BIS_fnc_setTaskLocal;
};

_id