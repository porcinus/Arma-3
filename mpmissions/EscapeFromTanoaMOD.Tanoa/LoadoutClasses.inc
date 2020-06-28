class CfgRoles
{
	class Assault
	{
		displayName = $STR_A3_Role_Assault;
		icon = "a3\missions_f_exp\data\img\classes\assault_ca.paa";
	};
	class Support
	{
		displayName = $STR_A3_Role_Support;
		icon = "a3\missions_f_exp\data\img\classes\support_ca.paa";
	};
	class Recon
	{
		displayName = $STR_A3_Role_Recon;
		icon = "a3\missions_f_exp\data\img\classes\recon_ca.paa";
	};
	
	class Saved_Loadout { //NNS
		displayName = "Previous Loadout";
		icon = "a3\missions_f_exp\data\img\lobby\ui_campaign_lobby_icon_player_connecting_ca.paa";
	};
};

class CfgRespawnInventory
{
	class B_Saved_Loadout { //NNS
		show = "side group _this == west";
		displayName = "Restore Loadout";
		role = "Saved_Loadout";
		icon = "\A3\ui_f\data\map\VehicleIcons\iconManLeader_ca.paa";
		uniformClass = "U_C_Poloshirt_stripped";
		weapons[] = {};
		magazines[] = {};
		linkedItems[] = {};
		items[] = {};
	};
	
	class B_SquadLeader {
		displayName = $STR_b_soldier_sl_f0;
		role = "Assault";
		icon = "\A3\ui_f\data\map\VehicleIcons\iconManLeader_ca.paa";
		show = "side group _this == west";
		weapons[] = {"arifle_SPAR_01_blk_ERCO_Pointer_F","Rangefinder","hgun_P07_khk_F"};
		magazines[] = {"16Rnd_9x21_Mag","16Rnd_9x21_Mag","16Rnd_9x21_Mag","30Rnd_556x45_Stanag_Tracer_Red","30Rnd_556x45_Stanag_Tracer_Red","30Rnd_556x45_Stanag_Tracer_Red","30Rnd_556x45_Stanag_Tracer_Red","30Rnd_556x45_Stanag_Tracer_Red","30Rnd_556x45_Stanag_Tracer_Red","30Rnd_556x45_Stanag_Tracer_Red","30Rnd_556x45_Stanag_Tracer_Red","HandGrenade","HandGrenade"};
		items[] = {"FirstAidKit","optic_Nightstalker"};
		linkedItems[] = {"V_PlateCarrierSpec_tna_F","H_HelmetB_Enh_tna_F","acc_pointer_IR","NVGogglesB_blk_F","ItemGPS","ItemMap","ItemCompass","ItemWatch","ItemRadio"};
		uniformClass = "U_B_T_Soldier_SL_F";
	};
	
	class B_Marksman {
		displayName = $STR_b_soldier_m_f0;
		role = "Assault";
		icon = "\A3\ui_f\data\map\VehicleIcons\iconMan_ca.paa";
		show = "side group _this == west";
		weapons[] = {"arifle_SPAR_03_blk_MOS_Pointer_Bipod_F","Rangefinder","hgun_P07_khk_F"};
		magazines[] = {"16Rnd_9x21_Mag","16Rnd_9x21_Mag","16Rnd_9x21_Mag","20Rnd_762x51_Mag","20Rnd_762x51_Mag","20Rnd_762x51_Mag","20Rnd_762x51_Mag","20Rnd_762x51_Mag","20Rnd_762x51_Mag","20Rnd_762x51_Mag","20Rnd_762x51_Mag","HandGrenade","HandGrenade"};
		items[] = {"FirstAidKit","optic_Nightstalker"};
		linkedItems[] = {"V_PlateCarrier1_tna_F","H_HelmetB_Light_tna_F","acc_pointer_IR","bipod_01_F_blk","NVGogglesB_blk_F","ItemGPS","ItemMap","ItemCompass","ItemWatch","ItemRadio"};
		uniformClass = "U_B_T_Soldier_SL_F";
	};
	
