/*
	Author: 
		Karel Moricky, tweaked by Killzone_Kid

	Description:
		Converts config color format to RGBA array of numbers.
		["0.5 + 0.25",0,0,1] becomes [0.75,0,0,1]

	Parameter(s):
		0: ARRAY - color in RGBA format or CONFIG color array

	Returns:
		ARRAY
*/

private _color = [param [0, [0,0,0,0]], _this] select (_this isEqualType [] && { count _this > 1 });

if ((_color isEqualType configNull && { count getArray _color == 4 }) || (_color isEqualType [] && { count _color == 4 })) exitWith { _color call BIS_fnc_parseNumberSafe };

["Invalid color '%1'", _color] call BIS_fnc_error;

[0,0,0,0]