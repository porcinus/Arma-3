/*
WARLORDS-SPECIFIC FUNCTION

Author: Josef Zemánek

Description: Handles the seizing bar element in UI.
*/

if (count _this == 0) exitWith {BIS_WL_seizingBar_progress = []};

private ["_sector", "_situation", "_tmout", "_tmoutCur", "_title", "_barColor", "_sectorColor", "_tmoutVarID"];

_sector = _this # 0;
_situation = _this # 1;

_tmoutVarIDArr = ["BIS_WL_timeoutCur_WEST", "BIS_WL_timeoutCur_EAST", "BIS_WL_timeoutCur_GUER"] select {(_sector getVariable [_x, -1]) >= 0};
if (count _tmoutVarIDArr == 0 && _situation != 3) exitWith {};

_tmoutVarID = _tmoutVarIDArr # 0;

_title = "";
if (_situation == 1) then {_title = ""};
if (_situation == 2) then {_title = ""};
if (_situation == 3) then {_title = localize "STR_A3_WL_osd_zone"};

_tmout = 0;
_tmoutCur = 0;
_barColor = "";
_sectorColor = "";

if (count _this > 2) then {
	_tmout = _this # 2;
	_tmoutCur = _this # 3;
	_barColor = [1, 0, 0, 1];
	_sectorColor = [1, 1, 1, 1];
} else {
	_tmout = _sector getVariable "BIS_WL_timeoutBase";
	_tmoutCur = _sector getVariable _tmoutVarID;
	_barColor = +(switch (_tmoutVarID) do {
		case "BIS_WL_timeoutCur_WEST": {BIS_WL_sectorColors # 1};
		case "BIS_WL_timeoutCur_EAST": {BIS_WL_sectorColors # 0};
		case "BIS_WL_timeoutCur_GUER": {BIS_WL_sectorColors # 2};
	});
	_sectorColor = +(switch (_sector getVariable "BIS_WL_sectorSide") do {
		case WEST: {BIS_WL_sectorColors # 1};
		case EAST: {BIS_WL_sectorColors # 0};
		case RESISTANCE: {BIS_WL_sectorColors # 2};
	});
};

if (_barColor isEqualTo _sectorColor) exitWith {};

_barColor set [3, 1];
_sectorColor set [3, 1];

BIS_WL_seizingBar_progress = [_tmoutCur, _tmout, _barColor, _sectorColor, if (_situation == 3) then {localize "STR_A3_WL_osd_zone"} else {_sector getVariable "Name"}];