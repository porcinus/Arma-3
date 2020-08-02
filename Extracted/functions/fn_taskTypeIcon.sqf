/*
	Author: Jiri Wainar

	Description:
	Returns path to the icon texture associated with given task type.

	Parameters:
		0: STRING - task type
		1: STRING - default path; used in case task type was not found

	Returns:
		STRING - path to the task type texture
*/

#include "defines.inc"

private _type 	 = param [0, "Default", [""]];

private _readConfig =
{
	private _default = param [1, configFile >> "CfgTaskTypes" >> "Default" >> "icon", [configNull]];
	private _config  = [["CfgTaskTypes",_type,"icon"],_default] call bis_fnc_loadEntry;

	getText _config
};

missionNamespace getVariable ["bis_fnc_taskTypeIcon_" + _type, call _readConfig]