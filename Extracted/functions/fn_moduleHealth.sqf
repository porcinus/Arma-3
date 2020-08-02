private ["_logic","_units","_kindOfWound","_value","_bodyParts"];

_logic = _this param [0,objnull,[objnull]];
_units = _this param [1,[],[[]]];
_activated = _this param [2,true,[true]];

if (_activated) then {

	//--- Extract the user defined module arguments
	_value = (_logic getvariable ["value",0]) min 1 max 0;
	_kindOfWound = _logic getvariable ["bodypart",0];
	if (_kindOfWound isequaltype "") then {_kindOfWound = parsenumber _kindOfWound;};

	_bodyParts=["Whole body"];
	{
		_bodyParts=_bodyParts + [configName _x]; // want to read config names of soldier body
	} foreach ((configfile >> "CfgVehicles" >> "CAManBase" >> "HitPoints") call bis_fnc_subClasses);

	if (_kindOfWound==0) then
	{
		{if (_x isKindOf "CaManBase") then
			{				
				_x setDamage _value;			
			};
		} foreach _units
	} else {
		{if (_x isKindOf "CaManBase") then
			{				
				_x setHitPointDamage [(_bodyParts select _kindOfWound),_value];			
			};
		} foreach _units
	};
};

true