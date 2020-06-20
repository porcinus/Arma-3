//NNS : use orginal escape rules or permissive rules
if (isServer) then {
	_escapeRules = param [0,1,[999]];
	missionNamespace setVariable ["BIS_EscapeRules",_escapeRules,true];
	//publicVariable "BIS_EscapeRules";
};
