/*
	Author: 
		Karel Moricky, optimised by Killzone_Kid

	Description:
		Gets display's color

	Parameters:
		0: STRING - Tag name (or BOOLEAN for init)
		1: STRING - Variable name
	
	Returns:
		ARRAY (or NOTHING for init)
*/

//--- Check and set all

private _init = param [0, ""];

if (_init isEqualType true) exitWith 
{
	if (_init) then
	{
		private 
		[
			"_varNameWithTag", 
			"_cfgVar", 
			"_defaultTagPresetInConfig", 
			"_defaultTagPresetUser", 
			"_currentTagPresetUser", 
			"_colorValueInConfig", 
			"_colorValueUser", 
			"_allTagPresetsInConfig"
		];
		
		private _saveProfileNamespace = false;
		private _isContact = isclass (configfile >> "CfgMods" >> "Contact");
		
		private _fnc_varCheckAndSet = 
		{
			params ["_cfgTag", "_varNameInConfig"];			
			_varNameWithTag = format ["%1_%2", configName _cfgTag, _varNameInConfig];
			
			//--- Check set default preset
			_varNameWithTag + "_presetDefault" call
			{
				_defaultTagPresetUser = profileNamespace getVariable _this;
				
				if (
					isNil "_defaultTagPresetUser" //--- Must be defined
					|| 
					{!(_defaultTagPresetUser isEqualType "")} //--- Must be string
					||
					{!(_defaultTagPresetUser isEqualTo _defaultTagPresetInConfig)} //--- Must match config value
				) 
				then
				{
					_saveProfileNamespace = true;
					_defaultTagPresetUser = _defaultTagPresetInConfig;
					profileNamespace setVariable [_this, _defaultTagPresetUser];
				};
			};
			
			//--- Check set current preset
			_varNameWithTag + "_preset" call
			{
				_currentTagPresetUser = profileNamespace getVariable _this;

				if (
					isNil "_currentTagPresetUser" //--- Must be defined
					|| 
					{!(_currentTagPresetUser isEqualType "")} //--- Must be string
					||
					{!(
						_currentTagPresetUser isEqualTo "" 
						|| 
						{(_cfgTag >> "Presets" >> _currentTagPresetUser) in _allTagPresetsInConfig} //--- Must be one of the config presets, unless it is custom preset
					)}
				) 
				then
				{
					_saveProfileNamespace = true;
					_currentTagPresetUser = _defaultTagPresetUser;
					profileNamespace setVariable [_this, _currentTagPresetUser];
				};

			};

			if (_varNameInConfig == "BCG_RGB") then {
				_var = _varNameWithTag + "_preset";
				_varVanilla = _var + "Vanilla";
				if (_isContact) then {
					//--- Save
					if (isnil {profileNamespace getVariable _varVanilla}) then {
						_saveProfileNamespace = true;
						profileNamespace setVariable [_varVanilla,_currentTagPresetUser];
						_currentTagPresetUser = _defaultTagPresetUser;
						profileNamespace setVariable [_var,_currentTagPresetUser];
					};
				} else {
					//--- Load
					_valueVanilla = profileNamespace getVariable _varVanilla;
					if (!isnil "_valueVanilla") then {
						_saveProfileNamespace = true;
						profileNamespace setVariable [_varVanilla,nil];
						_currentTagPresetUser = _valueVanilla;
						profileNamespace setVariable [_var,_currentTagPresetUser];
					};
				};
			};

			//--- Check set current colors
			_cfgVar = _cfgTag >> "Presets" >> _currentTagPresetUser >> "Variables" >> _varNameInConfig;
			
			getArray _cfgVar call
			{
				if !(count _this isEqualTo 4 || _currentTagPresetUser isEqualTo "") then {["Wrong color format %1 in %2", _cfgVar] call BIS_fnc_error};
				
				{
					_colorValueInConfig = param [_forEachIndex, parseNumber (_forEachIndex == 3)]; //--- Default [0,0,0,1]
					_colorValueUser = profileNamespace getVariable _x;

					//--- Force Contact main menu color
					if (_varNameInConfig == "BCG_RGB") then {
						_var = _x;
						_varVanilla = _var + "Vanilla";
						if (_isContact) then {
							//--- Save
							if (isnil {profileNamespace getVariable _varVanilla} && !isnil "_colorValueUser") then {
								_saveProfileNamespace = true;
								profileNamespace setVariable [_varVanilla,_colorValueUser];
								_colorValueUser = _colorValueInConfig;
								profileNamespace setVariable [_var,_colorValueUser];
							};
						} else {
							//--- Load
							_valueVanilla = profileNamespace getVariable _varVanilla;
							if (!isnil "_valueVanilla") then {
								_saveProfileNamespace = true;
								profileNamespace setVariable [_varVanilla,nil];
								_colorValueUser = _valueVanilla;
								profileNamespace setVariable [_var,_colorValueUser];
							};
						};
					};

					if (
						isNil "_colorValueUser"  //--- Must be defined
						|| 
						{!(_colorValueUser isEqualType 0)}  //--- Must be number
						|| 
						{!(_currentTagPresetUser isEqualTo "" || _colorValueUser isEqualTo _colorValueInConfig)}  //--- Must match config value, unless it is custom preset color
					) 
					then
					{
						_saveProfileNamespace = true;
						profileNamespace setVariable [_x, _colorValueInConfig];
					};
				}
				forEach [_varNameWithTag + "_R", _varNameWithTag + "_G", _varNameWithTag + "_B", _varNameWithTag + "_A"];
			};

			if (_saveProfileNamespace) then {saveProfileNamespace};

		};

		{
			_allTagPresetsInConfig = "true" configClasses (_x >> "Presets");
			
			_defaultTagPresetInConfig = _allTagPresetsInConfig select {getNumber (_x >> "default") isEqualTo 1} call
			{
				if (count _this > 1) then {["More than 1 default preset exists for the tag '%1'", configName _x] call BIS_fnc_error};
				configName (param [0, ""]) //--- Default preset in config for this tag
			};
			
			if (_defaultTagPresetInConfig isEqualTo "") exitWith {["No default preset exists for the tag '%1'", configName _x] call BIS_fnc_error};
			
			_x call
			{
				{
					[_this, configName _x] call _fnc_varCheckAndSet; //--- Check and set all variables
				}
				forEach ("true" configClasses (_this >> "Variables")); //--- Variables
			};
		}
		forEach ("true" configClasses (configfile >> "CfgUIColors")); //--- Tags
	};
	
	nil
};


//--- Get color
params [["_tag", "", [""]], ["_varName", "", [""]]];

if (_tag isEqualTo "" || _varName isEqualTo "") exitwith 
{
	["Missing tag or variable name %1", _this] call BIS_fnc_error; 
	[0, 0, 0, 1]
};

private _varNameWithTag = format ["%1_%2", _tag, _varName];

[
	profileNamespace getVariable [_varNameWithTag + "_R", 0], 
	profileNamespace getVariable [_varNameWithTag + "_G", 0], 
	profileNamespace getVariable [_varNameWithTag + "_B", 0], 
	profileNamespace getVariable [_varNameWithTag + "_A", 1]
]