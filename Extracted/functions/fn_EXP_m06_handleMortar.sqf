// Wait for mortar to come online
waitUntil {missionNamespace getVariable ["BIS_mortarActive", false]};

// Add support to player
[player, BIS_requester, BIS_provider] call BIS_fnc_addSupportLink;

true