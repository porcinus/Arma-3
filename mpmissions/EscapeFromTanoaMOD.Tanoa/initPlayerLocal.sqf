
//NNS : varible to ignore unit for compute group center
player setVariable ["recovery",true,true];
[] spawn {sleep 10; player setVariable ["recovery",false,true];};

//NNS : teleport to initial respawn position
if !(getMarkerColor "marker_respawn" == "") then {
	[player, "marker_respawn"] call BIS_fnc_moveToRespawnPosition;
	//player setPos ((getMarkerPos "marker_respawn") getPos [5, random 360]); //initial respawn still exist
} else {
	[player, leader group player] call BIS_fnc_moveToRespawnPosition;
	//player setPos ((leader group player) getPos [5, random 360]);
}; //initial respawn don't exist, spawn on group leader


// Create diary for each player
_null = player createDiaryRecord ["Diary", [localize "str_a3_diary_execution_title", format ["%1%4%2%4%3",localize "STR_A3_EscapeFromTanoa_execution01",format [localize "STR_A3_EscapeFromTanoa_execution02","</marker>", "<marker name = 'BIS_mrkGeorgetown'>","<marker name = 'BIS_mrkAirfield'>","<marker name = 'BIS_mrkLijnPort'>","<marker name = 'BIS_mrkLijnAirport'>"],localize "STR_A3_EscapeFromTanoa_execution03","<br /><br />"]]];

//NNS : allow player to heal and repair
if (BIS_loadoutLevel == 0) then {
	player setUnitTrait ["Medic",true];
	player setUnitTrait ["Engineer",true];
};

//NNS : stamina
if !(BIS_stamina) then {player enablestamina false;};

// Add respawn tickets if set to individual unit
if (missionNamespace getVariable "BIS_respawnTickets" == 0) then {[player,1] call BIS_fnc_respawnTickets};
if (missionNamespace getVariable "BIS_respawnTickets" == 1) then {[player,2] call BIS_fnc_respawnTickets};
if (missionNamespace getVariable "BIS_respawnTickets" == 2) then {[player,3] call BIS_fnc_respawnTickets};
if (missionNamespace getVariable "BIS_respawnTickets" == 3) then {[player,4] call BIS_fnc_respawnTickets};
if (missionNamespace getVariable "BIS_respawnTickets" == 4) then {[player,5] call BIS_fnc_respawnTickets};
if (missionNamespace getVariable "BIS_respawnTickets" == 5) then {[player,6] call BIS_fnc_respawnTickets};
if (missionNamespace getVariable "BIS_respawnTickets" == 10) then {[player,11] call BIS_fnc_respawnTickets};

// Handle JIP respawn
missionNamespace setVariable ["_initialRespawn", addMissionEventHandler ["PreloadFinished",
{
	if !(getMarkerColor "marker_respawn" == "") then {
		[player, "marker_respawn"] call BIS_fnc_moveToRespawnPosition;
		//player setPos ((getMarkerPos "marker_respawn") getPos [5, random 360]); //initial respawn still exist
	} else {
		[player, leader group player] call BIS_fnc_moveToRespawnPosition;
		//player setPos ((leader group player) getPos [5, random 360]);
	}; //initial respawn don't exist, spawn on group leader

	
	removeMissionEventHandler ["PreloadFinished", missionNamespace getVariable ["_initialRespawn", -1]];
	missionNamespace setVariable ["_initialRespawn", nil];
	
	if (didJIP and (time > 30)) then {
		player enableSimulationGlobal false;
		player enableSimulation false;
		player hideObjectGlobal true;
		player hideObject true;
		forceRespawn player;
		deleteVehicle player;
	};
}]];

