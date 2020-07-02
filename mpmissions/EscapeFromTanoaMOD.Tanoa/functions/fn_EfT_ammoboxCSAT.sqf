// Custom content for CSAT ammo+supply box

// Params
params
[
	["_box",objNull,[objNull]]	// ammobox
];

{clearMagazineCargoGlobal _x, clearWeaponCargoGlobal _x, clearItemCargoGlobal _x, clearBackpackCargoGlobal _x} forEach [_box];

// WEAPON ITEMS

// Optics
_box addItemCargoGlobal ["optic_aco_grn",4 + (round random 2)];
_box addItemCargoGlobal ["optic_arco_blk_F",2 + (round random 1)];
_box addItemCargoGlobal ["optic_dms",(round random 1.5)];
_box addItemCargoGlobal ["optic_nvs",(round random 1.5)];

// Laser pointers
_box addItemCargoGlobal ["acc_pointer_IR",2 + (round random 4)];

// Suppressors
_box addItemCargoGlobal ["muzzle_snds_58_blk_F",1 + (round random 2)];
_box addItemCargoGlobal ["muzzle_snds_65_TI_blk_F",(round random 1.5)];

// WEAPONS
_box addWeaponCargoGlobal ["arifle_CTAR_blk_F",2 + (round random 2)];
_box addWeaponCargoGlobal ["arifle_CTAR_GL_blk_F",1 + (round random 1.5)];
_box addWeaponCargoGlobal ["arifle_CTARS_blk_F",1 + (round random 1.5)];
_box addWeaponCargoGlobal ["srifle_DMR_07_blk_F",1];

// AMMO

// 5.8 mm, tracer/non-tracer
if (random 100 < 50) then {_box addMagazineCargoGlobal ["30Rnd_580x42_Mag_F",12 + (round random 6)]} else {_box addMagazineCargoGlobal ["30Rnd_580x42_Mag_Tracer_F",12 + (round random 6)]};
if (random 100 < 50) then {_box addMagazineCargoGlobal ["100Rnd_580x42_Mag_F",5 + (round random 5)]} else {_box addMagazineCargoGlobal ["100Rnd_580x42_Mag_Tracer_F",5 + (round random 5)]};

// 6.5 mm
_box addMagazineCargoGlobal ["20Rnd_650x39_Cased_Mag_F",6 + (round random 4)];

// 40mm UGLs
_box addMagazineCargoGlobal ["1Rnd_HE_Grenade_shell",8 + (round random 4)];

// Smoke shells
_box addMagazineCargoGlobal ["SmokeShell",4 + (round random 4)];

// Grenades
_box addMagazineCargoGlobal ["HandGrenade",4 + (round random 4)];
_box addMagazineCargoGlobal ["MiniGrenade",4 + (round random 4)];

// Explosive satchel
_box addMagazineCargoGlobal ["SatchelCharge_Remote_Mag",2 + (round random 2)];

// GM6 Lynx
if (random 100 < 35) then {_box addMagazineCargoGlobal ["5Rnd_127x108_APDS_Mag",4 + (round random 2)]; _box addWeaponCargoGlobal ["srifle_GM6_LRPS_F",1]};

// RPG-42
_box addMagazineCargoGlobal ["RPG32_F",2];
_box addMagazineCargoGlobal ["RPG32_HE_F",2];
_box addWeaponCargoGlobal ["launch_RPG32_ghex_F",1];

// Titan AA
//if (random 100 < 50) then {
	_box addMagazineCargoGlobal ["Titan_AA",2];
	_box addWeaponCargoGlobal ["launch_O_Titan_ghex_F",1];
	_box addBackpackCargoGlobal ["B_Fieldpack_ghex_F",1];
//};

// FAKs
_box addItemCargoGlobal ["FirstAidKit",4 + (round random 2)];

// Rangefinder
_box addItemCargoGlobal ["Rangefinder",(round random 1)];

// Backpacks
_box addBackpackCargoGlobal ["B_Fieldpack_ghex_F",1];
_box addBackpackCargoGlobal ["B_Carryall_ghex_F",(round random 1)];

// GPS
_box addItemCargoGlobal ["ItemGPS",1 + (round random 1)];

// Medikit
// _box addItemCargoGlobal ["Medikit",(round random 1)];

// Toolkit
// _box addItemCargoGlobal ["Toolkit",(round random 1)];

// Mine detector
// _box addItemCargoGlobal ["MineDetector",(round random 1)];

// NVGs
_box addItemCargoGlobal ["O_NVGoggles_ghex_F",2 + (round random 2)];

//Titan AT
_box addMagazineCargoGlobal ["Titan_AT",2];
_box addWeaponCargoGlobal ["launch_B_Titan_short_F",1];