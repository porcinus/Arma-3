_logic = _this param [0,objnull,[objnull]];
_activated = _this param [2,true,[true]];

if (_activated) then {
	_heli = objnull;
	_cargo = objnull;

	{
		_veh = vehicle _x;
		_cfg = configfile >> "cfgvehicles" >> typeof _veh;
		if (count getarray (_cfg >> "slingLoadCargoMemoryPoints") > 0) then {_cargo = _veh;};
		if (gettext (_cfg >> "slingLoadMemoryPoint") != "") then {_heli = _veh;};
	} foreach (synchronizedobjects _logic);

	if (!isnull _heli && !isnull _cargo) then {
		_heli setslingload _cargo;
	};

};