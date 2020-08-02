/*
	Author: Thomas Ryan
	
	Description:
	Initializes the classes players can choose from before spawning.
	Must only be executed on the server.
	
	Parameters:
		_this (Optional): STRING - Can be either "DAY" (unsilenced, no NVGs, default) or "NIGHT" (silenced, NVGs)
	
	Returns:
	True if successful, false if not.
*/

private _mode = param [0, "DAY", [""]];
_mode = toUpper _mode;

if (!(isServer)) exitWith {"Must only be executed on the server!" call BIS_fnc_error; false};
if (!(_mode in ["DAY", "NIGHT"])) exitWith {"Mode must be either ""DAY"" or ""NIGHT""!" call BIS_fnc_error; false};

if (_mode == "DAY") then {
	// Unsilenced
	{[missionNamespace, _x] call BIS_fnc_addRespawnInventory} forEach ["Rifleman", "Grenadier", "MachineGunner", "Medic", "Engineer", "RiflemanAT", "Scout", "Sharpshooter", "Saboteur"];
} else {
	// Silenced
	{[missionNamespace, _x] call BIS_fnc_addRespawnInventory} forEach ["Rifleman_Night", "Grenadier_Night", "MachineGunner_Night", "Medic_Night", "Engineer_Night", "RiflemanAT_Night", "Scout_Night", "Sharpshooter_Night", "Saboteur_Night"];
};

true