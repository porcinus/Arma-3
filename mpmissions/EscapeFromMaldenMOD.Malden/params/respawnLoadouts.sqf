if (isServer) then {
	_respawnLoadouts = param [0,1,[999]];
	missionNamespace setVariable ["BIS_loadoutLevel",_respawnLoadouts,true];
	//if (_respawnLoadouts == 0) Then {missionNamespace setVariable ["BIS_loadoutLevel",0,true];};
	//if (_respawnLoadouts == 1) Then {missionNamespace setVariable ["BIS_loadoutLevel",1,true];};
	//if (_respawnLoadouts == 2) Then {missionNamespace setVariable ["BIS_loadoutLevel",2,true];};
	publicVariable "BIS_loadoutLevel";
};
