class CfgRoles {
	class Assault {
		displayName = $STR_A3_Role_Assault;
		icon = "a3\missions_f_exp\data\img\classes\assault_ca.paa";
	};

	class Support {
		displayName = $STR_A3_Role_Support;
		icon = "a3\missions_f_exp\data\img\classes\support_ca.paa";
	};

	class Recon {
		displayName = $STR_A3_Role_Recon;
		icon = "a3\missions_f_exp\data\img\classes\recon_ca.paa";
	};

	class Saved_Loadout { //NNS
		displayName = "Previous Loadout";
		icon = "a3\missions_f_exp\data\img\lobby\ui_campaign_lobby_icon_player_connecting_ca.paa";
	};
};

//NNS : Night stalker added, smokes removed, various additionnal tweaks
//NNS : TODO Need to redo whole limited equipment part
class CfgRespawnInventory {
	class O_Saved_Loadout { //NNS
		show = "side group _this == east";
		displayName = "Restore Loadout";
		role = "Saved_Loadout";
		icon = "\A3\ui_f\data\map\VehicleIcons\iconManLeader_ca.paa";
		uniformClass = "U_C_Poloshirt_stripped";
		weapons[] = {};
		magazines[] = {};
		linkedItems[] = {};
		items[] = {};
	};

	class O_SquadLeader {
		show = "side group _this == east";
		displayName = $STR_b_soldier_sl_f0;
		role = "Assault";
		icon = "\A3\ui_f\data\map\VehicleIcons\iconManLeader_ca.paa";
		uniformClass = "U_O_CombatUniform_ocamo";
		backpack = "B_FieldPack_ocamo";
		weapons[] = {"arifle_Katiba_ARCO_pointer_F","hgun_Pistol_heavy_02_F","Rangefinder"};
		magazines[] = {"6Rnd_45ACP_Cylinder","6Rnd_45ACP_Cylinder","6Rnd_45ACP_Cylinder","30Rnd_65x39_caseless_green_mag_Tracer","30Rnd_65x39_caseless_green_mag_Tracer","30Rnd_65x39_caseless_green_mag_Tracer","30Rnd_65x39_caseless_green_mag_Tracer","30Rnd_65x39_caseless_green_mag_Tracer","30Rnd_65x39_caseless_green_mag_Tracer","30Rnd_65x39_caseless_green_mag_Tracer","30Rnd_65x39_caseless_green_mag_Tracer","HandGrenade","HandGrenade"};
		linkedItems[] = {"V_TacVest_khk","H_HelmetLeaderO_ocamo","ItemGPS","ItemMap","ItemCompass","ItemWatch","ItemRadio","NVGogglesB_blk_F"};
		items[] = {"FirstAidKit","optic_Nightstalker"};
	};

	class O_Marksman {
		show = "side group _this == east";
		displayName = $STR_b_soldier_m_f0;
		role = "Assault";
		icon = "\A3\ui_f\data\map\VehicleIcons\iconMan_ca.paa";
		uniformClass = "U_O_CombatUniform_ocamo";
		backpack = "B_FieldPack_ocamo";
		weapons[] = {"srifle_DMR_01_DMS_F","hgun_Rook40_F","Rangefinder"};
		magazines[] = {"16Rnd_9x21_Mag","16Rnd_9x21_Mag","16Rnd_9x21_Mag","10Rnd_762x54_Mag","10Rnd_762x54_Mag","10Rnd_762x54_Mag","10Rnd_762x54_Mag","10Rnd_762x54_Mag","10Rnd_762x54_Mag","10Rnd_762x54_Mag","10Rnd_762x54_Mag","10Rnd_762x54_Mag","10Rnd_762x54_Mag","10Rnd_762x54_Mag","10Rnd_762x54_Mag","HandGrenade","HandGrenade"};
		linkedItems[] = {"V_HarnessO_brn","H_HelmetSpecO_ocamo","bipod_02_F_blk","ItemGPS","ItemMap","ItemCompass","ItemWatch","ItemRadio","NVGogglesB_blk_F"};
		items[] = {"FirstAidKit","optic_Nightstalker"};
	};

	class O_Autorifleman {
		show = "side group _this == east";
		displayName = $STR_b_soldier_ar_f0;
		role = "Assault";
		icon = "\A3\ui_f\data\map\VehicleIcons\iconManMG_ca.paa";
		uniformClass = "U_O_CombatUniform_ocamo";
		backpack = "B_FieldPack_ocamo";
		weapons[] = {"LMG_Zafir_ARCO_F","hgun_Rook40_F","Rangefinder"};
		magazines[] = {"16Rnd_9x21_Mag","16Rnd_9x21_Mag","16Rnd_9x21_Mag","150Rnd_762x54_Box","150Rnd_762x54_Box","150Rnd_762x54_Box","HandGrenade","HandGrenade"};
		linkedItems[] = {"V_HarnessO_brn","H_HelmetO_ocamo","acc_pointer_IR","ItemGPS","ItemMap","ItemCompass","ItemWatch","ItemRadio","NVGogglesB_blk_F"};
		items[] = {"FirstAidKit","optic_Nightstalker"};
	};