// Set available loadout
/*
if (typeOf player == "B_T_Soldier_SL_F") then {
	if (BIS_loadoutLevel == 0) then {[player,"B_SquadLeader"] call BIS_fnc_addRespawninventory; player setUnitLoadout [["arifle_SPAR_01_khk_F","","acc_pointer_IR","optic_ERCO_blk_F",["30Rnd_556x45_Stanag_Tracer_Red",30],[],""],[],["hgun_P07_khk_F","","","",["16Rnd_9x21_Mag",16],[],""],["U_B_T_Soldier_SL_F",[["FirstAidKit",1],["SmokeShell",2,1],["16Rnd_9x21_Mag",2,16]]],["V_PlateCarrierSpec_tna_F",[["30Rnd_556x45_Stanag_Tracer_Red",7,30],["HandGrenade",2,1]]],[],"H_HelmetB_Enh_tna_F",nil,["Rangefinder","","","",[],[],""],["ItemMap","ItemGPS","ItemRadio","ItemCompass","ItemWatch","NVGoggles_tna_F"]]};
	if (BIS_loadoutLevel == 1) then {[player,"B_SquadLeader_L"] call BIS_fnc_addRespawninventory; player setUnitLoadout [["arifle_SPAR_01_khk_F","","acc_flashlight","optic_ERCO_blk_F",["30Rnd_556x45_Stanag_Tracer_Red",30],[],""],[],["hgun_P07_khk_F","","","",["16Rnd_9x21_Mag",16],[],""],["U_B_T_Soldier_SL_F",[["FirstAidKit",1],["SmokeShell",2,1],["16Rnd_9x21_Mag",2,16]]],["V_PlateCarrierSpec_tna_F",[["30Rnd_556x45_Stanag_Tracer_Red",3,30],["HandGrenade",2,1]]],[],"H_HelmetB_Enh_tna_F",nil,["Binocular","","","",[],[],""],["ItemMap","ItemGPS","ItemRadio","ItemCompass","ItemWatch",""]]};
	if (BIS_loadoutLevel == 2) then {[player,"B_SquadLeader_S"] call BIS_fnc_addRespawninventory; player setUnitLoadout [["arifle_SPAR_01_khk_F","","acc_flashlight","",["30Rnd_556x45_Stanag_Tracer_Red",30],[],""],[],["hgun_P07_khk_F","","","",["16Rnd_9x21_Mag",16],[],""],["U_B_T_Soldier_SL_F",[["FirstAidKit",1],["SmokeShell",2,1],["16Rnd_9x21_Mag",2,16]]],["V_PlateCarrierSpec_tna_F",[["30Rnd_556x45_Stanag_Tracer_Red",1,30],["HandGrenade",2,1]]],[],"H_HelmetB_Enh_tna_F",nil,["Binocular","","","",[],[],""],["ItemMap","","ItemRadio","ItemCompass","ItemWatch",""]]};
};

if (typeOf player == "B_T_soldier_M_F") then {
	if (BIS_loadoutLevel == 0) then {[player,"B_Marksman"] call BIS_fnc_addRespawninventory; player setUnitLoadout [["arifle_SPAR_03_khk_F","","acc_pointer_IR","optic_ERCO_blk_F",["20Rnd_762x51_Mag",20],[],"bipod_01_F_blk"],[],["hgun_P07_khk_F","","","",["16Rnd_9x21_Mag",16],[],""],["U_B_T_Soldier_SL_F",[["FirstAidKit",1],["SmokeShell",2,1],["16Rnd_9x21_Mag",2,16]]],["V_PlateCarrier1_tna_F",[["20Rnd_762x51_Mag",7,20],["HandGrenade",2,1]]],[],"H_HelmetB_Light_tna_F",nil,["Rangefinder","","","",[],[],""],["ItemMap","ItemGPS","ItemRadio","ItemCompass","ItemWatch","NVGoggles_tna_F"]]};
	if (BIS_loadoutLevel == 1) then {[player,"B_Marksman_L"] call BIS_fnc_addRespawninventory; player setUnitLoadout [["arifle_SPAR_03_khk_F","","acc_flashlight","optic_ERCO_blk_F",["20Rnd_762x51_Mag",20],[],"bipod_01_F_blk"],[],["hgun_P07_khk_F","","","",["16Rnd_9x21_Mag",16],[],""],["U_B_T_Soldier_SL_F",[["FirstAidKit",1],["SmokeShell",2,1],["16Rnd_9x21_Mag",2,16]]],["V_PlateCarrier1_tna_F",[["20Rnd_762x51_Mag",3,20],["HandGrenade",2,1]]],[],"H_HelmetB_Light_tna_F",nil,["Binocular","","","",[],[],""],["ItemMap","","ItemRadio","ItemCompass","ItemWatch",""]]};
	if (BIS_loadoutLevel == 2) then {[player,"B_Marksman_S"] call BIS_fnc_addRespawninventory; player setUnitLoadout [["arifle_SPAR_03_khk_F","","acc_flashlight","",["20Rnd_762x51_Mag",20],[],"bipod_01_F_blk"],[],["hgun_P07_khk_F","","","",["16Rnd_9x21_Mag",16],[],""],["U_B_T_Soldier_SL_F",[["FirstAidKit",1],["SmokeShell",2,1],["16Rnd_9x21_Mag",2,16]]],["V_PlateCarrier1_tna_F",[["20Rnd_762x51_Mag",1,20],["HandGrenade",2,1]]],[],"H_HelmetB_Light_tna_F",nil,[],["ItemMap","","ItemRadio","ItemCompass","ItemWatch",""]]};
};

if (typeOf player == "B_T_soldier_AR_F") then {
	if (BIS_loadoutLevel == 0) then {[player,"B_Autorifleman"] call BIS_fnc_addRespawninventory; player setUnitLoadout [["arifle_SPAR_02_khk_F","","acc_pointer_IR","optic_Aco",["150Rnd_556x45_Drum_Mag_F",150],[],"bipod_01_F_blk"],[],["hgun_P07_khk_F","","","",["16Rnd_9x21_Mag",16],[],""],["U_B_T_Soldier_AR_F",[["FirstAidKit",1],["SmokeShell",2,1],["16Rnd_9x21_Mag",2,16]]],["V_PlateCarrier2_tna_F",[["150Rnd_556x45_Drum_Mag_F",3,150],["HandGrenade",2,1]]],[],"H_HelmetB_tna_F",nil,[],["ItemMap","ItemGPS","ItemRadio","ItemCompass","ItemWatch","NVGoggles_tna_F"]]};
	if (BIS_loadoutLevel == 1) then {[player,"B_Autorifleman_L"] call BIS_fnc_addRespawninventory; player setUnitLoadout [["arifle_SPAR_02_khk_F","","acc_flashlight","optic_Aco",["150Rnd_556x45_Drum_Mag_F",150],[],"bipod_01_F_blk"],[],["hgun_P07_khk_F","","","",["16Rnd_9x21_Mag",16],[],""],["U_B_T_Soldier_AR_F",[["FirstAidKit",1],["SmokeShell",2,1],["16Rnd_9x21_Mag",2,16]]],["V_PlateCarrier2_tna_F",[["150Rnd_556x45_Drum_Mag_F",1,150],["HandGrenade",2,1]]],[],"H_HelmetB_tna_F",nil,[],["ItemMap","","ItemRadio","ItemCompass","ItemWatch",""]]};
	if (BIS_loadoutLevel == 2) then {[player,"B_Autorifleman_S"] call BIS_fnc_addRespawninventory; player setUnitLoadout [["arifle_SPAR_02_khk_F","","acc_flashlight","",["150Rnd_556x45_Drum_Mag_F",150],[],"bipod_01_F_blk"],[],["hgun_P07_khk_F","","","",["16Rnd_9x21_Mag",16],[],""],["U_B_T_Soldier_AR_F",[["FirstAidKit",1],["SmokeShell",2,1],["16Rnd_9x21_Mag",2,16]]],["V_PlateCarrier2_tna_F",[["HandGrenade",2,1]]],[],"H_HelmetB_tna_F",nil,[],["ItemMap","","ItemRadio","ItemCompass","ItemWatch",""]]};
};

if (typeOf player == "B_T_soldier_GL_F") then {
	if (BIS_loadoutLevel == 0) then {[player,"B_Grenadier"] call BIS_fnc_addRespawninventory; player setUnitLoadout [["arifle_SPAR_01_GL_khk_F","","acc_pointer_IR","optic_Aco",["30Rnd_556x45_Stanag_red",30],["1Rnd_HE_Grenade_shell",1],""],[],["hgun_P07_khk_F","","","",["16Rnd_9x21_Mag",16],[],""],["U_B_T_Soldier_AR_F",[["FirstAidKit",1],["SmokeShell",2,1],["16Rnd_9x21_Mag",2,16]]],["V_PlateCarrierGL_tna_F",[["30Rnd_556x45_Stanag_red",7,30],["HandGrenade",2,1],["1Rnd_HE_Grenade_shell",5,1]]],[],"H_HelmetB_tna_F",nil,[],["ItemMap","ItemGPS","ItemRadio","ItemCompass","ItemWatch","NVGoggles_tna_F"]]};
	if (BIS_loadoutLevel == 1) then {[player,"B_Grenadier_L"] call BIS_fnc_addRespawninventory; player setUnitLoadout [["arifle_SPAR_01_GL_khk_F","","acc_flashlight","optic_Aco",["30Rnd_556x45_Stanag_red",30],["1Rnd_HE_Grenade_shell",1],""],[],["hgun_P07_khk_F","","","",["16Rnd_9x21_Mag",16],[],""],["U_B_T_Soldier_AR_F",[["FirstAidKit",1],["SmokeShell",2,1],["16Rnd_9x21_Mag",2,16]]],["V_PlateCarrierGL_tna_F",[["30Rnd_556x45_Stanag_red",3,30],["HandGrenade",2,1],["1Rnd_HE_Grenade_shell",3,1]]],[],"H_HelmetB_tna_F",nil,[],["ItemMap","","ItemRadio","ItemCompass","ItemWatch",""]]};
	if (BIS_loadoutLevel == 2) then {[player,"B_Grenadier_S"] call BIS_fnc_addRespawninventory; player setUnitLoadout [["arifle_SPAR_01_GL_khk_F","","acc_flashlight","",["30Rnd_556x45_Stanag_red",30],["1Rnd_HE_Grenade_shell",1],""],[],["hgun_P07_khk_F","","","",["16Rnd_9x21_Mag",16],[],""],["U_B_T_Soldier_AR_F",[["FirstAidKit",1],["SmokeShell",2,1],["16Rnd_9x21_Mag",2,16]]],["V_PlateCarrierGL_tna_F",[["30Rnd_556x45_Stanag_red",1,30],["HandGrenade",2,1],["1Rnd_HE_Grenade_shell",1,1]]],[],"H_HelmetB_tna_F",nil,[],["ItemMap","","ItemRadio","ItemCompass","ItemWatch",""]]};
};

if (typeOf player == "B_T_soldier_F") then {
	if (BIS_loadoutLevel == 0) then {[player,"B_Rifleman"] call BIS_fnc_addRespawninventory; player setUnitLoadout [["arifle_SPAR_01_khk_F","","acc_pointer_IR","optic_Aco",["30Rnd_556x45_Stanag_red",30],[],""],[],["hgun_P07_khk_F","","","",["16Rnd_9x21_Mag",16],[],""],["U_B_T_Soldier_AR_F",[["FirstAidKit",1],["SmokeShell",2,1],["16Rnd_9x21_Mag",2,16]]],["V_PlateCarrier2_tna_F",[["30Rnd_556x45_Stanag_red",7,30],["HandGrenade",2,1]]],[],"H_HelmetB_tna_F",nil,[],["ItemMap","ItemGPS","ItemRadio","ItemCompass","ItemWatch","NVGoggles_tna_F"]]};
	if (BIS_loadoutLevel == 1) then {[player,"B_Rifleman_L"] call BIS_fnc_addRespawninventory; player setUnitLoadout [["arifle_SPAR_01_khk_F","","acc_flashlight","optic_Aco",["30Rnd_556x45_Stanag_red",30],[],""],[],["hgun_P07_khk_F","","","",["16Rnd_9x21_Mag",16],[],""],["U_B_T_Soldier_AR_F",[["FirstAidKit",1],["SmokeShell",2,1],["16Rnd_9x21_Mag",2,16]]],["V_PlateCarrier2_tna_F",[["30Rnd_556x45_Stanag_red",3,30],["HandGrenade",2,1]]],[],"H_HelmetB_tna_F",nil,[],["ItemMap","","ItemRadio","ItemCompass","ItemWatch",""]]};
	if (BIS_loadoutLevel == 2) then {[player,"B_Rifleman_S"] call BIS_fnc_addRespawninventory; player setUnitLoadout [["arifle_SPAR_01_khk_F","","acc_flashlight","",["30Rnd_556x45_Stanag_red",30],[],""],[],["hgun_P07_khk_F","","","",["16Rnd_9x21_Mag",16],[],""],["U_B_T_Soldier_AR_F",[["FirstAidKit",1],["SmokeShell",2,1],["16Rnd_9x21_Mag",2,16]]],["V_PlateCarrier2_tna_F",[["30Rnd_556x45_Stanag_red",1,30],["HandGrenade",2,1]]],[],"H_HelmetB_tna_F",nil,[],["ItemMap","","ItemRadio","ItemCompass","ItemWatch",""]]};
};

if (typeOf player == "B_T_soldier_LAT_F") then {
	if (BIS_loadoutLevel == 0) then {[player,"B_AT"] call BIS_fnc_addRespawninventory; player setUnitLoadout [["arifle_SPAR_01_khk_F","","acc_pointer_IR","optic_Aco",["30Rnd_556x45_Stanag_red",30],[],""],["launch_NLAW_F","","","",["NLAW_F",1],[],""],["hgun_P07_khk_F","","","",["16Rnd_9x21_Mag",16],[],""],["U_B_T_Soldier_AR_F",[["FirstAidKit",1],["16Rnd_9x21_Mag",2,16],["SmokeShell",2,1]]],["V_PlateCarrier2_tna_F",[["30Rnd_556x45_Stanag_red",7,30],["HandGrenade",2,1]]],["B_AssaultPack_tna_F",[["NLAW_F",1,1]]],"H_HelmetB_tna_F",nil,[],["ItemMap","","ItemRadio","ItemCompass","ItemWatch","NVGoggles_tna_F"]]};
	if (BIS_loadoutLevel == 1) then {[player,"B_AT_L"] call BIS_fnc_addRespawninventory; player setUnitLoadout [["arifle_SPAR_01_khk_F","","acc_flashlight","optic_Aco",["30Rnd_556x45_Stanag_red",30],[],""],["launch_NLAW_F","","","",["NLAW_F",1],[],""],["hgun_P07_khk_F","","","",["16Rnd_9x21_Mag",16],[],""],["U_B_T_Soldier_AR_F",[["FirstAidKit",1],["16Rnd_9x21_Mag",2,16],["SmokeShell",2,1]]],["V_PlateCarrier2_tna_F",[["30Rnd_556x45_Stanag_red",3,30],["HandGrenade",2,1]]],["B_AssaultPack_tna_F",[["NLAW_F",1,1]]],"H_HelmetB_tna_F",nil,[],["ItemMap","","ItemRadio","ItemCompass","ItemWatch",""]]};
	if (BIS_loadoutLevel == 2) then {[player,"B_AT_S"] call BIS_fnc_addRespawninventory; player setUnitLoadout [["arifle_SPAR_01_khk_F","","acc_flashlight","",["30Rnd_556x45_Stanag_red",30],[],""],["launch_NLAW_F","","","",["NLAW_F",1],[],""],["hgun_P07_khk_F","","","",["16Rnd_9x21_Mag",16],[],""],["U_B_T_Soldier_AR_F",[["FirstAidKit",1],["16Rnd_9x21_Mag",2,16],["SmokeShell",2,1]]],["V_PlateCarrier2_tna_F",[["30Rnd_556x45_Stanag_red",1,30],["HandGrenade",2,1]]],["B_AssaultPack_tna_F",[["NLAW_F",1,1]]],"H_HelmetB_tna_F",nil,[],["ItemMap","","ItemRadio","ItemCompass","ItemWatch",""]]};
};

if (typeOf player == "B_T_engineer_F") then {
	if (BIS_loadoutLevel == 0) then {[player,"B_Engineer"] call BIS_fnc_addRespawninventory; player setUnitLoadout [["arifle_SPAR_01_khk_F","","acc_pointer_IR","optic_Aco",["30Rnd_556x45_Stanag_red",30],[],""],[],["hgun_P07_khk_F","","","",["16Rnd_9x21_Mag",16],[],""],["U_B_T_Soldier_AR_F",[["FirstAidKit",1],["SmokeShell",2,1],["16Rnd_9x21_Mag",2,16]]],["V_PlateCarrier1_tna_F",[["30Rnd_556x45_Stanag_red",7,30]]],["B_AssaultPack_tna_F",[["ToolKit",1],["MineDetector",1],["DemoCharge_Remote_Mag",2,1]]],"H_HelmetB_Light_tna_F",nil,[],["ItemMap","ItemGPS","ItemRadio","ItemCompass","ItemWatch","NVGoggles_tna_F"]]};
	if (BIS_loadoutLevel == 1) then {[player,"B_Engineer_L"] call BIS_fnc_addRespawninventory; player setUnitLoadout [["arifle_SPAR_01_khk_F","","acc_flashlight","optic_Aco",["30Rnd_556x45_Stanag_red",30],[],""],[],["hgun_P07_khk_F","","","",["16Rnd_9x21_Mag",16],[],""],["U_B_T_Soldier_AR_F",[["FirstAidKit",1],["SmokeShell",2,1],["16Rnd_9x21_Mag",2,16]]],["V_PlateCarrier1_tna_F",[["30Rnd_556x45_Stanag_red",3,30]]],["B_AssaultPack_tna_F",[["ToolKit",1],["MineDetector",1],["DemoCharge_Remote_Mag",2,1]]],"H_HelmetB_Light_tna_F",nil,[],["ItemMap","","ItemRadio","ItemCompass","ItemWatch",""]]};
	if (BIS_loadoutLevel == 2) then {[player,"B_Engineer_S"] call BIS_fnc_addRespawninventory; player setUnitLoadout [["arifle_SPAR_01_khk_F","","acc_flashlight","",["30Rnd_556x45_Stanag_red",30],[],""],[],["hgun_P07_khk_F","","","",["16Rnd_9x21_Mag",16],[],""],["U_B_T_Soldier_AR_F",[["FirstAidKit",1],["SmokeShell",2,1],["16Rnd_9x21_Mag",2,16]]],["V_PlateCarrier1_tna_F",[["30Rnd_556x45_Stanag_red",1,30]]],["B_AssaultPack_tna_F",[["ToolKit",1],["MineDetector",1],["DemoCharge_Remote_Mag",2,1]]],"H_HelmetB_Light_tna_F",nil,[],["ItemMap","","ItemRadio","ItemCompass","ItemWatch",""]]};
};

if (typeOf player == "B_T_medic_F") then {
	if (BIS_loadoutLevel == 0) then {[player,"B_CombatLifesaver"] call BIS_fnc_addRespawninventory; player setUnitLoadout [["arifle_SPAR_01_khk_F","","acc_pointer_IR","optic_Aco",["30Rnd_556x45_Stanag_red",30],[],""],[],["hgun_P07_khk_F","","","",["16Rnd_9x21_Mag",16],[],""],["U_B_T_Soldier_SL_F",[["FirstAidKit",1],["SmokeShellBlue",4,1],["16Rnd_9x21_Mag",2,16]]],["V_PlateCarrierSpec_tna_F",[["30Rnd_556x45_Stanag_red",7,30]]],["B_AssaultPack_tna_F",[["Medikit",1]]],"H_HelmetB_Enh_tna_F",nil,[],["ItemMap","ItemGPS","ItemRadio","ItemCompass","ItemWatch","NVGoggles_tna_F"]]};
	if (BIS_loadoutLevel == 1) then {[player,"B_CombatLifesaver_L"] call BIS_fnc_addRespawninventory; player setUnitLoadout [["arifle_SPAR_01_khk_F","","acc_flashlight","optic_Aco",["30Rnd_556x45_Stanag_red",30],[],""],[],["hgun_P07_khk_F","","","",["16Rnd_9x21_Mag",16],[],""],["U_B_T_Soldier_SL_F",[["FirstAidKit",1],["SmokeShellBlue",4,1],["16Rnd_9x21_Mag",2,16]]],["V_PlateCarrierSpec_tna_F",[["30Rnd_556x45_Stanag_red",3,30]]],["B_AssaultPack_tna_F",[["Medikit",1]]],"H_HelmetB_Enh_tna_F",nil,[],["ItemMap","","ItemRadio","ItemCompass","ItemWatch",""]]};
	if (BIS_loadoutLevel == 2) then {[player,"B_CombatLifesaver_S"] call BIS_fnc_addRespawninventory; player setUnitLoadout [["arifle_SPAR_01_khk_F","","acc_flashlight","",["30Rnd_556x45_Stanag_red",30],[],""],[],["hgun_P07_khk_F","","","",["16Rnd_9x21_Mag",16],[],""],["U_B_T_Soldier_SL_F",[["FirstAidKit",1],["SmokeShellBlue",4,1],["16Rnd_9x21_Mag",2,16]]],["V_PlateCarrierSpec_tna_F",[["30Rnd_556x45_Stanag_red",1,30]]],["B_AssaultPack_tna_F",[["Medikit",1]]],"H_HelmetB_Enh_tna_F",nil,[],["ItemMap","","ItemRadio","ItemCompass","ItemWatch",""]]};
};
*/


