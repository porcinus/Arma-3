/*
NNS
Output debug to chatbox or log, local or global

if _logs set to false, will try to recover DebugOutputs_Logs value.
if _chatbox set to false, will try to recover DebugOutputs_Chatbox value.
if _override set to false, variable "DebugOutputs_enable" to be set global and true to allow output to chatbox and/or logs.

Example: 
["text",_logs,_chatbox,_local,_override] call NNS_fnc_debugOutput;
["text bal bla bla",true,true,true,false] call NNS_fnc_debugOutput;

*/

// Params
params
[
	["_text",""], //text to output
	["_logs",false], //output to logs
	["_chatbox",false], //output to chatbox
	["_local",false], //output local
	["_override",false] //override DebugOutputs_enable value
];

_debug_enable = false;
if !(isNil "DebugOutputs_enable") then {_debug_enable = DebugOutputs_enable;}; //recover debug bool
if (_override) then {_debug_enable = true;}; //overide debug bool
if (!_logs && {!isNil "DebugOutputs_Logs"}) then {_logs = DebugOutputs_Logs;}; //recover DebugOutputs_Logs value
if (!_chatbox && {!isNil "DebugOutputs_Chatbox"}) then {_chatbox = DebugOutputs_Chatbox;}; //recover DebugOutputs_Chatbox value
if (!_debug_enable || {_text==""} || {(!_logs && !_chatbox)}) then {exit;}; //nothing to output, exit



if (_local) then { //local effect
	if (_chatbox) then {systemChat format["DEBUG (local) : %1",_text];}; //output to chatbox
	//if (_logs) then {diag_log format["DEBUG (local) : %1",_text];}; //output to log
} else { //global effect
	if (_chatbox) then {[format["DEBUG (%1:%2) : %3",player,name player,_text]] remoteExec ["systemChat",0,true];}; //global output to chatbox
	//if (_logs) then {[format["DEBUG (%1) : %2",player,_text]] remoteExec ["diag_log",0,true];}; //global output to log
};

if (_logs && {isServer}) then {diag_log format["DEBUG (%1:%2) : %3",player,name player,_text];}; //output to local log
