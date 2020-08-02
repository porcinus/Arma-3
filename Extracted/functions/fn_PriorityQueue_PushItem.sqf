/*
	Author: Zozo

	Description:
	Inserts item with a defined priority to the Queue
	The Priority Queue is sorted on inserting. Bigger numbers are set on higher indexes.
	If the callback code is set on init, it will call the code (only on successfully completed operation)
	Complexity: O(n)

	Parameters:
	_handle:INT - Queue handle (get it with BIS_fnc_PriorityQueue_Init)
	_item:ANY - item, can be whatever
	_priority:INT - the priority the item is inserted with

	Returns:
	_success:BOOL - true if item was inserted into the Queue, otherwise false

	Syntax:
	_success:BOOL = [_handle, _item, _priority] call BIS_fnc_PriorityQueue_InsertItem;

	Example:
	_s = [_priorityQueue_1, "myItem", 5] call BIS_fnc_PriorityQueue_InsertItem;
*/

#include "..\priorityQueue_defines.inc"
params [ [ "_handle", 0, [99] ], [ "_content", "", ["", 99, [], objNull] ], [ "_priority", 0, [99] ] ];

if( isNil {QUEUES} || {_handle  > (count QUEUES - 1 )} ) exitWith {false};
private _queue = ACTUAL_QUEUE(_handle);
private _nrOfItems = ACTUAL_QUEUE_SIZE(_handle);

if (PRIORITY_QUEUE_DEBUG) then {["PriorityQueue before INSERT: %1", _queue] call BIS_fnc_LogFormat;};
if( [_handle] call BIS_fnc_PriorityQueue_IsFull ) exitWith {false};
if( _nrOfItems == 0 ) then
{
	_queue pushBack [_content, _priority];
	(ACTUAL_QUEUE_META(_handle)) set [1, _nrOfItems + 1];
}
else
{
	private _i = _nrOfItems;
	while { _i > 0 && {( GET_PRIORITY(_i-1) ) >= _priority} } do
	{
		_queue set [_i, _queue#(_i-1)];
		_i = _i - 1;
	};
	_queue set [ _i, [_content, _priority] ];
	(ACTUAL_QUEUE_META(_handle)) set [1, _nrOfItems + 1];
};
[QUEUE_SPACE, format ["BIS_onQueue%1Push", _handle], [_handle]] call BIS_fnc_callScriptedEventHandler;
if (PRIORITY_QUEUE_DEBUG) then {["PriorityQueue after INSERT: %1", _queue] call BIS_fnc_LogFormat;};
true
