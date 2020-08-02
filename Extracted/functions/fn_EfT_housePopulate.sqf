/*
Populate houses (based on type) with Syndikat troops. Houses are selected in fn_EfT_housesFind.sqf

Example: _null = this call BIS_fnc_EfT_populateHouse;
*/

// Params
params
[
	["_house",objNull,[objNull]]	// house

];

switch (typeOf _house) do {
	case "Land_Shop_City_07_F": {

		// 1st pair
		_grp01 = createGroup resistance;
		_dir01 = ((getDir _house) + 90);
		_grp01 setFormDir _dir01;

		_pos01a = (AGLToASL (_house buildingPos 2));
		_pos01b = (AGLToASL (_house buildingPos 4));

		_unit01a = _grp01 createUnit [selectRandom ["I_C_Soldier_Para_7_F","I_C_Soldier_Bandit_6_F"], _pos01a, [], _dir01, "CAN_COLLIDE"];
		_unit01a setPosASL _pos01a;
		_unit01b = _grp01 createUnit [selectRandom ["I_C_Soldier_Para_4_F","I_C_Soldier_Bandit_4_F"], _pos01b, [], _dir01, "CAN_COLLIDE"];
		_unit01b setPosASL _pos01b;

		{_x setUnitPos "Up"; _x disableAI "Path"; _x setDir _dir01} forEach (units _grp01);
		{_x setSkill ["AimingAccuracy",0.1]} forEach (units _grp01);
		if (missionNamespace getVariable "BIS_enemyEquipment" == 1) then {{_null = _x execVM "Scripts\LimitEquipment.sqf"} forEach (units _grp01)};

		// 2nd pair
		_grp02 = createGroup resistance;
		_dir02 = ((getDir _house) - 90);
		_grp02 setFormDir _dir02;

		_pos02a = (AGLToASL (_house buildingPos 6));
		_pos02b = (AGLToASL (_house buildingPos 7));

		_unit02a = _grp02 createUnit [selectRandom ["I_C_Soldier_Para_6_F","I_C_Soldier_Bandit_7_F"], _pos02a, [], _dir02, "CAN_COLLIDE"];
		_unit02a setPosASL _pos02a;
		_unit02b = _grp02 createUnit [selectRandom ["I_C_Soldier_Para_5_F","I_C_Soldier_Bandit_5_F"], _pos02b, [], _dir02, "CAN_COLLIDE"];
		_unit02b setPosASL _pos02b;

		{_x setUnitPos "Up"; _x disableAI "Path"; _x setDir _dir02} forEach (units _grp02);
		{_x setSkill ["AimingAccuracy",0.1]} forEach (units _grp02);
		if (missionNamespace getVariable "BIS_enemyEquipment" == 1) then {{_null = _x execVM "Scripts\LimitEquipment.sqf"} forEach (units _grp02)};
/*
		// delete if too far away
		_null = _grp01 spawn {
			waitUntil {sleep 5; {(_x distance2d (leader _this)) < (1500)} count allPlayers == 0};
			{deleteVehicle _x} forEach (units _this);
			deleteGroup _this;
		};

		_null = _grp02 spawn {
			waitUntil {sleep 5; {(_x distance2d (leader _this)) < (1500)} count allPlayers == 0};
			{deleteVehicle _x} forEach (units _this);
			deleteGroup _this;
		};
*/

		// Enable Dynamic simulation
		_grp01 enableDynamicSimulation true;
		_grp02 enableDynamicSimulation true;

	};

	case "Land_Shop_City_04_F": {

		// 1st pair
		_grp01 = createGroup resistance;
		_dir01 = ((getDir _house) + 180);
		_grp01 setFormDir _dir01;

		_pos01a = (AGLToASL (_house buildingPos 15));
		_pos01b = (AGLToASL (_house buildingPos 23));

		_unit01a = _grp01 createUnit [selectRandom ["I_C_Soldier_Para_7_F","I_C_Soldier_Bandit_6_F"], _pos01a, [], _dir01, "CAN_COLLIDE"];
		_unit01a setPosASL _pos01a;
		_unit01b = _grp01 createUnit [selectRandom ["I_C_Soldier_Para_4_F","I_C_Soldier_Bandit_4_F"], _pos01b, [], _dir01, "CAN_COLLIDE"];
		_unit01b setPosASL _pos01b;

		{_x setUnitPos "Up"; _x disableAI "Path"; _x setDir _dir01} forEach (units _grp01);
		{_x setSkill ["AimingAccuracy",0.1]} forEach (units _grp01);
		if (missionNamespace getVariable "BIS_enemyEquipment" == 1) then {{_null = _x execVM "Scripts\LimitEquipment.sqf"} forEach (units _grp01)};

		// 2nd pair
		_grp02 = createGroup resistance;
		_dir02 = ((getDir _house) + 90);
		_grp02 setFormDir _dir02;

		_pos02a = (AGLToASL (_house buildingPos 21));
		_pos02b = (AGLToASL (_house buildingPos 12));

		_unit02a = _grp02 createUnit [selectRandom ["I_C_Soldier_Para_6_F","I_C_Soldier_Bandit_7_F"], _pos02a, [], _dir02, "CAN_COLLIDE"];
		_unit02a setPosASL _pos02a;
		_unit02b = _grp02 createUnit [selectRandom ["I_C_Soldier_Para_5_F","I_C_Soldier_Bandit_5_F"], _pos02b, [], _dir02, "CAN_COLLIDE"];
		_unit02b setPosASL _pos02b;

		{_x setUnitPos "Up"; _x disableAI "Path"; _x setDir _dir02} forEach (units _grp02);
		{_x setSkill ["AimingAccuracy",0.1]} forEach (units _grp02);
		if (missionNamespace getVariable "BIS_enemyEquipment" == 1) then {{_null = _x execVM "Scripts\LimitEquipment.sqf"} forEach (units _grp02)};
/*
		// delete if too far away
		_null = _grp01 spawn {
			waitUntil {sleep 5; {(_x distance2d (leader _this)) < (1500)} count allPlayers == 0};
			{deleteVehicle _x} forEach (units _this);
			deleteGroup _this;
		};

		_null = _grp02 spawn {
			waitUntil {sleep 5; {(_x distance2d (leader _this)) < (1500)} count allPlayers == 0};
			{deleteVehicle _x} forEach (units _this);
			deleteGroup _this;
		};
*/

		// Enable Dynamic simulation
		_grp01 enableDynamicSimulation true;
		_grp02 enableDynamicSimulation true;

	};

	case "Land_Addon_04_F": {

		// 1st pair
		_grp01 = createGroup resistance;
		_dir01 = ((getDir _house) + 90);
		_grp01 setFormDir _dir01;

		_pos01a = (AGLToASL (_house buildingPos 12));
		_pos01b = (AGLToASL (_house buildingPos 10));

		_unit01a = _grp01 createUnit [selectRandom ["I_C_Soldier_Para_7_F","I_C_Soldier_Bandit_6_F"], _pos01a, [], _dir01, "CAN_COLLIDE"];
		_unit01a setPosASL _pos01a;
		_unit01b = _grp01 createUnit [selectRandom ["I_C_Soldier_Para_4_F","I_C_Soldier_Bandit_4_F"], _pos01b, [], _dir01, "CAN_COLLIDE"];
		_unit01b setPosASL _pos01b;

		{_x setUnitPos "Up"; _x disableAI "Path"; _x setDir _dir01} forEach (units _grp01);
		{_x setSkill ["AimingAccuracy",0.1]} forEach (units _grp01);
		if (missionNamespace getVariable "BIS_enemyEquipment" == 1) then {{_null = _x execVM "Scripts\LimitEquipment.sqf"} forEach (units _grp01)};

		// 2nd pair
		_grp02 = createGroup resistance;
		_dir02 = (getDir _house);
		_grp02 setFormDir _dir02;

		_pos02a = (AGLToASL (_house buildingPos 13));
		_pos02b = (AGLToASL (_house buildingPos 15));

		_unit02a = _grp02 createUnit [selectRandom ["I_C_Soldier_Para_6_F","I_C_Soldier_Bandit_7_F"], _pos02a, [], _dir02, "CAN_COLLIDE"];
		_unit02a setPosASL _pos02a;
		_unit02b = _grp02 createUnit [selectRandom ["I_C_Soldier_Para_5_F","I_C_Soldier_Bandit_5_F"], _pos02b, [], _dir02, "CAN_COLLIDE"];
		_unit02b setPosASL _pos02b;

		{_x setUnitPos "Up"; _x disableAI "Path"; _x setDir _dir02} forEach (units _grp02);
		{_x setSkill ["AimingAccuracy",0.1]} forEach (units _grp02);
		if (missionNamespace getVariable "BIS_enemyEquipment" == 1) then {{_null = _x execVM "Scripts\LimitEquipment.sqf"} forEach (units _grp02)};
/*
		// delete if too far away
		_null = _grp01 spawn {
			waitUntil {sleep 5; {(_x distance2d (leader _this)) < (1500)} count allPlayers == 0};
			{deleteVehicle _x} forEach (units _this);
			deleteGroup _this;
		};

		_null = _grp02 spawn {
			waitUntil {sleep 5; {(_x distance2d (leader _this)) < (1500)} count allPlayers == 0};
			{deleteVehicle _x} forEach (units _this);
			deleteGroup _this;
		};
*/

		// Enable Dynamic simulation
		_grp01 enableDynamicSimulation true;
		_grp02 enableDynamicSimulation true;

	};

	case "Land_House_Big_03_F": {

		// 1st pair
		_grp01 = createGroup resistance;
		_dir01 = (getDir _house);
		_grp01 setFormDir _dir01;

		_pos01a = (AGLToASL (_house buildingPos 8));
		_pos01b = (AGLToASL (_house buildingPos 13));

		_unit01a = _grp01 createUnit [selectRandom ["I_C_Soldier_Para_7_F","I_C_Soldier_Bandit_6_F"], _pos01a, [], _dir01, "CAN_COLLIDE"];
		_unit01a setPosASL _pos01a;
		_unit01b = _grp01 createUnit [selectRandom ["I_C_Soldier_Para_4_F","I_C_Soldier_Bandit_4_F"], _pos01b, [], _dir01, "CAN_COLLIDE"];
		_unit01b setPosASL _pos01b;

		{_x setUnitPos "Up"; _x disableAI "Path"; _x setDir _dir01} forEach (units _grp01);
		{_x setSkill ["AimingAccuracy",0.1]} forEach (units _grp01);
		if (missionNamespace getVariable "BIS_enemyEquipment" == 1) then {{_null = _x execVM "Scripts\LimitEquipment.sqf"} forEach (units _grp01)};

		// 2nd pair
		_grp02 = createGroup resistance;
		_dir02 = ((getDir _house) + 180);
		_grp02 setFormDir _dir02;

		_pos02a = (AGLToASL (_house buildingPos 7));
		_pos02b = (AGLToASL (_house buildingPos 12));

		_unit02a = _grp02 createUnit [selectRandom ["I_C_Soldier_Para_6_F","I_C_Soldier_Bandit_7_F"], _pos02a, [], _dir02, "CAN_COLLIDE"];
		_unit02a setPosASL _pos02a;
		_unit02b = _grp02 createUnit [selectRandom ["I_C_Soldier_Para_5_F","I_C_Soldier_Bandit_5_F"], _pos02b, [], _dir02, "CAN_COLLIDE"];
		_unit02b setPosASL _pos02b;

		{_x setUnitPos "Up"; _x disableAI "Path"; _x setDir _dir02} forEach (units _grp02);
		{_x setSkill ["AimingAccuracy",0.1]} forEach (units _grp02);
		if (missionNamespace getVariable "BIS_enemyEquipment" == 1) then {{_null = _x execVM "Scripts\LimitEquipment.sqf"} forEach (units _grp02)};
/*
		// delete if too far away
		_null = _grp01 spawn {
			waitUntil {sleep 5; {(_x distance2d (leader _this)) < (1500)} count allPlayers == 0};
			{deleteVehicle _x} forEach (units _this);
			deleteGroup _this;
		};

		_null = _grp02 spawn {
			waitUntil {sleep 5; {(_x distance2d (leader _this)) < (1500)} count allPlayers == 0};
			{deleteVehicle _x} forEach (units _this);
			deleteGroup _this;
		};
*/

		// Enable Dynamic simulation
		_grp01 enableDynamicSimulation true;
		_grp02 enableDynamicSimulation true;

	};

	case "Land_Hotel_01_F": {

		// 1st pair
		_grp01 = createGroup resistance;
		_dir01 = ((getDir _house) + 180);
		_grp01 setFormDir _dir01;

		_pos01a = (AGLToASL (_house buildingPos 12));
		_pos01b = (AGLToASL (_house buildingPos 5));

		_unit01a = _grp01 createUnit [selectRandom ["I_C_Soldier_Para_7_F","I_C_Soldier_Bandit_6_F"], _pos01a, [], _dir01, "CAN_COLLIDE"];
		_unit01a setPosASL _pos01a;
		_unit01b = _grp01 createUnit [selectRandom ["I_C_Soldier_Para_4_F","I_C_Soldier_Bandit_4_F"], _pos01b, [], _dir01, "CAN_COLLIDE"];
		_unit01b setPosASL _pos01b;

		{_x setUnitPos "Up"; _x disableAI "Path"; _x setDir _dir01} forEach (units _grp01);
		{_x setSkill ["AimingAccuracy",0.1]} forEach (units _grp01);
		if (missionNamespace getVariable "BIS_enemyEquipment" == 1) then {{_null = _x execVM "Scripts\LimitEquipment.sqf"} forEach (units _grp01)};

		// 2nd pair
		_grp02 = createGroup resistance;
		_dir02 = (getDir _house);
		_grp02 setFormDir _dir02;

		_pos02a = (AGLToASL (_house buildingPos 9));
		_pos02b = (AGLToASL (_house buildingPos 1));

		_unit02a = _grp02 createUnit [selectRandom ["I_C_Soldier_Para_6_F","I_C_Soldier_Bandit_7_F"], _pos02a, [], _dir02, "CAN_COLLIDE"];
		_unit02a setPosASL _pos02a;
		_unit02b = _grp02 createUnit [selectRandom ["I_C_Soldier_Para_5_F","I_C_Soldier_Bandit_5_F"], _pos02b, [], _dir02, "CAN_COLLIDE"];
		_unit02b setPosASL _pos02b;

		{_x setUnitPos "Up"; _x disableAI "Path"; _x setDir _dir02} forEach (units _grp02);
		{_x setSkill ["AimingAccuracy",0.1]} forEach (units _grp02);
		if (missionNamespace getVariable "BIS_enemyEquipment" == 1) then {{_null = _x execVM "Scripts\LimitEquipment.sqf"} forEach (units _grp02)};
/*
		// delete if too far away
		_null = _grp01 spawn {
			waitUntil {sleep 5; {(_x distance2d (leader _this)) < (1500)} count allPlayers == 0};
			{deleteVehicle _x} forEach (units _this);
			deleteGroup _this;
		};

		_null = _grp02 spawn {
			waitUntil {sleep 5; {(_x distance2d (leader _this)) < (1500)} count allPlayers == 0};
			{deleteVehicle _x} forEach (units _this);
			deleteGroup _this;
		};
*/

		// Enable Dynamic simulation
		_grp01 enableDynamicSimulation true;
		_grp02 enableDynamicSimulation true;

	};

	case "Land_House_Big_04_F": {

		// 1st pair
		_grp01 = createGroup resistance;
		_dir01 = ((getDir _house) - 90);
		_grp01 setFormDir _dir01;

		_pos01a = (AGLToASL (_house buildingPos 10));
		_pos01b = (AGLToASL (_house buildingPos 9));

		_unit01a = _grp01 createUnit [selectRandom ["I_C_Soldier_Para_7_F","I_C_Soldier_Bandit_6_F"], _pos01a, [], _dir01, "CAN_COLLIDE"];
		_unit01a setPosASL _pos01a;
		_unit01b = _grp01 createUnit [selectRandom ["I_C_Soldier_Para_4_F","I_C_Soldier_Bandit_4_F"], _pos01b, [], _dir01, "CAN_COLLIDE"];
		_unit01b setPosASL _pos01b;

		{_x setUnitPos "Up"; _x disableAI "Path"; _x setDir _dir01} forEach (units _grp01);
		{_x setSkill ["AimingAccuracy",0.1]} forEach (units _grp01);
		if (missionNamespace getVariable "BIS_enemyEquipment" == 1) then {{_null = _x execVM "Scripts\LimitEquipment.sqf"} forEach (units _grp01)};

		// 2nd pair
		_grp02 = createGroup resistance;
		_dir02 = ((getDir _house) + 180);
		_grp02 setFormDir _dir02;

		_pos02a = (AGLToASL (_house buildingPos 7));
		_pos02b = (AGLToASL (_house buildingPos 5));

		_unit02a = _grp02 createUnit [selectRandom ["I_C_Soldier_Para_6_F","I_C_Soldier_Bandit_7_F"], _pos02a, [], _dir02, "CAN_COLLIDE"];
		_unit02a setPosASL _pos02a;
		_unit02b = _grp02 createUnit [selectRandom ["I_C_Soldier_Para_5_F","I_C_Soldier_Bandit_5_F"], _pos02b, [], _dir02, "CAN_COLLIDE"];
		_unit02b setPosASL _pos02b;

		{_x setUnitPos "Up"; _x disableAI "Path"; _x setDir _dir02} forEach (units _grp02);
		{_x setSkill ["AimingAccuracy",0.1]} forEach (units _grp02);
		if (missionNamespace getVariable "BIS_enemyEquipment" == 1) then {{_null = _x execVM "Scripts\LimitEquipment.sqf"} forEach (units _grp02)};
/*
		// delete if too far away
		_null = _grp01 spawn {
			waitUntil {sleep 5; {(_x distance2d (leader _this)) < (1500)} count allPlayers == 0};
			{deleteVehicle _x} forEach (units _this);
			deleteGroup _this;
		};

		_null = _grp02 spawn {
			waitUntil {sleep 5; {(_x distance2d (leader _this)) < (1500)} count allPlayers == 0};
			{deleteVehicle _x} forEach (units _this);
			deleteGroup _this;
		};
*/

		// Enable Dynamic simulation
		_grp01 enableDynamicSimulation true;
		_grp02 enableDynamicSimulation true;

	};
};
