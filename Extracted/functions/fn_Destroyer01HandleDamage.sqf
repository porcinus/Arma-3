/*
	Author: Bravo Zero One development
	- John_Spartan

	Description:
	- This is a damage visual FX simulation function designed to animate ships bridge windows when shot.
	  Due to engine limitation (damage simulation is disabled for indestructible objects e.g. ships components) this workaround is applied.

	Execution:
	- Call from EH on the ship's model part with windows.

		Example:
		class Eventhandlers
		{
			HitPart = "_this call BIS_fnc_Destroyer01HandleDamage;";
		};

	Requirements:
	- Compatible object (e.g. ship component) must have a set of selections that are setup and named by convention.
	  Selections must be defined as hidden selections in order for setObjectTexture to work.

	Parameter(s):
		_this select 0: mode (Scalar)
		0: event Handler Array as documented here - https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#HitPart


	Returns: nothing
	Result: Destroyer (ship) window textures are swapped for damaged ones. Simple swap.

*/
private _eventHandlerArray = param [0, []];
if (count _eventHandlerArray == 0) exitWith {};

private _shipPart = _eventHandlerArray select 0;
private _selectionsHit = _eventHandlerArray select 5;
if (count _selectionsHit == 0) exitWith {};

_hitSelections =
[
    "glass_1",
    "glass_2",
    "glass_3",
    "glass_4",
    "glass_5",
    "glass_6",
    "glass_7",
    "glass_8",
    "glass_9",
    "glass_10",
    "glass_11",
    "glass_12",
    "glass_13",
    "glass_14",
    "glass_15",
    "glass_16",
    "glass_17",
    "glass_18"
];

private _matchResult = -1;

{
	_matchResult = _hitSelections find _x;

	if (_matchResult >= 0) then
	{
		private _slectionToHide = format ["%1_hide", (_hitSelections select _matchResult)];
		private _slectionToShow = format ["%1_unhide", (_hitSelections select _matchResult)];
		_shipPart animate [_slectionToHide,1];
		_shipPart animate [_slectionToShow,1];
	};
}
foreach _selectionsHit;

