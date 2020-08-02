// Prevent units from disembarking if disabled
BIS_LSV1 allowCrewInImmobile true;

// Unhide first LSV
BIS_LSV1 setPosASL (BIS_LSV1 getVariable "BIS_alt");

{
	_x hideObjectGlobal false;
	_x enableSimulationGlobal true;
	_x allowDamage true;
} forEach [BIS_LSV1, BIS_LSV1D, BIS_LSV1G];

// Watch first shooting position
BIS_LSV1G doWatch (markerPos "BIS_suppress1");

sleep 1;

BIS_LSV1 setPos ([BIS_LSV1, 2, random 360] call BIS_fnc_relPos);

sleep 3;

// Unhide second LSV
BIS_LSV2 setPosASL (BIS_LSV2 getVariable "BIS_alt");

{
	_x hideObjectGlobal false;
	_x enableSimulationGlobal true;
	_x allowDamage true;
	_x setCaptive false;
} forEach ([BIS_LSV2] + BIS_viper4);

sleep 1;

BIS_LSV2 setPos ([BIS_LSV2, 2, random 360] call BIS_fnc_relPos);

true