//NNS : Add respawn inventories
if (BIS_loadoutLevel == 0 || {typeOf player == "B_T_Soldier_SL_F"}) then {[player,"B_SquadLeader"] call BIS_fnc_addRespawninventory};
if (BIS_loadoutLevel == 0 || {typeOf player == "B_T_soldier_M_F"}) then {[player,"B_Marksman"] call BIS_fnc_addRespawninventory};
if (BIS_loadoutLevel == 0 || {typeOf player == "B_T_soldier_AR_F"}) then {[player,"B_Autorifleman"] call BIS_fnc_addRespawninventory};
if (BIS_loadoutLevel == 0 || {typeOf player == "B_T_soldier_GL_F"}) then {[player,"B_Grenadier"] call BIS_fnc_addRespawninventory};
if (BIS_loadoutLevel == 0 || {typeOf player == "B_T_soldier_F"}) then {[player,"B_Rifleman"] call BIS_fnc_addRespawninventory};
if (BIS_loadoutLevel == 0 || {typeOf player == "B_T_soldier_LAT_F"}) then {[player,"B_AT"] call BIS_fnc_addRespawninventory};
if (BIS_loadoutLevel == 0 || {typeOf player == "B_T_engineer_F"}) then {[player,"B_Engineer"] call BIS_fnc_addRespawninventory};
if (BIS_loadoutLevel == 0 || {typeOf player == "B_T_medic_F"}) then {[player,"B_CombatLifesaver"] call BIS_fnc_addRespawninventory};
if (BIS_loadoutLevel == 0) then {[player,"B_Saved_Loadout"] call BIS_fnc_addRespawninventory};

