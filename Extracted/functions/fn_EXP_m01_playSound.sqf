params [
	["_sound", "", [""]],
	["_target", objNull, [objNull]]
];

if (isNull _target) then {
	// Play in 2D
	playSound [_sound, true];
} else {
	// Play it from the target
	_target say3D _sound;
};

true