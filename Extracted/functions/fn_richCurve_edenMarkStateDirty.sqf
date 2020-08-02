/*
	Author: Nelson Duarte <@Nelson_G_Duarte>

	Description:
	Marks a curve state as dirty, so it knows it needs to recalculate
	For example, moving a key in EDEN

	Parameter(s):
	_this select 0: Object	- The Curve

	Returns:
	Nothing
*/

// Parameters
private _curve = _this param [0, objNull, [objNull]];

// Validate curve
if (isNull _curve) exitWith {};

// Mark state dirty
_curve setVariable ["_dirty", true];

// Make entity list dirty
missionNamespace setVariable ["_entityListDirty", true];