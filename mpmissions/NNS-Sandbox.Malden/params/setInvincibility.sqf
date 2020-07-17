//NNS : add menu option to set players invincibility
if (isServer) then {
	_invinc = param [0,1,[999]];
	
	_allowDamage = false;
	if (_invinc == 1) then {_allowDamage = true;};
	
	missionNamespace setVariable ["BIS_Invincibility",_allowDamage,true];
};
