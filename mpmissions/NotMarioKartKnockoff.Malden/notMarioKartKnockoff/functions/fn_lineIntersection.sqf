/*
NNS
Not Mario Kart Knockoff
Found line-line intersection point.
Based on: https://en.wikipedia.org/wiki/Line%E2%80%93line_intersection
*/

params [
	["_line1Start", []], //line 1 start position
	["_line1End", []], //line 1 end position
	["_line2Start", []], //line 2 start position
	["_line2End", []] //line 2 end position
];

private _line1X1 = _line1Start select 0; private _line1Y1 = _line1Start select 1; //line1Start XY
private _line1X2 = _line1End select 0; private _line1Y2 = _line1End select 1; //line1End XY

private _line2X1 = _line2Start select 0; private _line2Y1 = _line2Start select 1; //line2Start XY
private _line2X2 = _line2End select 0; private _line2Y2 = _line2End select 1; //line2End XY

private _line1Xdiff = _line1X1 - _line1X2; _line1Ydiff = _line1Y1 - _line1Y2; //line 1 XY difference
private _line2Xdiff = _line2X1 - _line2X2; _line2Ydiff = _line2Y1 - _line2Y2; //line 2 XY difference

private _line1Cross = (_line1X1 * _line1Y2) - (_line1Y1 * _line1X2); //line 1 cross product
private _line2Cross = (_line2X1 * _line2Y2) - (_line2Y1 * _line2X2); //line 2 cross product

private _divisor = (_line1Xdiff * _line2Ydiff) - (_line1Ydiff * _line2Xdiff); //common divisor for X and Y intersection
if (_divisor == 0) exitWith {[]}; //invalid, parallel or coincident lines

[((_line1Cross * _line2Xdiff) - (_line1Xdiff * _line2Cross)) / _divisor, ((_line1Cross * _line2Ydiff) - (_line1Ydiff * _line2Cross)) / _divisor, 0]; //return intersection [x, y, 0]