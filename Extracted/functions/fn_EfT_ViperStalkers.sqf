/*
Create Viper group and let it stalk players, use custom loadouts (no TI helmets) and do not use the limitXY functions on them
*/

// Params
params
[
	["_axisX",0,[999]], // X axis
	["_axisY",0,[999]] // Y axis
];

private _leaderLoadout =
[
	["arifle_ARX_blk_F","","acc_pointer_IR","optic_Arco_blk_F",["30Rnd_65x39_caseless_green",30],["10Rnd_50BW_Mag_F",10],""],
	[],
	[],
	["U_O_V_Soldier_Viper_F",[["FirstAidKit",1],["SmokeShellOrange",2,1]]],
	[],
	["B_ViperHarness_blk_F",[["30Rnd_65x39_caseless_green",9,30],["10Rnd_50BW_Mag_F",3,10],["MiniGrenade",2,1]]],
	"",
	"G_Balaclava_TI_blk_F",
	["Rangefinder","","","",[],[],""],
	["ItemMap","ItemGPS","ItemRadio","ItemCompass","ItemWatch","O_NVGoggles_ghex_F"]
];

private _marksmanLoadout =
[
	["arifle_ARX_blk_F","","acc_pointer_IR","optic_dms",["30Rnd_65x39_caseless_green",30],["10Rnd_50BW_Mag_F",10],"bipod_02_F_blk"],
	[],
	[],
	["U_O_V_Soldier_Viper_F",[["FirstAidKit",1],["SmokeShellOrange",2,1]]],
	[],
	["B_ViperHarness_blk_F",[["30Rnd_65x39_caseless_green",9,30],["10Rnd_50BW_Mag_F",3,10],["MiniGrenade",2,1]]],
	"",
	"G_Balaclava_TI_blk_F",
	[],
	["ItemMap","","ItemRadio","ItemCompass","ItemWatch","O_NVGoggles_ghex_F"]
];

private _medicLoadout =
[
	["arifle_ARX_blk_F","","acc_pointer_IR","optic_Arco_blk_F",["30Rnd_65x39_caseless_green",30],["10Rnd_50BW_Mag_F",10],""],
	[],
	[],
	["U_O_V_Soldier_Viper_F",[["FirstAidKit",1],["SmokeShellOrange",2,1]]],
	[],
	["B_ViperHarness_blk_F",[["30Rnd_65x39_caseless_green",9,30],["10Rnd_50BW_Mag_F",3,10],["MiniGrenade",2,1],["Medikit",1]]],
	"",
	"G_Balaclava_TI_blk_F",
	[],
	["ItemMap","","ItemRadio","ItemCompass","ItemWatch","O_NVGoggles_ghex_F"]
];

private _ATLoadout =
[
	["arifle_ARX_blk_F","","acc_pointer_IR","optic_Arco_blk_F",["30Rnd_65x39_caseless_green",30],["10Rnd_50BW_Mag_F",10],""],
	["launch_RPG32_ghex_F","","","",["RPG32_F",1],[],""],
	[],
	["U_O_V_Soldier_Viper_F",[["FirstAidKit",1],["SmokeShellOrange",2,1]]],
	[],
	["B_ViperHarness_blk_F",[["30Rnd_65x39_caseless_green",7,30],["10Rnd_50BW_Mag_F",3,10],["MiniGrenade",2,1],["RPG32_F",2,1]]],
	"",
	"G_Balaclava_TI_blk_F",
	[],
	["ItemMap","ItemGPS","ItemRadio","ItemCompass","ItemWatch","O_NVGoggles_ghex_F"]
];

_newGrp = createGroup east;

// Team leader
_unit01 = _newGrp createUnit ["O_V_Soldier_TL_ghex_F", [_axisX,_axisY,0], [], 0, "CAN_COLLIDE"];
_unit01 setPosASL [_axisX,_axisY,0];
_unit01 setUnitLoadout _leaderLoadout;

// Marksman
_unit02 = _newGrp createUnit ["O_V_Soldier_M_ghex_F", [_axisX + 1,_axisY,0], [], 0, "CAN_COLLIDE"];
_unit02 setPosASL [_axisX + 1,_axisY,0];
_unit02 setUnitLoadout _marksmanLoadout;

// Paramedic
_unit03 = _newGrp createUnit ["O_V_Soldier_Medic_ghex_F", [_axisX - 1,_axisY,0], [], 0, "CAN_COLLIDE"];
_unit03 setPosASL [_axisX - 1,_axisY,0];
_unit03 setUnitLoadout _medicLoadout;

// AT rifleman
_unit04 = _newGrp createUnit ["O_V_Soldier_LAT_ghex_F", [_axisX + 2,_axisY,0], [], 0, "CAN_COLLIDE"];
_unit04 setPosASL [_axisX + 2,_axisY,0];
_unit04 setUnitLoadout _ATLoadout;

// Enable Dynamic simulation
_newGrp enableDynamicSimulation true;

// Set skill
{_x setSkill ["General",0.5], _x setSkill ["AimingAccuracy",0.2]} forEach (units _newGrp);

// If it's night, use NVS scopes instead
if !((dayTime > 6.5) and (dayTime < 18.125)) then {
	{_x setUnitLoadout [[nil,nil,nil,"optic_nvs",nil,nil,nil],nil,nil,nil,nil,nil,nil,nil,nil,nil]} forEach (units _newGrp);
};

sleep (30 + (random 30));

// Stalk players
waitUntil {sleep 5; simulationEnabled (leader _newGrp)};

_stalk = [_newGrp,group (allPlayers select 0)] spawn BIS_fnc_stalk;
/*
waitUntil {sleep 5; {(_x distance leader _newGrp) < (1500)} count allPlayers == 0};
{deleteVehicle _x} forEach (units _newGrp);
deleteGroup _newGrp;
*/
