/*
	Author: 
		Karel Moricky, optimised by Killzone_Kid

	Description:
		Returns list of all parent classes
	
	Parameter(s):
		0: starting config class (Config)
		1: true if you want to return only classnames (Boolean)
	
	Returns:
		Array - List of all classes (including starting one)
*/

params ["_config", ["_returnNames", false]];

/// --- validate input
#include "..\paramsCheck.inc"
#define arr1 [_config,_returnNames]
#define arr2 [configNull,false]
paramsCheck(arr1,isEqualTypeArray,arr2)

private _ret = [];

if (_returnNames) exitWith 
{
	while {isClass _config} do 
	{
		_ret pushBack configName _config;
		_config = inheritsFrom _config;
	};
	
	_ret
};

while {isClass _config} do 
{
	_ret pushBack _config;
	_config = inheritsFrom _config;
};

_ret