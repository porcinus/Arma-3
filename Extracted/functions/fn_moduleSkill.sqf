private ["_logic","_units","_skill"];

_logic = _this param [0,objnull,[objnull]];
_units = _this param [1,[],[[]]];
_activated = _this param [2,true,[true]];

if (_activated) then {

	//--- Extract the user defined module arguments
	_skill = (_logic getvariable ["value",0.5]) min 1 max 0;

	{
		(vehicle _x) setSkill _skill;
	} foreach _units;
};

true