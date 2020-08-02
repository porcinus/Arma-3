/*
	Author: Nelson Duarte <@Nelson_G_Duarte>

	Description:
	Whether two vectors are equal with given tolerance

	Parameter(s):
	_this select 0: Array 	- The first vector
	_this select 1: Array 	- The second vector
	_this select 2: Number 	- The tolerance

	Returns:
	bool - True if equal, false if not
*/

private _a 			= _this param [0, [0.0, 0.0, 0.0], [[]]];
private _b 			= _this param [1, [0.0, 0.0, 0.0], [[]]];
private _tolerance 	= _this param [2, 0.0, [0.0]];

abs((_a select 0) - (_b select 0)) <= _tolerance &&
abs((_a select 1) - (_b select 1)) <= _tolerance &&
abs((_a select 2) - (_b select 2)) <= _tolerance;