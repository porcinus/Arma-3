/*
	Author: Thomas Ryan
	
	Description:
	Add effects to a live feed via a module.
	
	Parameters:
		_this: OBJECT - Live Feed - Effects module
*/

// They ran me on a dedicated server. I stopped their function.
if (isDedicated) exitWith {true};

// Wait for a live feed to exist
waitUntil {!(isNil "BIS_liveFeed")};

private ["_module"];
_module = _this param [0, objNull, [objNull]];

// Apply defined effects
private ["_mode"];
_mode = _module getVariable "EffectMode";
if (typeName _mode == typeName "") then {_mode = parseNumber _mode};
_mode call BIS_fnc_liveFeedEffects;

true