//NNS : add infinite respawn
if (isServer) then {
	_respawnTickets = param [0,9,[999]];
	_playerSide = missionNamespace getVariable ["BIS_playerSide", side (leader BIS_grpMain)]; //get players side
	if (_respawnTickets == -1) then {[_playerSide,0] call BIS_fnc_respawnTickets; /*publicVariable "BIS_respawnTickets"*/};
	if (_respawnTickets == 0) then {missionNamespace setVariable ["BIS_respawnTickets",0,true]; /*publicVariable "BIS_respawnTickets"*/};
	if (_respawnTickets == 1) then {[_playerSide,10] call BIS_fnc_respawnTickets;};
	if (_respawnTickets == 2) then {[_playerSide,20] call BIS_fnc_respawnTickets;};
	if (_respawnTickets == 3) then {[_playerSide,30] call BIS_fnc_respawnTickets;};
	if (_respawnTickets == 4) then {[_playerSide,40] call BIS_fnc_respawnTickets;};
	if (_respawnTickets == 5) then {[_playerSide,50] call BIS_fnc_respawnTickets;};
	if (_respawnTickets == 6) then {[_playerSide,100] call BIS_fnc_respawnTickets;};
	if (_respawnTickets == 7) then {missionNamespace setVariable ["BIS_respawnTickets",1,true]; /*publicVariable "BIS_respawnTickets"*/};
	if (_respawnTickets == 8) then {missionNamespace setVariable ["BIS_respawnTickets",2,true]; /*publicVariable "BIS_respawnTickets"*/};
	if (_respawnTickets == 9) then {missionNamespace setVariable ["BIS_respawnTickets",3,true]; /*publicVariable "BIS_respawnTickets"*/};
	if (_respawnTickets == 10) then {missionNamespace setVariable ["BIS_respawnTickets",4,true]; /*publicVariable "BIS_respawnTickets"*/};
	if (_respawnTickets == 11) then {missionNamespace setVariable ["BIS_respawnTickets",5,true]; /*publicVariable "BIS_respawnTickets"*/};
	if (_respawnTickets == 12) then {missionNamespace setVariable ["BIS_respawnTickets",10,true]; /*publicVariable "BIS_respawnTickets"*/};
};
