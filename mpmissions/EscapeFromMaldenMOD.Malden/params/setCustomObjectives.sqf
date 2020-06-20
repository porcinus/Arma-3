//NNS : add menu option for custom objectives
if (isServer) then {
	_customObjectives = param [0,9,[999]];
	if (_customObjectives == 0) then {missionNamespace setVariable ["BIS_customObjectives",0]; publicVariable "BIS_customObjectives"};
	if (_customObjectives == 1) then {missionNamespace setVariable ["BIS_customObjectives",1]; publicVariable "BIS_customObjectives"};
	if (_customObjectives == 2) then {missionNamespace setVariable ["BIS_customObjectives",2]; publicVariable "BIS_customObjectives"};
	if (_customObjectives == 3) then {missionNamespace setVariable ["BIS_customObjectives",3]; publicVariable "BIS_customObjectives"};
	if (_customObjectives == 4) then {missionNamespace setVariable ["BIS_customObjectives",4]; publicVariable "BIS_customObjectives"};
	if (_customObjectives == 5) then {missionNamespace setVariable ["BIS_customObjectives",5]; publicVariable "BIS_customObjectives"};
	if (_customObjectives == 6) then {missionNamespace setVariable ["BIS_customObjectives",999]; publicVariable "BIS_customObjectives"};
};
