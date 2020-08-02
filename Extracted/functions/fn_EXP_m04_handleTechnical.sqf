params ["_technical"];
private _gunner = gunner _technical;
private _driver = driver _technical;

private _crew = [_gunner, _driver];
private _group = group _gunner;

waitUntil {
	// Crew was engaged
	{!(alive _x) || behaviour _x == "COMBAT"} count _crew > 0
	||
	// Technical can't shoot
	!(canFire _technical)
	||
	// Technical can't move
	!(canMove _technical)
};

// Defend position
private _wp = _group addWaypoint [position _technical, 0];
_wp setWaypointType "SAD";
_group setCurrentWaypoint _wp;

waitUntil {
	// Gunner was killed
	!(alive _gunner)
	||
	// Technical can't shoot
	!(canFire _technical)
	||
	// Technical can't move
	!(canMove _technical)
};

if (canFire _technical && { canMove _technical && { alive _driver } }) then {
	// Remove gunner from group
	[_gunner] joinSilent grpNull;

	// Make driver switch to gunner seat
	_driver assignAsGunner _technical;
	[_driver] orderGetIn true;
};

true