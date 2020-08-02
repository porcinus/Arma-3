/*
	Author: Nelson Duarte <@Nelson_G_Duarte>

	Description:
	Set's whether this control point is arrive or leave

	Parameter(s):
	_this select 0: Object 	- The control point
	_this select 1: Bool	- Whether this control point is arrive or leave

	Returns:
	Nothing
*/

// Parameters
private _controlPoint 	= _this param [0, objNull, [objNull]];
private _arrive			= _this param [1, true, [true]];

// Validate control point
if (isNull _controlPoint) exitWith {};

// The wanted state
private _newState = if (_arrive) then {0} else {1};

// 3DEN is handled differently
if (is3DEN) then
{
	_controlPoint set3DENAttribute ["TangentType", _newState];
}
else
{
	_controlPoint setVariable ["TangentType", _newState];
};