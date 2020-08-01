/*
	Author: Bravo Zero One development
	- John_Spartan & Jiri Wainar

	Description:
	- On demand function to invoke acceleration of aircraft (vehicle).

	Exucution:
	- Call the function via code/script

		[_plane] call BIS_fnc_AircraftCatapultLaunch;

	Requirments:
	- Compatible aircraft must have a config definition for all sub-systems that will be invoked by this function

		example of cfgVehicles subclass definitions;

		tailHook = true;																		Allow to land on carrier
		class CarrierOpsCompatability
		{
			ArrestHookAnimationList[] = {"tailhook", "tailhook_door_l", "tailhook_door_r"};		List of animation played to animate tailhook. Defined in model.cfg (type user)
			ArrestHookAnimationStates[] = {0,0.53,1};											Tailhook animation states when down, hooked, up.
			ArrestHookMemoryPoint = "pos_tailhook";												TailHook memory point in plane model.p3d
			ArrestMaxAllowedSpeed = 275;														Max speed km/h allowed for successful landing
			ArrestSlowDownStep = 0.8;															Simulation step for calcualting how smooth plane will be slowed down.
			ArrestVelocityReduction = -12;														Speed reduced per simulation step
			LaunchVelocity = 300;																Speed required for take off
			LaunchVelocityIncrease = 10;														Speed increased per simulation step
			LaunchAccelerationStep = 0.001;														Simulation step for calcualting how smooth plane will launched from carrier catapult.
			LaunchBarMemoryPoint = "pos_gear_f_hook";											LaunchBar memory point
		};

	Parameter(s):
		_this select 0: mode (Scalar)
		0: plane/object


	Returns: nothing
	Result: Aircraft will be accelerated to required speed

*/

private _plane = param [0, objNull]; if (!local _plane) exitWith {};
private _dirCatapult = param [1, getDir _plane, [123]];
private _isAi = !(driver _plane == player || {(UAVControl _plane) param [1,""] == "DRIVER"});

private _configPath = configFile >> "CfgVehicles" >> typeOf _plane;
private _velocityLaunch = getNumber (_configPath >> "CarrierOpsCompatability" >> "LaunchVelocity") max 210;
private _velocityIncrease = getNumber (_configPath >> "CarrierOpsCompatability" >> "LaunchVelocityIncrease") max 75;
private _accelerationStep = getNumber (_configPath >> "CarrierOpsCompatability" >> "LaunchAccelerationStep") max 0.001;

/*
["[ ] _velocityLaunch: %1",_velocityLaunch] call bis_fnc_logFormat;
["[ ] _velocityIncrease: %1",_velocityIncrease] call bis_fnc_logFormat;
["[ ] _accelerationStep: %1",_accelerationStep] call bis_fnc_logFormat;
*/

_plane engineOn true;
_plane setAirplaneThrottle 1;
_plane setDir _dirCatapult;

private _velocity = 0;

private _timeStart = time;
private _timeDelta = 0;

while
{
	speed _plane < _velocityLaunch && {isEngineOn _plane && {((getPos _plane) param [2,0]) < 1}}
}
do
{
	_plane setDir _dirCatapult;

	if (_isAi) then
	{
		_plane engineOn true;
		_plane setAirplaneThrottle 1;
	};

	_timeDelta = time - _timeStart;
	_velocity = _velocityIncrease * _timeDelta;

	_plane setVelocity [sin _dirCatapult * _velocity,cos _dirCatapult * _velocity,velocity _plane select 2];

	sleep _accelerationStep;
};

if (_isAi) then
{
	private _t = time + 1;

	waitUntil
	{
		_velocity = velocity _plane;
		_velocity set [2,1];

		_plane setVelocity _velocity;

		time > _t
	};
};