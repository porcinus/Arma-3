/*
NNS
Set global variable "srvFPS" with array [fps,servertime].
Return "current" server fps, last value if fail

Example:
	_serverFPS = call NNS_fnc_serverFPS; //will remoteexec on its own if client is not server
*/

_fps = (missionNamespace getVariable ["srvFPS", [0, 0]]) select 0; //get fps from var
if (isServer) then { //run on server
	_fps = floor (diag_fps); //get fps
	missionNamespace setVariable ["srvFPS", [_fps, serverTime], true]; //set glabal var
} else {
	estimatedTimeLeft (estimatedEndServerTime - serverTime); //force server to broadcast serverTime to all clients
	_null = remoteExec ["NNS_fnc_serverFPS", 2]; //remoteexec on server
	_time = time; //used for timeout
	waitUntil {(time - _time) < 1 && (abs (serverTime - ((missionNamespace getVariable ["srvFPS", [0, 0]]) select 1)) < 1)}; //not 1sec timeout and server time difference from global var under 1sec
	_fps = (missionNamespace getVariable ["srvFPS", [0, 0]]) select 0; //get fps from var
};

_fps //return current server fps