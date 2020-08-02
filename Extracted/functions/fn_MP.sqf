/*
	Author: 
		Karel Moricky, modified by Killzone_Kid

	Description:
		Sends function or scripting command for remote execution (and executes locally if conditions are met)

	Parameter(s):
		0: ANY - function params
		1: STRING - function or scripting command name
		2 (Optional):
			BOOL - true to execute on each machine (including the one where the function was called from), false to execute it on server only [default: true]
			STRING - the function will be executed only where object or group defined by the variable name is local
			OBJECT - the function will be executed only where unit is local
			GROUP - the function will be executed only on client who is member of the group
			SIDE - the function will be executed on all players of the given side
			NUMBER - the function will be executed only on client with the given owner ID
			ARRAY - array of previous data types
		3 (Optional): BOOL - true for persistent call (will be called now and for every JIP client) [default: false]

	Returns:
		ARRAY - information about sent instructions
*/

with missionNamespace do
{
	params [
		["_params", []],
		["_functionName", ""],
		["_targets", 0],
		["_isPersistent", false],
		["_isCall", false]
	];
	
	/// --- validate input
	#include "..\paramsCheck.inc"
	#define arr1 [_params,_functionName,_targets,_isPersistent,_isCall]
	#define arr2 [nil,"",nil,false,false]
	paramsCheck(arr1,isEqualTypeParams,arr2)
		
	private _allTargets = [];
	private _fnc_getTargets = 
	{ 
		{
			call
			{
				if (isNil "_x") exitWith 
				{
					["Target at index %1 in %2 is undefined! Skipping...", _forEachIndex, _this] call BIS_fnc_error;
				};
				if (_x isEqualType []) exitWith 
				{
					_x call _fnc_getTargets;
				};
				if (_x isEqualType false) exitWith 
				{
					_allTargets pushBack ([2, 0] select _x);
				};
				if !(_x isEqualTypeAny [objNull, 0, sideUnknown, grpNull, ""]) exitWith 
				{
					["Target at index %1 in %2 is invalid! Skipping...", _forEachIndex, _this] call BIS_fnc_error;
				};
				_allTargets pushBack _x;
			};
		
		} 
		forEach _this;
	};
	
	[_targets] call _fnc_getTargets;

	if (_isCall) then
	{
		_params remoteExecCall [_functionName, _allTargets, _isPersistent, false];
	}
	else
	{
		_params remoteExec [_functionName, _allTargets, _isPersistent, false];
	};

	[0, _params, _functionName, _allTargets, _isPersistent, _isCall]
};