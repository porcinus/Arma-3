// Play conversation
private _conversationScript = ["55_Engage"] spawn BIS_fnc_missionConversations;

// Make Support Team engage
{
	_x setCombatMode "YELLOW";
	_x setUnitPos "MIDDLE";
} forEach BIS_supportUnits;

private _time = time + 7;
waitUntil {time >= _time || {alive _x} count BIS_finalSupport == 0};

// Kill remaining Support Team enemies
{if (alive _x) then {_x setDamage 1}} forEach BIS_finalSupport;

// Join them together
private _units = [BIS_support2, BIS_support3];
_units joinSilent BIS_supportLead;
{_x allowFleeing 0} forEach _units;

{
	_x enableAI "MOVE";
	_x disableAI "AUTOCOMBAT";
	_x setBehaviour "AWARE";
	_x setCombatMode "BLUE";
	_x setUnitPos "AUTO";
} forEach BIS_supportUnits;

// Create waypoints
for "_i" from 1 to 4 do {
	private _marker = "BIS_supportMove" + (str _i);
	private _wp = BIS_supportGroup addWaypoint [markerPos _marker, 0];

	switch (_i) do {
		case 1: {
			// Check the building
			_wp setWaypointStatements ["true", "if (isServer) then {BIS_supportSearched = true}"];
			_wp setWaypointSpeed "FULL";
		};

		case 3: {
			// Let Support Team engage and be engaged
			_wp setWaypointStatements [
				"true",
				"
					if (isServer) then {
						{_x setCaptive false} forEach (BIS_supportUnits + BIS_finalUnits);

						{
							_x setBehaviour 'COMBAT';
							_x setCombatMode 'YELLOW';
							_x enableAI 'AUTOCOMBAT';
							_x setSkill ['aimingAccuracy', 0.2];
						} forEach BIS_supportUnits;
					};
				"
			];
		};

		case 4: {
			// Search the area
			_wp setWaypointSpeed "NORMAL";
			_wp setWaypointType "SAD";
		};
	};

	// Move out
	if (_i != 4) then {_wp setWaypointType "MOVE"};
	if (_i == 1) then {BIS_supportGroup setCurrentWaypoint _wp};
};

true