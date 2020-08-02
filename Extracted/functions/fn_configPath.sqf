/*
	Author: 
		Karel Moricky, optimised by Killzone_Kid

	Description:
		Returns config path to given entry in given format

	Parameter(s):
		0: CONFIG or ARRAY or STRING
		1: (Optional) ARRAY or STRING or CONFIG - type of returned value. Default: ARRAY, unless ARRAY is input, then CONFIG is returned (see Example 1)
		2: (Optional) BOOL - by default the function will not attempt to construct a valid config before certain format convertions (see Example 2)
		Set this param to TRUE to invoke the strict mode

	Returns:
		ARRAY - list of classes (e.g., ["configfile","CfgVehicles"])
		STRING - composed path (e.g., "configfile >> 'CfgVehicles'")
		CONFIG - system path (e.g., configfile >> "CfgVehicles")
	
	Example 1:
		["configFile >> ""CfgVehicles"" >> ""Car"""] call BIS_fnc_configPath; // ["configFile","CfgVehicles","Car"]
		[["configFile","CfgVehicles","Car"]] call BIS_fnc_configPath; // bin\config.cpp/CfgVehicles/Car
		["bin\config.cpp/CfgVehicles/Car"] call BIS_fnc_configPath; // ["configFile","CfgVehicles","Car"]
		[configFile >> "CfgVehicles" >> "Car", ""] call BIS_fnc_configPath; // "configFile >> ""CfgVehicles"" >> ""Car"""
	
	Example 2:
		[["mary", "had", "a", "little", "lamb"], ""] call BIS_fnc_configPath; // "mary >> ""had"" >> ""a"" >> ""little"" >> ""lamb"""
		[["mary", "had", "a", "little", "lamb"], "", true] call BIS_fnc_configPath; // "" invalid config
		[["mary", "had", "a", "little", "lamb"], []] call BIS_fnc_configPath; // ["mary", "had", "a", "little", "lamb"]
		[["mary", "had", "a", "little", "lamb"], [], true] call BIS_fnc_configPath; // [""] invalid config
*/

private _fnc_getNameFromConfig = 
{
	if (_this isEqualTo configFile) exitWith {"configFile"};
	if (_this isEqualTo missionConfigFile) exitWith {"missionConfigFile"};
	if (_this isEqualTo campaignConfigFile) exitWith {"campaignConfigFile"};
	configName _this
};

private _fnc_getConfigHierarchy = 
{
	if (_this isEqualTo []) exitWith {[configNull]};
	
	private _base = _this deleteAt 0 call 
	{
		if (_this isEqualTo "") exitWith {configNull};
		if (_this == "configFile" || {_this == str configFile}) exitWith {configFile};
		if (_this == "missionConfigFile" || {_this == str missionConfigFile}) exitWith {missionConfigFile};
		if (_this == "campaignConfigFile" || {_this == str campaignConfigFile}) exitWith {campaignConfigFile};
		configNull
	};
	
	if (!isNull _base) exitWith {[_base] + (_this apply {_base = _base >> _x; _base})};
	[configNull]
};

params [["_config", -1], "_type", ["_strict", false]];

// check param 1
if !(_config isEqualTypeAny [[], "", configNull]) exitWith {[_this, "isEqualTypeParams", [[], configNull]] call BIS_fnc_errorParamsType};

// if input ARRAY and no type is given, return CONFIG 
if (_config isEqualType [] && isNil "_type") then {_type = configNull};

// otherwise return ARRAY, unless return type is given
if (isNil "_type") then {_type = []};

// check param 2
if !(_type isEqualTypeAny [[], "", configNull]) exitWith {[_this, "isEqualTypeParams", [[], configNull]] call BIS_fnc_errorParamsType};

// no conversion needed
if (_strict isEqualTo false && {_config isEqualType _type}) exitWith {_config};

private _cfgArr = [configNull];

// parse config
if (_config isEqualType configNull && {!isNull _config}) then 
{
	if (isClass _config) exitWith {_cfgArr = configHierarchy _config};
	_cfgArr = str _config splitString "/" call _fnc_getConfigHierarchy;
};

// parse string (could be many different formats)
if (_config isEqualType "" && {!(_config isEqualTo "")}) then 
{
	call
	{
		if (_config find ">>" > -1) exitWith // "a >> ""b"" >> ""c""", "a >> 'b' >> 'c'"
		{
			_cfgArr = _config splitString " >""'" call _fnc_getConfigHierarchy;
		};
		
		if (_config find "\" > -1) exitWith // "bin\config.bin/CfgVehicles"...etc
		{
			_cfgArr = _config splitString "/" call _fnc_getConfigHierarchy;
		};
		
		// "a / ""b"" / ""c""", // "a / 'b' / 'c'"
		_cfgArr = _config splitString " /""'" call _fnc_getConfigHierarchy;
	};
};

// convert array of strings to string (allow non-existing configs)
if (_strict isEqualTo false && {[_config, _type] isEqualTypeParams [[], ""]}) exitWith 
{
	private _strArr = _config apply {str _x};
	_strArr set [0, _config param [0, ""]];
	_strArr joinString " >> "
};

// parse array of strings
if (_config isEqualType [] && {_config isEqualTypeAll ""}) then {_cfgArr = +_config call _fnc_getConfigHierarchy};

// return config
if (_type isEqualType configNull) exitWith {_cfgArr select (count _cfgArr - 1)};

// return string
if (_type isEqualType "") exitWith {([_cfgArr deleteAt 0 call _fnc_getNameFromConfig] + (_cfgArr apply {str (_x call _fnc_getNameFromConfig)})) joinString " >> "};

// return default array of strings
_cfgArr apply {_x call _fnc_getNameFromConfig}