/*
	Author: 
		Karel Moricky, optimised by Killzone_Kid

	Description:
		Sets unit inisgnia (e.g., shoulder insignia on soldiers)

	Parameter(s):
		0: OBJECT - unit
		1: STRING - CfgUnitInsignia class. Use an empty string to remove current insignia.

	Returns:
		BOOL - true if insignia was set
*/

/// --- validate input
#include "..\paramsCheck.inc"
#define arr [objNull,""]
paramsCheck(_this,isEqualTypeParams,arr)

#define DEFAULT_MATERIAL "\a3\data_f\default.rvmat"
#define DEFAULT_TEXTURE "#(rgb,8,8,3)color(0,0,0,0)"

params ["_unit", "_class"];

// --- load texture from config.cpp or description.ext
private _cfgInsignia = [["CfgUnitInsignia", _class], configNull] call BIS_fnc_loadClass;

// --- check if insignia exists
if (configName _cfgInsignia != _class) exitWith 
{
	[
		"'%1' is not found in CfgUnitInsignia. Available classes: %2", 
		_class, 
		("true" configClasses (configFile >> "CfgUnitInsignia") apply {configName _x}) 
		+ 
		("true" configClasses (missionConfigFile >> "CfgUnitInsignia") apply {configName _x})
		+
		("true" configClasses (campaignConfigFile >> "CfgUnitInsignia") apply {configName _x})
	] 
	call BIS_fnc_error; 
	false
};

private _set = false;

// --- find insignia index in hidden textures
{
	if (_x == "insignia") exitWith 
	{ 	
		isNil // --- make it safe in scheduled
		{
			// --- set insignia if not set
			if (_unit call BIS_fnc_getUnitInsignia != _class) then
			{
				_unit setVariable ["BIS_fnc_setUnitInsignia_class", [_class, nil] select (_class isEqualTo ""), true];			
				_unit setObjectMaterialGlobal [_forEachIndex, getText (_cfgInsignia >> "material") call {[_this, DEFAULT_MATERIAL] select (_this isEqualTo "")}];
				_unit setObjectTextureGlobal [_forEachIndex, getText (_cfgInsignia >> "texture") call {[_this, DEFAULT_TEXTURE] select (_this isEqualTo "")}];
				_set = true;
			};
		};
	};
} 
forEach getArray (configFile >> "CfgVehicles" >> getText (configFile >> "CfgWeapons" >> uniform _unit >> "ItemInfo" >> "uniformClass") >> "hiddenSelections");

_set 