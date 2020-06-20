/*
Populate Checkpoint
*/

private _trigger = _this select 0;

//NNS : delete trigger
deleteVehicle _trigger;

//NNS : Populate building / ammo box
_checkpoint = [checkpoint_02_post_0,checkpoint_02_post_1,"checkpoint_02_wp_0","checkpoint_02_wp_1","checkpoint_02_wp_2","checkpoint_02_wp_3"] call BIS_fnc_EfM_populateCheckpoint;
_null = checkpoint_02_hq_0 call BIS_fnc_NNS_Populate_CargoHQ;
_null = checkpoint_02_bunker_0 call BIS_fnc_NNS_Populate_BagBunkerTower;
_null = checkpoint_02_bunker_1 call BIS_fnc_NNS_Populate_BagBunkerTower;
_null = checkpoint_02_natocrate_0 call BIS_fnc_EfM_ammoboxNATO;

missionNamespace setVariable ["checkpoint_02_spawned",true,true];
