/*
NNS : Populate south west base (created from scratch)
*/

//NNS : advise player for ahead location
private _trigger = _this select 0;
private _triggerPos = getPos _trigger;
private _locationName = text nearestLocation [_triggerPos, "NameLocal"]; //try to recover location name
_distance = round (_triggerPos vectorDistance (getPos player)); //marker length
[format[localize "STR_NNS_Escape_approachingLocation",[_locationName] call NNS_fnc_StringCapitalize,_distance]] remoteExec ["systemChat"];

//NNS : delete trigger
deleteVehicle _trigger;
//missionNamespace setVariable ["NorthEastBase_populated",true,true];

//Destroyed helicopter
_wreckHeliPos = [7562,10496,0];
_wreckHeli = "O_Heli_Light_02_unarmed_F" createVehicle [0,0,0]; //create helicopter
_wreckHeli setDamage [1, false]; //destroy helicopter
_wreckHeli setDir (random 360); //set helicopter direction
_wreckHeli setPos _wreckHeliPos; //set helicopter position
_wreckHeli setVectorUp surfaceNormal _wreckHeliPos;
sleep 2;
_wreckHeli enableSimulation false; //disable simulation

{ //NNS : Damage vehicle
	[_x,["hitfuel"],0.4,0.7] call NNS_fnc_randomVehicleDamage;
	_x setFuel (random 0.05);
	_x setVehicleAmmo (0.05 + random 0.1);
	[_x,0,0,true] call NNS_fnc_AmmoboxLimiter;
} forEach [northeastbase_vehi_0, northeastbase_vehi_1, northeastbase_vehi_2, northeastbase_vehi_3, northeastbase_vehi_4];

//NNS : Damage map buildings
//[_triggerPos,250] call NNS_fnc_destroyZone;

//NNS : Populate building / ammo box
_genUnits0 = northeastbase_post_0 call NNS_fnc_populatePost_CSAT;
_genUnits1 = northeastbase_post_1 call NNS_fnc_populatePost_CSAT;
_genUnits2 = northeastbase_tower_0 call NNS_fnc_populateTower_CSAT;
_genUnits3 = northeastbase_hq_0 call NNS_fnc_populateCargoHQ_CSAT;
_allBaseUnit = _genUnits0+_genUnits1+_genUnits2+_genUnits3;

_null = northeastbase_tower_0 call NNS_fnc_CargoTower_Equipments;
_null = northeastbase_hq_0 call NNS_fnc_CargoHQ_Equipments;

//NNS: create units
_grp01 = createGroup east;
_grp01 setFormDir 240;
_unit01a = _grp01 createUnit ["O_Soldier_SL_F", [7507,10602,0], [], 0, "CAN_COLLIDE"];
_unit01b = _grp01 createUnit ["O_soldier_F", [7507,10598,0], [], 0, "CAN_COLLIDE"];
_unit01c = _grp01 createUnit ["O_soldier_AR_F", [7507,10588,0], [], 0, "CAN_COLLIDE"];
_unit01d = _grp01 createUnit ["O_HeavyGunner_F", [7507,10585,0], [], 0, "CAN_COLLIDE"];
_unit01e = _grp01 createUnit ["O_soldier_AR_F", [7509.7,10566.5,7.55], [], 0, "CAN_COLLIDE"];
_unit01f = _grp01 createUnit ["O_HeavyGunner_F", [7509.7,10564.2,7.55], [], 0, "CAN_COLLIDE"];
{_x setUnitPos "Up"; _x disableAI "Path"; _x setDir 240;} forEach [_unit01a,_unit01b,_unit01c,_unit01d,_unit01e,_unit01f];
_grp01 enableDynamicSimulation true;
_grp01 deleteGroupWhenEmpty true;
_grp01 allowFleeing 0;
_allBaseUnit append [_unit01a,_unit01b,_unit01c,_unit01d,_unit01e,_unit01f];

_grp02 = createGroup east;
_grp02Pos = [7529,10598,0];
_unit02a = _grp02 createUnit ["O_Soldier_SL_F", _grp02Pos getPos [3 + random 3, random 360], [], 0, "CAN_COLLIDE"];
_unit02b = _grp02 createUnit ["O_soldier_M_F", _grp02Pos getPos [3 + random 3, random 360], [], 0, "CAN_COLLIDE"];
_unit02c = _grp02 createUnit ["O_soldier_AR_F", _grp02Pos getPos [3 + random 3, random 360], [], 0, "CAN_COLLIDE"];
_unit02d = _grp02 createUnit ["O_soldier_GL_F", _grp02Pos getPos [3 + random 3, random 360], [], 0, "CAN_COLLIDE"];
_unit02e = _grp02 createUnit ["O_soldier_F", _grp02Pos getPos [3 + random 3, random 360], [], 0, "CAN_COLLIDE"];
_unit02f = _grp02 createUnit ["O_HeavyGunner_F", _grp02Pos getPos [3 + random 3, random 360], [], 0, "CAN_COLLIDE"];
_grp02 enableDynamicSimulation true;
_grp02 deleteGroupWhenEmpty true;
_grp02 allowFleeing 0;
_allBaseUnit append [_unit02a,_unit02b,_unit02c,_unit02d,_unit02e,_unit02f];

