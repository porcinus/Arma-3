/*
	Author: 
		Killzone_Kid

	Description:
		Converts expression into a number (or array of expressions into an array of numbers)
		If expression does not return a number, 0 is returned

	Parameter(s):
		NUMBER, STRING, ARRAY, SIDE, CONFIG (NUMBER, STRING, ARRAY) 
			
	Returns:
		NUMBER (or ARRAY of NUMBERs if ARRAY is passed as an argument)
*/

#define THIS_FUNCTION BIS_fnc_parseNumberSafe
#define MATH_OPS \
[ \
	"safezonex", "safezoney", "safezonew", "safezoneh", "safezonexabs", "min", "max", "sqrt", "abs", "floor", "ceil", "round", "mod", \
	"sin", "cos", "tan", "acos", "asin", "atan", "atan2", "ln", "pi", "rad", "deg", "e", "log", \
	"pixelw", "pixelh", "pixelgrid", "pixelgridbase", "pixelgridnouiscale" \
]

private _fnc_parseNumberConfigArray = 
{
	if (_this isEqualType 0) exitWith { _this };
				
	if (_this isEqualType "") exitWith 
	{
		private _res = [call compile _this] param [0, 0];
		[0, _res] select (_res isEqualType 0) 
	};
	
	0
};

if (_this isEqualType 0) exitWith { _this };

if (_this isEqualType "") exitWith
{	
	private _res = { if !(toLower _x in MATH_OPS) exitWith { 0 } } forEach (_this splitString ("+-*/^%.0123456789( )" + toString [9,10,13]));
	
	if (isNil "_res") then { _res = [call compile _this] param [0, 0] };
	[0, _res] select (_res isEqualType 0)
};

if (_this isEqualType configNull) exitWith
{
	if (isNumber _this) exitWith { getNumber _this };

	if (isText _this) exitWith 
	{ 
		private _res = [call compile getText _this] param [0, 0];
		[0, _res] select (_res isEqualType 0)
	};

	if (isArray _this) exitWith { getArray _this apply { _x call _fnc_parseNumberConfigArray } };
	
	0
};

if (_this isEqualType []) exitWith { _this apply { _x call THIS_FUNCTION } };

if (_this isEqualType sideUnknown) exitWith { _this call BIS_fnc_sideID };

0 