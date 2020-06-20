/*
Populate Pessagne
*/

//NNS : advise player for ahead location
private _trigger = _this select 0;
_distance = round ((getPos _trigger) vectorDistance (getPos player)); //marker length
[format["Enemy activity detected in Pessagne (%1m)",_distance]] remoteExec ["systemChat",0,true];

//NNS : delete trigger
deleteVehicle _trigger;
//missionNamespace setVariable ["Pessagne_populated",true,true];

//NNS : Populate building / ammo box
_null = BIS_Tower_Pessagne call BIS_fnc_EfM_populateTower;
