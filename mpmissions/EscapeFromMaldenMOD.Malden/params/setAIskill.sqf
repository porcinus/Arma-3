//NNS : add menu option for enemy AI skill
if (isServer) then {
	_AIskill = param [0,1,[999]];
	if (_AIskill == 0) then {missionNamespace setVariable ["BIS_AIskill",0.25];};
	if (_AIskill == 1) then {missionNamespace setVariable ["BIS_AIskill",0.5];};
	if (_AIskill == 2) then {missionNamespace setVariable ["BIS_AIskill",0.75];};
	publicVariable "BIS_AIskill";
};
