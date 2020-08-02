// Custom content for 'Special' ammobox

// Params
params
[
	["_box",objNull,[objNull]] // ammobox
];

{clearMagazineCargoGlobal _x, clearWeaponCargoGlobal _x, clearItemCargoGlobal _x, clearBackpackCargoGlobal _x} forEach [_box];

// ITEMS
_box addItemCargoGlobal ["FirstAidKit",6 + (round random 6)];
_box addItemCargoGlobal ["Rangefinder",1 + (round random 1)];
_box addItemCargoGlobal ["ItemGPS",2 + (round random 1)];
_box addItemCargoGlobal ["bipod_02_F_blk",2 + (round random 1)];

// WEAPON ITEMS
_box addItemCargoGlobal ["optic_Arco_blk_F",2 + (round random 2)];
_box addItemCargoGlobal ["optic_dms",1 + (round random 1)];
_box addItemCargoGlobal ["optic_nvs",2 + (round random 1)];
_box addItemCargoGlobal ["acc_pointer_IR",4 + (round random 2)];

// WEAPONS
_box addWeaponCargoGlobal ["arifle_ARX_blk_F",4 + (round random 2)];
_box addWeaponCargoGlobal ["srifle_DMR_04_ACO_F",1];
// _box addWeaponCargoGlobal ["launch_O_Titan_F",1];
// _box addWeaponCargoGlobal ["launch_O_Titan_short_F",1];

// AMMO
_box addMagazineCargoGlobal ["30Rnd_65x39_caseless_green",32 + (round random 8)];
_box addMagazineCargoGlobal ["10Rnd_50BW_Mag_F",16 + (round random 8)];
_box addMagazineCargoGlobal ["10Rnd_127x54_Mag",6 + (round random 6)];
// _box addMagazineCargoGlobal ["Titan_AA",2 + (round random 2)];
// _box addMagazineCargoGlobal ["Titan_AT",2 + (round random 2)];

// BACKPACKS
// _box addBackpackCargoGlobal ["B_Carryall_ocamo",1 + (round random 1)];
