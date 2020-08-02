/*
	Author: Nelson Duarte

	Description:
	Balances a group depending on the amount of connected players

	Parameters:
		_group: The group to balance
		_minCount: The minimal count of units group must end up with
		_bExcludeVehicleRoles: Whether to exclude units in important vehicle roles (driver, gunner, commander)

	Returns:
		Nothing
*/

// Campaign common includes
#include "\A3\Missions_F_Exp\Campaign\commonDefines.inc"

// Parameters
params
[
	["_group", grpNull, [grpNull]],
	["_minCount", 1, [0]],
	["_bExcludeVehicleRoles", true, [true]]
];

// Validate group
if (isNull _group) exitWith
{
	"Provided _group is NULL" call BIS_fnc_error;
};

// Validate group units
if ({alive _x && !fleeing _x} count units _group < 1) exitWith
{
	"Provided _group does not have enough units to be balanced" call BIS_fnc_error;
};

// Validate minimum count
if (count units _group < _minCount) exitWith
{
	"Provided _group has less units than those required to be present" call BIS_fnc_error;
};

// The amount of units in group
private _units = units _group;
private _countUnits = count _units;

// The amount of players playing the game
private _countPlayers = count ([] call BIS_fnc_listPlayers);

// The amount of players to take into account
private _playersPerc = _countPlayers / MAX_PLAYERS;

// The desired number of units
private _maxUnits = ceil (_countUnits * _playersPerc);

// The number of units to delete
private _numberToDelete = _minCount max (_countUnits - _maxUnits);

// Select units to be destroyed
private _unitsToDelete = [];

// Go through array of units backwards
for "_i" from (_countUnits - _numberToDelete) to (_countUnits - 1) do
{
	// In case we already reached threshold, stop here
	if (count _unitsToDelete >= _numberToDelete) exitWith {};

	// The current unit to be tested
	private _unit = _units select _i;

	// Do not delete leader
	if (leader _group != _unit) then
	{
		// Exclude vehicle roles if requested
		if (!_bExcludeVehicleRoles || {vehicle _unit == _unit} || {_unit != driver vehicle _unit && {_unit != gunner vehicle _unit} && {_unit != commander vehicle _unit}}) then
		{
			// Store unit to be deleted
			_unitsToDelete pushBackUnique _unit;
		};
	};
};

// Delete units if there are any
if (count _unitsToDelete > 0) then
{
	{
		// Validate unit count
		if (count units _group <= _minCount) exitWith {};

		// If inside a vehicle move unit out of it prior to deletion
		// Placeholder fix for AI group disembarking after such event
		if (vehicle _x != _x) then
		{
			_x setPosASL [-100.0, -100.0, 0.0];
		};

		// Delete the unit
		deleteVehicle _x;
	}
	forEach _unitsToDelete;
};