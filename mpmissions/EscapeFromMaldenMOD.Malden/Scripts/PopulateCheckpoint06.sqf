/*
Populate Checkpoint
*/

private _trigger = _this select 0;

//NNS : delete trigger
deleteVehicle _trigger;
//missionNamespace setVariable ["Checkpoint06_populated",true,true];

//NNS : Populate building / ammo box
_checkpoint = [BIS_Post11,BIS_Post12,"BIS_mrkWP06_01","BIS_mrkWP06_02","BIS_mrkWP06_03","BIS_mrkWP06_04"] call BIS_fnc_EfM_populateCheckpoint;
BIS_NATO_Box_06 call BIS_fnc_EfM_ammoboxNATO;
