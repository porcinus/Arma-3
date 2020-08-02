private _group = group BIS_miller;
private _i = 1;
private "_marker";

// Make Miller move normally
{BIS_miller enableAI _x} forEach ["ANIM", "AUTOCOMBAT", "AUTOTARGET", "MOVE", "TARGET"];
BIS_miller setUnitPos "UP";
BIS_miller setCombatMode "YELLOW";
BIS_miller setBehaviour "AWARE";

// Move to engage patrol first
private _wp = _group addWaypoint [markerPos "BIS_patrol", 0];
_wp setWaypointType "MOVE";
_group setCurrentWaypoint _wp;

// Wait for all guards to die, or for the timeout to be reached
private _time = time + 30;
waitUntil {time >= _time || {alive _x} count BIS_droneGuards == 0};

// Kill surviving guards
{if (alive _x) then {_x setDamage 1}} forEach BIS_droneGuards;

// Disable unnecessary parts of Miller's AI
{BIS_miller disableAI _x} forEach ["AUTOCOMBAT", "AUTOTARGET", "TARGET"];
BIS_miller setCombatMode "BLUE";

while {_marker = ("BIS_millerWP" + (str _i)); markerType _marker != ""} do {
	// Add waypoint
	private _pos = markerPos _marker;
	private _wp = _group addWaypoint [_pos, 0];
	_wp setWaypointPosition [_pos, 0];
	_wp setWaypointType "MOVE";

	if (_i == 5) then {
		// Move to exact position
		_wp setWaypointStatements [
			"true",
			"
				if (isServer) then {
					BIS_miller doMove [2830.604,9487.637,0];

					[] spawn {
						scriptName 'BIS_fnc_EXP_m06_millerMove: final move';

						waitUntil {!(unitReady BIS_miller)};
						waitUntil {unitReady BIS_miller};

						BIS_miller disableAI 'MOVE';
						BIS_miller enableMimics false;
						BIS_miller playMove 'Acts_MillerCamp';

						private _animEH = BIS_miller addEventHandler [
							'AnimStateChanged',
							{
								params ['_unit', '_anim'];

								if (_anim == 'Acts_MillerCamp') then {
									private _animEH = _unit getVariable 'BIS_fnc_EXP_m06_millerMove_animEH';
									if (!(isNil {_animEH})) then {
										_unit removeEventHandler ['AnimStateChanged', _animEH];
										_unit setVariable ['BIS_fnc_EXP_m06_millerMove_animEH', nil];
									};

									_unit enableSimulationGlobal false;
									_unit setPos [2830.604,9487.637,0];
									_unit setDir 33.842;
								};
							}
						];

						BIS_miller setVariable ['BIS_fnc_EXP_m06_millerMove_animEH', _animEH];
					};
				};
			"
		];
	};

	// Ensure he moves
	if (_i == 1) then {_group setCurrentWaypoint _wp};

	// Increase iteration
	_i = _i + 1;
};

true