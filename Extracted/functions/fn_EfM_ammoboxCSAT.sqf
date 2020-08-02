// Custom content for CSAT ammobox

// Params
params
[
	["_box",objNull,[objNull]]	// ammobox
];

{clearMagazineCargoGlobal _x, clearWeaponCargoGlobal _x, clearItemCargoGlobal _x, clearBackpackCargoGlobal _x} forEach [_box];

// Navid or Cyrus
if (random 100 < 50) then {
	_box addWeaponCargoGlobal ["MMG_01_tan_F",1]; _box addMagazineCargoGlobal ["150Rnd_93x64_Mag",2 + (round random 2)];
} else {
	_box addWeaponCargoGlobal ["srifle_DMR_05_KHS_LP_F",1]; _box addMagazineCargoGlobal ["10Rnd_93x64_DMR_05_Mag",4 + (round random 2)];
};

// AK-12
_box addWeaponCargoGlobal ["arifle_AK12_F",2 + (round random 2)];
_box addWeaponCargoGlobal ["arifle_AK12_GL_F",1 + (round random 1)];

// GM6
if (random 100 < 50) then {_box addMagazineCargoGlobal ["5Rnd_127x108_Mag",4 + (round random 4)]; _box addWeaponCargoGlobal ["srifle_GM6_LRPS_F",1]};

// AMMO

// 6.5 mm, tracer/non-tracer
if (random 100 < 50) then {_box addMagazineCargoGlobal ["30Rnd_65x39_caseless_green",18 + (round random 6)]} else {_box addMagazineCargoGlobal ["30Rnd_65x39_caseless_green_mag_Tracer",18 + (round random 6)]};

// 7.62 mm
_box addMagazineCargoGlobal ["10Rnd_762x54_Mag",6 + (round random 4)];
if (random 100 < 50) then {_box addMagazineCargoGlobal ["150Rnd_762x54_Box",4 + (round random 4)]} else {_box addMagazineCargoGlobal ["150Rnd_762x54_Box_Tracer",4 + (round random 4)]};
if (random 100 < 50) then {_box addMagazineCargoGlobal ["30Rnd_762x39_Mag_Green_F",18 + (round random 6)]} else {_box addMagazineCargoGlobal ["30Rnd_762x39_Mag_Tracer_Green_F",18 + (round random 6)]};

// 40mm UGLs
_box addMagazineCargoGlobal ["1Rnd_HE_Grenade_shell",4 + (round random 4)];

// Smoke shells
_box addMagazineCargoGlobal ["SmokeShell",4 + (round random 4)];

// Grenades
_box addMagazineCargoGlobal ["HandGrenade",4 + (round random 4)];
_box addMagazineCargoGlobal ["MiniGrenade",4 + (round random 4)];
