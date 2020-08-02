/*
Create sniper group and let it go after players
Do not limit their equipment and set high skill
*/

// Params
params
[
	["_axisX",0,[999]], // X axis
	["_axisY",0,[999]] // Y axis
];

private _sniper =
[
	["srifle_GM6_F","","","optic_dms",["5Rnd_127x108_Mag",5],[],""],
	[],
	["hgun_Pistol_heavy_02_F","","","",["6Rnd_45ACP_Cylinder",6],[],""],
	["U_O_T_Sniper_F",[["FirstAidKit",1],["SmokeShellRed",2,1],["6Rnd_45ACP_Cylinder",3,6]]],
	["V_BandollierB_ghex_F",[["5Rnd_127x108_Mag",5,5]]],
	[],
	"",
	"",
	[],
	["ItemMap","ItemGPS","ItemRadio","ItemCompass","ItemWatch","O_NVGoggles_ghex_F"]
];

private _spotter =
[
	["arifle_CTAR_GL_blk_F","","acc_pointer_IR","optic_Arco_blk_F",["30Rnd_580x42_Mag_F",30],["1Rnd_HE_Grenade_shell",1],""],
	[],
	[],
	["U_O_T_Sniper_F",[["FirstAidKit",1],["SmokeShellRed",2,1]]],
	["V_Chestrig_rgr",[["30Rnd_580x42_Mag_F",7,30],["1Rnd_HE_Grenade_shell",5,1],["MiniGrenade",2,1]]],
	[],
	"",
	"",
	["Rangefinder","","","",[],[],""],
	["ItemMap","ItemGPS","ItemRadio","ItemCompass","ItemWatch","O_NVGoggles_ghex_F"]
];

_newGrp = createGroup east;

// Sniper
_unit01 = _newGrp createUnit ["O_T_ghillie_tna_F", [_axisX,_axisY,0], [], 0, "CAN_COLLIDE"];
_unit01 setPosASL [_axisX,_axisY,0];
_unit01 setSkill 0.6;
_unit01 setSkill ["AimingAccuracy",0.25];
_unit01 setUnitLoadout _sniper;

// Spotter
_unit02 = _newGrp createUnit ["O_T_Spotter_F", [_axisX + 1,_axisY,0], [], 0, "CAN_COLLIDE"];
_unit02 setPosASL [_axisX + 1,_axisY,0];
_unit02 setSkill 0.5;
_unit02 setSkill ["AimingAccuracy",0.2];
_unit02 setUnitLoadout _spotter;

// Enable Dynamic simulation
_newGrp enableDynamicSimulation true;

// If it's night, use NVS scopes instead
if !((dayTime > 6.5) and (dayTime < 18.125)) then {
	{_x setUnitLoadout [[nil,nil,nil,"optic_nvs",nil,nil,nil],nil,nil,nil,nil,nil,nil,nil,nil,nil]} forEach (units _newGrp);
};

sleep (30 + (random 30));

// Stalk players
waitUntil {sleep 5; simulationEnabled (leader _newGrp)};

_stalk = [_newGrp,group (allPlayers select 0)] spawn BIS_fnc_stalk;
{_x disableAI "Autocombat"} forEach (units _newGrp);
_newGrp setBehaviour "Stealth";
_newGrp setCombatMode "Red";
/*
waitUntil {sleep 5; {(_x distance leader _newGrp) < (1500)} count allPlayers == 0};
{deleteVehicle _x} forEach (units _newGrp);
deleteGroup _newGrp;
*/
