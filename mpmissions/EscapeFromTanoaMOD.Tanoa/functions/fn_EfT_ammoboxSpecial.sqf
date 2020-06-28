// Custom content for 'Special' ammobox

// Params
params
[
	["_box",objNull,[objNull]] // ammobox
];

{clearMagazineCargoGlobal _x, clearWeaponCargoGlobal _x, clearItemCargoGlobal _x, clearBackpackCargoGlobal _x} forEach [_box];

// ITEMS
_box addItemCargoGlobal ["FirstAidKit",8 + (round random 4)];
_box addItemCargoGlobal ["Rangefinder",1];
_box addItemCargoGlobal ["O_NVGoggles_ghex_F",6 + (round random 2)];
_box addItemCargoGlobal ["ItemGPS",4 + (round random 2)];

// WEAPON ITEMS
_box addItemCargoGlobal ["bipod_02_F_blk",1 + (round random 1)];
_box addItemCargoGlobal ["optic_Arco_blk_F",4 + (round random 2)];
_box addItemCargoGlobal ["optic_dms",1];
_box addItemCargoGlobal ["optic_nvs",2 + (round random 1)];
_box addItemCargoGlobal ["acc_pointer_IR",4 + (round random 2)];
_box addItemCargoGlobal ["muzzle_snds_65_TI_blk_F",2 + (round random 1)];

// WEAPONS
_box addWeaponCargoGlobal ["arifle_ARX_blk_F",6 + (round random 2)];
_box addWeaponCargoGlobal ["launch_RPG32_ghex_F",1];
_box addWeaponCargoGlobal ["launch_O_Titan_short_ghex_F",1];

// AMMO
_box addMagazineCargoGlobal ["30Rnd_65x39_caseless_green",32 + (round random 8)];
_box addMagazineCargoGlobal ["10Rnd_50BW_Mag_F",12 + (round random 6)];
_box addMagazineCargoGlobal ["RPG32_F",3];
_box addMagazineCargoGlobal ["Titan_AT",1];
_box addMagazineCargoGlobal ["SmokeShell",8 + (round random 4)];
_box addMagazineCargoGlobal ["HandGrenade",8 + (round random 4)];
_box addMagazineCargoGlobal ["MiniGrenade",8 + (round random 4)];

//Titan AT
_box addMagazineCargoGlobal ["Titan_AT",2];
_box addWeaponCargoGlobal ["launch_B_Titan_short_F",1];