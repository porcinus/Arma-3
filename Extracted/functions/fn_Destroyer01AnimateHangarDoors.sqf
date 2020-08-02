/*
	Author: Bravo Zero One development
	- John_Spartan

	Description:
	- This is a sub function designed to handle animations of ship hangar doors. Used in Eden attributes and objects user actions.

	Execution:
	- Call from script.

	Example:
		[_shipPart, _value, false] spawn bis_fnc_destroyer01AnimateHangarDoors;

	Required:
		Object (ship) must have all animations correctly defined and user actions configured.

	Parameter(s):
		_this select 0: mode (Scalar)
		0: ship-part object
		and
		1: animation state of doors
		2: animation speed (instant = true/smooth=false);

	Returns: nothing
	Result: Ship's hangar door animation is played with sounds added.

*/
private _shipPart = param [0, objNull];
private _animationState = param [1, 0];
private _animationIsInstant = param [2,false];
private _animationList = ["Door_Hangar_1_1_open", "Door_Hangar_1_2_open", "Door_Hangar_1_3_open", "Door_Hangar_2_1_open", "Door_Hangar_2_2_open", "Door_Hangar_2_3_open"];

if (!isNull _shipPart) then
{
	if(!_animationIsInstant) then
	{
		private _soundPos = _shipPart modelToWorldWorld (_shipPart selectionPosition "Door_Hangar_SoundPos");
		[_shipPart, _soundPos, _animationState] spawn bis_fnc_destroyer01PlayHangarDoorSound;
	};

	{
		_shipPart animate [_x,_animationState,_animationIsInstant];
	}
	foreach _animationList;
};