#include "defines.inc"

//["[ ] Catapult action removal initialized: %1",_this] call bis_fnc_logFormat;

private _trigger = param [0, objNull, [objNull]];
private _target = GET_AIRPLANE(_trigger);

private _actionID = GET_ACTION_ID(_target);

if (_actionID != -1) then
{
	//["[ ] Catapult action (id: %2) removed from airplane %1.",_target,_actionID] call bis_fnc_logFormat;

	[_target,_actionID] call bis_fnc_holdActionRemove;

	SET_ACTION_ID(_target,-1);
};