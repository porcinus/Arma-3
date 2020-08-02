/*
	Author: 
		Karel Moricky, optimised by Killzone_Kid

	Description:
		Removes all scripted event handlers of given type
		"ScriptedEventHandlerRemoved" scripted EH is called for each removed EH

	Parameter(s):
		0: BOOL, NAMESPACE, OBJECT, GROUP, LOCATION, CONTROL or DISPLAY - namespace in which handler is saved
		1: STRING - handler name

	Returns:
		BOOL
*/

params [
	["_namespace", objNull, [true, missionNamespace, objNull, grpNull, locationNull, controlNull, displayNull]],
	["_name", "", [""]]
];

if (_namespace isEqualType true) then {_namespace = missionNamespace};

_name = "BIS_fnc_addScriptedEventHandler_" + _name;
private _handlers = _namespace getVariable _name;

if (isNil "_handlers") exitWith {false};

{
	if (_x isEqualType {}) then
	{
		_handlers set [_forEachIndex, -1];
		[missionNamespace, "ScriptedEventHandlerRemoved", [_namespace, _name, _forEachIndex]] call BIS_fnc_callScriptedEventHandler;
	};
}
forEach _handlers;

_namespace setVariable [_name, []];
true 