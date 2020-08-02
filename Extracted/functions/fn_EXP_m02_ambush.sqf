BIS_convoySpotted = true;
BIS_detonate = true;
deleteVehicle BIS_miner;
{deleteVehicle _x} forEach BIS_charges;

// Gather groups and units
private _groups = [];
private _units = [];

{
	private _unit = _x;
	private _gunner = gunner vehicle _unit;

	// Separate unit into its own group
	private _group = createGroup RESISTANCE;
	[_unit] joinSilent _group;

	if (_gunner == _unit) then {
		// Stop gunner from disembarking
		_gunner setBehaviour "COMBAT";
	} else {
		// Add group and units
		_groups = _groups + [_group];
		_units = _units + [_unit];
	};
} forEach BIS_convoyUnits;

{
	// Unassign vehicles from group
	private _group = _x;
	{_group leaveVehicle _x} forEach BIS_convoyVehicles;

	// Defend themselves
	private _wp = _group addWaypoint [position vehicle leader _group, 0];
	_wp setWaypointBehaviour "COMBAT";
	_wp setWaypointCombatMode "RED";
	_wp setWaypointSpeed "FULL";
	_wp setWaypointType "SAD";
	_group setCurrentWaypoint _wp;
} forEach _groups;

// Switch units to combat, unassign from vehicle
{
	_x setBehaviour "COMBAT";
	unassignVehicle _x;
} forEach _units;

// Order to disembark
doGetOut _units;
_units orderGetIn false;

[] spawn {
	scriptName "missionFlow.fsm: engage";

	sleep 1;

	// Play conversation
	["75_Open_Fire"] spawn BIS_fnc_missionConversations;


	// Let Support Team engage
	{
		_x setCaptive false;
		_x setCombatMode "YELLOW";
	} forEach BIS_supportUnits;

	// Close the exit
	BIS_supportAttack = true;
	{_x setUnitPos "AUTO"} forEach [BIS_supportLead, BIS_support2, BIS_support3];
};
