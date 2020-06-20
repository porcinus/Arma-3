if (isServer) then {
	_respawnTickets = param [0,9,[999]];
	if (_respawnTickets == 0) then {missionNamespace setVariable ["BIS_respawnTickets",0]; publicVariable "BIS_respawnTickets"};
	if (_respawnTickets == 1) then {[east,10] call BIS_fnc_respawnTickets;};
	if (_respawnTickets == 2) then {[east,20] call BIS_fnc_respawnTickets;};
	if (_respawnTickets == 3) then {[east,30] call BIS_fnc_respawnTickets;};
	if (_respawnTickets == 4) then {[east,40] call BIS_fnc_respawnTickets;};
	if (_respawnTickets == 5) then {[east,50] call BIS_fnc_respawnTickets;};
	if (_respawnTickets == 6) then {[east,100] call BIS_fnc_respawnTickets;};
	if (_respawnTickets == 7) then {missionNamespace setVariable ["BIS_respawnTickets",1]; publicVariable "BIS_respawnTickets"};
	if (_respawnTickets == 8) then {missionNamespace setVariable ["BIS_respawnTickets",2]; publicVariable "BIS_respawnTickets"};
	if (_respawnTickets == 9) then {missionNamespace setVariable ["BIS_respawnTickets",3]; publicVariable "BIS_respawnTickets"};
	if (_respawnTickets == 10) then {missionNamespace setVariable ["BIS_respawnTickets",4]; publicVariable "BIS_respawnTickets"};
	if (_respawnTickets == 11) then {missionNamespace setVariable ["BIS_respawnTickets",5]; publicVariable "BIS_respawnTickets"};
	if (_respawnTickets == 12) then {missionNamespace setVariable ["BIS_respawnTickets",10]; publicVariable "BIS_respawnTickets"};
};
