/*
 * Author: Zozo
 * Rotates the vector around the given axis by the given angle
 *
 * Arguments:
 * 0: _vector ARRAY [x,y,z]
 * 1: _angle SCALAR (accepts also negative numbers)
 * 2: _axis (AXIS_X - 0, AXIS_Y - 1 AXIS_Z - 2)
 *
 * Return Value:
 * ARRAY [x,y,z]
 *
 * Example:
 [vectorDir player, 90, AXIS_Z] call BIS_rotateVector;
 *
 *
 * Dependency: BIS_fnc_multiplySquareMatrixByVector
 */

#include "\a3\Functions_F\matrix_defines.inc"
params [ "_vector", "_angle", "_axis" ];

private _matrix = [];
switch (_axis)
do
{
 case (AXIS_X): {_matrix = MATRIX_X};
 case (AXIS_Y): {_matrix = MATRIX_Y};
 case (AXIS_Z): {_matrix = MATRIX_Z};
};
[_matrix, _vector] call BIS_fnc_multiplySquareMatrixByVector
