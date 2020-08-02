/*
	Author: Josef Zemanek

	Description:
	Combat Patrol safe azimuth finder. Scans around the AO for usable & convenient approach routes
*/

_radius = _this select 0;
_gradientCheck = _this select 1;

_ret = [];
_landArr = [];

for [{_i = 0}, {_i <= 360}, {_i = _i + 1}] do {
	if ({_i >= (_x select 0) && _i <= (_x select 1)} count BIS_CP_targetLocationAzimuthBlacklistArr == 0) then {
		_safe = TRUE;
		for [{_j = _radius - (if (_gradientCheck) then {10} else {0})}, {_j <= (_radius + (if (_gradientCheck) then {10} else {0})) && _safe}, {_j = _j + 10}] do {
			private ["_pos"];
			_pos = [BIS_CP_targetLocationPos, _j, _i] call BIS_fnc_relPos;
			_pos set [2, 0];
			_zDiff = 0;
			if (_gradientCheck) then {
				_dummy = leader BIS_copyGrp;
				_dummy setPos (_pos vectorAdd [0,0,100]);
				_zDiff = ((getPosATL _dummy) select 2) - ((position _dummy) select 2);
			};
			if (!_gradientCheck || (count (_pos isFlatEmpty [-1, -1, 1]) > 0 && _zDiff < 2)) then {
				if (surfaceIsWater _pos) then {
					_safe = FALSE;
				};
			} else {
				_safe = FALSE;
			};
		};
		if (_safe) then {
			if (count _landArr == 0) then {
				_landArr pushBack _i;
			} else {
				if (_i == 360) then {
					_landArr pushBack _i;
					_ret pushBack +_landArr;
					_landArr = [];
				};
			};
		} else {
			if (count _landArr == 1) then {
				_landArr pushBack _i;
				_ret pushBack +_landArr;
				_landArr = [];
			};
		};
	};
};

{
	if ((_x select 1) - (_x select 0) < 10) then {
		_ret set [_forEachIndex, -1];
	};
} forEach _ret;
_ret = _ret - [-1];

_ret