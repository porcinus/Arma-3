private ["_curator","_input","_coef","_enable"];
_curator = _this param [0,objnull,[objnull]];
_input = _this param [1,[],[0,[]]];

_coef = _input param [0,0,[0]];
_enable = _input param [1,true,[true]];

_curator setvariable ["bis_fnc_curatorSystem_coefDestroy",[_coef,_enable],true];
[_coef,_enable]