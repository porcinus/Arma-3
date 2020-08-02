/*
	Author: Nelson Duarte <@Nelson_G_Duarte>

	Description:
	Returns the value of given key

	Parameter(s):
	_this select 0: Object - The key

	Returns:
	Float - The key value
*/

// Parameters
private _key  = _this param [0, objNull, [objNull]];
private _type = _this param [1, 2, [0]];

// Switch type
switch (_type) do
{
	// Value float
	case 0:
	{
		_key getVariable ["Value", 0.0];
	};

	// Value vector
	case 1:
	{
		_key getVariable ["Value", [0.0, 0.0, 0.0]];
	};

	// Value location
	case 2:
	{
		getPosASLVisual _key;
	};

	// Value forward vector
	case 3:
	{
		vectorDirVisual _key;
	};

	// Value up vector
	case 4:
	{
		vectorUpVisual _key;
	};

	// Value camera FOV
	case 5:
	{
		[_key] call BIS_fnc_key_getFOV;
	};

	default
	{
		[0.0, 0.0, 0.0];
	};
};