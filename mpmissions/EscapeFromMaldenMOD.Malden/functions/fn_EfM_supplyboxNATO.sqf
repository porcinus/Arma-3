// Custom content for NATO supplybox - not used, only the ammobox fnc is used

// Params
params
[
	["_box",objNull,[objNull]] // ammobox
];

// Check for validity
if (isNull _box) exitWith {[format["BIS_fnc_EfM_supplyboxNATO : Non-existing unit box %1 used!",_box]] call NNS_fnc_debugOutput;};

{clearMagazineCargoGlobal _x, clearWeaponCargoGlobal _x, clearItemCargoGlobal _x, clearBackpackCargoGlobal _x} forEach [_box];

// WEAPON ITEMS

// Bipods
_box addItemCargoGlobal ["bipod_01_F_blk",(round random 1.5)];

// Optics
_box addItemCargoGlobal ["optic_aco",2 + (round random 2)];
_box addItemCargoGlobal ["optic_hamr",1 + (round random 1)];
_box addItemCargoGlobal ["optic_Nightstalker",(round random 1)];

// Laser pointers
_box addItemCargoGlobal ["acc_pointer_IR",(round random 2)];

// FAKs
_box addItemCargoGlobal ["FirstAidKit",4 + (round random 4)];

// Rangefinder
_box addItemCargoGlobal ["Rangefinder",(round random 1)];

// NLAWs
_box addMagazineCargoGlobal ["NLAW_F",2];
_box addWeaponCargoGlobal ["launch_NLAW_F",2];

// AA Titan
_box addMagazineCargoGlobal ["Titan_AA",2 + (round random 3)]; // NNS
_box addWeaponCargoGlobal ["launch_B_Titan_F",1];

// NNS : AC Titan
_box addMagazineCargoGlobal ["Titan_AT",2 + (round random 3)];
_box addWeaponCargoGlobal ["launch_O_Titan_short_F",1];

// Backpacks
_box addBackpackCargoGlobal ["B_AssaultPack_rgr",1];
_box addBackpackCargoGlobal ["B_Kitbag_rgr",(round random 1)];
