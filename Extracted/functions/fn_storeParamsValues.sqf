/*
	Author:
		Killzone_Kid

	Description:
		Parses mission params and stores them into public variable "BIS_fnc_storeParamsValues_data"
		Use BIS_fnc_getParamValue to retrieve params values from the variable

	Parameter(s):
		NONE

	Returns:
		NOTHING
*/

if (isServer) then 
{
	private _values = [];
	private _names = [];
	
	private _fnc_pushParam = 
	{
		//--- Ignore when old params are not defined
		if !(isArray getMissionConfig format ["valuesParam%1", _this]) exitWith {};

		private _name = format ["param%1", _this];
		private _value = missionNamespace getVariable _name;

		if (isNil "_value") then 
		{
			private _cfg = getMissionConfig format ["defValueParam%1", _this];
			if (!isNull _cfg) then 
			{
				_values pushBack getNumber _cfg;
				_names pushBack _name;
			};
		}
		else
		{
			_values pushBack _value;
			_names pushBack _name;
		};
	};
	
	private _paramsArray =+ (missionNamespace getVariable ["paramsArray", []]);
	reverse _paramsArray;
	
	private _cfgParams = "true" configClasses getMissionConfig "Params";
	reverse _cfgParams;

	_paramsArray resize count _cfgParams;

	{
		private _value = _paramsArray select _forEachIndex;
		_values pushBack (if (isNil "_value") then {getNumber (_x >> "default")} else {_value});
		_names pushBack toLower configName _x;
	} 
	forEach _cfgParams;

	2 call _fnc_pushParam;
	1 call _fnc_pushParam;

	missionNamespace setVariable [
		"BIS_fnc_storeParamsValues_data",
		compileFinal ([_values, " param [", _names, " find toLower _this]"] joinString ""),
		true
	];
};