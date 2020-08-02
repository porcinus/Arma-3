//--- A script function for animating "Land_DataTerminal_01_F"
//--- To open terminal: [box, 3] call BIS_fnc_DataTerminalAnimate
//--- To close terminal: [box, 0] call BIS_fnc_DataTerminalAnimate

if !(_this isEqualTypeParams [objNull, 0]) exitWith
{
	["Required format: [<dataTerminalObject>, <animationPhase>]"] call BIS_fnc_error;
	nil
};

params ["_obj", "_phase"];

_obj animateSource ["Lock_source", _phase];
_obj animateSource ["Sesame_source", _phase];
_obj animateSource ["Antenna_source", _phase];