/*
	Author: Nelson Duarte <@Nelson_G_Duarte>

	Description:
	Resets camera in 3DEN

	Parameter(s):
	_this select 0: Object	- The camera

	Returns:
	Nothing
*/

// 3DEN only
if (!is3DEN) exitWith {};

// Reset
terminate (uiNamespace getVariable ["_scriptPIP", scriptNull]);
(uiNamespace getVariable ["_camPIP", objNull]) cameraEffect ["terminate", "back"];
uiNamespace setVariable ["_scriptPIP", nil];
uiNamespace setVariable ["_camPIP", nil];
(["CameraPIP"] call bis_fnc_rscLayer) cutText ["", "plain"];
get3DENCamera cameraEffect ["internal", "BACK"];