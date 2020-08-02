params [
	["_track", "", [""]],
	["_volume", -1, [0]]
];

// Ensure no music is currently playing
waitUntil {!(missionNamespace getVariable ["BIS_fnc_EXP_m07_playMusic_musicPlaying", false])};

// Register that music is playing
BIS_fnc_EXP_m07_playMusic_musicPlaying = true;

// Set volume if necessary
if (_volume >= 0) then {0 fadeMusic _volume};

// Play track
playMusic _track;

// Detect when it ends
BIS_fnc_EXP_m07_playMusic_musicEH = addMusicEventHandler [
	"MusicStop",
	{
		// Remove event handler
		removeMusicEventHandler ["MusicStop", BIS_fnc_EXP_m07_playMusic_musicEH];
		
		// Register that the music stopped
		BIS_fnc_EXP_m07_playMusic_musicPlaying = false;
	}
];

true