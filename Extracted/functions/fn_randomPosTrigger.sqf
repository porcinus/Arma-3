/*
	Author: 
		Karel Moricky, optimised by Killzone_Kid

	Description:
		Selects random position within trigger, marker, location area or area defined by array

	Parameter(s):
		_this: 
			OBJECT - trigger
			STRING - marker
			ARRAY - array in format [center, distance] or [center, [a, b, angle, rect]] or [center, [a, b, angle, rect, height]]
			LOCATION - location

	Returns:
		ARRAY - [x,y,z]
*/

if (_this isEqualType [] && {count _this isEqualTo 1}) then {_this = param [0, ""]}; // backward compatibility

_this call BIS_fnc_getArea params ["_center", "_a", "_b", "_angle", "_rect"];

// rectangle
if (_rect) exitWith {_center vectorAdd ([[2 * random _a - _a, 2 * random _b - _b, 0], -_angle] call BIS_fnc_rotateVector2D)};

// ellipse
[random 360, sqrt random 1] params ["_dir", "_k"];
_center vectorAdd ([[_a * _k * cos _dir, _b * _k * sin _dir, 0], -_angle] call BIS_fnc_rotateVector2D)