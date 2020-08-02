/*

	PROJECT: R&D
	DATE:    22/07/2014

	AUTHOR:  Sho

	fn_HEXtoRGB.sqf

		This script converts hexcodes into rgb arrays

	Params

		0: STRING         (Core)     >> HEXCODE string

	Return

		0: ARRAY          (Core)     >> RGB Array
*/

// Init control array
private ["_hexString"];
_hexString = _this select 0;

private ["_hexArray"];
_hexArray = toArray _hexString;

private ["_rgbArray"];
_rgbArray =
[
	(call compile ("0x" + (toString [_hexArray select 0, _hexArray select 1]))) * 0.00392157,
	(call compile ("0x" + (toString [_hexArray select 2, _hexArray select 3]))) * 0.00392157,
	(call compile ("0x" + (toString [_hexArray select 4, _hexArray select 5]))) * 0.00392157,
	(call compile ("0x" + (toString [_hexArray select 6, _hexArray select 7]))) * 0.00392157
];

_rgbArray