/*
	Author: Zozo

	Description:
	Pops the item with the highest priority from the Queue (item with highest index).
	The item is removed from the Queue.
	If the callback code is set on init, it will call the code (even if the item is kept in the queue)
	Complexity: O(1)

	Parameters:
	_handle:INT - Queue handle (get it with BIS_fnc_PriorityQueue_Init)
	_keep:BOOL - if true, the item is not removed from the Queue

	Returns:
	_item:ANY - the item stored in the Queue

	Syntax:
	_item:ANY = [_handle] call BIS_fnc_PriorityQueue_PopItem;

	Example:
	_myItem = [_priorityQueue_1] call BIS_fnc_PriorityQueue_PopItem;
*/

#include "..\priorityQueue_defines.inc"
params [ "_handle", ["_keep", false, [false]] ];
if( isNil {QUEUES} || {_handle  > (count QUEUES - 1 )} ) exitWith {false};
private _queue = ACTUAL_QUEUE(_handle);
private _nrOfItems = ACTUAL_QUEUE_SIZE(_handle);
private "_result";
if!([_handle] call BIS_fnc_PriorityQueue_IsEmpty) then
{
	if(!_keep) then
	{
		(ACTUAL_QUEUE_META(_handle)) set [1, _nrOfItems - 1];
		_result = (_queue deleteAt (_nrOfItems-1)) select 0
	}
	else
	{
		_result = (_queue select (_nrOfItems-1)) select 0
	};

	[QUEUE_SPACE, format ["BIS_onQueue%1Pop", _handle], [_handle]] call BIS_fnc_callScriptedEventHandler;
	_result
} else
{ [] };
