// Custom content for CSAT ammo+supply box at Comms Bravo

// Params
params
[
	["_box",objNull,[objNull]]	// ammobox
];

{clearMagazineCargoGlobal _x, clearWeaponCargoGlobal _x, clearItemCargoGlobal _x, clearBackpackCargoGlobal _x} forEach [_box];

// WEAPON ITEMS

// Optics
_box addItemCargoGlobal ["optic_aco_grn",2 + (round random 2)];
_box addItemCargoGlobal ["optic_arco_blk_F",1 + (round random 1)];

// WEAPONS
_box addWeaponCargoGlobal ["arifle_CTAR_blk_F",2 + (round random 2)];
_box addWeaponCargoGlobal ["arifle_CTAR_GL_blk_F",1 + (round random 1)];
_box addWeaponCargoGlobal ["arifle_CTARS_blk_F",1 + (round random 1)];

// AMMO

// 5.8 mm, tracer/non-tracer
if (random 100 < 50) then {_box addMagazineCargoGlobal ["30Rnd_580x42_Mag_F",12 + (round random 6)]} else {_box addMagazineCargoGlobal ["30Rnd_580x42_Mag_Tracer_F",12 + (round random 6)]};
if (random 100 < 50) then {_box addMagazineCargoGlobal ["100Rnd_580x42_Mag_F",5 + (round random 5)]} else {_box addMagazineCargoGlobal ["100Rnd_580x42_Mag_Tracer_F",5 + (round random 5)]};

// 6.5 mm
_box addMagazineCargoGlobal ["20Rnd_650x39_Cased_Mag_F",4 + (round random 4)];

// 40mm UGLs
_box addMagazineCargoGlobal ["1Rnd_HE_Grenade_shell",2 + (round random 2)];

// Smoke shells
_box addMagazineCargoGlobal ["SmokeShell",4 + (round random 4)];

// Grenades
_box addMagazineCargoGlobal ["HandGrenade",2 + (round random 2)];
_box addMagazineCargoGlobal ["MiniGrenade",2 + (round random 2)];

// FAKs
_box addItemCargoGlobal ["FirstAidKit",2 + (round random 2)];

// Binocular
_box addItemCargoGlobal ["Binocular",1];

// Backpacks
_box addBackpackCargoGlobal ["B_Fieldpack_ghex_F",1];

// GPS
_box addItemCargoGlobal ["ItemGPS",(round random 1)];

// Medikit
// _box addItemCargoGlobal ["Medikit",(round random 1)];

// Toolkit
// _box addItemCargoGlobal ["Toolkit",(round random 1)];

// Mine detector
// _box addItemCargoGlobal ["MineDetector",(round random 1)];

// NVGs
_box addItemCargoGlobal ["O_NVGoggles_ghex_F",2 + (round random 2)];
