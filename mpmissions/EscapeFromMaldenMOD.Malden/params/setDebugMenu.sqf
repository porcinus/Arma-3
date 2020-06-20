//NNS : add menu option for debug outputs
if (isServer) then {
	_debugmenu_level = param [0,9,[999]];
	missionNamespace setVariable ["DebugMenu_level","none"];
	if (_debugmenu_level == 1) then {missionNamespace setVariable ["DebugMenu_level","admin"];};
	if (_debugmenu_level == 2) then {missionNamespace setVariable ["DebugMenu_level","anyone"];};
	publicVariable "DebugMenu_level";
};
