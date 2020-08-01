/*
	Author: 
		Karel Moricky, optimised by Killzone_Kid

	Description:
		Adds scripted event handler and returns id
		"ScriptedEventHandlerAdded" scripted EH is called

	Parameter(s):
		0: BOOL, NAMESPACE, OBJECT, GROUP, LOCATION, CONTROL or DISPLAY - namespace in which handler is saved. When BOOL, missionNameSpace is used.
		1: STRING - handler name
		2: CODE or STRING - code executed upon calling

	Returns:
		NUMBER - handler ID
*/

params [
	["_namespace", objNull, [true, missionNamespace, objNull, grpNull, locationNull, controlNull, displayNull]],
	["_name", "", [""]],
	["_code", {}, [{}, ""]]
];

if (_code isEqualType "") then {_code = compile _code};
if (_namespace isEqualType true) then {_namespace = missionNamespace};

_name = "BIS_fnc_addScriptedEventHandler_" + _name;
private _handlers = _namespace getVariable _name;

if (isNil "_handlers") exitWith 
{
	_namespace setVariable [_name, [_code]];
	
	[missionNamespace, "ScriptedEventHandlerAdded", [_namespace, _name, 0]] call BIS_fnc_callScriptedEventHandler;
	0
};

private _handlerID = _handlers find -1;

if (_handlerID < 0) then
{
	_handlerID = _handlers pushBack _code;
}
else
{
	_handlers set [_handlerID, _code];
};

[missionNamespace, "ScriptedEventHandlerAdded", [_namespace, _name, _handlerID]] call BIS_fnc_callScriptedEventHandler;
_handlerID 