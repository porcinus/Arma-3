/*
	Author: Joris-Jan van 't Land

	Description:
	Stop one or all automated procedures.

	Parameter(s):
	_this select 0: helicopter (Object)
	_this select 1: procedure (String) [optional: default "" - all procedures]
	_this select 2: disable auto sequences? (Bool) [optional: default true]

	Returns:
	Boolean
*/

private ["_heli", "_stopAuto", "_procedure", "_showReports"];
_heli = _this param [0, objNull, [objNull]];
_procedure = _this param [1, "", [""]];
_stopAuto = _this param [2, true, [false]];

//TODO: allow passing specific procedures

if (_stopAuto) then {_heli enableAutoStartUpRTD false};

//TODO: fetch actual procedure names from config
{
	_heli setVariable ["HSim_Procedure_" + _x, false];
} forEach ["Startup", "Shutdown"];

true