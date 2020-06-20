
{deleteVehicle _x;} forEach ((getMissionLayerEntities "objective_zone_11 : Powerplant Sabotage") select 0);
{_x setMarkerAlpha 0;} forEach ((getMissionLayerEntities "objective_zone_11 : Powerplant Sabotage") select 1);
