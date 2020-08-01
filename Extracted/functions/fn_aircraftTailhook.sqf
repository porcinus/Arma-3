/*
	Author: Bravo Zero One development
	- John_Spartan

	Description:
	Aircrfat carrier arrest/recovery function for USS Freedom aircraft carrier

	Exucution:
	Call the function via user-action or script for any compatible fixed wing aircrfat
	[this] spawn bis_fnc_aircraftTailhook;

	Requirments:
	- Compatible aircrfat must have an animation for arrest/tail hook selection defined in CfgCehicles and modeled in 3D model (model.cfg)
	- Compatible aircrfat must have a memory point for cable attach position

	example of cfgVehicles subclass definitions;

		tailHook = true;																			Allow to land on carrier
		class CarrierOpsCompatability
		{
			ArrestHookAnimationList[] = {"tailhook", "tailhook_door_l", "tailhook_door_r"};			List of animation played to animate tailhook. Defined in model.cfg (type user)
			ArrestHookAnimationStates[] = {0,0.53,1};												Tailhook animation states when down, hooked, up.
			ArrestHookMemoryPoint = "pos_tailhook";													TailHook memory point in plane model.p3d
			ArrestMaxAllowedSpeed = 275;															Max speed km/h allowed for successful landing
			ArrestSlowDownStep = 0.8;																Simulation step for calcualting how smooth plane will be slowed down.
			ArrestVelocityReduction = -12;															Speed reduced per simulation step

		};

	Parameter(s):
		_this select 0: mode (Scalar)
		0: plane/object


	Returns: nothing
	Result: Aircrfat after touch down on carrier deck will be dynamicly slowed down. If speed willbe above 275 km/h (suggested and configured on vanilla assets) wire snap will be simulated.
		Aircrfat will come to full stop in 155-175 m

*/

#define EXIT_CODE		{_plane animate [_x,_planeHookUpAnimState];} forEach _planeHookAnimList;_plane SetUserMFDvalue [4,0];

private _plane = param [0, objNull];
if (!local _plane) exitWith {};
private _configPath = configFile >> "CfgVehicles" >> typeOf _plane;
private _planeCarrierOpsEnabled = (_configPath >> "tailHook") call BIS_fnc_getCfgData; if (_planeCarrierOpsEnabled == 0) exitWith {};
private _planeHookAnimList = (_configPath >> "CarrierOpsCompatability" >> "ArrestHookAnimationList") call BIS_fnc_getCfgData;
private _arrestMaxAllowedSpeed = (_configPath >> "CarrierOpsCompatability" >> "ArrestMaxAllowedSpeed") call BIS_fnc_getCfgData;
private _arrestSlowDownStep = (_configPath >> "CarrierOpsCompatability" >> "ArrestSlowDownStep") call BIS_fnc_getCfgData;
private _arrestVelocityReduction = (_configPath >> "CarrierOpsCompatability" >> "ArrestVelocityReduction") call BIS_fnc_getCfgData;
private _planeHookAnimStates = (_configPath >> "CarrierOpsCompatability" >> "ArrestHookAnimationStates") call BIS_fnc_getCfgData;
_planeHookAnimStates params ["_planeHookDownAnimState","_planeHookCaughtAnimState","_planeHookUpAnimState"];
private _carrierPart = "Land_Carrier_01_hull_08_1_F";

sleep 2;

private _hookAnim = _planeHookAnimList param [0,"",[""]];
waitUntil{!alive _plane || {_plane animationphase _hookAnim == _planeHookUpAnimState || {getPos _plane select 2 < 1}}};
if (!alive _plane || getPos _plane select 2 > 1) exitWith {EXIT_CODE};

private _objects = _plane nearObjects [_carrierPart, 150]; if (count _objects == 0) exitWith {EXIT_CODE};
private _carrier = _objects param [0, objNull];
private _carrierWirePos = _carrier modelToWorld (_carrier selectionPosition "pos_cable_1");
private _distance = _plane distance2D _carrierWirePos; if (_distance > 75) exitWith {EXIT_CODE};
{_plane animate [_x,_planeHookCaughtAnimState, true];} foreach _planeHookAnimList;

sleep 0.5;
if (speed _plane > _arrestMaxAllowedSpeed ) exitWith {EXIT_CODE; _plane say3D "Land_Carrier_01_wire_snap_sound";};
_plane say3D "Land_Carrier_01_wire_trap_sound";

while {alive _plane && {_plane animationphase _hookAnim != _planeHookUpAnimState && {speed _plane > -10}}} do
{
	_velInitial = velocity _plane;
	_dirPlane = direction _plane;
	_plane setVelocity (_velInitial vectorAdd [sin _dirPlane * _arrestVelocityReduction,cos _dirPlane * _arrestVelocityReduction,0]);

	sleep _arrestSlowDownStep;
	if (_arrestVelocityReduction >= -3) then {_arrestVelocityReduction = -3;} else {_arrestVelocityReduction = _arrestVelocityReduction + 0.1;};
	if (_arrestSlowDownStep <= 0.2) then {_arrestSlowDownStep = 0.03;} else {_arrestSlowDownStep = _arrestSlowDownStep - 0.1;};
};

sleep 2;

if (_plane animationphase _hookAnim == _planeHookUpAnimState) exitWith {};

EXIT_CODE;

//------------------------------------
//Set Steam Archivement state
//------------------------------------
if (canMove _plane && {(isPlayer driver _plane || {(UAVControl _plane) isEqualTo [player,"DRIVER"]})}) then
{
	setStatValue ["JetsGetArrested", 1];
};