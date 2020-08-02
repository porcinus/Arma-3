params ["_vehicle"];

private _pos = getpos _vehicle;
private _isUAV = unitIsUav _vehicle;
private _height = _pos select 2;

if (isServer) then
{
	//remove weapons/ammo to prevent explosion
	removeAllWeapons _vehicle;

	//in air explosion (not for UAV)
	if (!_isUAV && {_height > 1}) then {createVehicle ["HelicopterExploSmall", _pos, [], 0, "CAN_COLLIDE"]};

	private _timeout = time + 60;
	private _velocityVert = velocity _vehicle select 2;
	private _velocityVertPrev = _velocityVert;
	private _delta = abs(_velocityVert - _velocityVertPrev);
	private _deltaPrev = _delta;

	//detect crash
	waitUntil
	{
		_velocityVertPrev = _velocityVert;
		_velocityVert = velocity _vehicle select 2;

		_deltaPrev = _delta max 3;
		_delta = abs(_velocityVert - _velocityVertPrev);

		_delta > 5 * _deltaPrev || {time > _timeout}
	};

	if (surfaceIsWater _pos || {time > _timeout}) exitWith {};

	//slowdown vehicle & reduce / remove bouncing
	_vehicle spawn
	{
		while {abs(speed _this) > 0.1} do
		{
			(velocity _this) params ["_xv","_yv","_zv"];

			_this setVelocity [_xv * 0.98, _yv * 0.98, -10];

			sleep 0.05;
		};
	};

	//crash explosion
	if (_isUAV) then
	{
		//smoke on destruction
		private _source01 = createVehicle ["#particlesource", getpos _vehicle, [], 0, "CAN_COLLIDE"];
		_source01 setParticleClass "UAVCrashSmoke";
		_source01 setPos _pos;

		if (_height > 4) then
		{
			//dust cloud on crash from height
			private _source02 = createVehicle ["#particlesource", getpos _vehicle, [], 0, "CAN_COLLIDE"];
			_source02 setPos _pos;
			_source02 setParticleCircle [0.4, [1.2, 1.2, 0]];
			_source02 setParticleParams [["\A3\data_f\ParticleEffects\Universal\Universal", 16, 12, 8, 0], "", "Billboard", 1, 10, [0, 0, 0], [0, 0, 0], 5, 1.275, 1.0, 0.15, [2,4.6],
							[[0.5,0.45,0.4,(0.04 * _height) min 0.4],[0.5,0.45,0.4,(0.024 * _height) min 0.24],[0.5,0.45,0.4,(0.014 * _height) min 0.14],[0.5,0.45,0.4,0.01]], [0,1], 0.1, 0.05, "", "", ""];
			_source02 setParticleRandom [6, [0,0,0], [0.5,0.5,0.05], 20, 0.5, [0,0,0,0], 0, 0, 0];
			_source02 setDropInterval 0.0012;

			sleep 0.15;
			deleteVehicle _source02;
		}
		else
		{
			sleep 0.15;
		};

		deleteVehicle _source01;
	}
	else
	{
		createVehicle ["HelicopterExploBig", getpos _vehicle, [], 0, "CAN_COLLIDE"];

		//extra crash particle effects and craters
		[_vehicle] call BIS_fnc_effectKilledAirDestructionStage2;
	};
};