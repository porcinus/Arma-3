/*
	Author: Karel Moricky

	Description:
	Shake analogue gauges

	Parameter(s):
	_this select 0 (Optional): NUMBER - shake limit (max distance gauges can move on screen from original position)
	_this select 1 (Optional): NUMBER - number of repeats
	_this select 2 (Optional): NUMBER - delay between every position change
	_this select 3 (Optional): ARRAY - list of IDCs

	Returns:
	NOTHING
*/


disableserialization;

_shakeLimit = _this param [0,0.002,[0]];
_shakeRepeats = _this param [1,50,[0]];
_shakeDelay = _this param [2,0.01,[0]];
_controls = _this param [2,[601,611,621,631,641,660],[[]]];

_display = uinamespace getvariable 'RscUnitInfoAir';
if (isnull _display) exitwith {};

//--- Save
_positions = [];
{
	_ctrl = _display displayctrl _x;
	_positions set [count _positions,ctrlposition _ctrl];
} foreach _controls;

//--- Shake
for "_i" from 0 to _shakeRepeats do {
	_xRan = -_shakeLimit + random (2 * _shakeLimit);
	_yRan = -_shakeLimit + random (2 * _shakeLimit);
	{
		_ctrl = _display displayctrl _x;
		_pos = _positions select _foreachindex;
		_pos = +_pos;
		_pos set [0,(_pos select 0) + _xRan];
		_pos set [1,(_pos select 1) + _yRan];
		_ctrl ctrlsetposition _pos;
		_ctrl ctrlcommit _shakeDelay;
	} foreach _controls;
	sleep _shakeDelay;
};

//--- Restore
{
	_ctrl = _display displayctrl _x;
	_pos = _positions select _foreachindex;
	_ctrl ctrlsetposition _pos;
	_ctrl ctrlcommit _shakeDelay;
} foreach _controls;