//NNS : Player loadout from server selection
if (typeOf player == "B_T_Soldier_SL_F") then {player setUnitLoadout (missionConfigFile >> "CfgRespawnInventory" >> "B_SquadLeader");};
if (typeOf player == "B_T_soldier_M_F") then {player setUnitLoadout (missionConfigFile >> "CfgRespawnInventory" >> "B_Marksman");};
if (typeOf player == "B_T_soldier_AR_F") then {player setUnitLoadout (missionConfigFile >> "CfgRespawnInventory" >> "B_Autorifleman");};
if (typeOf player == "B_T_soldier_GL_F") then {player setUnitLoadout (missionConfigFile >> "CfgRespawnInventory" >> "B_Grenadier");};
if (typeOf player == "B_T_soldier_F") then {player setUnitLoadout (missionConfigFile >> "CfgRespawnInventory" >> "B_Rifleman");};
if (typeOf player == "B_T_soldier_LAT_F") then {player setUnitLoadout (missionConfigFile >> "CfgRespawnInventory" >> "B_AT");};
if (typeOf player == "B_T_engineer_F") then {player setUnitLoadout (missionConfigFile >> "CfgRespawnInventory" >> "B_Engineer");};
if (typeOf player == "B_T_medic_F") then {player setUnitLoadout (missionConfigFile >> "CfgRespawnInventory" >> "B_CombatLifesaver");};

