private ["_competitor", "_cp", "_angle"];
_competitor = _this param [0, player, [objNull]];
_cp = _this param [1, objNull, [objNull]];

_angle = [_cp, _competitor] call BIS_fnc_relativeDirTo;
if (_angle < 0) then {_angle = _angle + 360;};
if ((_angle > 90) && (_angle < 270)) then {false} else {true}