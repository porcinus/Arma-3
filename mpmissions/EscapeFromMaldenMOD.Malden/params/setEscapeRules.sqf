if (isServer) then {
	_escapeRules = param [0,1,[999]];
	missionNamespace setVariable ["BIS_EscapeRules",_escapeRules];
	publicVariable "BIS_EscapeRules";
};
