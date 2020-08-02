/*
	Author: 
		Karel Moricky, modified by Killzone_Kid

	Description:
		Initialize mission params and create log in the diary

	Parameter(s):
		NONE

	Returns:
		BOOL
*/

_fnc_scriptName = "param";

private _diaryArray = [];
private _diaryAvailable = hasInterface && !isNull player;
private _fnc_pushToDiaryArray = 
{	
	params ["_cfg", "_value", ["_param", ""]];
	private _valueTitle = getText (_cfg >> format ["title%1", _param]);
	if (_valueTitle isEqualTo "") then {_valueTitle = [_param, configName _cfg] select (_param isEqualTo "")};
	_diaryArray pushBack [
		_valueTitle, 
		getArray (_cfg >> format ["texts%1", _param]) param [
			getArray (_cfg >> format ["values%1", _param]) find _value, 
			_value
		]
	];
};

//--- Check if primary params exist then add them to the diary array
if (_diaryAvailable) then 
{
	private _param1 = ["param1", nil] call BIS_fnc_getParamValue;
	if (!isNil "_param1") then {[missionConfigFile, _param1, "param1"] call _fnc_pushToDiaryArray};
	private _param2 = ["param2", nil] call BIS_fnc_getParamValue;
	if (!isNil "_param2") then {[missionConfigFile, _param2, "param2"] call _fnc_pushToDiaryArray};
};

{
	private _value = configName _x call BIS_fnc_getParamValue;
	if (_diaryAvailable) then {[_x, _value] call _fnc_pushToDiaryArray};
		
	if (isServer || getNumber (_x >> "isGlobal") > 0) then
	{
		private _code = _x call
		{
			private _functionVar = getText (_this >> "function");
			if !(_functionVar isEqualTo "") exitWith 
			{
				private _function = missionNamespace getVariable _functionVar;
				if (isNil "_function" || {!(_function isEqualType {})}) then
				{
					["Function '%1' is not found or invalid, cannot initialize '%2' mission param.", _functionVar, configName _this] call BIS_fnc_error;
					_function = {};
				};
				
				_function
			};
			
			private _scriptFile = getText (_this >> "file");
			if !(_scriptFile isEqualTo "") exitWith {compile preprocessFileLineNumbers _scriptFile};
			
			{}
		};
		
		//--- Call params function if there is one
		[_value] call _code; 
	};	
}
forEach ("true" configClasses getMissionConfig "Params");

//--- Prepare diary records
if !(_diaryArray isEqualTo []) then 
{
	private _text = "";
	{
		_text = _text + format [
			"<img image='#(argb,8,8,3)color(1,1,1,0.1)' height='1' width='640' /><br /><br /><font>%1</font><br /><font size='16' face='PuristaLight'>%2</font><br />",
			_x select 0,
			_x select 1
		];
	} 
	forEach _diaryArray;

	//--- Add diary records
	[player, localize "STR_DISP_XBOX_EDITOR_WIZARD_PARAMS", _text] call BIS_fnc_createLogRecord;
};

true