/*
	Author: Nelson Duarte <@Nelson_G_Duarte>

	Description:
	Set's the curve's orientation mode

	Parameter(s):
	_this select 0: Object 	- The curve
	_this select 1: Integer - The orientation mode (0 = None / 1 = Animation / 2 = Look At / 3 = Movement Direction)

	Returns:
	Nothing
*/

// Parameters
private _curve 				= _this param [0, objNull, [objNull]];
private _orientationMode 	= _this param [1, 0, [0]];

// Set the mode
if (is3DEN) then
{
	_curve set3DENAttribute ["OrientationMode", _orientationMode];
}
else
{
	_curve setVariable ["OrientationMode", _orientationMode];
};