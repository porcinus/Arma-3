/*
	Author: 
		Karel Moricky, optimised by Killzone_Kid

	Description:
		Removes scripted event handler of given type and id
		"ScriptedEventHandlerRemoved" scripted EH is called

	Parameter(s):
		0: BOOL, NAMESPACE, OBJECT, GROUP, LOCATION, CONTROL or DISPLAY - namespace in which handler is saved. When BOOL, missionNameSpace is used.
		1: STRING - handler name
		2: NUMBER - handler ID

	Returns:
		BOOL
*/

params [
	["_namespace", objNull, [true, missionNamespace, objNull, grpNull, locationNull, controlNull, displayNull]],
	["_name", "", [""]],
	["_handlerID", -1, [0]]
];

if (_namespace isEqualType true) then {_namespace = missionNamespace};

_name = "BIS_fnc_addScriptedEventHandler_" + _name;
private _handlers = _namespace getVariable [_name, []];

if (_handlerID >= 0 && _handlerID < count _handlers) exitWith
{
	_handlers set [_handlerID, -1];

	[missionNamespace, "ScriptedEventHandlerRemoved", [_namespace, _name, _handlerID]] call BIS_fnc_callScriptedEventHandler;
	true
};

false
