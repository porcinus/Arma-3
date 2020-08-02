/*
WARLORDS-SPECIFIC FUNCTION

Author: Josef Zemánek

Description: Returns a random position in rectangle area.
*/

_center = _this # 0;
_axisX = _this # 1;
_axisY = _this # 2;

private ["_i", "_i2", "_pos"];

_i = 1; if (random 1 >= 0.5) then {_i = -1};
_i2 = 1; if (random 1 >= 0.5) then {_i2 = -1};

_pos = [(_center # 0) + ((random _axisX) * _i), (_center # 1) + ((random _axisY) * _i2), 0];

while {surfaceIsWater _pos} do {
	_pos = [(_center # 0) + ((random _axisX) * _i), (_center # 1) + ((random _axisY) * _i2), 0];
};

_pos