_grp03 = createGroup east;
_grp03Pos = [7532,10553,0];
_unit03a = _grp03 createUnit ["O_Soldier_SL_F", _grp03Pos getPos [3 + random 3, random 360], [], 0, "CAN_COLLIDE"];
_unit03b = _grp03 createUnit ["O_soldier_M_F", _grp03Pos getPos [3 + random 3, random 360], [], 0, "CAN_COLLIDE"];
_unit03c = _grp03 createUnit ["O_soldier_AR_F", _grp03Pos getPos [3 + random 3, random 360], [], 0, "CAN_COLLIDE"];
_unit03d = _grp03 createUnit ["O_soldier_GL_F", _grp03Pos getPos [3 + random 3, random 360], [], 0, "CAN_COLLIDE"];
_unit03e = _grp03 createUnit ["O_soldier_F", _grp03Pos getPos [3 + random 3, random 360], [], 0, "CAN_COLLIDE"];
_unit03f = _grp03 createUnit ["O_HeavyGunner_F", _grp03Pos getPos [3 + random 3, random 360], [], 0, "CAN_COLLIDE"];
_grp03 enableDynamicSimulation true;
_grp03 deleteGroupWhenEmpty true;
_grp03 allowFleeing 0;
_allBaseUnit append [_unit03a,_unit03b,_unit03c,_unit03d,_unit03e,_unit03f];

//limit units equipment
{
	_x removePrimaryWeaponItem "acc_pointer_IR"; //remove IR pointer
	_x addPrimaryWeaponItem "acc_flashlight";  //add flashlight
	_x disableConversation true; //disable unit radio
	_x setSkill 0.4 + (random 0.2); //limit ability
} forEach _allBaseUnit;

//spawn flares
[_triggerPos, _allBaseUnit] spawn {
	_centerPos = _this select 0;
	_allBaseUnit = _this select 1;
	_unitsAlive = true;
	while {sleep (15 + random 20); _unitsAlive} do {
		for "_i" from 0 to (count _allBaseUnit) -1 do { //units loop
			_unit = _allBaseUnit select _i;
			if (alive _unit) then {_unit setUnitLoadout (configFile >> "CfgVehicles" >> typeOf _unit); //unit alive, refill ammo
			} else {_allBaseUnit set [_i, objNull];}; //replace unit by objNull
		};
		
		_allBaseUnit = _allBaseUnit arrayIntersect _allBaseUnit; //remove objNull from units array
		
		if !(sunOrMoon == 1) then { //moon time
			[_centerPos] remoteExec ["NNS_fnc_spawnFlare"]; //remoteexec flare
			sleep 25; //wait for the flare to die
		} else {sleep 60}; //long wait
		_tmpNearUnits = (_centerPos nearObjects ["Man", 70]) - allPlayers - agents; //detect man objects near position
		if ({alive _x} count _allBaseUnit == 0) then {_unitsAlive = false}; //no units alive, kill loop
	};
};

{ //lock barrack door
	_tmpname = (format["%1",_x] splitString " ."); //parse object node/name
	_tmpname = _tmpname select ((count _tmpname) - 2); //extract name without extension
	if (_tmpname == "i_barracks_v2_f") then { //wanted building
		for "_i" from 1 to 8 do {_x setVariable [format["bis_disabled_Door_%1", _i], 1, true];}; //lock wanted doors
	}
} foreach (nearestTerrainObjects [[7514,10561,0],[],10,false]);

//NNS : limit ammobox content
[northeastbase_ammo_0,0,0,true] call NNS_fnc_AmmoboxLimiter;
[northeastbase_ammo_1,0,0,true] call NNS_fnc_AmmoboxLimiter;
[northeastbase_ammo_2,0,0,true] call NNS_fnc_AmmoboxLimiter;
[northeastbase_ammo_3,0,0,true] call NNS_fnc_AmmoboxLimiter;
[northeastbase_ammo_4,0,0,true] call NNS_fnc_AmmoboxLimiter;

//NNS: Init zombie spawner
if (northeastbase_zombie_0 getVariable ["TotalAmount",-1] != -1) then {[] spawn {[northeastbase_zombie_0] call RyanZM_fnc_rzfunctionspawn}};
