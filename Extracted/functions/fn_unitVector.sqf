
/************************************************************
	Unit Vector
	Author: Andrew Barron, optimised by Killzone_Kid

Returns the unit vector for the passed vector (vector pointing
in the same direction, but with magnitude == 1)
This does not modify the original array.
The array can have any number of elements (2, 3, etc).
************************************************************/

/// --- validate general input
#include "..\paramsCheck.inc"
paramsCheck(_this,isEqualType,[])

if (count _this isEqualTo 3) exitWith {vectorNormalized _this};

private _mag = _this call BIS_fnc_magnitude;
if (_mag isEqualTo 0) exitWith {_this};

private _ret = [];
{_ret append [_x / _mag]} count _this;

_ret