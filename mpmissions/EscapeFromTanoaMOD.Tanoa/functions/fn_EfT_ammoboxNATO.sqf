// Custom content for NATO ammobox

// Params
params
[
	["_box",objNull,[objNull]] // ammobox
];

{clearMagazineCargoGlobal _x, clearWeaponCargoGlobal _x, clearItemCargoGlobal _x, clearBackpackCargoGlobal _x} forEach [_box];

// WEAPON ITEMS

// Bipods
_box addItemCargoGlobal ["bipod_01_F_blk",1 + (round random 1)];

// Optics
_box addItemCargoGlobal ["optic_aco",4 + (round random 2)];
_box addItemCargoGlobal ["optic_ERCO_blk_F",2 + (round random 1)];
_box addItemCargoGlobal ["optic_nvs",1 + (round random 1)];

// Laser pointers
_box addItemCargoGlobal ["acc_pointer_IR",2 + (round random 4)];

// Suppressors
_box addItemCargoGlobal ["muzzle_snds_M",1 +(round random 2)];
_box addItemCargoGlobal ["muzzle_snds_B",(round random 1)];

// WEAPONS
_box addWeaponCargoGlobal ["arifle_SPAR_01_khk_F",2 + (round random 2)];
_box addWeaponCargoGlobal ["arifle_SPAR_01_GL_khk_F",1 + (round random 1)];
_box addWeaponCargoGlobal ["arifle_SPAR_02_khk_F",1 + (round random 1)];
_box addWeaponCargoGlobal ["arifle_SPAR_03_khk_F",1];
_box addWeaponCargoGlobal ["srifle_LRR_LRPS_F",1];

// AMMO

// 5.56 mm, tracer/non-tracer
if (random 100 < 50) then {_box addMagazineCargoGlobal ["30Rnd_556x45_Stanag_red",24 + (round random 8)]} else {_box addMagazineCargoGlobal ["30Rnd_556x45_Stanag_Tracer_Red",24 + (round random 8)]};
if (random 100 < 50) then {_box addMagazineCargoGlobal ["150Rnd_556x45_Drum_Mag_F",6 + (round random 2)]} else {_box addMagazineCargoGlobal ["150Rnd_556x45_Drum_Mag_Tracer_F",6 + (round random 2)]};

// 7.62 mm
_box addMagazineCargoGlobal ["20Rnd_762x51_Mag",8 + (round random 4)];

// .408
_box addMagazineCargoGlobal ["7Rnd_408_Mag",6 + (round random 2)];

// 40mm UGLs
_box addMagazineCargoGlobal ["1Rnd_HE_Grenade_shell",8 + (round random 4)];

// Smoke shells
_box addMagazineCargoGlobal ["SmokeShell",4 + (round random 4)];

// Grenades
_box addMagazineCargoGlobal ["HandGrenade",4 + (round random 4)];
_box addMagazineCargoGlobal ["MiniGrenade",4 + (round random 4)];

// Explosive charges
_box addMagazineCargoGlobal ["DemoCharge_Remote_Mag",2 + (round random 2.5)];

//Titan AT
_box addMagazineCargoGlobal ["Titan_AT",2];
_box addWeaponCargoGlobal ["launch_B_Titan_short_F",1];

//Titan AA
_box addMagazineCargoGlobal ["Titan_AA",2];
_box addWeaponCargoGlobal ["launch_O_Titan_ghex_F",1];
_box addBackpackCargoGlobal ["B_Fieldpack_ghex_F",1];