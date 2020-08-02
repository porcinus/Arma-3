/*
	Author: Bravo Zero One development
	- John_Spartan & Jiri Wainar

	Description:
	- On demand function to invoke set of animations associated with carrier catapult jet blast deflector.

	Exucution:
	- Call the function via code/script

		[_carrierPart, _animations, 10] spawn BIS_fnc_Carrier01AnimateDeflectors;

	Requirments:
	- Compatible carrier part must have a config definition for all sub-systems that will be invoked by this function

		example of cfgVehicles subclass definitions for carrier part;
		class Catapults
		{
			class Catapult1
			{
				memoryPoint = "pos_catapult_01";											Memory point in carrier part model.p3d
				dirOffset = -5.5;													Offset angle in degrees between carrier part direction and actual catapult launch direction
				animations[] = {"Deflector_1","Deflector_1_hydraulic_1", "Deflector_1_hydraulic_2","Deflector_1_hydraulic_3"};		Array with animation names for carrier part jet blast deflectors
				launchActionName = "$STR_A3_action_launchFromCatapult_1";								Visual display name of "Attach Action"
				detachActionName = "$STR_A3_action_detachFromCatapult_1";								Visual display name of "Dettach Action"
			};
		};

	Parameter(s):
		_this select 0: mode (Scalar)
		0: carrier part/object to animate
		1: animations/array of animations to animate
		2: animationState/int for required animation state


	Returns: nothing
	Result: Aircraft carrier part's specified catapult's animations are played/animated

*/

private _carrierPart = param [0, objNull, [objNull]];
private _animationList = param [1, [], [[]]];
private _animationState = param [2, objNull, [123]];

{
	if (_forEachIndex == 0) then
	{
		switch (_animationState) do
		{
			case 10:
			{
				if (_carrierPart animationPhase _x < 0.1) then {_carrierPart say3D "Land_Carrier_01_blast_deflector_up_sound"};
			};
			case 0:
			{
				if (_carrierPart animationPhase _x > 9.9) then {_carrierPart say3D "Land_Carrier_01_blast_deflector_down_sound"};
			};
			default
			{

			};
		};
	};

	_carrierPart animate [_x, _animationState];
}
foreach _animationList;