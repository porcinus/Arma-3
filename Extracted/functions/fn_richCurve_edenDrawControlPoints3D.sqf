/*
	Author: Nelson Duarte <@Nelson_G_Duarte>

	Description:
	Draws all control points of a curve

	Parameter(s):
	_this select 0: Curve - The curve
	_this select 1: Array - The color of the icons rendering

	Returns:
	Nothing
*/

// Parameters
private _curve = _this param [0, objNull, [objNull]];

// Draw Points
{
	_pos 		= ASLToAGL ([_x] call BIS_fnc_key_getValue);
	_colorIcon	= if ([_x] call BIS_fnc_key_edenIsSelected) then {[0,1,0,1]} else {[1,1,1,1]};

	drawLine3D [_pos, _pos vectorAdd (vectorDir _x vectorMultiply 2.0), [0,1,0,1]];
	drawLine3D [_pos, _pos vectorAdd (vectorUp _x vectorMultiply 2.0), [0,0,1,1]];
	drawLine3D [_pos, _pos vectorAdd (((vectorDir _x) vectorCrossProduct (vectorUp _x)) vectorMultiply 2.0), [0.8,0.5,0.5,1]];

	if (get3DENIconsVisible select 1) then
	{
		drawIcon3D ["", _colorIcon, _pos vectorAdd [0,0,-4], 0, 0, 0, str _forEachIndex, 1, 0.1, "PuristaMedium"];
	};
}
forEach ([_curve] call BIS_fnc_richCurve_getKeys);