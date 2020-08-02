/*
	Author: Jiri Wainar

	Description:
	Play animation or action throught different commands on given carrier crew unit.

	Parameter(s):
		0: carrier crew unit
		1: mode defining command used, accepted values are "playmove", "playmovenow", "switchmove" or "playaction"
		2: animation name (without the suffix '_m' that is used for mirrored anim set)
		3: anim set is mirrored (default: false)

	Returns:
	Nothing.

	Example:
	[_unit,_mode,_animation,_mirrored] call bis_fnc_carrier01CrewPlayAnim;
	[_crewAidF,"playmovenow","Acts_JetsCrewaidFCrouchThumbup_loop",true] call bis_fnc_carrier01CrewPlayAnim;
*/

#include "defines.inc"

params
[
	["_unit",objNull,[objNull]],
	["_mode","",[""]],
	["_animation","",[""]],
	["_mirrored",false,[true]]
];

if (isNull _unit) exitWith {["[x] Cannot play animation, unit is NULL!"] call bis_fnc_error};
if (_mode == "") exitWith {["[x] Cannot play animation for unit '%1', mode is empty string!",_unit] call bis_fnc_error};
if (_animation == "") exitWith {["[x] Cannot play animation for unit '%1', animation is empty string!",_unit] call bis_fnc_error};

if (_mirrored) then
{
	_animation = format["%1_m",_animation];
};

_mode = toLower _mode;

//["[ ][ANIM PREV] animationState %1 = '%2'",_unit,animationState _unit] call bis_fnc_logFormat;
//["[ ][ANIM CODE] %1 %2 '%3'",_unit,_mode,_animation] call bis_fnc_logFormat;

switch (_mode) do
{
	case "playmove":
	{
		_unit playMove _animation;
	};
	case "playmovenow":
	{
		_unit playMoveNow _animation;
	};
	case "switchmove":
	{
		_unit switchMove _animation;
	};
	case "playaction":
	{
		_unit playAction _animation;
	};
	default
	{
		["[x] Cannot play animation '%3' for unit '%1', unrecognized mode '%2' used!",_unit,_mode,_animation] call bis_fnc_error;
	};
};