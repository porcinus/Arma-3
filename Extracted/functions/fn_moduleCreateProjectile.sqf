_logic = _this param [0,objnull,[objnull]];
_units = _this param [1,[],[[]]];
_activated = _this param [2,true,[true]];

if (_activated) then {

	_type = _logic getvariable ["Type","SmokeShell"];
	_smoke = createvehicle [_type,position _logic,[],0,"none"];
	_smoke setpos position _logic;
};