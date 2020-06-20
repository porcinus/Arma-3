//NNS : add menu option for debug outputs
if (isServer) then {
	_debug_outputs_level = param [0,9,[999]];
	missionNamespace setVariable ["DebugOutputs_enable",false];
	missionNamespace setVariable ["DebugOutputs_Chatbox",false];
	missionNamespace setVariable ["DebugOutputs_Logs",false];
	if (_debug_outputs_level == 0) then {missionNamespace setVariable ["DebugOutputs_enable",false];};
	if (_debug_outputs_level > 0) then {missionNamespace setVariable ["DebugOutputs_enable",true];}; //debug output enable
	if (_debug_outputs_level == 1 || {_debug_outputs_level == 3}) then {missionNamespace setVariable ["DebugOutputs_Chatbox",true];}; //debug output to chatbox
	if (_debug_outputs_level == 2 || {_debug_outputs_level == 3}) then {missionNamespace setVariable ["DebugOutputs_Logs",true];}; //debug output to server logs
	publicVariable "DebugOutputs_enable";
	publicVariable "DebugOutputs_Chatbox";
	publicVariable "DebugOutputs_Logs";
};
