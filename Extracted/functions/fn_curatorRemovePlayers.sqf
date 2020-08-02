private ["_curator","_units","_players","_selectedArray","_selectedObjects"];
_curator = _this param [0,objnull,[objnull]];
_units = _this param [1,[],[[]]];

_players = _curator getvariable ["bis_fnc_curatorSystem_players",[]];
{
	_unitID = _players find _x;
	if (_unitID >= 0) then {
		_players set [_unitID,-1];
		[_x,"bis_fnc_curatorSystem_curatorsPlayer",_curator,true] call bis_fnc_variablespaceremove;
	};
} foreach _units;
_players = _players - [-1];
_curator setvariable ["bis_fnc_curatorSystem_players",_players,true];


_players