// Delete original unit when player joins the game - not used, respawnOnStart is now -1

waitUntil {sleep 0.5; not alive _this};
deleteVehicle _this;