	class B_Autorifleman {
		displayName = $STR_b_soldier_ar_f0;
		role = "Assault";
		icon = "\A3\ui_f\data\map\VehicleIcons\iconManMG_ca.paa";
		show = "side group _this == west";
		weapons[] = {"arifle_SPAR_02_blk_ERCO_Pointer_F","hgun_P07_khk_F"};
		magazines[] = {"16Rnd_9x21_Mag","16Rnd_9x21_Mag","16Rnd_9x21_Mag","150Rnd_556x45_Drum_Mag_F","150Rnd_556x45_Drum_Mag_F","150Rnd_556x45_Drum_Mag_F","150Rnd_556x45_Drum_Mag_F","HandGrenade","HandGrenade"};
		items[] = {"FirstAidKit","optic_Nightstalker"};
		linkedItems[] = {"V_PlateCarrier2_tna_F","H_HelmetB_tna_F","bipod_01_F_blk","acc_pointer_IR","NVGogglesB_blk_F","ItemGPS","ItemMap","ItemCompass","ItemWatch","ItemRadio"};
		uniformClass = "U_B_T_Soldier_AR_F";
	};
	
	class B_Grenadier {
		displayName = $STR_b_soldier_gl_f0;
		role = "Assault";
		icon = "\A3\ui_f\data\map\VehicleIcons\iconMan_ca.paa";
		show = "side group _this == west";
		weapons[] = {"arifle_SPAR_01_GL_blk_ERCO_Pointer_F","hgun_P07_khk_F"};
		magazines[] = {"16Rnd_9x21_Mag","16Rnd_9x21_Mag","16Rnd_9x21_Mag","30Rnd_556x45_Stanag_red","30Rnd_556x45_Stanag_red","30Rnd_556x45_Stanag_red","30Rnd_556x45_Stanag_red","30Rnd_556x45_Stanag_red","30Rnd_556x45_Stanag_red","30Rnd_556x45_Stanag_red","30Rnd_556x45_Stanag_red","HandGrenade","HandGrenade","1Rnd_HE_Grenade_shell","1Rnd_HE_Grenade_shell","1Rnd_HE_Grenade_shell","1Rnd_HE_Grenade_shell","1Rnd_HE_Grenade_shell","1Rnd_HE_Grenade_shell"};
		items[] = {"FirstAidKit","optic_Nightstalker"};
		linkedItems[] = {"V_PlateCarrierGL_tna_F","H_HelmetB_tna_F","acc_pointer_IR","NVGogglesB_blk_F","ItemGPS","ItemMap","ItemCompass","ItemWatch","ItemRadio"};
		uniformClass = "U_B_T_Soldier_AR_F";
	};
	
	class B_Rifleman {
		displayName = $STR_A3_cfgvehicles_b_soldier_f0;
		role = "Assault";
		icon = "\A3\ui_f\data\map\VehicleIcons\iconMan_ca.paa";
		show = "side group _this == west";
		weapons[] = {"arifle_SPAR_01_blk_ERCO_Pointer_F","hgun_P07_khk_F"};
		magazines[] = {"16Rnd_9x21_Mag","16Rnd_9x21_Mag","16Rnd_9x21_Mag","30Rnd_556x45_Stanag_red","30Rnd_556x45_Stanag_red","30Rnd_556x45_Stanag_red","30Rnd_556x45_Stanag_red","30Rnd_556x45_Stanag_red","30Rnd_556x45_Stanag_red","30Rnd_556x45_Stanag_red","30Rnd_556x45_Stanag_red","HandGrenade","HandGrenade"};
		items[] = {"FirstAidKit","optic_Nightstalker"};
		linkedItems[] = {"V_PlateCarrier2_tna_F","H_HelmetB_tna_F","acc_pointer_IR","NVGogglesB_blk_F","ItemGPS","ItemMap","ItemCompass","ItemWatch","ItemRadio"};
		uniformClass = "U_B_T_Soldier_AR_F";
	};
	
