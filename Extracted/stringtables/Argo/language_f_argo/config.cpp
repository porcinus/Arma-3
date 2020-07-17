// config.bin - 18:33:54 07/16/20, generated in 0.00 seconds
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
	class A3_Language_F_Argo {
		author = "$STR_A3_Bohemia_Interactive";
		name = "Arma 3 Malden - Texts and Translations";
		url = "https://www.arma3.com";
		requiredAddons[] = {"A3_Data_F_Argo"};
		requiredVersion = 0.1;
		units[] = {};
		weapons[] = {};
	};
};

class CfgHints {
	class MaldenDLC {
		displayName = $STR_A3_CFGHINTS_MALDENDLC0;
		logicalOrder = 19;
		category = "Product";
		
		class Malden {
			displayName = $STR_A3_CFGHINTS_MALDENDLC_MALDEN0;
			description = $STR_A3_CFGHINTS_MALDENDLC_MALDEN1;
			arguments[] = {};
			image = "\A3\Data_F_Argo\Logos\arma3_argo_icon_hint_ca.paa";
			logicalOrder = 1;
		};
		
		class MaldenTerrain : Malden {
			displayName = $STR_A3_CFGHINTS_MALDENDLC_MALDENTERRAIN0;
			description = $STR_A3_CFGHINTS_MALDENDLC_MALDENTERRAIN1;
			logicalOrder = 2;
		};
		
		class CombatPatrol : Malden {
			displayName = $STR_A3_CFGHINTS_MALDENDLC_COMBATPATROL0;
			description = $STR_A3_CFGHINTS_MALDENDLC_COMBATPATROL1;
			logicalOrder = 3;
		};
	};
};