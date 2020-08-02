/*
	Author: Jiri Wainar

	Description:
	Returns is unit is playing given animation or ev. one of the given animations.

	Parameter(s):
		0: unit
		1: animation or array of animations
		2: animation set is mirrored (default: false)

	Returns:
	TRUE if unit is playing animation or one of the given animations.

	Example:
	[_unit,_anims,_mirrored] call bis_fnc_carrier01CrewInAnim;
*/

#include "defines.inc"

params
[
	["_unit",objNull,[objNull]],
	["_anims","",["",[]]],
	["_mirrored",false,[true]]
];

if (isNull _unit) exitWith {["[x] Cannot play animation, unit is NULL!"] call bis_fnc_error};

if (_anims isEqualType "") then
{
	_anims = [_anims];
};

if (_mirrored) then
{
	_anims = _anims apply {toLower format["%1_m",_x]};
}
else
{
	_anims = _anims apply {toLower _x};
};

(animationState _unit) in _anims