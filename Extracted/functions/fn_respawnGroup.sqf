params [["_newUnit", objNull], ["_oldUnit", objNull]];
if (isNull _newUnit || isNull _oldUnit) exitWith {};

// must be spawned
if (!canSuspend) exitWith {};

// create transition camera
private _cam = "camera" camCreate [0, 0, 0];

// focus on old unit
_cam camSetTarget vehicle _oldUnit;
_cam camSetRelPos [-0.82, 3.12, 3.38];
_cam camSetFOV 0.3;
_cam camCommit 0;

// switch to cinema mode
_cam cameraEffect ["External", "Back"];

// get sound from old location
switchCamera _oldUnit;

// prepare scene at the location of new unit
preloadCamera (vehicle _newUnit modelToWorld [-3.5, 2.96, 6.48]);
2 preloadObject vehicle _newUnit;	

// zoom out
_cam camSetRelPos [-3.5, -2.96, 6.48];
_cam camSetFOV 0.8;
_cam camCommit 4;

// camera transition routine
sleep 3.5;
titleCut ["", "BLACK OUT", 0.5];

waituntil {camCommitted _cam};

// focus on new unit
_cam camSetTarget vehicle _newUnit;
_cam camSetRelPos [-3.5, 2.96, 6.48];
_cam camSetFOV 0.8;
_cam camCommit 0;

titleCut ["", "BLACK IN", 0.5];

// get sound from new location
switchCamera _newUnit;

// zoom in
_cam camSetRelPos [-0.82, -3.12, 3.38];
_cam camSetFOV 0.3;
_cam camCommit 3;

waituntil {camCommitted _cam};

_oldUnit cameraEffect ["Terminate", "Back"];
camDestroy _cam;

if (!isNil "BIS_DeathBlur" && {BIS_DeathBlur isEqualType 0} && {ppEffectEnabled BIS_DeathBlur}) then
{
	BIS_DeathBlur ppEffectAdjust [0];
	BIS_DeathBlur ppEffectCommit 0.5;
};
