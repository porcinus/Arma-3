/*
Populate Debug Zone
*/

//NNS : advise player for ahead location
private _trigger = _this select 0;
private _triggerPos = getPos _trigger;
private _locationName = "debug zone";//text nearestLocation [_triggerPos, "NameVillage"]; //try to recover location name
_distance = round (_triggerPos vectorDistance (getPos player)); //marker length
[format[localize "STR_NNS_approachingLocation",[_locationName] call NNS_fnc_StringCapitalize,_distance]] remoteExec ["systemChat"];

//NNS : delete trigger
deleteVehicle _trigger;
//missionNamespace setVariable ["Airbase_populated",true,true];

skipTime(12-daytime+24)%24;




_arrow = 'Sign_Arrow_Large_Blue_F' createVehicle [0,0,0];
_arrow setPos _triggerPos;

[debugzone_vehi_0,["hitfuel"],0.3,0.9] call NNS_fnc_randomVehicleDamage;
[debugzone_vehi_1,["hitfuel"],0.5,0.9] call NNS_fnc_randomVehicleDamage;
[debugzone_vehi_2,["hitfuel"],0.5,0.9] call NNS_fnc_randomVehicleDamage;

//debugzone_building_0 setDamage [1, false];
//[debugzone_building_0,1000,true] remoteExec ["NNS_fnc_spawnBigFire",0,true]; //remoteexec fire

//alarm car
//[[1209.377,12294.334],90,[],[],1,false,false,0,1,["C_man_polo_1_F"]] call NNS_fnc_spawnCivVehi;
//[[1209.047,12287.499],90,[],[],1,false,false,0,1,["C_man_polo_1_F"]] call NNS_fnc_spawnCivVehi;
//[[1209.409,12280.695],90,[],[],1,false,false,0,1,["C_man_polo_1_F"]] call NNS_fnc_spawnCivVehi;

_debugzone_vehi_3 = createVehicle ["O_APC_Tracked_02_cannon_F", [1272.073,12269.836,0], [], 0, "NONE"];
_debugzone_vehi_3 setDir 0;
_debugzone_vehi_3 setPos [1272.073,12269.836,0];
_debugzone_vehi_3 enableDynamicSimulation true;

[_debugzone_vehi_3,["hitfuel"],0.3,0.9] call NNS_fnc_randomVehicleDamage;
_debugzone_vehi_3 setFuel (random 0.05);
[_debugzone_vehi_3,0,0,true] call NNS_fnc_AmmoboxLimiter;

//debugzone_lamp_0



/*
this addAction 
[ 
 "soundtest local", 
 { 
  params ["_target", "_caller", "_actionId", "_arguments"]; 
  _pos = getPos _target; 
  _sound = createSoundSource ["Sound_Alarm", _pos, [], 0]; 
 }, 
 nil, 
 1.5, 
 true, 
 true, 
 "", 
 "true", 
 3 
];*/







//sleep 5;
/*
ZombiesUnit setVariable ["TotalAmount",100,true];
systemChat "eee";
[ZombiesUnit] call RyanZM_fnc_rzfunctionspawn;
*/
/*
ZombiesUnit setVariable ["TotalAmount",100,true];
ZombiesUnit getVariable "TotalAmount";
ZombiesUnit call RZ_fnc_ModuleSpawner;

systemChat format['%1', this getVariable 'TotalAmount'];
ZombiesUnit setVariable ["TotalAmount",100,true];
waitUntil {missionNamespace setVariable ['zombie_ready',false]};
systemChat format['%1', this getVariable 'TotalAmount'];

*/

//ZombiesUnit setVariable ['BIS_fnc_initModules_disableAutoActivation', false, true];
//ZombiesUnit getVariable 'Amount'
//[ZombiesUnit] call BIS_fnc_initModules;
//[ZombiesUnit] call RZ_fnc_ModuleSpawner;

/*
//NNS : Damage map buildings
{
	if !(_x isKindOf "PowerLines_base_F" || _x isKindOf "PowerLines_Small_base_F") then { //ignore PowerLines class
		_rnd = 0.5 + random 0.7;
		if (_rnd > 1) then {_rnd = 1;};
		_x setDamage [_rnd,false];
	};
} foreach (_triggerPos nearObjects ["House", 500]);

// Empty vehicles
_kamysh = createVehicle ["B_APC_Tracked_01_rcws_F", [7943.02,9981.25,0], [], 0, "NONE"];
_kamysh setDir 0;
[_kamysh,["hitfuel"],0.3,0.7] call NNS_fnc_randomVehicleDamage;
_kamysh setFuel (random 0.05);

_tigris = createVehicle ["B_APC_Tracked_01_AA_F", [7999.55,10069.1,0], [], 0, "NONE"];
_tigris setDir 270;
[_tigris,["hitfuel"],0.3,0.7] call NNS_fnc_randomVehicleDamage;
_tigris setFuel (random 0.05);

{_x setFuel (random 0.1);} forEach [BIS_EW01,BIS_EW02,BIS_EW03,BIS_EW04,BIS_EW05];

sleep 5;

//NNS : Populate building / ammo box
airbase_crate_0 call BIS_fnc_EfM_ammoboxCSAT;
_null = airbase_tower_0 call NNS_fnc_CargoTower_Equipments;
_null = airbase_tower_1 call NNS_fnc_CargoTower_Equipments;

{ // set random damage and fuel to tanks/truck
	_x enableDynamicSimulation true;
	[_x,["hitfuel"],0.3,0.9] call NNS_fnc_randomVehicleDamage;
	_x setFuel (random 0.05);
	_x setVehicleAmmo (0.05 + random 0.1);
} forEach [airbase_vehi_0];
*/