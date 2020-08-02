_unit = _this param [0,objnull,[objnull]];
_respawn = _this param [2,-1,[0]];

//--- Check the respawn templates -> for new respawn screen only allow button, but does not start spectator right here
_respawnScreen = false;
_respawnTemplates = getMissionConfigValue "respawnTemplates";
_sideTemplates = getMissionConfigValue ("respawnTemplates" + str (side group player));	//check side specific templates as well
if ((!isNil "_sideTemplates") && {(count _sideTemplates) > 0}) then {_respawnTemplates = _sideTemplates};
if ((isNil "_respawnTemplates") || {(typeName []) != (typeName _respawnTemplates)}) then {_respawnTemplates = []};
{if (_x in ["MenuPosition","MenuInventory"]) then {_respawnScreen = true}} forEach _respawnTemplates;

//_layer = "BIS_fnc_respawnSpectator" call bis_fnc_rscLayer;

if (!alive _unit) then {
	//_layer cutrsc ["RscSpectator","plain"];
	if (_respawnScreen) then {
		if !(isNil {uiNamespace getVariable "BIS_RscRespawnControlsMap_ctrlButtonSpectate"}) then {
			(uiNamespace getVariable "BIS_RscRespawnControlsMap_ctrlButtonSpectate") ctrlEnable true;
			(uiNamespace getVariable "BIS_RscRespawnControlsMap_ctrlButtonSpectate") ctrlSetTooltip "";
		};
	} else {
		["Initialize", [player, [], false]] call BIS_fnc_EGSpectator;
	};
} else {
	if (_respawn == 1) then {

		//--- Open
		waituntil {missionnamespace getvariable ["BIS_fnc_feedback_allowDeathScreen",true]};
		BIS_fnc_feedback_allowPP = false;
		//(["HealthPP_black"] call bis_fnc_rscLayer) cutText ["","BLACK IN",1];
		//_layer cutrsc ["RscSpectator","plain"];
		if (_respawnScreen) then {
			if !(isNil {uiNamespace getVariable "BIS_RscRespawnControlsMap_ctrlButtonSpectate"}) then {
				(uiNamespace getVariable "BIS_RscRespawnControlsMap_ctrlButtonSpectate") ctrlEnable true;
				(uiNamespace getVariable "BIS_RscRespawnControlsMap_ctrlButtonSpectate") ctrlSetTooltip "";
			};
		} else {
			["Initialize", [player, [], false, true, true]] call BIS_fnc_EGSpectator;
		};
	} else {

		//--- Close
		//_layer cuttext ["","plain"];
		if (_respawnScreen) then {
			if !(isNil {uiNamespace getVariable "BIS_RscRespawnControlsMap_ctrlButtonSpectate"}) then {
				(uiNamespace getVariable "BIS_RscRespawnControlsMap_ctrlButtonSpectate") ctrlEnable false;
				(uiNamespace getVariable "BIS_RscRespawnControlsMap_ctrlButtonSpectate") ctrlSetTooltip (localize "STR_A3_RscRespawnControls_SpectatingDisabled");
			};
		} else {
			["Terminate"] call BIS_fnc_EGSpectator;
		};
	};
};