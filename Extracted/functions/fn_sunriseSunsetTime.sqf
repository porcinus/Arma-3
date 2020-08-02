/*
	Author: Karel Moricky, modified by Killzone_Kid

	Description:
	Calculate sunrise and sunset time.

	Parameter(s):
		ARRAY  - date in format [year,month,day,hour,minute], i.e., standard game date format

	Returns:
	ARRAY in format [<sunriseTime:number>,<sunsetTime:number>]
	Returns special values when the world position is behind the polar cicle:
	[0,-1] - polar summer (i.e., no sunset)
	[-1,0] - polar winter (i.e., no sunrise)
*/

private _fnc_sunriseSunsetTime = 
{
	private _equinox = (360 * datetonumber _this) - (360 * 81 / 365);
	private _inc = asin (sin 23.44 * sin _equinox);
	private _lat = -getnumber (configfile >> "cfgworlds" >> worldname >> "latitude");
	private _hourAngle = -tan _lat * tan _inc;

	if (_hourAngle >= -1 && _hourAngle <= 1) then {
		[
			12 - acos _hourAngle / 15,
			12 + acos _hourAngle / 15
		]
	} else {
		[
			if (_hourAngle < -1) then {-1} else {0},
			if (_hourAngle > +1) then {-1} else {0}
		]
	};
};

// date call BIS_fnc_sunriseSunsetTime
if (_this isEqualTypeParams date) exitWith {_this call _fnc_sunriseSunsetTime};

// [] call BIS_fnc_sunriseSunsetTime or [date] call BIS_fnc_sunriseSunsetTime
_this = param [0, date];
if (_this isEqualTypeParams date) exitWith {_this call _fnc_sunriseSunsetTime};

["Wrong function calling format!"] call BIS_fnc_error;
nil