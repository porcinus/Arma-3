//NNS : add menu option to disable stamina
if (isServer) then {
	_punish = param [0,1,[999]];
	
	_TKpunish = false;
	if (_punish == 1) then {_TKpunish = true;};
	
	missionNamespace setVariable ["BIS_TKpunish",_TKpunish,true];
};
