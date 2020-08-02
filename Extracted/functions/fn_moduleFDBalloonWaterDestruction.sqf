private ["_position", "_velocity", "_color"];
//				param list | param index | default value 	  | allowed types | allowed array sizes
_position	= _this param [0,			  [0.0, 0.0, 0.0],		[[]],			[3]		];
_velocity	= _this param [1,			  [0.0, 0.0, 0.0],		[[]],			[3]		];
_color		= _this param [2,			  "Orange",				[""]					];

switch (toLower _color) do
{
	case "green":	{_color = "green";};
	case "red":		{_color = "red";};
	case "blue":	{_color = "blue";};
	case "orange":	{_color = "orange";};
	case "white":	{_color = "white";};
	case "purple":	{_color = "purple";};
};

//////////////////////////////////////////////////////////////

playSound3D ["A3\Sounds_F\sfx\objects\balloon\Balloon_water_0" + str((floor(random(2.9999))) + 1) + ".wss", objNull, false, _position, 40, 1, 70];

//////////////////////////////////////////////////////////////

private ["_source_water_explosion"];
_source_water_explosion = "#particlesource" createVehicleLocal _position;
_source_water_explosion setPos _position;
_source_water_explosion setParticleParams
[
	["\A3\Data_F_Mark\ParticleEffects\Universal\waterBallonExplode_01", 4, 0, 16, 0],
	"", "Billboard", 1, 1.0, [0, 0, 0.25], [0, 0, 0], 0, 0.42, 0.15, 0.15,
	[0.95], [[0.5,0.5,0.5,1]], [2], 0.0, 0.0, "", "", ""
];
_source_water_explosion setParticleRandom
[
	0.0, [0, 0, 0], [0.0, 0.0, 0.0], 0, 0.5, [0, 0, 0, 0], 0.0, 0.0, 0
];
_source_water_explosion setDropInterval 5.0;

//////////////////////////////////////////////////////////////

private ["_source_water_drop_01"];
_source_water_drop_01 = "#particlesource" createVehicleLocal _position;
_source_water_drop_01 setPos _position;
_source_water_drop_01 setParticleParams
[
	"\A3\Data_F_Mark\ParticleEffects\Universal\waterDrop",
	"", "SpaceObject", 1, 1.0, [0, 0, 0.25], [0, 0, -0.3], 0, 0.42, 0.15, 0.15,
	[0.43], [[0.5, 0.5, 0.5, 1]], [0], 0.0, 0.0, "", "", ""
];
_source_water_drop_01 setParticleRandom
[
	0.5, [0.2, 0.2, 0.2], [2.3, 2.3, 2.5], 0, 0.03, [0, 0, 0, 0], 0.0, 0.0, 0
];
_source_water_drop_01 setDropInterval 0.01;

//////////////////////////////////////////////////////////////

private ["_source_water_drop_02"];
_source_water_drop_02 = "#particlesource" createVehicleLocal _position;
_source_water_drop_02 setPos _position;
_source_water_drop_02 setParticleParams
[
	"\A3\Data_F_Mark\ParticleEffects\Universal\waterDrop",
	"", "SpaceObject", 1, 1.0, [0, 0, 0.05], [0, 0, 0.3], 0, 0.42, 0.15, 0.15,
	[0.48, 0.41],  [[0.5, 0.5, 0.5, 1]], [0], 0.0, 0.0, "", "", ""
];
_source_water_drop_02 setParticleRandom
[
	0.5, [0.2, 0.2, 0.2], [6.3, 6.3, 5.5], 0, 0.13, [0, 0, 0, 0], 0.0, 0.0, 0
];
_source_water_drop_02 setDropInterval 0.01;

//////////////////////////////////////////////////////////////

private ["_source_water_drops"];
_source_water_drops = "#particlesource" createVehicleLocal _position;
_source_water_drops setPos _position;
_source_water_drops setParticleParams
[
	"\A3\Data_F_Mark\ParticleEffects\Universal\waterDrops",
	"", "SpaceObject", 1, 1.0, [0, 0, 0], [0, 0, -0.3], 0, 0.62, 0.15, 0.15,
	[0.5, 0.8], [[0.5, 0.5, 0.5, 1]], [2], 0.0, 0.0, "", "", ""
];
_source_water_drops setParticleRandom
[
	0.0, [0, 0, 0], [0.0, 0.0, 0.0], 0, 0.03, [0, 0, 0, 0], 0.0, 0.0, 0
];
_source_water_drops setDropInterval 0.1;

//////////////////////////////////////////////////////////////

private ["_source_part_01"];
_source_part_01 = "#particlesource" createVehicleLocal _position;
_source_part_01 setPos _position;
_source_part_01 setParticleParams
[
	("\A3\Structures_F_Mark\Items\Sport\Particles\Balloon_01_part_01_" + _color + "_F.p3d"),
	"", "SpaceObject", 1, 5.0, [0, 0, 1], _velocity, 0, 10, 0.2, 0.9,
	[1.0], [[0.5, 0.5, 0.5, 1]], [2], 0.0, 0.0, "", "", ""
];
_source_part_01 setParticleRandom
[
	0.0, [0, 0, 0], [3.3, 3.3, 1.5], 4, 0.03, [0, 0, 0, 0], 0.0, 0.0, 0
];
_source_part_01 setDropInterval 50.0;

//////////////////////////////////////////////////////////////

private ["_source_part_02"];
_source_part_02 = "#particlesource" createVehicleLocal _position;
_source_part_02 setPos _position;
_source_part_02 setParticleParams
[
	("\A3\Structures_F_Mark\Items\Sport\Particles\Balloon_01_part_02_" + _color + "_F.p3d"),
	"", "SpaceObject", 1, 5.0, [0, 0, 0.5], _velocity, 0, 10, 0.2, 0.9,
	[1.0, 0.08], [[0.5, 0.5, 0.5, 1]], [2], 0.0, 0.0, "", "", ""
];
_source_part_02 setParticleRandom
[
	0.0, [0, 0, 0], [3.3, 3.3, 1.5], 4, 0.03, [0, 0, 0, 0], 0.0, 0.0, 0
];
_source_part_02 setDropInterval 50.0;

//////////////////////////////////////////////////////////////

sleep 0.5;

deleteVehicle _source_water_explosion;
deleteVehicle _source_water_drop_01;
deleteVehicle _source_water_drop_02;
deleteVehicle _source_water_drops;
deleteVehicle _source_part_01;
deleteVehicle _source_part_02;

true