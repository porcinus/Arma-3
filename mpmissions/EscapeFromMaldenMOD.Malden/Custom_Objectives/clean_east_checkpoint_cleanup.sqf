
{deleteVehicle _x;} forEach ((getMissionLayerEntities "objective_zone_2 : Clean East Checkpoint") select 0);
{/*_x setMarkerAlpha 0;*/deleteMarker _x;} forEach ((getMissionLayerEntities "objective_zone_2 : Clean East Checkpoint") select 1);

_markerListHide = missionNamespace getVariable ["markerListHide",[]]; //checkpoint marker list
if ("NNS_checkpoint_marker_02" in _markerListHide) then { //marker in list
	_markerListHide deleteAt (_markerListHide find "NNS_checkpoint_marker_02"); //delete from list array
	missionNamespace setVariable ["markerListHide",_markerListHide]; //update marker list
};
