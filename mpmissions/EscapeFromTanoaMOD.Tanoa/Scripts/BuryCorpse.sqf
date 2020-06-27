// Delete player's corpse after respawn, but only after all group members are far away and thus cannot be already looting his inventory
// The reason is to prevent excessive looting of your own corpses

_body = _this;

waitUntil {sleep 1; {(_x distance _body) < 25} count allPlayers == 0};

deleteVehicle _body;
