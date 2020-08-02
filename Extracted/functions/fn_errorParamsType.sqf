/*
	Author: Killzone_Kid

	Description:
		Displays params type error message explaining the problem

	Parameter(s):
		0: ANY - actual input
		1: STRING - validation method - the name of type validation command used:
			*	"isEqualType"
			*	"isEqualTypeArray"
			*	"isEqualTypeAll"
			*	"isEqualTypeAny"
			*	"isEqualTypeParams"
		2: ANY - expected input type format

	Returns:
		NOTHING
	
	Example1:
		//Show error and abort if input is not of type ARRAY
		if !(_this isEqualType []) exitWith {[_this,"isEqualType",[]] call BIS_fnc_errorParamsType};
	
	Example2:
		//Show error and abort if array input is not in format [SCALAR,STRING,BOOL]
		if !(_this isEqualTypeArray [0,"",true]) exitWith {[_this,"isEqualTypeArray",[0,"",true]] call BIS_fnc_errorParamsType};
	
	Example3:
		//Show error and abort if array input is not in format [BOOL,BOOL,BOOL....]
		if !(_this isEqualTypeAll true) exitWith {[_this,"isEqualTypeAll",true] call BIS_fnc_errorParamsType};
		
	Example4:
		//Show error and abort if input is neither ARRAY nor OBJECT
		if !(_this isEqualTypeAny [[],objNull]) exitWith {[_this,"isEqualTypeAny",[[],objNull]] call BIS_fnc_errorParamsType};
	
	Example5:
		//Show error and abort if input is neither of type ARRAY nor array in format [SCALAR,ARRAY,<ANYTHING>,OBJECT....]
		if !(_this isEqualTypeParams [0,[],nil,objNull]) exitWith {[_this,"isEqualTypeParams",[0,[],nil,objNull]] call BIS_fnc_errorParamsType};
	
*/

#define TYPE_ERROR "Error: type %1, expected %2, in %3"
#define ARRAY_TYPE_ERROR "Error: type %1, expected %2, on index %3, in %4"
#define ARRAY_SIZE_ERROR "Error: size %1, expected %2, in %3"
#define THIS_FUNCTION "BIS_fnc_errorParamsType"

private _fnc_getTypeName = 
{
	if (isNil {_this select 0}) then {"ANY"} else {typeName (_this select 0)};
};

try 
{
	if !(params [["_actual",nil],["_method","",[""]],["_expected",nil]]) then 
	{
		throw ["%1: Invalid Input", THIS_FUNCTION];
	};

	if (_method == "isEqualType") then 
	{
		if !(_actual isEqualType _expected) then 
		{
			throw [TYPE_ERROR, [_actual] call _fnc_getTypeName, [_expected] call _fnc_getTypeName, str _actual];
		};
	};

	if (_method == "isEqualTypeArray") then 
	{
		private _actualCount = count _actual;
		private _expectedCount = count _expected;
		
		if (_actualCount != _expectedCount) then 
		{
			throw [ARRAY_SIZE_ERROR, _actualCount, _expectedCount, str _actual];
		};
		
		{
			private _par = _actual select _forEachIndex;
			
			if !(isNil "_x" && isNil "_par") then 
			{
				if !(!isNil "_x" && !isNil "_par" && {_par isEqualType _x}) then 
				{
					throw [ARRAY_TYPE_ERROR, [_par] call _fnc_getTypeName, [_x] call _fnc_getTypeName, _forEachIndex, str _actual];
				};
			};
		} 
		forEach _expected;
	};
	
	if (_method == "isEqualTypeAll") then 
	{
		if (_actual isEqualTo []) then 
		{
			throw [ARRAY_SIZE_ERROR, 0, 1, str _actual];
		};
		
		{
			if !(!isNil "_x" && {_x isEqualType _expected}) then 
			{
				throw [ARRAY_TYPE_ERROR, [_x] call _fnc_getTypeName, [_expected] call _fnc_getTypeName, _forEachIndex, str _actual];
			};
		} 
		forEach _actual;
	};
	
	if (_method == "isEqualTypeAny") then 
	{	
		_expected = _expected arrayIntersect _expected;
		
		{
			_expected set [_forEachIndex, [_x] call _fnc_getTypeName];
		} 
		forEach _expected;
		
		private _actualTypeName = [_actual] call _fnc_getTypeName;
		
		if !(_expected isEqualTo [] || _actualTypeName in _expected) then 
		{
			throw [TYPE_ERROR, _actualTypeName, _expected joinString ", ", str _actual];
		};
	};
	
	if (_method == "isEqualTypeParams") then 
	{
		if !(_actual isEqualType []) then 
		{
			throw [TYPE_ERROR, [_actual] call _fnc_getTypeName, typeName [], str _actual];
		};
		
		private _actualCount = count _actual;
		private _expectedCount = count _expected;
		
		if (_actualCount < _expectedCount) then 
		{
			throw [ARRAY_SIZE_ERROR, _actualCount, _expectedCount, str _actual];
		};
		
		{
			private _par = _actual select _forEachIndex;
			
			if (!isNil "_x") then 
			{
				if !(!isNil "_par" && {_par isEqualType _x}) then 
				{
					throw [ARRAY_TYPE_ERROR, [_par] call _fnc_getTypeName, [_x] call _fnc_getTypeName, _forEachIndex, str _actual];
				};
			};
		} 
		forEach _expected;
	};
	
	throw ["%1: Unknown Validation Method", THIS_FUNCTION];
} 
catch 
{
	_exception call BIS_fnc_error;
	
	nil
};