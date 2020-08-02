params [
	["_track", "", [""]],
	["_volume", -1, [0]],
	["_commit", 0, [0]]
];

// Set volume if necessary
if (_volume >= 0) then {_commit fadeMusic _volume};

// Play track
if (_track != "") then {playMusic _track};

true