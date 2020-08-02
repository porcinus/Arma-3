/*
	Author: Jiri Wainar

	Description:
	Delete task

	Parameters:
		0: STRING - Task ID
		1: Removed task owners (optional, the task will be removed for all existing owners by default)
			BOOL - true to useall playable units
			OBJECT - specific object
			GROUP - all objects in the group
			SIDE - all objects of the given side
			ARRAY - collection of above types

	Returns:
	BOOL
*/

#include "defines.inc"

private ["_taskID","_owners","_init","_taskVar","_children","_ownersLocal","_ownersAll"];

_taskID = _this param [0,"",[""]];
_owners = _this param [1,[],[true,sideunknown,grpnull,objnull,[],""]];
_init = _this param [2,true,[true]];

_taskVar = _taskID call bis_fnc_taskVar;
if !(_owners isEqualType []) then {_owners = [_owners];};

//["[ ] _taskID: %1 | _owners: %2 | _init: %3",_taskID,_owners,_init] call bis_fnc_logFormat;

//private initialization
if (_init) then
{
	//terminate when the task does not exist
	if (isNil{GET_DATA_NIL(_taskVar,ID)}) exitwith {false};

	//select tasks to delete (include subtasks)
	_children = GET_DATA(_taskVar,CHILDREN);

	{
		_taskVar = _x call bis_fnc_taskVar;

		//init
		_ownersLocal = if (count _owners == 0) then {GET_DATA(_taskVar,OWNERS)} else {_owners};

		if (isMultiplayer) then
		{
			[[_x,_ownersLocal,false],"bis_fnc_deleteTask"] call bis_fnc_mp;
		}
		else
		{
			[_x,_ownersLocal,false] call bis_fnc_deleteTask;
		};

		//delete owners
		_ownersAll = GET_DATA(_taskVar,OWNERS);
		_ownersAll = _ownersAll - _ownersLocal;

		//SET_DATA(_taskVar,OWNERS,_ownersAll);
		//publicvariable GET_VAR(_taskVar,OWNERS);

		if (count _ownersAll > 0) then
		{
			SET_DATA_BROADCAST(_taskVar,OWNERS,_ownersAll);
		}
		else
		{
			SET_DATA_BROADCAST(_taskVar,OWNERS,nil);
		};

	}
	foreach ([_taskID] + _children);
}
else
{
	//local
	private ["_units","_owner"];

	_units = [];

	{
		_owner = _x;

		switch (typename _owner) do
		{
			case (typename ""):
			{
				_units pushBack (missionnamespace getvariable [_owner,objnull]);
			};
			case (typename grpnull):
			{
				_units = _units + units _owner;
			};
			case (typename sideunknown):
			{
				{
					if ((_x call bis_fnc_objectSide) == _owner) then {_units pushBack _x};
				}
				foreach (allunits + alldead);
			};
			case (typename []):
			{
				_units append _owner;
			};
			case (typename true):
			{
				if (_owner) then
				{
					_units append ([] call bis_fnc_listplayers);
				};
			};
		};
	}
	foreach _owners;

	//remove duplicities
	_units = _units arrayIntersect _units;

	//remove task
	{
		private ["_task","_tasks"];

		_task = _x getvariable [_taskVar,tasknull];
		_x removesimpletask _task;
		_x setvariable [_taskVar,nil];

		//remove task from the unit's tasks
		_tasks = _x getvariable ["BIS_fnc_setTaskLocal_tasks",[]];
		_tasks = _tasks - [_taskID];
		_x setvariable ["BIS_fnc_setTaskLocal_tasks",_tasks];

		//clean variables storing individual task parameters
		for "_i" from 0 to 11 do {SET_DATA(_taskVar,_i,nil)};
	}
	foreach _units;
};

true