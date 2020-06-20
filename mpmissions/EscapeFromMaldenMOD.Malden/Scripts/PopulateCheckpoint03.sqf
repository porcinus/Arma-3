/*
Populate Checkpoint
*/

private _trigger = _this select 0;

//NNS : delete trigger
deleteVehicle _trigger;
//missionNamespace setVariable ["Checkpoint03_populated",true,true];

//NNS : Populate building / ammo box
_checkpoint = [BIS_Post05,BIS_Post06,"BIS_mrkWP03_01","BIS_mrkWP03_02","BIS_mrkWP03_03","BIS_mrkWP03_04"] call BIS_fnc_EfM_populateCheckpoint;
