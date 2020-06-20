/*
NNS : Compile all players stats for debriefing screen
Note: maybe need to rework this file since it is only called when mission ends
*/

params [
	["_client_exec",true]
];


if (_client_exec) then { //NNS : stats : convert to global when mission end
	_distance_traveled = player getVariable "distance_traveled"; player setVariable ["distance_traveled",_distance_traveled,true]; //set distance traveled value to public
	_shot_fired = player getVariable "shot_fired"; player setVariable ["shot_fired",_shot_fired,true]; //set shot fired value to public
	["BIS_fnc_NNS_CompileDebriefingStats : Stats variables set to global"] call BIS_fnc_NNS_debugOutput; //debug
};

if (isServer && {!_client_exec}) then { //if server, compile all data, TODO: to localize
	[true] remoteExec ["BIS_fnc_NNS_CompileDebriefingStats",0,true]; //ask everyone to set stats variable to global
	sleep 5; //allow some time for everyone
	
	["BIS_fnc_NNS_CompileDebriefingStats : Server start compile players stats"] call BIS_fnc_NNS_debugOutput; //debug
	_players_stats = []; //store array
	_shot_fired_group = [0,0,0,0,0]; //store used ammo for whole group
	_longest_kill_group = [objNull,0]; //store group longest kill
	_friendly_kill_group = [objNull,0];
	
	{
		if !(_x isEqualTo objNull) then { //extra security
			if ((getPlayerUID _x) != "" && {(getPlayerUID _x) != "_SP_AI_"}) then { //not AI
				_players_stats pushBack format["<t font='PuristaBold' underline='1'>%1</t><br/>",name _x]; //player name
				
				_shot_fired = _x getVariable ["shot_fired",[0,0,0,0,0]]; //recover player shot fired value and compile data
				_shot_fired_group set [0, (_shot_fired_group select 0) + (_shot_fired select 0)]; _shot_fired_group set [1, (_shot_fired_group select 1) + (_shot_fired select 1)]; _shot_fired_group set [2, (_shot_fired_group select 2) + (_shot_fired select 2)]; _shot_fired_group set [3, (_shot_fired_group select 3) + (_shot_fired select 3)]; _shot_fired_group set [4, (_shot_fired_group select 4) + (_shot_fired select 4)];
				_players_stats pushBack format[localize "STR_NNS_Debriefing_AmmoUsed_title",(_shot_fired select 0),["","s"] select ((_shot_fired select 0) > 1),
				[format[localize "STR_NNS_Debriefing_AmmoUsed_HEgrenades",(_shot_fired select 1),["","s"] select ((_shot_fired select 1) > 1)], ""] select ((_shot_fired select 1) == 0),
				[format[localize "STR_NNS_Debriefing_AmmoUsed_SmokeGrenade",(_shot_fired select 2),["","s"] select ((_shot_fired select 2) > 1)], ""] select ((_shot_fired select 2) == 0),
				[format[localize "STR_NNS_Debriefing_AmmoUsed_Rockets",(_shot_fired select 3),["","s"] select ((_shot_fired select 3) > 1)], ""] select ((_shot_fired select 3) == 0),
				[format[localize "STR_NNS_Debriefing_AmmoUsed_Vehicle",(_shot_fired select 4),["","s"] select ((_shot_fired select 4) > 1)], ""] select ((_shot_fired select 4) == 0)];
				_players_stats pushBack "<br/>"; //linebreak
				
				_distance_traveled = _x getVariable ["distance_traveled",[0,0]]; //recover player distance traveled value and compile data
				_players_stats pushBack format[localize "STR_NNS_Debriefing_DistanceTravel_title",round (_distance_traveled select 0),
				[format[localize "STR_NNS_Debriefing_DistanceTravel_vehicle",round (_distance_traveled select 1),round ((_distance_traveled select 0)+(_distance_traveled select 1))], ""] select (round (_distance_traveled select 1) == 0)]; //distance traveled
				_players_stats pushBack "<br/>"; //linebreak
				
				_longest_kill = _x getVariable ["longest_kill",[0,""]]; //recover player longest kill and compile data
				if ((_longest_kill select 0) > (_longest_kill_group select 1)) then {_longest_kill_group = [_x,(_longest_kill select 0)];};
				_longest_kill_weapon = gettext (configFile >> "CfgWeapons" >> (_longest_kill select 1) >> "displayName"); //try to recover weapon name
				if (_longest_kill_weapon=="") then {_longest_kill_weapon = gettext (configFile >> "CfgVehicles" >> (_longest_kill select 1) >> "displayName");}; //failed: try to get vehicle name
				_players_stats pushBack format[localize "STR_NNS_Debriefing_LongestKill_title",(_longest_kill select 0),[format[" (%1)",_longest_kill_weapon],""] select (_longest_kill_weapon == "")];
				_players_stats pushBack "<br/>"; //linebreak
				
				_friendly_kill = _x getVariable ["friendly_kill",0]; //recover player friendly kill and compile data
				if (_friendly_kill > (_friendly_kill_group select 1)) then {_friendly_kill_group = [_x,_friendly_kill];};
				_players_stats pushBack format[localize "STR_NNS_Debriefing_FriendlyKill_title",_friendly_kill,""];
				_players_stats pushBack "<br/>"; //linebreak
				
				
				
				
				_players_stats pushBack "<br/>"; //add separator
			};
		};
	} forEach units BIS_grpMain; //go thru all player in group
	
	//group shot fired value and compile data
	_players_stats pushBack "<br/>"; //add separator
	_players_stats pushBack format["<t font='PuristaBold' underline='1'>%1</t><br/>",localize "STR_NNS_Debriefing_GroupStats_title"]; //title
	_players_stats pushBack format[localize "STR_NNS_Debriefing_AmmoUsed_title",(_shot_fired_group select 0),["","s"] select ((_shot_fired_group select 0) > 1),
	[format[localize "STR_NNS_Debriefing_AmmoUsed_HEgrenades",(_shot_fired_group select 1),["","s"] select ((_shot_fired_group select 1) > 1)], ""] select ((_shot_fired_group select 1) == 0),
	[format[localize "STR_NNS_Debriefing_AmmoUsed_SmokeGrenade",(_shot_fired_group select 2),["","s"] select ((_shot_fired_group select 2) > 1)], ""] select ((_shot_fired_group select 2) == 0),
	[format[localize "STR_NNS_Debriefing_AmmoUsed_Rockets",(_shot_fired_group select 3),["","s"] select ((_shot_fired_group select 3) > 1)], ""] select ((_shot_fired_group select 3) == 0),
	[format[localize "STR_NNS_Debriefing_AmmoUsed_Vehicle",(_shot_fired_group select 4),["","s"] select ((_shot_fired_group select 4) > 1)], ""] select ((_shot_fired_group select 4) == 0)];
	_players_stats pushBack "<br/>"; //linebreak
	
	//group longest and compile data
	if !((_longest_kill_group select 0) isEqualTo objNull) then {
		_players_stats pushBack format[localize "STR_NNS_Debriefing_LongestKill_title",(_longest_kill_group select 1),format[" (%1)",name (_longest_kill_group select 0)]];
		_players_stats pushBack "<br/>"; //linebreak
	};
	
	if !((_friendly_kill_group select 0) isEqualTo objNull) then {
		_players_stats pushBack format[localize "STR_NNS_Debriefing_FriendlyKill_title",(_friendly_kill_group select 1),format[" (%1)",name (_friendly_kill_group select 0)]];
		_players_stats pushBack "<br/>"; //linebreak
	};
	
	missionNamespace setVariable ["BIS_GlobalStats",_players_stats joinString "",true]; //export
	sleep 5; //allow some time for everyone
};
