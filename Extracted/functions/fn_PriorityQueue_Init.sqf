/*
	Author: Zozo

	Description:
	Initialize the Priority Queue data structure.
	The Priority Queue is sorted on inserting. Bigger numbers are set on higher indexes.

	Parameters:
	_maxSize:SCALAR - OPTIONAL, sets the Queue MAX SIZE (otherwise it is set to the constant defined in the .inc file)
	_callonPush:CODE - 	OPTIONAL, if set, the scripted eventhandler is added (called when the queue size is extended)
	_callonPop:CODE - 	OPTIONAL, if set, the scripted eventhandler is added (called when the queue size is reduced)

	Returns:
	_handle: Handle to the Queue (essential for manipulation with the Queue)

	Syntax:
	_handle:SCALAR = [_maxSize] call BIS_fnc_PriorityQueue_Init;

	Example:
	_priorityQueue_1 = [10] call BIS_fnc_PriorityQueue_Init;
*/

#include "..\priorityQueue_defines.inc"
params [ ["_maxSize", MAX_SIZE, [99] ], "_callBackonPush", "_callBackonPop"];
if( isNil {QUEUES} ) then {	QUEUE_SPACE setVariable ["BIS_fnc_PriorityQueue_queues", [] ] };
QUEUES append [ [ [], 0, _maxSize ] ];
private _id = count (QUEUES) - 1;
if(!isNil "_callBackonPush") then { [	QUEUE_SPACE, format ["BIS_onQueue%1Push", _id], _callBackonPush] call BIS_fnc_addScriptedEventHandler };
if(!isNil "_callBackonPop") then { [	QUEUE_SPACE, format ["BIS_onQueue%1Pop", _id], _callBackonPop] call BIS_fnc_addScriptedEventHandler };
_id
