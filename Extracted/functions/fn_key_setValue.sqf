/*
	Author: Nelson Duarte <@Nelson_G_Duarte>

	Description:
	Set's the value of given key

	Parameter(s):
	_this select 0: Object	- The key
	_this select 1: Float	- The new value

	Returns:
	Nothing
*/

// Parameters
private _key	= _this param [0, objNull, [objNull]];
private _value	= _this param [1, [0.0, 0.0, 0.0], [0.0, []]];
private _type 	= _this param [2, 2, [0]];

// Switch type
switch (_type) do
{
	// Value float
	case 0:
	{
		_key setVariable ["Value", _value];
	};

	// Value vector
	case 1:
	{
		_key setVariable ["Value", _value];
	};

	// Value location
	case 2:
	{
		_key setPosASL _value;
		_key setVariable ["Value", _value];
	};

	// Value forward vector
	case 3:
	{
		_key setVectorDir _value;
		_key setVariable ["Value", _value];
	};

	// Value up vector
	case 4:
	{
		_key setVectorUp _value;
		_key setVariable ["Value", _value];
	};

	// Value transform
	case 5:
	{
		_key setPosASL (_value select 0);
		_key setVectorDir (_value select 1);
		_key setVectorUp (_value select 2);
		_key setVariable ["Value", _value];
	};

	default
	{
		_key setVariable ["Value", [0.0, 0.0, 0.0]];
	};
};