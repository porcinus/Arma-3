params [["_color", "WHITE", [""]], "_pos", "_duration", "_3D"];

private ["_group", "_logic"];
_group = grpNull;
_logic = objNull;

if (!(_3D)) then {
	// Sound is played in 2D space
	[true, "BIS_fnc_EXP_m04_flareSound"] call BIS_fnc_MP;
} else {
	// Sound is played in 3D space
	// Ensure the logic is on the ground (improves audibility of sound)
	private _logicPos = +_pos;
	_logicPos set [2, 0];

	// Create fake logic to play sound on
	_group = createGroup sideLogic;
	_logic = _group createUnit ["Logic", _logicPos, [], 0, "NONE"];
	_logic setPosATL _logicPos;

	// Play sound on logic
	[[false, _logic], "BIS_fnc_EXP_m04_flareSound"] call BIS_fnc_MP;
};

// Let sound reach appropriate point
sleep 2.2;

// Determine flare class based on color
private _class = "F_20mm_White_Infinite";
if (_color == "RED") then {_class = "F_20mm_Red_Infinite"};

// Create flare
private _flare = createVehicle [_class, _pos, [], 0, "NONE"];
_flare setPosATL _pos;
_flare setVelocity [0,0,-1];

// Manage fake sound effect
_flare spawn {
	scriptName format ["BIS_fnc_EXP_m04_flareCreate: sound source control - %1", _this];

	params ["_flare"];

	// Create sound source
	private _sound = createSoundSource ["SoundFlareLoop_F", getPosATL _flare, [], 0];

	// Make it move with the flare
	while {!(isNull _flare)} do {
		_sound setPosATL (getPosATL _flare);
		sleep 0.05;
	};

	// Delete after flare disappears
	deleteVehicle _sound;
};

// Create light source for fake light
private _light = createVehicle ["#lightpoint", _pos, [], 0, "NONE"];
_light lightAttachObject [_flare, [0,0,0]];

// Broadcast new array
BIS_newFlare = [_flare, _light];
publicVariable "BIS_newFlare";

// Handle on server
["UPDATE", BIS_newFlare] call BIS_fnc_EXP_m04_flareInit;

// Wait for defined duration
sleep _duration;

// Delete flare and fake light
{deleteVehicle _x} forEach [_flare, _light];

// Delete logic and group if necessary
if (!(isNull _logic)) then {deleteVehicle _logic};
if (!(isNull _group)) then {deleteGroup _group};

true