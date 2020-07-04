//NNS : add menu option for ammobox contain limiter
if (isServer) then {
	_ammoboxAmount = param [0,1,[999]];
	
	_min = 0.1; _max = 0.25;
	
	if (_ammoboxAmount == 1) then {_min = 0.25; _max = 0.50;};
	if (_ammoboxAmount == 2) then {_min = 0.50; _max = 0.75;};
	if (_ammoboxAmount == 3) then {_min = 0.75; _max = 1;};
	
	missionNamespace setVariable ["BIS_ammoboxAmount",[_min,_max],true];
};
