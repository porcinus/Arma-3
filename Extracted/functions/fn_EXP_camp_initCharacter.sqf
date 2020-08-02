/*
	Author: Thomas Ryan
	
	Description:
	Assigns correct appearance and loadout of story characters based upon their vehicle classnames.
	Must be executed on all machines.
	
	Parameters:
		_this select 0: OBJECT - The character to be initialized
		_this select 1 (Optional): Can be either "DAY" (unsilenced, no NVGs, default) or "NIGHT" (silenced, NVGs)
	
	Returns:
	True if successful, false if not.
*/

params [
	["_unit", objNull, [objNull]],
	["_mode", "DAY", [""]]
];

_mode = toUpper _mode;
if (isNull _unit) exitWith {"Defined unit does not exist!" call BIS_fnc_error; false};
if (!(_mode in ["DAY", "NIGHT"])) exitWith {"Mode must be either ""DAY"" or ""NIGHT""!" call BIS_fnc_error; false};

private ["_name", "_face", "_voice", "_uniform", "_vest", "_primary", "_handgun"];
private _headgear = "";
private _backpack = [];
private _secondary = [];

switch (typeOf _unit) do {
	// Miller
	case "B_Story_SF_Captain_F": {
		_name = "STR_A3_CFGIDENTITIES_MILLER0" call BIS_fnc_localize;
		_face = "Miller";
		_voice = "Male03ENGB";
		
		_uniform = "U_B_CTRG_Soldier_3_F";
		_vest = "V_PlateCarrier2_rgr_noflag_F";
		
		_primary = [
			"arifle_SPAR_01_khk_F",
			["30Rnd_556x45_Stanag", 6],
			["optic_ERCO_khk_F", "acc_pointer_IR"],
			"muzzle_snds_M"
		];
		
		_handgun = [
			"hgun_P07_khk_F",
			["16Rnd_9x21_Mag", 3],
			"muzzle_snds_L"
		];
	};
	
	// Support Team Lead
	case "B_Soldier_TL_F": {
		_name = localize "STR_A3_ApexProtocol_identity_Riker";	
		_face = "WhiteHead_20";
		_voice = "Male01ENG";
		
		_uniform = "U_B_CTRG_Soldier_2_F";
		_vest = "V_PlateCarrier2_rgr_noflag_F";
		_headgear = "H_Watchcap_khk";
		
		_primary = [
			"arifle_SPAR_01_khk_F",
			["30Rnd_556x45_Stanag", 6],
			["optic_ERCO_khk_F", "acc_pointer_IR"],
			"muzzle_snds_M"
		];
		
		_handgun = [
			"hgun_P07_khk_F",
			["16Rnd_9x21_Mag", 3],
			"muzzle_snds_L"
		];
	};
	
	// Marksman
	case "B_soldier_M_F": {
		_name = localize "STR_A3_ApexProtocol_identity_Grimm";
		_face = "WhiteHead_15";
		_voice = "Male01ENG";
		
		_uniform = "U_B_CTRG_Soldier_2_F";
		_vest = "V_PlateCarrier2_rgr_noflag_F";
		_headgear = "H_Cap_oli_hs";
		
		_primary = [
			"arifle_SPAR_03_khk_F",
			["20Rnd_762x51_Mag", 6],
			["optic_AMS_khk", "acc_pointer_IR", "bipod_01_F_khk"],
			"muzzle_snds_B"
		];
		
		_handgun = [
			"hgun_P07_khk_F",
			["16Rnd_9x21_Mag", 3],
			"muzzle_snds_L"
		];
	};
	
	// Machine Gunner
	case "B_soldier_AR_F": {
		_name = localize "STR_A3_ApexProtocol_identity_Salvo";
		_face = "WhiteHead_06";
		_voice = "Male01ENG";
		
		_uniform = "U_B_CTRG_Soldier_2_F";
		_vest = "V_PlateCarrier1_rgr_noflag_F";
		_headgear = "H_Bandanna_khk_hs";
		
		_backpack = ["B_AssaultPack_rgr"];
		
		_primary = [
			"arifle_SPAR_02_khk_F",
			["150Rnd_556x45_Drum_Mag_F", 2],
			["optic_ERCO_khk_F", "acc_pointer_IR", "bipod_01_F_khk"],
			"muzzle_snds_M"
		];
		
		_handgun = [
			"hgun_P07_khk_F",
			["16Rnd_9x21_Mag", 3],
			"muzzle_snds_L"
		];
	};
	
	// Specialist
	case "B_soldier_LAT_F": {
		_name = localize "STR_A3_ApexProtocol_identity_Truck";
		_face = "WhiteHead_02";
		_voice = "Male01ENG";
		
		_uniform = "U_B_CTRG_Soldier_2_F";
		_vest = "V_PlateCarrier1_rgr_noflag_F";
		_headgear = "H_HelmetB_light";
		
		_backpack = ["B_AssaultPack_rgr"];
		
		_primary = [
			"arifle_SPAR_01_khk_F",
			["30Rnd_556x45_Stanag", 6],
			["optic_ERCO_khk_F", "acc_pointer_IR"],
			"muzzle_snds_M"
		];
		
		_secondary = [
			"launch_NLAW_F",
			["NLAW_F", 2]
		];
		
		_handgun = [
			"hgun_P07_khk_F",
			["16Rnd_9x21_Mag", 3],
			"muzzle_snds_L"
		];
	};
};

// Set up identity
_unit setName _name;
_unit setFace _face;
_unit setSpeaker _voice;
_unit setPitch 1;

// Configure loadout
if (isServer) then {
	// Remove everything
	removeAllAssignedItems _unit;
	removeAllWeapons _unit;
	
	// Appearance
	_unit forceAddUniform _uniform;
	_unit addVest _vest;
	if (_headgear != "") then {_unit addHeadgear _headgear};
	
	// Backpack
	removeBackpack _unit;
	
	if (count _backpack > 0) then {
		_unit addBackpack (_backpack select 0);
		if (count _backpack > 1) then {{_unit addItemToBackpack _x} forEach (_backpack select 1)};
	};
	
	// Weapons
	private _weapons = [_primary, _handgun];
	if (count _secondary > 0) then {_weapons = _weapons + [_secondary]};
	
	{
		// Magazines
		_unit addMagazines (_x select 1);
		
		// Weapon itself
		_unit addWeapon (_x select 0);
		
		switch (_forEachIndex) do {
			// Primary
			case 0: {
				// Accessories
				{_unit addPrimaryWeaponItem _x} forEach (_x select 2);
				
				// Silencer
				if (_mode == "NIGHT") then {_unit addPrimaryWeaponItem (_x select 3)};
			};
			
			// Handgun
			case 1: {
				// Silencer
				if (_mode == "NIGHT") then {_unit addHandgunItem (_x select 2)};
			};
		};
	} forEach _weapons;
	
	if (_mode == "DAY") then {
		// Glasses
		_unit addGoggles "G_Tactical_Black";
	} else {
		// NVGs
		removeGoggles _unit;
		_unit linkItem "NVGogglesB_grn_F";
	};
	
	// Misc
	{_unit linkItem _x} forEach ["ItemMap", "ItemCompass", "ItemWatch", "ItemRadio", "ItemGPS"];
	
	// Select primary weapon
	_unit selectWeapon (_primary select 0);
};

true