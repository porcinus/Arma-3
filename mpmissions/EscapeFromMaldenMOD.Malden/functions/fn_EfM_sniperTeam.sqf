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
	["srifle_LRR_F","","","optic_LRPS",["7Rnd_408_Mag",7],[],""],
	[],
	["hgun_Pistol_heavy_01_F","","","optic_MRD",["11Rnd_45ACP_Mag",11],[],""],
	["U_B_FullGhillie_sard",[["FirstAidKit",1],["SmokeShellBlue",2,1],["11Rnd_45ACP_Mag",3,11]]],
	["V_Chestrig_rgr",[["7Rnd_408_Mag",5,7]]],
	[],
	"",
	"",
	[],
	["ItemMap","","ItemRadio","ItemCompass","ItemWatch","NVGogglesB_blk_F"] //NNS : NVG II
];

private _spotter =
[
	["arifle_MXM_F","","acc_pointer_IR","optic_Hamr",["30Rnd_65x39_caseless_mag",30],[],"bipod_01_F_blk"],
	[],
	["hgun_Pistol_heavy_01_F","","","optic_MRD",["11Rnd_45ACP_Mag",11],[],""],
	["U_B_FullGhillie_sard",[["FirstAidKit",1],["SmokeShellBlue",2,1],["11Rnd_45ACP_Mag",3,11]]],
	["V_Chestrig_oli",[["30Rnd_65x39_caseless_mag",7,30],["MiniGrenade",2,1]]],
	[],
	"",
	"",
	["Rangefinder","","","",[],[],""],
	["ItemMap","ItemGPS","ItemRadio","ItemCompass","ItemWatch","NVGogglesB_blk_F"] //NNS : NVG II
];

_newGrp = createGroup west;

// Sniper
_unit01 = _newGrp createUnit ["B_ghillie_sard_F", [_axisX,_axisY,0], [], 0, "CAN_COLLIDE"];
_unit01 setPosASL [_axisX,_axisY,0];
//_unit01 setSkill 0.75;
//_unit01 setSkill ["AimingAccuracy",0.75];
_unit01 setUnitLoadout _sniper;

// Spotter
_unit02 = _newGrp createUnit ["B_Spotter_F", [_axisX + 1,_axisY,0], [], 0, "CAN_COLLIDE"];
_unit02 setPosASL [_axisX + 1,_axisY,0];
//_unit02 setSkill 0.75;
//_unit02 setSkill ["AimingAccuracy",0.75];
_unit02 setUnitLoadout _spotter;

{[_x,"sniper"] call BIS_fnc_NNS_AIskill;} forEach (units _newGrp);

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