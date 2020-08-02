/*
	Author: 
		Killzone_Kid

	Description:
		Spawns given function and executes it in the order it was called in case multiple calls are made.
		If mutex name is not specified, function name is used.

	Parameter(s):
		0: ANYTHING - function params
		1: STRING - function name in current namespace
		2: STRING (Optional) - mutex name

	Returns:
		BOOLEAN - false if function name is empty, otherwise true
		
	Example:
		myFnc = { diag_log [_this, canSuspend] };
		for "_i" from 0 to 1000 do { [_i, "myFnc"] call BIS_fnc_spawnOrdered };
*/


private _fnc_spawnFIFO = 
{
	params ["___queue", "_params", "_function", "_namespace"];
	
	waitUntil { ___queue select 0 isEqualTo _thisScript };

	call
	{
		private ___queue = true; // special case
		_params call (_namespace getVariable [_function, {}]);
	};
	
	___queue deleteAt 0;
};

params 
[
	["_params", []], 
	["_function", "", [""]],
	["_mutex", "", [""]]
];

if (_function isEqualTo "") exitWith { false };
if (_mutex isEqualTo "") then { _mutex = _function };

private ___queue = [];

isNil 
{
	private _varName = format ["BIS_fnc_spawnOrdered_%1", _mutex];
	___queue = missionNamespace getVariable _varName;
	
	if (isNil "___queue") then 
	{ 
		missionNamespace setVariable [_varName, []];
		___queue = missionNamespace getVariable _varName;
	};
	
	___queue pushBack ([___queue, _params, _function, currentNamespace] spawn _fnc_spawnFIFO);
};

true 