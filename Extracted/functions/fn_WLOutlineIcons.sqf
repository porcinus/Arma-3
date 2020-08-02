/*
WARLORDS-SPECIFIC FUNCTION

Author: Josef Zemánek

Description: Handles icons selection visualization in map.
*/

private ["_EHIndex"];
BIS_WL_tempIconPool = _this;

_EHIndex = (findDisplay 12 displayCtrl 51) ctrlAddEventHandler ["Draw", {
	{
		(_this # 0) drawIcon [
			"A3\ui_f\data\map\groupicons\selector_selectedMission_ca.paa",
			if ((player getVariable ["BIS_WL_selectedSector", objNull]) == (_x getVariable ["BIS_WL_sector", objNull]) && BIS_WL_currentSelection == "voted") then {
				BIS_colorDrawWSel
			} else {
				(getGroupIconParams _x) # 0
			},
			leader _x,
			40,
			40,
			(time * 20) % 360,
			"",
			1,
			0.1,
			"EtelkaNarrowMediumPro",
			"right"
		];

		(_this # 0) drawIcon [
			"A3\ui_f\data\map\groupicons\selector_selectedMission_ca.paa",
			(getGroupIconParams _x) # 0,
			leader _x,
			40,
			0,
			0,
			_x getVariable "BIS_WL_dangerState",
			1,
			0.1,
			"EtelkaNarrowMediumPro",
			"right"
		];
	} forEach BIS_WL_tempIconPool;
}];

waitUntil {BIS_WL_currentSelection == ""};
(findDisplay 12 displayCtrl 51) ctrlRemoveEventHandler ["Draw", _EHIndex];