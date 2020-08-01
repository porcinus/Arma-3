private ["_unit"];
_unit = [_this, 0, objNull, [objNull]] call BIS_fnc_param;

removeAllWeapons _unit;
removeAllItems _unit;
removeBackpack _unit;
{_unit linkItem _x} forEach ["ItemMap", "ItemCompass", "ItemRadio", "ItemWatch", "NVGoggles"];

// Add GPS or UAV terminal
if (missionNamespace getVariable ["BIS_UAVAllowed", false] && {!(isUAVConnected BIS_UAV)}) then {
	_unit linkItem "B_UavTerminal";
} else {
	_unit linkItem "ItemGPS";
};

switch (toUpper (typeOf _unit)) do {
//===================================================================
// AUTORIFLEMAN
//===================================================================
	case "B_SOLDIER_AR_F": {
comment "Exported from Arsenal by zipper";

comment "Add containers";
_unit forceAddUniform "U_B_CombatUniform_mcam";
_unit addItemToUniform "200Rnd_65x39_cased_Box";
_unit addVest "V_PlateCarrierSpec_rgr";
for "_i" from 1 to 2 do {_unit addItemToVest "200Rnd_65x39_cased_Box";};
_unit addBackpack "B_AssaultPack_rgr";
_unit addItemToBackpack "FirstAidKit";
for "_i" from 1 to 3 do {_unit addItemToBackpack "200Rnd_65x39_cased_Box";};
for "_i" from 1 to 2 do {_unit addItemToBackpack "HandGrenade";};
_unit addHeadgear "H_HelmetB_light_snakeskin";

comment "Add weapons";
_unit addWeapon "LMG_Mk200_F";
_unit addPrimaryWeaponItem "acc_pointer_IR";
_unit addPrimaryWeaponItem "optic_Holosight";
_unit addPrimaryWeaponItem "bipod_01_F_blk";
_unit addWeapon "Binocular";
	};
	
//===================================================================
// MARKSMAN
//===================================================================
	case "B_SOLDIER_M_F": {
comment "Exported from Arsenal by zipper";

comment "Add containers";
_unit forceAddUniform "U_B_CombatUniform_mcam";
for "_i" from 1 to 3 do {_unit addItemToUniform "20Rnd_762x51_Mag";};
_unit addVest "V_PlateCarrierSpec_rgr";
_unit addItemToVest "FirstAidKit";
for "_i" from 1 to 6 do {_unit addItemToVest "20Rnd_762x51_Mag";};
for "_i" from 1 to 2 do {_unit addItemToVest "HandGrenade";};
_unit addHeadgear "H_HelmetB_light_snakeskin";

comment "Add weapons";
_unit addWeapon "srifle_EBR_F";
_unit addPrimaryWeaponItem "acc_pointer_IR";
_unit addPrimaryWeaponItem "optic_Hamr";
_unit addPrimaryWeaponItem "bipod_01_F_blk";
_unit addWeapon "Binocular";
	};
	
//===================================================================
// TEAM LEADER
//===================================================================
	case "B_SOLDIER_TL_F": {
comment "Exported from Arsenal by zipper";

comment "Add containers";
_unit forceAddUniform "U_B_CombatUniform_mcam";
for "_i" from 1 to 4 do {_unit addItemToUniform "30Rnd_65x39_caseless_mag";};
_unit addVest "V_PlateCarrierSpec_rgr";
_unit addItemToVest "FirstAidKit";
for "_i" from 1 to 4 do {_unit addItemToVest "1Rnd_HE_Grenade_shell";};
for "_i" from 1 to 2 do {_unit addItemToVest "HandGrenade";};
for "_i" from 1 to 5 do {_unit addItemToVest "30Rnd_65x39_caseless_mag";};
_unit addHeadgear "H_HelmetB_light_snakeskin";

comment "Add weapons";
_unit addWeapon "arifle_MX_GL_F";
_unit addPrimaryWeaponItem "acc_pointer_IR";
_unit addPrimaryWeaponItem "optic_Hamr";
_unit addWeapon "Binocular";
	};
	
//===================================================================
// MEDIC
//===================================================================
	case "B_MEDIC_F": {
comment "Exported from Arsenal by zipper";

comment "Add containers";
_unit forceAddUniform "U_B_CombatUniform_mcam";
for "_i" from 1 to 4 do {_unit addItemToUniform "30Rnd_65x39_caseless_mag";};
_unit addVest "V_PlateCarrierSpec_rgr";
_unit addItemToVest "FirstAidKit";
for "_i" from 1 to 2 do {_unit addItemToVest "HandGrenade";};
for "_i" from 1 to 7 do {_unit addItemToVest "30Rnd_65x39_caseless_mag";};
_unit addBackpack "B_AssaultPack_rgr";
for "_i" from 1 to 10 do {_unit addItemToBackpack "FirstAidKit";};
_unit addItemToBackpack "Medikit";
_unit addHeadgear "H_HelmetB_light_snakeskin";

comment "Add weapons";
_unit addWeapon "arifle_MX_F";
_unit addPrimaryWeaponItem "acc_pointer_IR";
_unit addPrimaryWeaponItem "optic_Holosight";
_unit addWeapon "Binocular";
	};
	
//===================================================================
// GRENADIER
//===================================================================
	case "B_SOLDIER_GL_F": {
comment "Exported from Arsenal by zipper";

comment "Add containers";
_unit forceAddUniform "U_B_CombatUniform_mcam";
for "_i" from 1 to 4 do {_unit addItemToUniform "30Rnd_65x39_caseless_mag";};
_unit addVest "V_PlateCarrierGL_rgr";
_unit addItemToVest "FirstAidKit";
for "_i" from 1 to 8 do {_unit addItemToVest "1Rnd_HE_Grenade_shell";};
for "_i" from 1 to 2 do {_unit addItemToVest "HandGrenade";};
for "_i" from 1 to 8 do {_unit addItemToVest "30Rnd_65x39_caseless_mag";};
_unit addHeadgear "H_HelmetB_light_snakeskin";

comment "Add weapons";
_unit addWeapon "arifle_MX_GL_F";
_unit addPrimaryWeaponItem "acc_pointer_IR";
_unit addPrimaryWeaponItem "optic_Holosight";
_unit addWeapon "Binocular";
	};
	
//===================================================================
// RIFLEMAN
//===================================================================
	case "B_SOLDIER_F": {
comment "Exported from Arsenal by zipper";

comment "Add containers";
_unit forceAddUniform "U_B_CombatUniform_mcam";
for "_i" from 1 to 4 do {_unit addItemToUniform "30Rnd_65x39_caseless_mag";};
_unit addVest "V_PlateCarrierSpec_rgr";
_unit addItemToVest "FirstAidKit";
for "_i" from 1 to 4 do {_unit addItemToVest "1Rnd_HE_Grenade_shell";};
for "_i" from 1 to 2 do {_unit addItemToVest "HandGrenade";};
for "_i" from 1 to 5 do {_unit addItemToVest "30Rnd_65x39_caseless_mag";};
_unit addHeadgear "H_HelmetB_light_snakeskin";

comment "Add weapons";
_unit addWeapon "arifle_MX_GL_F";
_unit addPrimaryWeaponItem "acc_pointer_IR";
_unit addPrimaryWeaponItem "optic_Holosight";
_unit addWeapon "Binocular";
	};
};

[_unit, "TFAegis"] call BIS_fnc_setUnitInsignia;
_unit selectWeapon primaryWeapon _unit;