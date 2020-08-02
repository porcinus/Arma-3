private _start 	= _this param [0, [0.0, 0.0, 0.0], [[]]];
private _end 	= _this param [1, [0.0, 0.0, 0.0], [[]]];
private _value 	= _this param [2, 0.0, [0.0]];

[
	[_start select 0, _end select 0, _value] call BIS_fnc_hermite,
	[_start select 1, _end select 1, _value] call BIS_fnc_hermite,
	[_start select 2, _end select 2, _value] call BIS_fnc_hermite
];