	class O_Grenadier {
		show = "side group _this == east";
		displayName = $STR_b_soldier_gl_f0;
		role = "Assault";
		icon = "\A3\ui_f\data\map\VehicleIcons\iconMan_ca.paa";
		uniformClass = "U_O_CombatUniform_ocamo";
		backpack = "B_FieldPack_ocamo";
		weapons[] = {"arifle_Katiba_GL_ARCO_pointer_F","hgun_Rook40_F","Rangefinder"};
		magazines[] = {"16Rnd_9x21_Mag","16Rnd_9x21_Mag","16Rnd_9x21_Mag","30Rnd_65x39_caseless_green","30Rnd_65x39_caseless_green","30Rnd_65x39_caseless_green","30Rnd_65x39_caseless_green","30Rnd_65x39_caseless_green","30Rnd_65x39_caseless_green","30Rnd_65x39_caseless_green","30Rnd_65x39_caseless_green","HandGrenade","HandGrenade","1Rnd_HE_Grenade_shell","1Rnd_HE_Grenade_shell","1Rnd_HE_Grenade_shell","1Rnd_HE_Grenade_shell","1Rnd_HE_Grenade_shell","1Rnd_HE_Grenade_shell"};
		linkedItems[] = {"V_HarnessOGL_brn","H_HelmetO_ocamo","ItemGPS","ItemMap","ItemCompass","ItemWatch","ItemRadio","NVGogglesB_blk_F"};
		items[] = {"FirstAidKit","optic_Nightstalker"};
	};

	class O_Rifleman {
		show = "side group _this == east";
		displayName = $STR_A3_cfgvehicles_b_soldier_f0;
		role = "Assault";
		icon = "\A3\ui_f\data\map\VehicleIcons\iconMan_ca.paa";
		uniformClass = "U_O_CombatUniform_ocamo";
		backpack = "B_FieldPack_ocamo";
		weapons[] = {"arifle_Katiba_ARCO_pointer_F","hgun_Rook40_F","Rangefinder"};
		magazines[] = {"16Rnd_9x21_Mag","16Rnd_9x21_Mag","16Rnd_9x21_Mag","30Rnd_65x39_caseless_green","30Rnd_65x39_caseless_green","30Rnd_65x39_caseless_green","30Rnd_65x39_caseless_green","30Rnd_65x39_caseless_green","30Rnd_65x39_caseless_green","30Rnd_65x39_caseless_green","30Rnd_65x39_caseless_green","HandGrenade","HandGrenade"};
		linkedItems[] = {"V_HarnessO_brn","H_HelmetO_ocamo","ItemGPS","ItemMap","ItemCompass","ItemWatch","ItemRadio","NVGogglesB_blk_F"};
		items[] = {"FirstAidKit","optic_Nightstalker"};
	};

	class O_LAT {
		show = "side group _this == east";
		displayName = $STR_b_soldier_lat_f0;
		role = "Assault";
		icon = "\A3\ui_f\data\map\VehicleIcons\iconManAT_ca.paa";
		uniformClass = "U_O_CombatUniform_ocamo";
		backpack = "B_FieldPack_ocamo";
		weapons[] = {"arifle_Katiba_ARCO_pointer_F","hgun_Rook40_F","launch_NLAW_F","Rangefinder"};
		magazines[] = {"16Rnd_9x21_Mag","16Rnd_9x21_Mag","16Rnd_9x21_Mag","30Rnd_65x39_caseless_green","30Rnd_65x39_caseless_green","30Rnd_65x39_caseless_green","30Rnd_65x39_caseless_green","30Rnd_65x39_caseless_green","30Rnd_65x39_caseless_green","30Rnd_65x39_caseless_green","30Rnd_65x39_caseless_green","HandGrenade","HandGrenade","NLAW_F","NLAW_F","NLAW_F"};
		linkedItems[] = {"V_HarnessO_brn","H_HelmetO_ocamo","ItemGPS","ItemMap","ItemCompass","ItemWatch","ItemRadio","NVGogglesB_blk_F"};
		items[] = {"FirstAidKit","optic_Nightstalker"};
	};

	class O_AA { //NNS : added
		show = "side group _this == east";
		displayName = $STR_b_soldier_aa_f0;
		role = "Assault";
		icon = "\A3\ui_f\data\map\VehicleIcons\iconManAT_ca.paa";
		uniformClass = "U_O_CombatUniform_ocamo";
		backpack = "B_FieldPack_ocamo";
		weapons[] = {"arifle_Katiba_ARCO_pointer_F","launch_O_Titan_F","Rangefinder"};
		magazines[] = {"30Rnd_65x39_caseless_green","30Rnd_65x39_caseless_green","30Rnd_65x39_caseless_green","30Rnd_65x39_caseless_green","30Rnd_65x39_caseless_green","30Rnd_65x39_caseless_green","HandGrenade","HandGrenade","Titan_AA","Titan_AA"};
		linkedItems[] = {"V_HarnessO_brn","H_HelmetO_ocamo","ItemGPS","ItemMap","ItemCompass","ItemWatch","ItemRadio","NVGogglesB_blk_F"};
		items[] = {"FirstAidKit","optic_Nightstalker"};
	};

