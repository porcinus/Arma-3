/*
	Author: Nelson Duarte <@Nelson_G_Duarte>

	Description:
	Returns true if this is a key with transform value, false if not

	Parameter(s):
	_this select 0: Object - The key

	Returns:
	Bool - True if key is of transform data type, false if not
*/

// Parameters
private _key = _this param [0, objNull, [objNull]];

// Whether it's transform key
[_key] call BIS_fnc_key_getValue isEqualTypeArray [[0.0, 0.0, 0.0], [0.0, 0.0, 0.0], [0.0, 0.0, 0.0]];