private ["_logic","_units","_skill","_combatMode","_formation","_speed","_behavior","_stance","_captive","_lock"];

_logic = _this param [0,objnull,[objnull]];
_units = _this param [1,[],[[]]];
_activated = _this param [2,true,[true]];

if (_activated) then {

	//--- Extract the user defined module arguments
	_combatMode = _logic getvariable ["combatMode",""];
	_formation = _logic getvariable ["formation",""];
	_speed = _logic getvariable ["speed",""];
	_behavior = _logic getvariable ["behavior",""];
	_stance = _logic getvariable ["stance",""];
	_captive = _logic getvariable ["captive",-1];
	if (_captive isequaltype "") then {_captive = parsenumber _captive;};
	_lock = _logic getvariable ["locked",""];

	{
		(group _x) setCombatmode _combatMode;
		
		(group _x) setFormation _formation;
		
		(group _x) setSpeedMode _speed;

		(group _x) setBehaviour _behavior;

		_x setUnitPos _stance;		
		
		switch (_captive) do
		{
			case -1: {};
			default {_x setCaptive _captive};	
		};
		
		(vehicle _x) setVehicleLock _lock;	
		
	} foreach _units;
};

true