	class O_Engineer {
		show = "side group _this == east";
		displayName = $STR_b_engineer_f0;
		role = "Assault";
		icon = "\A3\ui_f\data\map\VehicleIcons\iconManEngineer_ca.paa";
		uniformClass = "U_O_CombatUniform_ocamo";
		backpack = "B_FieldPack_ocamo";
		weapons[] = {"arifle_Katiba_ARCO_pointer_F","hgun_Rook40_F","Rangefinder"};
		magazines[] = {"16Rnd_9x21_Mag","16Rnd_9x21_Mag","16Rnd_9x21_Mag","30Rnd_65x39_caseless_green","30Rnd_65x39_caseless_green","30Rnd_65x39_caseless_green","30Rnd_65x39_caseless_green","30Rnd_65x39_caseless_green","30Rnd_65x39_caseless_green","30Rnd_65x39_caseless_green","30Rnd_65x39_caseless_green","DemoCharge_Remote_Mag","DemoCharge_Remote_Mag"};
		linkedItems[] = {"V_HarnessO_brn","H_HelmetO_ocamo","ItemGPS","ItemMap","ItemCompass","ItemWatch","ItemRadio","NVGogglesB_blk_F"};
		items[] = {"FirstAidKit","Toolkit","MineDetector","optic_Nightstalker"};
	};

	class O_CombatLifesaver {
		show = "side group _this == east";
		displayName = $STR_b_medic_f0;
		role = "Assault";
		icon = "\A3\ui_f\data\map\VehicleIcons\iconManMedic_ca.paa";
		uniformClass = "U_O_CombatUniform_ocamo";
		backpack = "B_FieldPack_ocamo";
		weapons[] = {"arifle_Katiba_ARCO_pointer_F","hgun_Rook40_F","Rangefinder"};
		magazines[] = {"16Rnd_9x21_Mag","16Rnd_9x21_Mag","16Rnd_9x21_Mag","30Rnd_65x39_caseless_green","30Rnd_65x39_caseless_green","30Rnd_65x39_caseless_green","30Rnd_65x39_caseless_green","30Rnd_65x39_caseless_green","30Rnd_65x39_caseless_green","30Rnd_65x39_caseless_green","30Rnd_65x39_caseless_green"};
		linkedItems[] = {"V_TacVest_khk","H_HelmetO_ocamo","ItemGPS","ItemMap","ItemCompass","ItemWatch","ItemRadio","NVGogglesB_blk_F"};
		items[] = {"FirstAidKit","optic_Nightstalker"};
	};

	class O_HeavyGunner { //NNS : added
		show = "side group _this == east";
		displayName = $STR_a3_cfgvehicles_b_heavygunner_f0;
		role = "Assault";
		icon = "\A3\ui_f\data\map\VehicleIcons\iconManMG_ca.paa";
		uniformClass = "U_O_CombatUniform_ocamo";
		backpack = "B_FieldPack_ocamo";
		weapons[] = {"MMG_01_hex_ARCO_LP_F","hgun_Rook40_F","Rangefinder"};
		magazines[] = {"16Rnd_9x21_Mag","16Rnd_9x21_Mag","16Rnd_9x21_Mag","150Rnd_93x64_Mag","150Rnd_93x64_Mag","150Rnd_93x64_Mag"};
		linkedItems[] = {"V_HarnessO_brn","H_HelmetO_ocamo","ItemGPS","ItemMap","ItemCompass","ItemWatch","ItemRadio","NVGogglesB_blk_F"};
		items[] = {"FirstAidKit","optic_Nightstalker"};
	};

	class O_AT { //NNS : added
		show = "side group _this == east";
		displayName = $STR_b_soldier_at_f0;
		role = "Assault";
		icon = "\A3\ui_f\data\map\VehicleIcons\iconManAT_ca.paa";
		uniformClass = "U_O_CombatUniform_ocamo";
		backpack = "B_FieldPack_ocamo";
		weapons[] = {"arifle_Katiba_ARCO_pointer_F","hgun_Rook40_F","launch_O_Titan_short_F","Rangefinder"};
		magazines[] = {"16Rnd_9x21_Mag","16Rnd_9x21_Mag","16Rnd_9x21_Mag","30Rnd_65x39_caseless_green","30Rnd_65x39_caseless_green","30Rnd_65x39_caseless_green","30Rnd_65x39_caseless_green","30Rnd_65x39_caseless_green","30Rnd_65x39_caseless_green","30Rnd_65x39_caseless_green","HandGrenade","HandGrenade","Titan_AT","Titan_AT","Titan_AT"};
		linkedItems[] = {"V_HarnessO_brn","H_HelmetO_ocamo","ItemGPS","ItemMap","ItemCompass","ItemWatch","ItemRadio","NVGogglesB_blk_F"};
		items[] = {"FirstAidKit","optic_Nightstalker"};
	};
};
