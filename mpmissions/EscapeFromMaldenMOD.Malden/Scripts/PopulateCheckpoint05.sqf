/*
Populate Checkpoint
*/

private _trigger = _this select 0;

//NNS : delete trigger
deleteVehicle _trigger;
//missionNamespace setVariable ["Checkpoint05_populated",true,true];

//NNS : Populate building / ammo box
_checkpoint = [BIS_Post09,BIS_Post10,"BIS_mrkWP05_01","BIS_mrkWP05_02","BIS_mrkWP05_03","BIS_mrkWP05_04"] call BIS_fnc_EfM_populateCheckpoint;
BIS_NATO_Box_05 call BIS_fnc_EfM_ammoboxNATO;
