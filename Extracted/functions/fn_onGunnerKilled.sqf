// Make sure we are running only on the server machine
if (!isServer) exitWith
{
	"Function must be called on the server only" call BIS_fnc_error;
};

// Campaign common includes
#include "\A3\Missions_F_Exp\Campaign\commonDefines.inc"

// Defines
#define MAX_DIST 100

// Parameters
private _gunner = _this param [0, objNull, [objNull]];

// Validate gunner
if (isNull _gunner) exitWith
{
	"_gunner is NULL" call BIS_fnc_error;
};

// The vehicle gunner was / is in
private _vehicle = vehicle _gunner;

// Make sure gunner is actually in a vehicle
if (_vehicle == _gunner) exitWith
{
	"_gunner is not in a vehicle" call BIS_fnc_error;
};

// Make sure gunner is actually a gunner in it's vehicle
if (_gunner != gunner _vehicle) exitWith
{
	"_gunner is not the GUNNER of his vehicle" call BIS_fnc_error;
};

// The newly assigned gunner
private _newGunner = objNull;

// Go through all units in gunners group and check whether one of those can assume gunner responsabilities
{
	if (alive _x && {vehicle _x == _x} && {_x distance _vehicle <= MAX_DIST}) exitWith
	{
		_newGunner = _x;
	};
}
forEach units group _gunner;

// Since gunner does not have group units which can take his place
// Evaluate groups of same side which could do it instead
if (isNull _newGunner) then
{
	// Go through all units of same side
	{
		if (alive _x && {vehicle _x == _x} && {_x != BIS_boss} && {side group _x == side group _gunner} && {_x distance _vehicle <= MAX_DIST}) exitWith
		{
			_newGunner = _x;
		};
	}
	forEach allUnits;
};

// Finally, if we found a valid replacement make him board vehicle weapon
// Also add killed event handler so flow can continue
if (!isNull _newGunner) then
{
	_newGunner assignAsGunner _vehicle;
	[_newGunner] allowGetIn true;
	[_newGunner] orderGetIn true;
	_newGunner addEventHandler ["Killed", {_this call BIS_fnc_onGunnerKilled}];
};

// Log
["New Gunner: %1 / %2", _newGunner, _vehicle] call BIS_fnc_logFormat;