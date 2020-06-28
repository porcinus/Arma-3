// Custom content for Syndikat ammo+supply box

// Params
params
[
	["_box",objNull,[objNull]]	// ammobox
];

{clearMagazineCargoGlobal _x, clearWeaponCargoGlobal _x, clearItemCargoGlobal _x, clearBackpackCargoGlobal _x} forEach [_box];

// WEAPONS
_box addWeaponCargoGlobal ["arifle_AKM_F",2 + (round random 2)];
_box addWeaponCargoGlobal ["arifle_AKS_F",2 + (round random 1)];
_box addWeaponCargoGlobal ["launch_RPG7_F",1];

// AMMO

// 5.45 mm, tracer/non-tracer
if (random 100 < 50) then {_box addMagazineCargoGlobal ["30Rnd_545x39_Mag_F",12 + (round random 6)]} else {_box addMagazineCargoGlobal ["30Rnd_545x39_Mag_Tracer_F",12 + (round random 6)]};

// 5.56 mm, tracer/non-tracer
if (random 100 < 50) then {_box addMagazineCargoGlobal ["200Rnd_556x45_Box_F",3 + (round random 2)]} else {_box addMagazineCargoGlobal ["200Rnd_556x45_Box_Tracer_F",3 + (round random 2)]};

// 7.62 mm, tracer/non-tracer
if (random 100 < 50) then {_box addMagazineCargoGlobal ["30Rnd_762x39_Mag_F",12 + (round random 6)]} else {_box addMagazineCargoGlobal ["30Rnd_762x39_Mag_Tracer_F",12 + (round random 6)]};

// 40mm UGLs
_box addMagazineCargoGlobal ["1Rnd_HE_Grenade_shell",4 + (round random 4)];

// Smoke shells
_box addMagazineCargoGlobal ["SmokeShell",4 + (round random 4)];

// Grenades
_box addMagazineCargoGlobal ["HandGrenade",4 + (round random 4)];
_box addMagazineCargoGlobal ["MiniGrenade",4 + (round random 4)];

// RPG-7
_box addMagazineCargoGlobal ["RPG7_F",2 + (round random 2)];

// Explosives
_box addMagazineCargoGlobal ["DemoCharge_Remote_Mag",2 + (round random 2)];
_box addMagazineCargoGlobal ["SLAMDirectionalMine_Wire_Mag",2 + (round random 2)];

// FAKs
_box addItemCargoGlobal ["FirstAidKit",2 + (round random 2)];

// Binocular
_box addItemCargoGlobal ["Binocular",1];

// Backpacks
_box addBackpackCargoGlobal ["B_FieldPack_blk",1];
_box addBackpackCargoGlobal ["B_Kitbag_rgr",(round random 0.75)];

//Titan AT
_box addMagazineCargoGlobal ["Titan_AT",2];
_box addWeaponCargoGlobal ["launch_B_Titan_short_F",1];