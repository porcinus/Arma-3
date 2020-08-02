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

playSound3D ["A3\Sounds_F\sfx\objects\balloon\Balloon_air_0" + str((floor(random(2.9999))) + 1) + ".wss", objNull, false, _position, 45, 1, 70];

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

sleep 1;

deleteVehicle _source_part_01;
deleteVehicle _source_part_02;

true