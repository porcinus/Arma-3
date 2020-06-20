/*
Populate Checkpoint
*/

private _trigger = _this select 0;

//NNS : delete trigger
deleteVehicle _trigger;
//missionNamespace setVariable ["Checkpoint02_populated",true,true];

//NNS : Populate building / ammo box
_checkpoint = [BIS_Post03,BIS_Post04,"BIS_mrkWP02_01","BIS_mrkWP02_02","BIS_mrkWP02_03","BIS_mrkWP02_04"] call BIS_fnc_EfM_populateCheckpoint;
BIS_NATO_Box_02 call BIS_fnc_EfM_ammoboxNATO;
_null = BIS_Tower_Port3 call BIS_fnc_EfM_populateTower;
