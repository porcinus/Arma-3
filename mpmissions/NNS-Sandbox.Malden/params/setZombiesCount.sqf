//NNS : add menu option for zombie amount
if (isServer) then {
	_zombieAmount = param [0,9,[999]];
	
	//normal: following players, caches, checkpoints, cities, big cities, pre escape
	_alive = [35,20,25,35,40,10];
	_total = [9999,30,35,45,50,9999];
	_horde = [10,8,10,15,15,5];
	
	if (_zombieAmount == 0) then {
		for "_i" from 0 to 5 do {
			_alive set [_i, ceil ((_alive select _i) * 0.5)];
			_total set [_i, ceil ((_total select _i) * 0.5)];
			_horde set [_i, ceil ((_horde select _i) * 0.5)];
		};
	};
	
	if (_zombieAmount == 2) then {
		for "_i" from 0 to 5 do {
			_alive set [_i, ceil ((_alive select _i) * 1.5)];
			_total set [_i, ceil ((_total select _i) * 1.5)];
			_horde set [_i, ceil ((_horde select _i) * 1.5)];
		};
	};
	
	if (_zombieAmount == 3) then { //debug, only one zombie
		for "_i" from 0 to 5 do {
			_alive set [_i, 1];
			_total set [_i, 1];
			_horde set [_i, 1];
		};
	};
	
	missionNamespace setVariable ["BIS_ZM_alive", _alive, true];
	missionNamespace setVariable ["BIS_ZM_total", _total, true];
	missionNamespace setVariable ["BIS_ZM_horde", _horde, true];
};
