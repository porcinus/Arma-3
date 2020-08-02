/*
	Author: Nelson Duarte <@Nelson_G_Duarte>

	Description:
	Draws a location curve in 3D

	Parameter(s):
	_this select 0: Array	- The baked curve
	_this select 1: Array	- The color of the curve rendering

	Returns:
	Nothing
*/

// Parameters
private _points = _this param [0, [], [[]]];

// Go through all points and render the lines between them
for "_i" from 0 to count _points - 2 do
{
	// Start and end points
	_start = (_points select _i) select 1;
	_end = (_points select (_i + 1)) select 1;

	if (_start isEqualTypeArray [0.0, 0.0, 0.0] && _end isEqualTypeArray [0.0, 0.0, 0.0]) then
	{
		// Position in AGL
		_startAGL = ASLToAGL _start;

		// Draw line between points
		drawLine3D [_startAGL, ASLToAGL _end, [1,0,0,1]];

		// Draw point along curve for density visualization
		drawIcon3D ["\A3\Ui_f\data\GUI\Cfg\Cursors\hc_move_gs.paa", [1,0,0,1], _startAGL, 0.2, 0.2, 0, "", 1, 0.02, "TahomaB"];
	};
};