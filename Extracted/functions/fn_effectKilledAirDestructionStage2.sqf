params ["_vehicle"];

private _pos = getpos _vehicle;
private _createCraters = worldName == "VR";

//particle effects
private _smoke = createVehicle ["#particlesource", getpos _vehicle, [], 0, "CAN_COLLIDE"];
_smoke attachto [_vehicle,[0,0,0],"destructionEffect1"];
_smoke setParticleParams [["\A3\data_f\ParticleEffects\Universal\Universal_02", 8, 0, 40],
			"", "Billboard", 1, 14, [0, 0, 0], [0, 0, 0], 1, 1.275, 1, 0, [10,18,24],
			[[0.1,0.1,0.1,0.6],[0.1,0.1,0.1,0.35],[0.1,0.1,0.1,0.01]], [0.5], 0.1, 0.1, "", "", _vehicle];
_smoke setParticleRandom [2, [2, 2, 2], [1.5, 1.5, 3.5], 0, 0, [0, 0, 0, 0], 0, 0];
_smoke setDropInterval 0.02;

private _dirt = createVehicle ["#particlesource", getpos _vehicle, [], 0, "CAN_COLLIDE"];
_dirt attachto [_vehicle,[0,0,0],"destructionEffect1"];
_dirt setParticleParams [["\A3\data_f\ParticleEffects\Universal\Universal",16,12,9,0], "", "Billboard", 1, 5, [0, 0, 0], [0, 0, 5], 0, 5, 1, 0, [7,12],
	  [[0.1,0.1,0.1,0.6],[0.1,0.1,0.1,0.35],[0.1,0.1,0.1,0.01]], [1000], 0, 0, "", "", _vehicle,360];
_dirt setParticleRandom [0, [1, 1, 1], [1, 1, 2.5], 0, 0, [0, 0, 0, 0.5], 0, 0];
_dirt setDropInterval 0.05;

private ["_pos","_speed","_dir","_tv","_dr","_craterType"];

while {abs(speed _vehicle) > 0.1} do
{
	//wait for the vehicle to get down to the ground
	_pos = getpos _vehicle;

	if (_pos select 2 >= 3) then
	{
		private _timeout = time + 60;

		waitUntil
		{
			sleep 0.05;
			_pos = getpos _vehicle;

			_pos select 2 < 3 || {time > _timeout}
		};
	};

	//exit if timeout and still not on the ground
	if (_pos select 2 >= 3) exitWith {};

	//set crater position to ground
	_pos set [2, 0];

	//create and repos the crater
	(velocity _vehicle) params ["_xv","_yv","_zv"];
	_dir = abs(_xv atan2 _yv);
	_speed = abs speed _vehicle;

	if (_createCraters) then
	{
		_craterType = if (_speed > 60) then {"CraterLong"} else {"CraterLong_small"};

		private _crater = createVehicle [_craterType, _pos, [], 0, "CAN_COLLIDE"];

		if (random 1 > 0.5) then
		{
			_crater setdir (_dir + 170 + (random 20));
		}
		else
		{
			_crater setdir (_dir - 10 + (random 20));
		};
		_crater setPos _pos;
	};

	//update the particle effects
	_tv = abs(_xv) + abs(_yv) + abs(_zv);
	_dr = if (_tv > 2) then {1/_tv} else {1};
	_smoke setDropInterval _dr * 1.5;
	_dirt setDropInterval _dr;

	sleep (0.25 - (_speed / 1000));
};

deleteVehicle _smoke;
deleteVehicle _dirt;