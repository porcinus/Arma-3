/*
	Author: Nelson Duarte

	Description:
	Make a unit play a punishment animation

	Parameter(s):
	https://community.bistudio.com/wiki/Arma_3_Modules

	Returns:
	NONE
*/

// Parameters
private ["_logic", "_units", "_activated"];
_logic 		= _this select 0;
_units 		= _this select 1;
_activated 	= _this select 2;

if (_activated) then {
	// Wait for parameters to be set
	if (_logic call bis_fnc_isCuratorEditable) then {
		waituntil {
			(
				!isNil { _logic getVariable "punishment" }
				&&
				{ !isNull attachedTo _logic }
				&&
				{ attachedTo _logic isKindOf "Man" }
			)
			||
			isNull _logic
		};
	};

	// Exit if logic is null
	if (isNull _logic) exitwith {
		// Log
		"Punishment module was probably deleted!" call BIS_fnc_log;
	};

	// The unit this module is attached to
	private _unit = attachedTo _logic;

	// The punishment animation
	private _animation = _logic getVariable ["punishment", ""];

	// Make sure target unit is not on water or in a vehicle
	if (vehicle _unit == _unit && {!surfaceIsWater position _unit}) then
	{
		// Force unit to play animation
		if (_animation != "") then
		{
			[[[_unit, _animation], { (_this select 0) playMove (_this select 1); }], "BIS_fnc_spawn", _unit, false] call BIS_fnc_mp;
		}
		else
		{
			["Animation for %1 is empty or does not exist %2", _unit, _animation] call BIS_fnc_error;
		};
	}
	else
	{
		private _text = if (vehicle _unit == _unit) then { localize "STR_A3_bis_fnc_modulepunishment_water" } else { localize "STR_A3_bis_fnc_modulepunishment_vehicle" };
		[getAssignedCuratorLogic player, _text] call BIS_fnc_showCuratorFeedbackMessage;
	};

	// Delete logic
	deleteVehicle _logic;
};