/*
	Author: Zozo

	Description:
	Checks if the Queue is full

	Parameters:
	_handle:INT - Queue handle (get it with BIS_fnc_PriorityQueue_Init)

	Returns:
	_full:BOOL - true if the Queue is full

	Syntax:
	_full:BOOL = [_handle] call BIS_fnc_PriorityQueue_IsFull;

	Example:
	_isTheQueueFull = [_priorityQueue_1] call BIS_fnc_PriorityQueue_IsFull;
*/

#include "..\priorityQueue_defines.inc"
params [ "_handle" ];
!isNil {QUEUES} && ACTUAL_QUEUE_SIZE(_handle) == ACTUAL_QUEUE_MAXSIZE(_handle)
