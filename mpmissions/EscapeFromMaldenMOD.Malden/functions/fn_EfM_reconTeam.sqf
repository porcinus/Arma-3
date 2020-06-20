/*
Create recon team and let it go after players
Do not limit their equipment and set high skill
*/

// Params
params
[
	["_axisX",0,[999]], // X axis
	["_axisY",0,[999]] // Y axis
];

private _leader =
[
	["arifle_MX_F","muzzle_snds_H","acc_pointer_IR","optic_Hamr",["30Rnd_65x39_caseless_mag",30],[],""],
	[],
	["hgun_Pistol_heavy_01_F","muzzle_snds_acp","","optic_MRD",["11Rnd_45ACP_Mag",11],[],""],
	["U_B_CombatUniform_mcam_vest",[["FirstAidKit",1],["SmokeShellBlue",2,1],["11Rnd_45ACP_Mag",3,11]]],
	["V_TacVest_oli",[["30Rnd_65x39_caseless_mag",7,30],["MiniGrenade",2,1]]],
	[],
	"H_Booniehat_mcamo",
	"",
	["Rangefinder","","","",[],[],""],
	["ItemMap","ItemGPS","ItemRadio","ItemCompass","ItemWatch","NVGogglesB_blk_F"] //NNS : NVG II
];

private _marksman =
[
	["arifle_MXM_F","muzzle_snds_H","acc_pointer_IR","optic_LRPS",["30Rnd_65x39_caseless_mag",30],[],"bipod_01_F_blk"],
	[],
	["hgun_Pistol_heavy_01_F","muzzle_snds_acp","","optic_MRD",["11Rnd_45ACP_Mag",11],[],""],
	["U_B_CombatUniform_mcam_vest",[["FirstAidKit",1],["SmokeShellBlue",2,1],["11Rnd_45ACP_Mag",3,11]]],
	["V_TacVest_oli",[["30Rnd_65x39_caseless_mag",7,30],["MiniGrenade",2,1]]],
	[],
	"H_Booniehat_mcamo",
	"",
	[],
	["ItemMap","","ItemRadio","ItemCompass","ItemWatch","NVGogglesB_blk_F"] //NNS : NVG II
];

private _paramedic =
[
	["arifle_MXC_F","muzzle_snds_H","acc_pointer_IR","optic_Aco",["30Rnd_65x39_caseless_mag",30],[],""],
	[],
	["hgun_Pistol_heavy_01_F","muzzle_snds_acp","","optic_MRD",["11Rnd_45ACP_Mag",11],[],""],
	["U_B_CombatUniform_mcam_vest",[["FirstAidKit",1],["SmokeShellBlue",2,1],["11Rnd_45ACP_Mag",3,11]]],
	["V_TacVest_oli",[["30Rnd_65x39_caseless_mag",7,30]]],
	["B_AssaultPack_rgr",[["Medikit",1],["FirstAidKit",5]]],
	"H_HelmetB_light_snakeskin",
	"",
	[],
	["ItemMap","","ItemRadio","ItemCompass","ItemWatch","NVGogglesB_blk_F"] //NNS : NVG II
];

private _scout =
[
	["arifle_MX_F","muzzle_snds_H","acc_pointer_IR","optic_Hamr",["30Rnd_65x39_caseless_mag",30],[],""],
	[],
	["hgun_Pistol_heavy_01_F","muzzle_snds_acp","","optic_MRD",["11Rnd_45ACP_Mag",11],[],""],
	["U_B_CombatUniform_mcam_vest",[["FirstAidKit",1],["SmokeShellBlue",2,1],["11Rnd_45ACP_Mag",3,11]]],
	["V_TacVest_oli",[["30Rnd_65x39_caseless_mag",7,30],["MiniGrenade",2,1]]],
	[],
	"H_HelmetB_light_snakeskin",
	"",
	[],
	["ItemMap","","ItemRadio","ItemCompass","ItemWatch","NVGogglesB_blk_F"] //NNS : NVG II
];

_newGrp = createGroup west;

// Team leader
_unit01 = _newGrp createUnit ["B_recon_TL_F", [_axisX,_axisY,0], [], 0, "CAN_COLLIDE"];
_unit01 setPosASL [_axisX,_axisY,0];
//_unit01 setSkill 0.75;
//_unit01 setSkill ["AimingAccuracy",0.5];
_unit01 setUnitLoadout _leader;

// Marksman
_unit02 = _newGrp createUnit ["B_recon_M_F", [_axisX + 1,_axisY,0], [], 0, "CAN_COLLIDE"];
_unit02 setPosASL [_axisX + 1,_axisY,0];
//_unit02 setSkill 0.5;
//_unit02 setSkill ["AimingAccuracy",0.5];
_unit02 setUnitLoadout _marksman;

// Paramedic
_unit03 = _newGrp createUnit ["B_recon_medic_F", [_axisX + 2,_axisY,0], [], 0, "CAN_COLLIDE"];
_unit03 setPosASL [_axisX + 1,_axisY,0];
//_unit03 setSkill 0.5;
//_unit03 setSkill ["AimingAccuracy",0.5];
_unit03 setUnitLoadout _paramedic;

// Scout
_unit04 = _newGrp createUnit ["B_recon_F", [_axisX + 3,_axisY,0], [], 0, "CAN_COLLIDE"];
_unit04 setPosASL [_axisX + 1,_axisY,0];
//_unit04 setSkill 0.5;
//_unit04 setSkill ["AimingAccuracy",0.5];
_unit04 setUnitLoadout _scout;

{[_x,"specops"] call BIS_fnc_NNS_AIskill;} forEach (units _newGrp);



// Enable Dynamic simulation
_newGrp enableDynamicSimulation true;

// If it's night, use NVS scopes instead
if !((dayTime > 4.5) and (dayTime < 20)) then {
	{_x setUnitLoadout [[nil,nil,nil,"optic_Nightstalker",nil,nil,nil],nil,nil,nil,nil,nil,nil,nil,nil,nil]} forEach (units _newGrp); //NNS : night stalker
};

//sleep (30 + (random 30));

// Stalk players
waitUntil {sleep 5; simulationEnabled (leader _newGrp)};

_stalk = [_newGrp,group (allPlayers select 0)] spawn BIS_fnc_stalk;
{_x disableAI "Autocombat"} forEach (units _newGrp);
_newGrp setBehaviour "Stealth";
_newGrp setCombatMode "Red";

 //NNS : return group
_newGrp