/*
WARLORDS-SPECIFIC FUNCTION

Author: Josef Zemánek

Description: Handles sector icons.
*/

disableSerialization;

private ["_sector", "_iconGrp", "_status", "_color", "_colorFull", "_colorFade", "_currentSectorVarID"];

_sector = _this # 0;
_iconGrp = group (_sector getVariable "BIS_WL_pointer");
_status = _this # 1;
_color = if !(_iconGrp getVariable ["BIS_WL_conflict", FALSE]) then {BIS_WL_sectorColors # (BIS_WL_sidesPool find (_sector getVariable "BIS_WL_sectorSide"))} else {BIS_WL_sectorColors # (BIS_WL_sidesPool find (side group player))};
_colorFull = [_color # 0, _color # 1, _color # 2, 1];
_colorFade = [_color # 0, _color # 1, _color # 2, 0.2];
if (time == 0) then {
	if (isMultiplayer) then {
		if (isServer) then {
			waitUntil {!isNull (findDisplay 52)};
			uiNamespace setVariable ["BIS_WL_mapDisplay", findDisplay 52];
		} else {
			waitUntil {!isNull (findDisplay 53)};
			uiNamespace setVariable ["BIS_WL_mapDisplay", findDisplay 53];
		};
	} else {
		waitUntil {!isNull (findDisplay 37) || time > 0};
		if (time > 0) exitWith {uiNamespace setVariable ["BIS_WL_mapDisplay", findDisplay 54]};
		uiNamespace setVariable ["BIS_WL_mapDisplay", findDisplay 37];
	};
} else {
	waitUntil {!isNull (findDisplay 12) || !isNull (findDisplay 160)};
	if !(isNull (findDisplay 12)) then {
		uiNamespace setVariable ["BIS_WL_mapDisplay", findDisplay 12];
	} else {
		uiNamespace setVariable ["BIS_WL_mapDisplay", findDisplay 160];
	};
};

_ctrl = (uiNamespace getVariable ["BIS_WL_mapDisplay", -1]) displayCtrl 51;

if (isNull _ctrl) exitWith {};

uiNamespace setVariable ["BIS_currentMapAnimSector", _sector];

switch (_status) do {
	case "hover": {
		if (!(isPlayer _sector) || (BIS_WL_currentSelection != "" && ((getGroupIconParams _iconGrp) # 3))) then {
			_iconGrp setGroupIconParams [_colorFull, "", 1, TRUE];
			if !(BIS_WL_hoverPlayed) then {
				BIS_WL_hoverPlayed = TRUE;
				playSound "clickSoft";
			};
		};
		_pos = position _sector;
		_offset = ctrlMapScale _ctrl;
		if (BIS_WL_currentSelection != "" && ((getGroupIconParams _iconGrp) # 3)) then {
			if (_iconGrp in BIS_WL_tempIconPool) then {
				_ctrl ctrlMapCursor ["Track", "HC_overMission"];
				if !(BIS_WL_hoverAnimated) then {
					BIS_WL_hoverAnimated = TRUE;
					_anim = _ctrl ctrlAddEventHandler ["Draw", {
						if !(isNull (uiNamespace getVariable ["BIS_currentMapAnimSector", objNull])) then {
							(_this # 0) drawIcon [
								"A3\ui_f\data\map\groupicons\selector_selectedMission_ca.paa",
								[1,1,1,0.25],
								uiNamespace getVariable ["BIS_currentMapAnimSector", objNull],
								85 - ((time % 1) * 85),
								85 - ((time % 1) * 85),
								(time * 20) % 360,
								"",
								(time * 20) % 360
							];
						};
					}];
					uiNamespace setVariable ["BIS_currentMapAnimHandle", _anim];
				};
			} else {
				_ctrl ctrlMapCursor ["Track", "HC_unsel"];
			};
		} else {
			_ctrl ctrlRemoveEventHandler ["Draw", uiNamespace getVariable ["BIS_currentMapAnimHandle", -1]];
			if !(isPlayer _sector) then {
				if ((_sector getVariable "BIS_WL_sectorSide") == side group player) then {
					_ctrl ctrlMapCursor ["Track", "HC_overFriendly"];
				} else {
					_ctrl ctrlMapCursor ["Track", "HC_overEnemy"];
				};
			};
		};
		if !(isPlayer _sector) then {
			if (isNull (uiNamespace getVariable ["BIS_sectorInfoBox", controlNull])) then {
				uiNamespace setVariable ["BIS_sectorInfoBox", (uiNamespace getVariable ["BIS_WL_mapDisplay", -1]) ctrlCreate ["RscStructuredText", 9999000]];
			};
			_sectorInfoBox = uiNamespace getVariable "BIS_sectorInfoBox";
			_xDef = safezoneX;
			_yDef = safezoneY;
			_wDef = safezoneW;
			_hDef = safezoneH;
			_mousePos = getMousePosition;
			_sectorInfoBox ctrlSetPosition [(_mousePos # 0) + _wDef / 100, (_mousePos # 1) + _hDef / 50, _wDef / 5, _hDef / 10];
			_sectorInfoBox ctrlSetBackgroundColor [0, 0, 0, 0];
			_sectorInfoBox ctrlSetTextColor [1,1,1,1];
			_sectorInfoBox ctrlSetFontHeight (_hDef / 30);
			_sectorInfoBox ctrlCommit 0;
			_sectorInfoBox ctrlSetStructuredText (_sector getVariable "BIS_WL_sectorText");
		};
	};
	case "reset_shape": {
		if (_sector in [BIS_WL_base_EAST, BIS_WL_base_WEST]) then {
			_iconGrp setGroupIcon [1, BIS_WL_baseMarker];
		} else {
			if !(isPlayer _sector) then {
				_iconGrp setGroupIcon [1, BIS_WL_sectorMarker];
			} else {
				_iconGrp setGroupIconParams [[0,0,0,0], "", 1, FALSE];
			};
		};
	};
	default {
		if (BIS_WL_currentSelection != "") then {
			_ctrl ctrlMapCursor ["Track", "HC_move"];
		} else {
			_ctrl ctrlMapCursor ["Track", "Track"];
		};
		if (!(isPlayer _sector) || (BIS_WL_currentSelection != "" && ((getGroupIconParams _iconGrp) # 3))) then {
			_iconGrp setGroupIconParams [_color, "", 1, TRUE];
		};
		if !(isPlayer _sector) then {
			_mrkr = (_sector getVariable "BIS_WL_sectorMrkrs") # 1;
			_mrkr setMarkerTypeLocal "Empty";
			ctrlDelete ((uiNamespace getVariable ["BIS_WL_mapDisplay", -1]) displayCtrl 9999000);
			_ctrl ctrlRemoveEventHandler ["Draw", uiNamespace getVariable ["BIS_currentMapAnimHandle", -1]];
		};
	};
};