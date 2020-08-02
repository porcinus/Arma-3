// Disable everything other than dialogues
enableSentences false;

if (!(isDedicated)) then {
	if (alive player) then {
		// Disable & reset damage, move out of incapacitated state
		player setCaptive true;
		player allowDamage false;
		player setDamage 0;
		player setUnconscious false;
		["",0,player] call bis_fnc_reviveOnState;
		player setVariable ["#rev", 0, true];
	};

	// Fade out
	[] spawn {
		disableSerialization;
		scriptName "BIS_fnc_EXP_m04_feed3: fade out";
		("BIS_fnc_EXP_m04_feed3_layerBlackScreen" call BIS_fnc_rscLayer) cutText ["", "BLACK OUT", 1];
	};
};

sleep 1;

if (!(isDedicated)) then {
	// Fade out sound
	10 fadeSound 0;

	// Play video
	["\a3\missions_f_exp\video\exp_m04_v03.ogv"] spawn BIS_fnc_playVideo;
};

sleep 0.1;

// Play conversation
if (isServer) then {"65_Feed_Start" spawn BIS_fnc_missionConversations};

sleep 16;

if (isServer) then {
	// Terminate feed
	BIS_feed3End = true;
};

true