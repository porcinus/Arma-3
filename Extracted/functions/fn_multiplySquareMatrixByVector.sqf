/*
 * Author: Zozo
 * Multiplies the square matrix by a vector: A(m,m) x V(m)
 *
 * Arguments:
 * 0: _matrix ARRAY (multi-dimensional)
 * 1: _vector ARRAY ([x,y,z] or [x,y,z,1])
 *
 * Return Value:
 * ARRAY [x,y,z]
 *
 * Example:
 * [_transformMatrix, vectorDir player] call BIS_multiplySquareMatrixVector
 *
 */

 params ["_matrix", "_vector"];
 if(count _vector == 3) then { _vector pushBack 1 };
 private _resultVector = [];
 {
     private _rowSum = 0;
     { _rowSum = _rowSum + (_x*_vector#_forEachIndex) } forEach _x;
     _resultVector pushBack _rowSum;
 } forEach _matrix;
 _resultVector deleteAt 3;
 _resultVector
