/*
	Author: 
		Killzone_Kid

	Description:
		Executes Debug Console code

	Parameter(s):
		0: NUMBER - target (0: local, 1: global, 2: server)
		1: CODE - code

	Returns:
		NOTHING
*/

#define FNC_ERROR (missionNamespace getVariable "BIS_fnc_error")
#define EXEC_RESULT str ([nil] apply {[] call (_this select 0)} param [0, text ""])
#define EXEC_RESULT_CTRL (parsingNamespace getVariable ["BIS_RscDebugConsoleExpressionResultCtrl", controlNull])

if (isServer && call (missionNamespace getVariable "BIS_fnc_isDebugConsoleAllowed")) exitWith
{
	// local execution (return local result)
	if (!isMultiplayer) exitWith
	{
		[[_this select 1], {EXEC_RESULT_CTRL ctrlSetText EXEC_RESULT}] remoteExec ["call", 0];
	};
	
	/* MP MODE STARTS HERE */
	
	if (!isRemoteExecuted || isRemoteExecutedJIP) exitWith
	{
		["This function should not be called stand alone or from JIP queue"] call FNC_ERROR;
	};
	
	// global execution (return local result)
	if (_this select 0 isEqualTo 1) exitWith
	{
		[[_this select 1, remoteExecutedOwner], {EXEC_RESULT_CTRL ctrlSetText ([nil, EXEC_RESULT] select (_this select 1 isEqualTo clientOwner))}] remoteExec ["call", 0];
	};
	
	// local execution (return local result)
	if (_this select 0 isEqualTo 0) exitWith
	{
		[[_this select 1], {EXEC_RESULT_CTRL ctrlSetText EXEC_RESULT}] remoteExec ["call", remoteExecutedOwner];
	};

	// server execution (return server result)
	if (_this select 0 isEqualTo 2) exitWith
	{
		[[_this select 1, remoteExecutedOwner], {[EXEC_RESULT, {EXEC_RESULT_CTRL ctrlSetText _this}] remoteExec ["call", _this select 1]}] remoteExec ["call", 2];
	};
	
	["Unsupported remoteExec target: %1", _this select 1] call FNC_ERROR;
	
};

["Execution of debug console code in this context is not allowed"] call FNC_ERROR;