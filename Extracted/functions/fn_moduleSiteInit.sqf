if (isNil 'BIS_initSitesRunning') then {
	BIS_initSitesRunning = TRUE;
	['[SITES] Modules config init'] call BIS_fnc_logFormat;
	if (isServer) then {execVM '\A3\modules_f\sites\init_core.sqf'} else {execVM '\A3\modules_f\sites\init_client.sqf'};
};