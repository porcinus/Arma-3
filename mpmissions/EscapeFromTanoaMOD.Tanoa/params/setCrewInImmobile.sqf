if (isServer) then
{
	_crewInImmobile = param [0,1,[999]];
	if (_crewInImmobile == 0) then {missionNamespace setVariable ["BIS_crewInImmobile",0]};
	if (_crewInImmobile == 1) then {missionNamespace setVariable ["BIS_crewInImmobile",1]};

};
