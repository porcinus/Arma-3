

//------------------
// Author: Philipp Pilhofer (raedor), optimised by Killzone_Kid
// Purpose: This function returns the absolute speed of a vehicle in km/h
// Arguments: vehicle
// Return: float
//
// Revision History:
// 26/11/06 0.1 - First cut
//------------------


/// --- validate input
#include "..\paramsCheck.inc"
paramsCheck(_this,isEqualType,objNull)

3.6 * vectorMagnitude velocity _this