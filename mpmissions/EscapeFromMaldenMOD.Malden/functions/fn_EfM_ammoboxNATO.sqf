// Custom content for NATO ammobox

// Params
params
[
	["_box",objNull,[objNull]] // ammobox
];

// Check for validity
if (isNull _box) exitWith {[format["BIS_fnc_EfM_ammoboxNATO : Non-existing unit box %1 used!",_box]] call BIS_fnc_NNS_debugOutput;};

{clearMagazineCargoGlobal _x, clearWeaponCargoGlobal _x, clearItemCargoGlobal _x, clearBackpackCargoGlobal _x} forEach [_box];

if (random 100 < 35) then {_box addMagazineCargoGlobal ["7Rnd_408_Mag",4 + (round random 4)]; _box addWeaponCargoGlobal ["srifle_LRR_LRPS_F",1]}; // M320
if (random 100 < 35) then {_box addMagazineCargoGlobal ["130Rnd_338_Mag",2 + (round random 2)]; _box addWeaponCargoGlobal ["MMG_02_sand_F",1]}; // SPMG
if (random 100 < 35) then {_box addMagazineCargoGlobal ["10Rnd_338_Mag",4 + (round random 4)]; _box addWeaponCargoGlobal ["srifle_DMR_02_camo_AMS_LP_F",1]}; // MAR-10
if (random 100 < 50) then {_box addMagazineCargoGlobal ["20Rnd_762x51_Mag",6 + (round random 6)]; _box addWeaponCargoGlobal ["srifle_DMR_03_tan_AMS_LP_F",1]}; // Mk-I

// AMMO

// 6.5 mm, tracer/non-tracer
if (random 100 < 50) then {_box addMagazineCargoGlobal ["30Rnd_65x39_caseless_mag",24 + (round random 8)]} else {_box addMagazineCargoGlobal ["30Rnd_65x39_caseless_mag_Tracer",24 + (round random 8)]};
if (random 100 < 50) then {_box addMagazineCargoGlobal ["100Rnd_65x39_caseless_mag",6 + (round random 6)]} else {_box addMagazineCargoGlobal ["100Rnd_65x39_caseless_mag_Tracer",6 + (round random 6)]};


_box addMagazineCargoGlobal ["1Rnd_HE_Grenade_shell",4 + (round random 4)]; // 40mm UGLs shells
_box addMagazineCargoGlobal ["SmokeShell",4 + (round random 4)]; // Smoke shells
_box addMagazineCargoGlobal ["HandGrenade",4 + (round random 4)]; // RGO Grenades
_box addMagazineCargoGlobal ["MiniGrenade",4 + (round random 4)]; // Mini Grenades


_box addItemCargoGlobal ["bipod_01_F_blk",(round random 1.5)]; // Bipods

_box addItemCargoGlobal ["optic_aco",2 + (round random 2)]; // ACO Optics
_box addItemCargoGlobal ["optic_hamr",1 + (round random 1)]; // HAMR Optics
_box addItemCargoGlobal ["optic_Nightstalker",(round random 1)]; // Nightstalker Optics

_box addItemCargoGlobal ["acc_pointer_IR",(round random 2)]; // Laser pointers

_box addItemCargoGlobal ["FirstAidKit",4 + (round random 4)]; // FAKs

_box addItemCargoGlobal ["Rangefinder",(round random 1)]; // Rangefinder

// AT launcher
if (random 100 < 50) then {
	_box addMagazineCargoGlobal ["NLAW_F",2 + (round random 2)]; _box addWeaponCargoGlobal ["launch_NLAW_F",2];
} else {
	_box addMagazineCargoGlobal ["Titan_AT",2 + (round random 1)]; _box addWeaponCargoGlobal ["launch_B_Titan_short_F",1];
};

// AA Titan
_box addMagazineCargoGlobal ["Titan_AA",2 + (round random 2)];
_box addWeaponCargoGlobal ["launch_B_Titan_F",1];

// Backpacks
_box addBackpackCargoGlobal ["B_AssaultPack_rgr",1 + (round random 1)];
_box addBackpackCargoGlobal ["B_Kitbag_rgr",1];
