/*
	Author: Bravo Zero One development
	- John_Spartan

	Description:
	- This function is designed as part of set of functions to implement semi-authenthic ejection system on fixed wing aircrfat that have such functionality enabled/configured.
	- Function created to add FX (sound/particles) for ejection feature.

	Exucution:
	- Call from within the main ejection fnc (on demand).

		Example:
		[_plane, _ejectionSeat] spawn BIS_fnc_planeEjectionFX;

	Requirments:
	- Compatible ejector seat must have a hide animation for rocket motor flash and position for FX to be attached. (TO DO PARAMETARIZE)
		Inehector seats model.cfg
		class Animations
		{

			class Rocket_Flash_hide
			{
				type = "hide";
				source = "user";
				selection = "rocket_flash";
				sourceAddress = "mirror";
				minValue = -1.5;
				maxValue = 0;
				hideValue = 0.99;


			};
		};

	Parameter(s):
		_this select 0: mode (Scalar)
		0: plane/object
		1: ejector seat/object


	Returns: nothing
	Result: Set of particle FX and sound FX will be aplied to ejection feature.
*/

private _plane = param [0,objNull]; if (isNull _plane) exitWith {};
private _ejectionSeat = param [1,objNull]; if (isNull _ejectionSeat) exitWith {};

private _configPath = configFile >> "CfgVehicles" >> (typeOf _plane) >> "EjectionSystem";
private _ejectionSoundInt = getText (_configPath >>"EjectionSoundInt");
private _ejectionSoundExt = getText (_configPath >>"EjectionSoundExt");

_ejectionSeat say _ejectionSoundInt;
_ejectionSeat say3D _ejectionSoundExt;
_ejectionSeat animate ["Rocket_Flash_hide",1];

private _planePos = getPos _plane;
private _ejectionSeatPos = getPos _ejectionSeat;

private _fxLightSource = "#lightpoint" createVehicleLocal _ejectionSeatPos;
_fxLightSource setLightBrightness 0.3;
_fxLightSource setLightAmbient[0.8, 0.6, 0.2];
_fxLightSource setLightColor[1, 0.5, 0.2];
_fxLightSource lightAttachObject [_ejectionSeat, [0,0,0]];

private _fxSmokeTrailSource = "#particlesource" createVehicleLocal _ejectionSeatPos;
_fxSmokeTrailSource setParticleClass "FX_EjectorSeatSmoke";
_fxSmokeTrailSource attachto [_ejectionSeat,[0,0,0],"FX_pos"];

private _fxSmokeSource1 = "#particlesource" createVehicleLocal _planePos;
_fxSmokeSource1 setParticleClass "FX_EjectorSeatSmoke";
_fxSmokeSource1 attachto [_plane,[0,0,0],"actionarea"];


sleep 0.05;
deleteVehicle _fxLightSource;
deleteVehicle _fxSmokeSource1;

sleep 0.2;
_ejectionSeat animate ["Rocket_Flash_hide",0];

sleep 0.3;
deleteVehicle _fxSmokeTrailSource;
