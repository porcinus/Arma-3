/*
	Author: Karel Moricky

	Description:
	Return particle params of CfgCloudlets class

	Parameter(s):
		0: STRING - CfgCloudlets class

	Returns:
	ARRAY in format [setParticleParams, setParticleRandom, setDropInterval, setParticleCircle]
*/

private _class = param [0,"",[""]];
private _cfg = configfile >> "CfgCloudlets" >> _class;
if (isclass _cfg) then {
	[
		//--- setParticleParams
		[
			[
				gettext (_cfg >> "particleShape"),
				getnumber (_cfg >> "particleFSNtieth"),
				getnumber (_cfg >> "particleFSIndex"),
				getnumber (_cfg >> "particleFSFrameCount"),
				getnumber (_cfg >> "particleFSLoop")
			],
			gettext (_cfg >> "animationName"),
			gettext (_cfg >> "particleType"),
			getnumber (_cfg >> "timerPeriod"),
			getnumber (_cfg >> "lifeTime"),
			getarray (_cfg >> "position"),
			getarray (_cfg >> "moveVelocity"),
			getnumber (_cfg >> "rotationVelocity"),
			getnumber (_cfg >> "weight"),
			getnumber (_cfg >> "volume"),
			getnumber (_cfg >> "rubbing"),
			getarray (_cfg >> "size"),
			getarray (_cfg >> "color"),
			getarray (_cfg >> "animationSpeed"),
			getnumber (_cfg >> "randomDirectionPeriod"),
			getnumber (_cfg >> "randomDirectionIntensity"),
			gettext (_cfg >> "onTimerScript"),
			gettext (_cfg >> "beforeDestroyScript"),
			"",
			getnumber (_cfg >> "angle"),
			getnumber (_cfg >> "onSurface") > 0,
			getnumber (_cfg >> "bounceOnSurface"),
			getarray (_cfg >> "emissiveColor")
		],

		//--- setParticleRandom
		[
			getnumber (_cfg >> "lifeTimeVar"),
			getarray (_cfg >> "positionVar"),
			getarray (_cfg >> "moveVelocityVar"),
			getnumber (_cfg >> "rotationVelocityVar"),
			getnumber (_cfg >> "sizeVar"),
			getarray (_cfg >> "colorVar"),
			getnumber (_cfg >> "randomDirectionPeriodVar"),
			getnumber (_cfg >> "randomDirectionIntensityVar"),
			getnumber (_cfg >> "angleVar"),
			getnumber (_cfg >> "bounceOnSurfaceVar")
		],

		//--- setDropInterval
		getnumber (_cfg >> "interval"),

		//--- setParticleCircle
		[
			getnumber (_cfg >> "circleRadius"),
			getarray (_cfg >> "circleVelocity")
		]
	]
} else {
	["Class %1 does not exist in CfgCloudlets",_class] call bis_fnc_error;
	[]
};