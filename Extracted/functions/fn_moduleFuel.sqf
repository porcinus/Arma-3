private ["_logic","_units","_kindOfWound","_value","_nameOfHitPoint"];

_logic = _this param [0,objnull,[objnull]];
_units = _this param [1,[],[[]]];
_activated = _this param [2,true,[true]];

if (_activated) then {

	//--- Extract the user defined module arguments
	_value = (_logic getvariable ["value",0]) min 1 max 0;

	// Warning: hitPoint string names are not read dynamically		

	{
		(vehicle _x) setFuel _value;				
	} foreach _units;
};

true