/*
NNS, original from 'Escape from Malden'
Custom content for 'sniper' ammobox
Modified to add ammo for Navid and Zubr
*/

// Params
params
[
	["_box",objNull,[objNull]]	// ammobox
];

// Check for validity
if (isNull _box) exitWith {[format["BIS_fnc_EfM_sniperBox : Non-existing unit box %1 used!",_box]] call BIS_fnc_NNS_debugOutput;};

{clearMagazineCargoGlobal _x, clearWeaponCargoGlobal _x, clearItemCargoGlobal _x, clearBackpackCargoGlobal _x} forEach [_box];

// EQUIPMENT
_box addItemCargoGlobal ["Rangefinder",1];
_box addItemCargoGlobal ["Binocular",2];

// WEAPONS
_box addWeaponCargoGlobal ["srifle_DMR_01_DMS_BI_F",1];
_box addWeaponCargoGlobal ["srifle_DMR_05_KHS_LP_F",1];
_box addWeaponCargoGlobal ["srifle_GM6_LRPS_F",1];

// AMMO
_box addMagazineCargoGlobal ["10Rnd_762x54_Mag",12 + (round random 6)];
_box addMagazineCargoGlobal ["10Rnd_93x64_DMR_05_Mag",8 + (round random 4)];
_box addMagazineCargoGlobal ["5Rnd_127x108_Mag",8 + (round random 4)];

//NNS: Navid / Zubr ammo
_box addMagazineCargoGlobal ["150Rnd_93x64_Mag", 3]; //Navid
_box addMagazineCargoGlobal ["6Rnd_45ACP_Cylinder", 6]; //Zubr