	class B_AT {
		displayName = $STR_b_soldier_lat_f0;
		role = "Assault";
		icon = "\A3\ui_f\data\map\VehicleIcons\iconManAT_ca.paa";
		show = "side group _this == west";
		weapons[] = {"arifle_SPAR_01_blk_ERCO_Pointer_F","hgun_P07_khk_F","launch_NLAW_F"};
		magazines[] = {"16Rnd_9x21_Mag","16Rnd_9x21_Mag","16Rnd_9x21_Mag","30Rnd_556x45_Stanag_red","30Rnd_556x45_Stanag_red","30Rnd_556x45_Stanag_red","30Rnd_556x45_Stanag_red","30Rnd_556x45_Stanag_red","30Rnd_556x45_Stanag_red","30Rnd_556x45_Stanag_red","30Rnd_556x45_Stanag_red","HandGrenade","HandGrenade","NLAW_F","NLAW_F"};
		items[] = {"FirstAidKit","optic_Nightstalker"};
		linkedItems[] = {"V_PlateCarrier2_tna_F","H_HelmetB_tna_F","acc_pointer_IR","NVGogglesB_blk_F","ItemGPS","ItemMap","ItemCompass","ItemWatch","ItemRadio"};
		uniformClass = "U_B_T_Soldier_AR_F";
		backpack = "B_AssaultPack_tna_F";	
	};
	
	class B_Engineer {
		displayName = $STR_b_engineer_f0;
		role = "Assault";
		icon = "\A3\ui_f\data\map\VehicleIcons\iconManEngineer_ca.paa";
		show = "side group _this == west";
		weapons[] = {"arifle_SPAR_01_blk_ERCO_Pointer_F","hgun_P07_khk_F"};
		magazines[] = {"16Rnd_9x21_Mag","16Rnd_9x21_Mag","16Rnd_9x21_Mag","30Rnd_556x45_Stanag_red","30Rnd_556x45_Stanag_red","30Rnd_556x45_Stanag_red","30Rnd_556x45_Stanag_red","30Rnd_556x45_Stanag_red","30Rnd_556x45_Stanag_red","30Rnd_556x45_Stanag_red","30Rnd_556x45_Stanag_red","DemoCharge_Remote_Mag","DemoCharge_Remote_Mag"};
		items[] = {"FirstAidKit","Toolkit","MineDetector","optic_Nightstalker"};
		linkedItems[] = {"V_PlateCarrier1_tna_F","H_HelmetB_Light_tna_F","acc_pointer_IR","NVGogglesB_blk_F","ItemGPS","ItemMap","ItemCompass","ItemWatch","ItemRadio"};
		uniformClass = "U_B_T_Soldier_AR_F";
		backpack = "B_AssaultPack_tna_F";
	};
	
	class B_CombatLifesaver {
		displayName = $STR_b_medic_f0;
		role = "Assault";
		icon = "\A3\ui_f\data\map\VehicleIcons\iconManMedic_ca.paa";
		show = "side group _this == west";
		weapons[] = {"arifle_SPAR_01_blk_ERCO_Pointer_F","hgun_P07_khk_F"};
		magazines[] = {"Blue","Blue","Blue","Blue","16Rnd_9x21_Mag","16Rnd_9x21_Mag","16Rnd_9x21_Mag","30Rnd_556x45_Stanag_red","30Rnd_556x45_Stanag_red","30Rnd_556x45_Stanag_red","30Rnd_556x45_Stanag_red","30Rnd_556x45_Stanag_red","30Rnd_556x45_Stanag_red","30Rnd_556x45_Stanag_red","30Rnd_556x45_Stanag_red"};
		items[] = {"FirstAidKit","Medikit","optic_Nightstalker"};
		linkedItems[] = {"V_PlateCarrierSpec_tna_F","H_HelmetB_Enh_tna_F","acc_pointer_IR","NVGogglesB_blk_F","ItemGPS","ItemMap","ItemCompass","ItemWatch","ItemRadio"};
		uniformClass = "U_B_T_Soldier_SL_F";
		backpack = "B_AssaultPack_tna_F";
	};
};
