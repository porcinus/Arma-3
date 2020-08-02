/*
	Author: 
		Karel Moricky, optimised by Killzone_Kid

	Description:
		Calls scripted event handlers

	Parameter(s):
		0: BOOL, NAMESPACE, OBJECT, GROUP, LOCATION, CONTROL or DISPLAY - namespace in which handler is saved. When BOOL, missionNameSpace is used.
		1: STRING - handler name
		2: ARRAY - arguments passed to the code
		3 (Optional): BOOL - true to expect returned value from all codes

	Returns:
		ARRAY - list of returned values or empty array
*/

#define EHID_VAR _thisScriptedEventHandler

params [
	["_namespace", objNull, [true, missionNamespace, objNull, grpNull, locationNull, controlNull, displayNull]],
	["_name", "", [""]],
	["_args", [], [[]]]
];

if (_namespace isEqualType true) then {_namespace = missionNamespace};

//-- return is needed
if (param [3, false] isEqualTo true) exitWith
{
	EHID_VAR = -1;
	(_namespace getVariable ["BIS_fnc_addScriptedEventHandler_" + _name, []]) apply 
	{
		EHID_VAR = EHID_VAR + 1;
		if (_x isEqualType {}) then 
		{
			[_args, _x] call
			{
				private ["_namespace", "_name", "_args", "_x"];
				_this select 0 call (_this select 1);
			};
		};
	};
};

//-- no return is needed
{
	EHID_VAR = _forEachIndex;
	if (_x isEqualType {}) then 
	{
		[_args, _x] call
		{
			private ["_namespace", "_name", "_args", "_x", "_forEachIndex"];
			_this select 0 call (_this select 1);
		};
	};
	
} 
forEach (_namespace getVariable ["BIS_fnc_addScriptedEventHandler_" + _name, []]);

[]