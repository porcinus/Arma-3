/*
Populate Checkpoint
*/

private _trigger = _this select 0;

//NNS : delete trigger
deleteVehicle _trigger;
//missionNamespace setVariable ["Checkpoint01_populated",true,true];

//NNS : Populate building / ammo box
_checkpoint = [BIS_Post01,BIS_Post02,"BIS_mrkWP01_01","BIS_mrkWP01_02","BIS_mrkWP01_03","BIS_mrkWP01_04"] call BIS_fnc_EfM_populateCheckpoint;
BIS_NATO_Box_01 call BIS_fnc_EfM_ammoboxNATO;
