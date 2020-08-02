/*
WARLORDS-SPECIFIC FUNCTION

Author: Josef Zemánek

Description: Hints buffer.
*/

private ["_i", "_text", "_duration"];

_i = _this # 0;
_text = _this # 1;
_duration = _this # 2;

BIS_WL_hintArray set [_i, _text];

if (_duration < 0) exitWith {};

sleep _duration;

if ((BIS_WL_hintArray # _i) == _text) then {
	BIS_WL_hintArray set [_i, ""];
};