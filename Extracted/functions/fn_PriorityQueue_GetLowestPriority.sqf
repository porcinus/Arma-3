/*
	Author: Zozo

	Description:
	Get the highest priority in the queue

	Parameters:
	_handle:INT - Queue handle (get it with BIS_fnc_PriorityQueue_Init)

	Returns:
	_priority:SCALAR - the priority

	Syntax:
	_item:ANY = [_handle] call BIS_fnc_PriorityQueue_GetHighestPriority;

	Example:
	_myItem = [_priorityQueue_1] call BIS_fnc_PriorityQueue_PopItem;
*/

#include "..\priorityQueue_defines.inc"
params [ "_handle" ];
if( isNil {QUEUES} || {_handle  > (count QUEUES - 1 )} ) exitWith {false};
private _queue = ACTUAL_QUEUE(_handle);
private _nrOfItems = ACTUAL_QUEUE_SIZE(_handle);
if!([_handle] call BIS_fnc_PriorityQueue_IsEmpty) then
{
	(_queue select 0) select 1
}
