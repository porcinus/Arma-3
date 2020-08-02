params [
	["_track", "", [""]],
	["_volume", -1, [0]]
];

// Set volume if necessary
if (_volume >= 0) then {0 fadeMusic _volume};

// Play track
playMusic _track;

true