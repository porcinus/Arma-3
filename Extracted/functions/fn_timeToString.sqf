//------------------
// Authors: Peter Morrison (snYpir) & Philipp Pilhofer (raedor), optimised by Killzone_Kid
// Purpose: This function returns a 24-hour time as a string from a decimal
// Arguments: [daytime]
// Return: boolean

/*
	This is meant to be used with the 'daytime' command, for
	example if 'daytime' was 7.36, '[daytime] call bis_fnc_timeToString'
	would return 07:21:36

	No rounding of the time is done - ie time is returned as per
	a clock

	The second array element passed in is the return time format.
	It can be:

	"HH"          - Hour
	"HH:MM"       - Hour:Minute
	"HH:MM:SS"    - Hour:Minute:Seconds
	"HH:MM:SS:MM" - Hour:Minute:Seconds:Milliseconds
	"ARRAY"       - [Hour,Minute,Seconds,Milliseconds]

	If the second parameter is not passed in, it defaults to
	"HH:MM:SS"
*/

params [["_daytime", dayTime], ["_format", "HH:MM:SS"]];

/// --- validate general input
#include "..\paramsCheck.inc"
#define arr1 [_daytime,_format]
#define arr2 [0,""]
paramsCheck(arr1,isEqualTypeParams,arr2)

private _min = _daytime % 1;
private _sec = (60 * _min) % 1;
private _msec = (60 * _sec) % 1;
private _hour = _daytime - _min;

_hour = format [["%1","0%1"] select (_hour < 10), _hour];
if (_format isEqualTo "HH") exitWith {_hour};

_min = 60 * _min;
_min = format [["%1","0%1"] select (_min < 10), _min - (_min % 1)];
if (_format isEqualTo "HH:MM") exitWith {[_hour, _min] joinString ":"};

_sec = 60 * _sec;
_sec = format [["%1","0%1"] select (_sec < 10), _sec - (_sec % 1)];
if (_format isEqualTo "HH:MM:SS") exitWith {[_hour, _min, _sec] joinString ":"};

_msec = 60 * _msec;
_msec = format [["%1","0%1"] select (_msec < 10), _msec - (_msec % 1)];
if (_format isEqualTo "HH:MM:SS:MM") exitWith {[_hour, _min, _sec, _msec] joinString ":"};

if (_format isEqualTo "ARRAY") exitWith {[_hour, _min, _sec, _msec]};

""