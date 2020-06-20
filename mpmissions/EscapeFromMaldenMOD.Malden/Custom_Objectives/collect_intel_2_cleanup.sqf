
{deleteVehicle _x;} forEach ((getMissionLayerEntities "objective_zone_10 : Collect Intel") select 0);
{_x setMarkerAlpha 0;} forEach ((getMissionLayerEntities "objective_zone_10 : Collect Intel") select 1);
