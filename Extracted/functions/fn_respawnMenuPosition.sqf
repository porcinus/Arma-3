disableSerialization;

// Params
private _unit 			= _this param [0,objnull,[objnull]];
private _respawnDelay 	= _this param [3, 0, [0]];
private _revive 		= _this param [4, false, [false]];

// Originally meant to let handling of the respawn on revive scripts, currently for back compatibility reasons
if (_unit getVariable ["BIS_fnc_showRespawnMenu_disable", false]) exitWith {};

// Unit dead, show respawn menu
if !(alive player) then
{
	// Clean all dead units from the disabled array - new check is needed, theay can be alive already
	["enable",uiNamespace getVariable "BIS_RscRespawnControlsMap_ctrlLocList",0,localize "STR_A3_RscRespawnControls_UnitUnavailable", [player] call BIS_fnc_objectVar] call BIS_fnc_showRespawnMenuDisableItem;

	// Open menu
	["open"] call BIS_fnc_showRespawnMenu;
}
// Unit alive, hide respawn menu
else
{
	// Undefined controls of respawn screen -> initial respawn on the start of mission, unit needs to be placed somewhere before player selects where he should be respawned
	if (isNil {uiNamespace getVariable "BIS_RscRespawnControlsMap_ctrlLocList"}) then
	{
		[player,((player call bis_fnc_getRespawnPositions) + ((player call bis_fnc_objectSide) call bis_fnc_getRespawnMarkers)) select 0] call BIS_fnc_moveToRespawnPosition;
	}
	else
	{
		// Move player to proper position
		_list = uiNamespace getVariable "BIS_RscRespawnControlsMap_ctrlLocList";

		if (missionNamespace getVariable ["BIS_RscRespawnControlsSpectate_shown", false]) then {_list = uiNamespace getVariable "BIS_RscRespawnControlsSpectate_ctrlLocList"};

		_curSel = if !(lbCurSel _list < 0) then {lbCurSel _list} else {0};

		if !(isNil {uiNamespace getVariable "BIS_RscRespawnControls_posMetadata"}) then
		{
			_metadata = ["get",_curSel] call BIS_fnc_showRespawnMenuPositionMetadata;
			_identity = (_metadata select 0) select 0;

			// Metadata function returns an empty array in some cases (usually start of a mission and waiting for respawn), in that case skip this (script error with undefined variable would appear otherwise)
			if !(isNil "_identity") then {[player,_identity] call BIS_fnc_moveToRespawnPosition};
		};

		// Some variables set to nil to prevent errors after current mission ends (and next mission begins)
		uiNamespace setVariable ["BIS_RscRespawnControls_posMetadata",nil];

		// Close respawn menu
		["close"] call BIS_fnc_showRespawnMenu;
		setplayerrespawntime _respawnDelay;
	};
};