_null = execVM 'scripts\PlayerLimitEquipment.sqf'; //NNS : Limit equipment

//NNS : backup loadout
[] spawn {while {sleep 5; true} do {if (alive player && {(getDammage player) < 0.9}) then {player setVariable["tmp_saved_loadout",getUnitLoadout player]}}}; //NNS : save previous loadout

//NNS : stats : track distance traveled
[] spawn {
	player setVariable ["distance_traveled",[0,0]]; //foot, vehicle
	player setVariable ["distance_traveled_suspended",false]; //suspended if just respawned
	while {true} do {
		_oldPos = getPos player; sleep 5; //backup and wait 5 sec
		_distance = floor (_oldPos distance2D (getPos player)); //distance traveled
		_suspend = player getVariable ["distance_traveled_suspended",false]; //is suspended for 11sec if just respawned
		if (_distance > 0 && {_distance < 556} &&  {!_suspend}) then { //only log if player is alive and traveled distance not too excessive (200km/h)
			_distance_traveled = player getVariable ["distance_traveled",[0,0]]; //recover old value
			if (vehicle player == player) then { _new_distance = (_distance_traveled select 0) + _distance; _distance_traveled set [0, _new_distance]; //not in vehicle
			} else {_new_distance = (_distance_traveled select 1) + _distance; _distance_traveled set [1, _new_distance]}; //in vehicle
			player setVariable ["distance_traveled",_distance_traveled]; //update var
		};
	};
};

