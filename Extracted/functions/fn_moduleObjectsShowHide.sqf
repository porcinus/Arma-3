private ["_logic","_units","_show"];

_logic = _this param [0,objnull,[objnull]];
_units = _this param [1,[],[[]]];
_show = parsenumber (_logic getvariable ["state","0"]) > 0;

{
	_x hideobject !_show;
	_x enablesimulation _show;
} foreach _units;

true