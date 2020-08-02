params [
	["_stats",[],[[]]],
	["_index",-1,[0]]
];

//--- Every new playthrough replaces values from the previous one
{
	setstatvalue [_x,if (_foreachindex == _index) then {1} else {0}];
} foreach _stats;

/*
//--- Save only the first occurance, ignore all others
private _stat = _stats select _index;
if ({[getstatvalue _x] param [0,0] > 0} count _stats == 0) then {
	setstatvalue [_stat,1];
	["Stat '%1' saved.",_stat] call bis_fnc_logFormat;
} else {
	["Stat '%1' not saved, because different choice already exists.",_stat] call bis_fnc_logFormat;
};
*/