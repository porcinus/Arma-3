private ["_logic","_units","_show"];

_logic = _this param [0,objnull,[objnull]];
_units = _this param [1,[],[[]]];
_activated = _this param [2,true,[true]];

if (_activated) then {
	_show = _logic getvariable ["state","0"];
	if (_show isequaltype "") then {_show = parsenumber _show;};
	_show = _show > 0;

	{
		_veh = vehicle _x;
		_veh hideobjectglobal !_show;
		_veh enablesimulationglobal _show;
	} foreach _units;
};

true