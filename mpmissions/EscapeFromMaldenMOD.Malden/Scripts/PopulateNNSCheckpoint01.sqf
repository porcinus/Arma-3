/*
Populate Checkpoint
*/

private _trigger = _this select 0;

//NNS : delete trigger
deleteVehicle _trigger;

//NNS : Populate building / ammo box
_checkpoint = [checkpoint_01_post_0,checkpoint_01_post_1,"checkpoint_01_wp_0","checkpoint_01_wp_1","checkpoint_01_wp_2","checkpoint_01_wp_3"] call BIS_fnc_EfM_populateCheckpoint;
_null = checkpoint_01_hq_0 call BIS_fnc_NNS_Populate_CargoHQ;
_null = checkpoint_01_bunker_0 call BIS_fnc_NNS_Populate_BagBunkerTower;
_null = checkpoint_01_bunker_1 call BIS_fnc_NNS_Populate_BagBunkerTower;
_null = checkpoint_01_natocrate_0 call BIS_fnc_EfM_ammoboxNATO;

missionNamespace setVariable ["checkpoint_01_spawned",true,true];
