/*--------------------------------------------------------------------------------------------------

	TERMINATE ALL BUT 1ST MODULE

--------------------------------------------------------------------------------------------------*/
private["_initialized"];

_initialized = missionNamespace getVariable ["bis_fnc_moduleSpawnAIOptions_initialized",false];

//make sure the module script runs only once
if (_initialized) exitWith {}; missionNamespace setVariable ["bis_fnc_moduleSpawnAIOptions_initialized",true];

/*--------------------------------------------------------------------------------------------------

	FLAG THE 1ST MODULE AS INITIALIZED

--------------------------------------------------------------------------------------------------*/
private["_module"];

_module = _this param [0,objNull,[objNull]];
_module setVariable ["initialized",true];