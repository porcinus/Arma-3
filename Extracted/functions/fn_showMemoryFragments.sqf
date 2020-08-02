params [
	["_show",true,[false]]
];

{
	_alt = if (_show) then {0} else {100};
	_pos = (_x getvariable ["bis_pos",position _x]) vectoradd [0,0,_alt];
	{_x setposatl _pos;} foreach (
		[_x]
		+
		((_x getvariable ["bis_effects",[]]) apply {_x select 0})
		//+
		//((getposatl _x) nearobjects ["dynamicsound",1])
	);
} foreach (missionnamespace getvariable ["BIS_memoryFragments",[]]);