private _group = group driver BIS_heli1;
private _units = units _group;
_units = _units + (crew BIS_heli1);

// Unhide units
{
	_x hideObjectGlobal false;
	_x enableSimulationGlobal true;
	_x setCaptive false;
} forEach ([BIS_heli1] + _units);

// Re-enable AI
{
	private _unit = _x;
	{_unit enableAI _x} forEach ["AUTOCOMBAT", "AUTOTARGET", "TARGET"];
	_unit setCombatMode "YELLOW";
} forEach _units;

while {!(BIS_falconLeave)} do {
	private _time = time + 20;
	waitUntil {
		// Timeout reached
		time >= _time
		||
		// Told to leave
		BIS_falconLeave
	};
	
	// Reset ammo
	BIS_heli1 setVehicleAmmoDef 1;
};

// Delete existing waypoints
private "_waypoints";
while {_waypoints = waypoints _group; count _waypoints > 0} do {deleteWaypoint (_waypoints select 0)};

// Disable AI
{
	private _unit = _x;
	{_unit disableAI _x} forEach ["AUTOCOMBAT", "AUTOTARGET", "TARGET"];
	_unit setCombatMode "BLUE";
} forEach _units;

// Send helicopter away
private _pos = markerPos "BIS_falconLeave";
private _wp = _group addWaypoint [_pos, 0];
_wp setWaypointPosition [_pos, 0];
_wp setWaypointStatements ["true", "if (isServer) then {{deleteVehicle _x} forEach ([BIS_heli1] + (units group driver BIS_heli1))}"];
_wp setWaypointType "MOVE";
_group setCurrentWaypoint _wp;

true