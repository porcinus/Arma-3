//NNS : add menu option to disable stamina
if (isServer) then {
	_stamina = param [0,1,[999]];
	
	_staminaEnable = false;
	if (_stamina == 1) then {_staminaEnable = true;};
	
	missionNamespace setVariable ["BIS_stamina",_staminaEnable,true];
	//publicVariable "BIS_stamina";
};
