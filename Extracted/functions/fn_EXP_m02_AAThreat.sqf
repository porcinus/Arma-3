// Unhide AA units and vehicles
{
	[_x, _x getVariable "BIS_alt"] call BIS_fnc_setHeight;

	_x hideObjectGlobal false;
	_x enableSimulationGlobal true;
	_x allowDamage true;
	_x setCaptive false;
} forEach (BIS_AAUnits + BIS_AAVehicles);

true