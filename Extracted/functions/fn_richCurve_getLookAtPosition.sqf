/*
	Author: Nelson Duarte <@Nelson_G_Duarte>

	Description:
	Returns the look at position of this curve, [0.0, 0.0, 0.0] if not set

	Parameter(s):
	_this select 0: Object - The curve

	Returns:
	Array - Target position, [0.0, 0.0, 0.0] if not set
*/

// Parameters
private _curve 	= _this param [0, objNull, [objNull]];

// Validate curve
if (isNull _curve) exitWith
{
	[0.0, 0.0, 0.0];
};

// The look at position
// At this point we do not know what type were dealing with
// Requires some validation
private _lookAt = if (is3DEN) then
{
	call compile ((_curve get3DENAttribute "LookAt") select 0);
}
else
{
	call compile (_curve getVariable ["LookAt", ""]);
};

// Type validation
if (!(_lookAt isEqualType []) || {count _lookAt <= 0}) exitWith
{
	[0.0, 0.0, 0.0];
};

// Return the correct position depending on input data
// When in 3DEN we get object from entity id
// When in game we take name of object directly
if (is3DEN) then
{
	getPosASLVisual (get3DENEntity (_lookAt select 0));
}
else
{
	getPosASLVisual (_lookAt select 1);
};