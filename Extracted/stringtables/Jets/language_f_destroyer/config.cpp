// config.bin - 18:33:34 07/16/20, generated in 0.00 seconds
// Generated by unRap v1.06 by Kegetys
// Separate rootclasses: Disabled, Automatic comments: Enabled

enum {
	DESTRUCTENGINE = 2,
	DESTRUCTDEFAULT = 6,
	DESTRUCTWRECK = 7,
	DESTRUCTTREE = 3,
	DESTRUCTTENT = 4,
	STABILIZEDINAXISX = 1,
	STABILIZEDINAXESXYZ = 4,
	STABILIZEDINAXISY = 2,
	STABILIZEDINAXESBOTH = 3,
	DESTRUCTNO = 0,
	STABILIZEDINAXESNONE = 0,
	DESTRUCTMAN = 5,
	DESTRUCTBUILDING = 1,
};

class CfgPatches {
	class A3_Language_F_Destroyer {
		author = "$STR_A3_Bohemia_Interactive";
		name = "Arma 3 Destroyer - Texts and Translations";
		url = "https://www.arma3.com";
		requiredAddons[] = {"A3_Data_F_Destroyer"};
		requiredVersion = 0.1;
		units[] = {};
		weapons[] = {};
	};
};

class CfgHints {
	class WeaponList {
		class Ship_Gun_01 {
			displayName = %11;
			description = %12;
			tip = "";
			arguments[] = {{"STR_A3_Ship_Gun_01_name"}, {"STR_A3_Ship_Gun_01_hint_description"}};
			image = "\a3\ui_f\data\gui\cfg\hints\Miss_icon_ca.paa";
			vehicle = "B_Ship_Gun_01_F";
			dlc = 601670;
			logicalOrder = 49;
		};
		
		class Ship_MRLS_01 {
			displayName = %11;
			description = %12;
			tip = "";
			arguments[] = {{"STR_A3_Ship_MRLS_01_name"}, {"STR_A3_Ship_MRLS_01_hint_description"}};
			image = "\a3\ui_f\data\gui\cfg\hints\Miss_icon_ca.paa";
			vehicle = "B_Ship_MRLS_01_F";
			dlc = 601670;
			logicalOrder = 50;
		};
	};
};
