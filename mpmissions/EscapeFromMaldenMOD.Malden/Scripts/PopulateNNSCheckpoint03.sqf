/*
Populate Checkpoint
*/

private _trigger = _this select 0;

//NNS : delete trigger
deleteVehicle _trigger;

//NNS : Populate building / ammo box
_checkpoint = [checkpoint_03_post_0,checkpoint_03_post_1,"checkpoint_03_wp_0","checkpoint_03_wp_1","checkpoint_03_wp_2","checkpoint_03_wp_3"] call BIS_fnc_EfM_populateCheckpoint;
_null = checkpoint_03_tower_0 call BIS_fnc_EfM_populateTower;
_null = checkpoint_03_tower_0 call BIS_fnc_NNS_Populate_CargoTower_More;
_null = checkpoint_03_hq_0 call BIS_fnc_NNS_Populate_CargoHQ;
_null = checkpoint_03_post_2 call BIS_fnc_EfM_populatePost;
_null = checkpoint_03_natocrate_0 call BIS_fnc_EfM_ammoboxNATO;

missionNamespace setVariable ["checkpoint_03_spawned",true,true];