//NNS : stats : track ammo used
player setVariable ["shot_fired",[0,0,0,0,0]]; //bullet, grenade, smoke, rocket, from vehicle
player addeventhandler ["FiredMan", { //ammo not in grenades,smokes,missile are considered as bullets
	_shot_fired = player getVariable "shot_fired"; //recover old value
	if (vehicle player == player) then { // player not in vehicle
		_ammo_alloc = false; //right list found
		_list_grenades = ["G_40mm_HE","GrenadeHand","mini_Grenade"];
		_list_smokes = ["G_40mm_Smoke","G_40mm_SmokeRed","G_40mm_SmokeGreen","G_40mm_SmokeYellow","G_40mm_SmokePurple","G_40mm_SmokeBlue","G_40mm_SmokeOrange","SmokeShell","SmokeShellRed","SmokeShellGreen","SmokeShellYellow","SmokeShellPurple","SmokeShellBlue","SmokeShellOrange"];
		_list_rockets = ["R_PG32V_F","R_TBG32V_F","M_NLAW_AT_F","M_Titan_AA","M_Titan_AP","M_Titan_AT","M_Titan_AA_long","M_Titan_AT_long","M_Titan_AA_static","M_Titan_AT_static","R_PG7_F","R_MRAAWS_HEAT_F","R_MRAAWS_HE_F","R_MRAAWS_HEAT55_F"];
		if ((_this select 4) in _list_grenades) then {_ammo_alloc=true; _shot_fired set [1, (_shot_fired select 1) + 1]}; //grenade
		if ((_this select 4) in _list_smokes) then {_ammo_alloc=true; _shot_fired set [2, (_shot_fired select 2) + 1]}; //smoke
		if ((_this select 4) in _list_rockets) then {_ammo_alloc=true; _shot_fired set [3, (_shot_fired select 3) + 1]}; //rocket
		if (!_ammo_alloc) then {_shot_fired set [0, (_shot_fired select 0) + 1]} //random ammo
	} else {_shot_fired set [4, (_shot_fired select 4) + 1]}; //update shot from vehicle
	player setVariable ["shot_fired",_shot_fired]; //update var
}];

