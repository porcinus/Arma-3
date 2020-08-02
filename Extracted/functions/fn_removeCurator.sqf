private ["_curator","_logic","_curators"];

_curator = _this param [0,objnull,[objnull]];
_logic = missionnamespace getvariable ["bis_functions_mainscope",objnull];

_curators = _logic getvariable ["bis_fnc_curatorInterface_curators",[]];
_curators = _curators - [_curator];
_logic setvariable ["bis_fnc_curatorInterface_curators",_curators,true];

true