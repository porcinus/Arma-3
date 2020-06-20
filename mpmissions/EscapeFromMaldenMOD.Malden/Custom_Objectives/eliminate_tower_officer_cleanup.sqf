
{deleteVehicle _x;} forEach ((getMissionLayerEntities "objective_zone_3 : Eliminate Tower Officer") select 0);
{_x setMarkerAlpha 0;} forEach ((getMissionLayerEntities "objective_zone_3 : Eliminate Tower Officer") select 1);
