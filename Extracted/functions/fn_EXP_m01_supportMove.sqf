#include "\a3\missions_f_exp\campaign\missions\exp_m01.tanoa\dev.hpp"

if (!(BIS_devMode)) then {
	sleep 4;
	
	{
		// Determine animation
		private _anim = switch (_forEachIndex) do {
			case 0: {"Acts_SupportTeam_Front_FromKneelLoop"};
			case 1: {"Acts_SupportTeam_Left_FromKneelLoop"};
		};
		
		// Store animation
		_x setVariable ["BIS_anim", _anim];
		
		// Detect when they stand up
		private _animEH = _x addEventHandler [
			"AnimDone",
			{
				params ["_unit", "_anim"];
				
				if (_anim == (_unit getVariable "BIS_anim")) then {
					// Remove event handler
					_unit removeEventHandler ["AnimDone", _unit getVariable "BIS_animEH"];
					{_unit setVariable [_x, nil]} forEach ["BIS_animEH", "BIS_anim"];
					
					// Enable AI
					{_unit enableAI _x} forEach ["AUTOTARGET", "TARGET"];
					_unit enableMimics true;
					
					// Register that they're ready
					_unit setVariable ["BIS_standing", true];
				};
			}
		];
		
		// Store event handler
		_x setVariable ["BIS_animEH", _animEH];
		
		// Play animation
		_x playMove _anim;
	} forEach [BIS_supportLead, BIS_support1];

	// Wait for everyone to be ready
	waitUntil {{!(_x getVariable ["BIS_standing", false])} count [BIS_supportLead, BIS_support1] == 0};
};

// Let them move
{
	_x setBehaviour "AWARE";
	_x enableAI "MOVE";
} forEach [BIS_supportLead, BIS_support1];

// Give them a waypoint
private _wp = BIS_supportGroup addWaypoint [[4207.27,4019.04,0], 0];
_wp setWaypointType "MOVE";
BIS_supportGroup setCurrentWaypoint _wp;

private _timeOut = time + 25;
private _away = false;

waitUntil {
	_away = call {
		{
			private _player = _x;
			{_player distance _x < 50} count [BIS_supportLead, BIS_support1] > 0
		} count allPlayers == 0
	};
	
	// Timed-out
	time >= _timeOut
	||
	// Players are far enough away
	_away
};

if (!(_away)) then {
	// Play conversation
	"x00_Orders" spawn BIS_fnc_missionConversations;
	
	// Wait for players to be far enough away
	waitUntil {
		{
			private _player = _x;
			{_player distance _x < 50} count [BIS_supportLead, BIS_support1] > 0
		} count allPlayers == 0
	};
};

// Delete waypoints
private "_waypoints";
while {_waypoints = waypoints BIS_supportGroup; count _waypoints > 0} do {deleteWaypoint (_waypoints select 0)};

{
	private _unit = _x;
	
	// Hide icons
	{_unit setVariable [_x, false, true]} forEach ["BIS_iconAlways", "BIS_iconShow", "BIS_iconName"];
	
	// Hide unit
	_unit hideObjectGlobal true;
	_unit enableSimulationGlobal false;
	
	// Move into the air
	[_unit, 10e10] call BIS_fnc_setHeight;
	_unit disableAI "MOVE";
} forEach [BIS_supportLead, BIS_support1];

true