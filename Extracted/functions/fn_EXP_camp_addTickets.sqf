params [
	["_tickets", 1, [0]]
];

// Only execute on Regular Difficulty
if ((paramsArray select 0) != 1) exitWith {true};

// Ensure Tickets are only added by the server
if (!(isServer)) exitWith {"This should only be executed on the server!" call BIS_fnc_error; false};

// Ensure it isn't called at mission start
if (isNil {BIS_fnc_EXP_camp_initDifficulty_maxTickets}) exitWith {"Tickets are already at maximum at mission start!" call BIS_fnc_error; false};

private _current = WEST call BIS_fnc_respawnTickets;
private _diff = BIS_fnc_EXP_camp_initDifficulty_maxTickets - _current;

if (_diff > 0) then {
	// Add Tickets
	private _add = if (_diff < _tickets) then {_diff} else {_tickets};
	[WEST, _add] call BIS_fnc_respawnTickets;
	
	// Display notification
	private _total = _current + _add;
	private _notification = "APTicketsAdd";
	if (_total == 1) then {_notification = "APTicketsAdd1"};
	[[_notification, [_total]], "BIS_fnc_showNotification"] call BIS_fnc_MP;
	
	// Reset warning about exhausted Tickets
	BIS_fnc_EXP_camp_initDifficulty_warned = false;
};

true