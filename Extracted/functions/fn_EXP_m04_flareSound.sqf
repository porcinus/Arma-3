params ["_2D", "_logic"];

// Fake sound of flare launching and popping
private _sound = "EXP_m04_flare";

if (_2D) then {
	// Play sound in 2D space
	playSound [_sound, true];
} else {
	// Play sound on logic
	_logic say3D _sound;
};

true