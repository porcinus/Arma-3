// Custom content for CSAT supplybox

// Params
params
[
	["_box",objNull,[objNull]] // ammobox
];

{clearMagazineCargoGlobal _x, clearWeaponCargoGlobal _x, clearItemCargoGlobal _x, clearBackpackCargoGlobal _x} forEach [_box];

// Optics
_box addItemCargoGlobal ["optic_aco_grn",2 + (round random 2)];
_box addItemCargoGlobal ["optic_arco_blk_F",1 + (round random 1)];
_box addItemCargoGlobal ["optic_dms",(round random 1.5)];
_box addItemCargoGlobal ["optic_nvs",(round random 1)];

// Laser pointers
_box addItemCargoGlobal ["acc_pointer_IR",(round random 3)];

// Suppressors
_box addItemCargoGlobal ["muzzle_snds_H",(round random 2.25)];
_box addItemCargoGlobal ["muzzle_snds_B",(round random 1.25)];

// AT Launcher
if (random 100 < 65) then {
	_box addMagazineCargoGlobal ["RPG32_F",2 + (round random 2)]; _box addMagazineCargoGlobal ["RPG32_HE_F",2 + (round random 2)]; _box addWeaponCargoGlobal ["launch_RPG32_F",1];
} else {
	_box addMagazineCargoGlobal ["Titan_AT",2 + (round random 1)]; _box addWeaponCargoGlobal ["launch_O_Titan_short_F",1];
};

// RPG-42
/*
_box addMagazineCargoGlobal ["RPG32_F",2 + (round random 2)];
_box addMagazineCargoGlobal ["RPG32_HE_F",2 + (round random 2)];
_box addWeaponCargoGlobal ["launch_RPG32_F",1];
*/

// Titan AA
_box addMagazineCargoGlobal ["Titan_AA",2 + (round random 1)];
_box addWeaponCargoGlobal ["launch_O_Titan_F",1];

// Titan AT
// _box addMagazineCargoGlobal ["Titan_AT",2 + (round random 1)];
// _box addWeaponCargoGlobal ["launch_O_Titan_short_F",1];

// FAKs
_box addItemCargoGlobal ["FirstAidKit",4 + (round random 4)];

// Rangefinder
_box addItemCargoGlobal ["Rangefinder",(round random 1.25)];

// Backpacks
_box addBackpackCargoGlobal ["B_FieldPack_ocamo",1];
_box addBackpackCargoGlobal ["B_Carryall_ocamo",(round random 1.25)];

// GPS
_box addItemCargoGlobal ["ItemGPS",(round random 2)];
