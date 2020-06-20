
{deleteVehicle _x;} forEach ((getMissionLayerEntities "objective_zone_1 : Clean South Checkpoint") select 0);
{/*_x setMarkerAlpha 0;*/deleteMarker _x;} forEach ((getMissionLayerEntities "objective_zone_1 : Clean South Checkpoint") select 1);

_markerListHide = missionNamespace getVariable ["markerListHide",[]]; //checkpoint marker list
if ("NNS_checkpoint_marker_01" in _markerListHide) then { //marker in list
	_markerListHide deleteAt (_markerListHide find "NNS_checkpoint_marker_01"); //delete from list array
	missionNamespace setVariable ["markerListHide",_markerListHide]; //update marker list
};
