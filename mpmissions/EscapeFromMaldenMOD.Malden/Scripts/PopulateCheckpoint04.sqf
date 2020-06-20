/*
Populate Checkpoint
*/

private _trigger = _this select 0;

//NNS : delete trigger
deleteVehicle _trigger;
//missionNamespace setVariable ["Checkpoint04_populated",true,true];

//NNS : Populate building / ammo box
_checkpoint = [BIS_Post07,BIS_Post08,"BIS_mrkWP04_01","BIS_mrkWP04_02","BIS_mrkWP04_03","BIS_mrkWP04_04"] call BIS_fnc_EfM_populateCheckpoint;
BIS_NATO_Box_04 call BIS_fnc_EfM_ammoboxNATO;