//NNS : stats : set public stats accessible from map, restore stats from server if player connect back
[] spawn {
	while {sleep 10; true} do {
		if !(player getVariable ["statsSrv",false]) then { //stats not sync from server
			_shot_fired = player getVariable ["shot_fired",[0,0,0,0,0]]; //bullet, grenade, smoke, rocket, from vehicle
			_distance_traveled = player getVariable ["distance_traveled",[0,0]]; //foot, vehicle
			player setVariable ["stats", [_shot_fired,_distance_traveled], true]; //public
		} else { //stats sync from server
			_serverStats = player getVariable ["stats", [[0,0,0,0,0],[0,0]]]; //recover stats by server
			player setVariable ["shot_fired",_serverStats select 0]; //bullet, grenade, smoke, rocket, from vehicle
			player setVariable ["distance_traveled",_serverStats select 1]; //foot, vehicle
			player setVariable ["statsSrv", false]; //reset sync from server bool
		};
	};
};

//NNS : stats : get players stats when map opened
addMissionEventHandler ["Map", {
	params ["_mapIsOpened", "_mapIsForced"];
	
	if (_mapIsOpened) then {
		if !(player getVariable ["DiaryResized",false]) then { //increase diary width, can cause problem with low resolution
			_diaryWidthFactor = 1.4;
			_mapDisplay = findDisplay 12;
			{
				_diaryCtrl = _mapDisplay displayCtrl _x;
				_diaryPos = ctrlPosition _diaryCtrl;
				_diaryCtrl ctrlSetPosition [_diaryPos select 0, _diaryPos select 1, (_diaryPos select 2) * _diaryWidthFactor, _diaryPos select 3];
				_diaryCtrl ctrlCommit 0;
			} forEach [1003,1013,1023]; //CA_Diary, CA_DiaryGroup, CA_ContentBackgroundd
			player setVariable ["DiaryResized",true];
		};
		
		private _nullRecord = objNull createDiaryRecord []; //"declare" _nullRecord
		_record = player getVariable ["TeamStatsRecord",_nullRecord]; //recover record
		if (!(player diarySubjectExists "TeamStats")) then {player createDiarySubject ["TeamStats", localize "STR_NNS_Debrif_Stats_title"];}; //subject not exist, create it
		if (_record isEqualTo _nullRecord) then { //record not exist
			_record = player createDiaryRecord ["TeamStats", [localize "STR_NNS_Debrif_Stats_team", localize "STR_NNS_Debrif_Stats_nodata"], taskNull, "", false]; //create record
			player setVariable ["TeamStatsRecord", _record]; //backup record
		};
		
		if !(_record isEqualTo _nullRecord) then { //record not null
			_players_stats = []; //store array
			_shot_fired_group = [0,0,0,0,0]; //store used ammo for whole group
			
			{ //players loop
				_tmpStats = _x getVariable ["stats",[[0,0,0,0,0],[0,0]]]; //recover player stats
				if (count _tmpStats == 2) then {
					_players_stats pushBack format["<font color='#99ffffff'>%1:</font><br/>",name _x]; //player name
					
					_shot_fired = _tmpStats select 0;
					_shot_fired_group set [0, (_shot_fired_group select 0) + (_shot_fired select 0)]; _shot_fired_group set [1, (_shot_fired_group select 1) + (_shot_fired select 1)]; _shot_fired_group set [2, (_shot_fired_group select 2) + (_shot_fired select 2)]; _shot_fired_group set [3, (_shot_fired_group select 3) + (_shot_fired select 3)]; _shot_fired_group set [4, (_shot_fired_group select 4) + (_shot_fired select 4)];
					_players_stats pushBack format[localize "STR_NNS_Debriefing_AmmoUsed_title",(_shot_fired select 0),["","s"] select ((_shot_fired select 0) > 1),
					[format[localize "STR_NNS_Debriefing_AmmoUsed_HEgrenades",(_shot_fired select 1),["","s"] select ((_shot_fired select 1) > 1)], ""] select ((_shot_fired select 1) == 0),
					[format[localize "STR_NNS_Debriefing_AmmoUsed_SmokeGrenade",(_shot_fired select 2),["","s"] select ((_shot_fired select 2) > 1)], ""] select ((_shot_fired select 2) == 0),
					[format[localize "STR_NNS_Debriefing_AmmoUsed_Rockets",(_shot_fired select 3),["","s"] select ((_shot_fired select 3) > 1)], ""] select ((_shot_fired select 3) == 0),
					[format[localize "STR_NNS_Debriefing_AmmoUsed_Vehicle",(_shot_fired select 4),["","s"] select ((_shot_fired select 4) > 1)], ""] select ((_shot_fired select 4) == 0)];
					_players_stats pushBack "<br/>"; //linebreak
					
					_distance_traveled = _tmpStats select 1;
					_players_stats pushBack format[localize "STR_NNS_Debriefing_DistanceTravel_title",round (_distance_traveled select 0),
					[format[localize "STR_NNS_Debriefing_DistanceTravel_vehicle",round (_distance_traveled select 1),round ((_distance_traveled select 0)+(_distance_traveled select 1))], ""] select (round (_distance_traveled select 1) == 0)]; //distance traveled
					_players_stats pushBack "<img image='#(argb,8,8,3)color(1,1,1,0.1)' height='1' width='640' /><br/>"; //linebreak
				};
			} forEach allPlayers;
			
			if (count _players_stats > 0) then { //some data recovered, compile group data
				_players_stats pushBack format["<font color='#99ffffff'>%1:</font><br/>",localize "STR_NNS_Debriefing_GroupStats_title"]; //title
				_players_stats pushBack format[localize "STR_NNS_Debriefing_AmmoUsed_title",(_shot_fired_group select 0),["","s"] select ((_shot_fired_group select 0) > 1),
				[format[localize "STR_NNS_Debriefing_AmmoUsed_HEgrenades",(_shot_fired_group select 1),["","s"] select ((_shot_fired_group select 1) > 1)], ""] select ((_shot_fired_group select 1) == 0),
				[format[localize "STR_NNS_Debriefing_AmmoUsed_SmokeGrenade",(_shot_fired_group select 2),["","s"] select ((_shot_fired_group select 2) > 1)], ""] select ((_shot_fired_group select 2) == 0),
				[format[localize "STR_NNS_Debriefing_AmmoUsed_Rockets",(_shot_fired_group select 3),["","s"] select ((_shot_fired_group select 3) > 1)], ""] select ((_shot_fired_group select 3) == 0),
				[format[localize "STR_NNS_Debriefing_AmmoUsed_Vehicle",(_shot_fired_group select 4),["","s"] select ((_shot_fired_group select 4) > 1)], ""] select ((_shot_fired_group select 4) == 0)];
				
				player setDiaryRecordText [["TeamStats", _record], [localize "STR_NNS_Debrif_Stats_team", _players_stats joinString ""]];
			};
		};
	};
}];

//NNS: punish teamkiller
if (missionNamespace getVariable ["BIS_TKpunish",false]) then {
	[] spawn {
		while {sleep 10; true} do {
			if !(rating player < 0) then {player addRating -(rating player)}; //reset player rating
			if ((rating player < -2000) && {vehicle player == player}) then { //renegade and not in vehicle
				if (([west] call BIS_fnc_respawnTickets) != -1) then {[west,1] call BIS_fnc_respawnTickets;}; //team based tickets, increse tickets by one to not punish whole team
				[player, nil, true] spawn BIS_fnc_moduleLightning; //zeus punishment
				player setDamage 1; //kill player
			};
		};
	};
};
