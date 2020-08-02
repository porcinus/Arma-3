/*
	Author: Jiri Wainar, modified by Killzone_Kid

	Description:
	Deletes specific crew member directly from the vehicle.

	Parameter(s):
		0: OBJECT - vehicle
		1: OBJECT - crew member

	Returns:
	NOTHING
*/

/// --- validate input
#include "..\paramsCheck.inc"
#define arr [objNull,objNull]
paramsCheck(_this,isEqualTypeParams,arr)

params ["_vehicle", "_unit"];

_vehicle deleteVehicleCrew _unit;