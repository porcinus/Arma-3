// Custom content for NATO supply box

// Params
params
[
	["_box",objNull,[objNull]] // ammobox
];

{clearMagazineCargoGlobal _x, clearWeaponCargoGlobal _x, clearItemCargoGlobal _x, clearBackpackCargoGlobal _x} forEach [_box];

// FAKs
_box addItemCargoGlobal ["FirstAidKit",4 + (round random 2)];

// Rangefinder
_box addItemCargoGlobal ["Rangefinder",1 + (round random 1.5)];

// Backpacks
_box addBackpackCargoGlobal ["B_AssaultPack_rgr",1];
_box addBackpackCargoGlobal ["B_Kitbag_rgr",(round random 1)];

// Ghillie suit
_box addItemCargoGlobal ["U_B_T_FullGhillie_tna_F",1];

// Vests
_box addItemCargoGlobal ["V_Chestrig_rgr",1];
_box addItemCargoGlobal ["V_PlateCarrierGL_tna_F",1 + (round random 1.5)];
_box addItemCargoGlobal ["V_PlateCarrierSpec_tna_F",1];

// GPS
_box addItemCargoGlobal ["ItemGPS",2 + (round random 1)];

// Medikit
// _box addItemCargoGlobal ["Medikit",(round random 1.5)];

// Toolkit
// _box addItemCargoGlobal ["Toolkit",(round random 1.5)];

// Mine detector
// _box addItemCargoGlobal ["MineDetector",(round random 1.5)];

// NVGs
_box addItemCargoGlobal ["NVGoggles_tna_F",2 + (round random 2)];

// NLAW
_box addMagazineCargoGlobal ["NLAW_F",1];
_box addWeaponCargoGlobal ["launch_NLAW_F",1];

// AA Titan (where's the new Stinger you promised for Apex?)
_box addMagazineCargoGlobal ["Titan_AA",2];
_box addWeaponCargoGlobal ["launch_B_Titan_tna_F",1];
_box addBackpackCargoGlobal ["B_AssaultPack_rgr",1];
