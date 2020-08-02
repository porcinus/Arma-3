_logic = _this param [0,objnull,[objnull]];
_units = _this param [1,[],[[]]];

_markers = _logic getvariable ["Markers",""];
_markers = call compile ("[" + _markers + "]");

{
	_x setmarkeralpha 0;
} foreach _markers;

true