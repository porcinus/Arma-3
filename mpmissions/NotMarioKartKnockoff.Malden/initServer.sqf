if (isNil "DebugMenu_level") then {missionNamespace setVariable ["DebugMenu_level","none",true]}; //used when description.ext debug entry disable
if (isNil "DebugOutputs_enable") then {missionNamespace setVariable ["DebugOutputs_enable",false,true]}; //used when description.ext debug entry disable
if (isNil "DebugOutputs_Chatbox") then {missionNamespace setVariable ["DebugOutputs_Chatbox",false,true]}; //used when description.ext debug entry disable
if (isNil "DebugOutputs_Logs") then {missionNamespace setVariable ["DebugOutputs_Logs",false,true]}; //used when description.ext debug entry disable


//Not Mario Kart Knockoff
[] spawn {
	_kartsList = [MKK_kart_0, MKK_kart_1, MKK_kart_2, MKK_kart_3,
								MKK_kart_4, MKK_kart_5, MKK_kart_6, MKK_kart_7,
								MKK_kart_8, MKK_kart_9, MKK_kart_10, MKK_kart_11,
								MKK_kart_12, MKK_kart_13, MKK_kart_14, MKK_kart_15];
	
	_syncUnits = [MKK_Area_0,
								MKK_Area_1,
								MKK_Area_2,
								MKK_Area_3,
								MKK_Area_4,
								MKK_Area_5,
								MKK_Area_6,
								MKK_Area_7];
	
	[_kartsList, _syncUnits] execVM "notMarioKartKnockoff\notMarioKartKnockoff.sqf";
};
