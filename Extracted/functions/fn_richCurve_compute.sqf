/*
	Author: Nelson Duarte <@Nelson_G_Duarte>

	Description:
	Computes curve data

	Parameter(s):
	_this select 0: Object 	- The curve
	_this select 1: Bool 	- Whether this is a forced computation (from on attributes changed and not from on drag)

	Returns:
	Nothing
*/

// Parameters
private _curve 	= _this param [0, objNull, [objNull]];
private _forced	= _this param [1, false, [false]];

// Validate curve
if (isNull _curve) exitWith {};

// Keys computation
{
	[_x, _forced] call BIS_fnc_key_compute;
}
forEach ([_curve, true, _forced] call BIS_fnc_richCurve_computeKeys);

// Computation
_curve setVariable ["OwnerTimeline", [_curve, _forced] call BIS_fnc_richCurve_computeOwnerTimeline];
_curve setVariable ["SimulatedObjects", [_curve, _forced] call BIS_fnc_richCurve_computeSimulatedObjects];
_curve setVariable ["Keys", [_curve, true, _forced] call BIS_fnc_richCurve_computeKeys];

private _curveLength		= [_curve, _forced] call BIS_fnc_richCurve_computeCurveArcLength;
private _arcTotalLength		= if (count _curveLength > 0) then {_curveLength select 0} else {0.0};
//private _arcLengths		= if (count _curveLength > 1) then {_curveLength select 1} else {[]};
//private _arcPoints		= if (count _curveLength > 2) then {_curveLength select 2} else {[]};

_curve setVariable ["ArcTotalLength", _arcTotalLength];
//_curve setVariable ["ArcLengths", _arcLengths];
//_curve setVariable ["ArcPoints", _arcPoints];

// Mark as dirty
if (is3DEN) then
{
	[_curve] call BIS_fnc_richCurve_edenMarkStateDirty;
};