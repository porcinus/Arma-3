private ["_logic","_units","_activated","_value"];

_logic = _this param [0,objnull,[objnull]];
_units = _this param [1,[],[[]]];
_activated = _this param [2,true,[true]];

if (_activated) then {

	//--- Extract the user defined module arguments
	_value = (_logic getvariable ["value",0]) min 1 max 0;

	{
		_veh = vehicle _x;			
		_x setVehicleAmmo _value;
	} foreach _units;
};
true