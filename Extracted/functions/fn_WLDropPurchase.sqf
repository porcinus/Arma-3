/*
WARLORDS-SPECIFIC FUNCTION

Author: Josef Zemánek

Description: Airdrop location selection routine.
*/

_currentSectorVarID = format ["BIS_WL_currentSector_%1", side group player];

if (typeName _this == typeName FALSE) exitWith {
	player setVariable ["BIS_WL_dropPos", group player];
};

_pool = [];
{_pool pushBack (_x # 0)} forEach (_this # 0);
_tgt = _this # 1;
_dropCost = BIS_WL_dropCost * _tgt;

_shipsCnt = {toLower getText (BIS_WL_cfgVehs >> _x >> "simulation") == "shipx"} count _pool;

BIS_WL_currentSelection = "drop";

player setVariable ["BIS_WL_funds", (player getVariable "BIS_WL_funds") - _dropCost, TRUE];

_iconGrpPool = [];
player setVariable ["BIS_WL_dropPos", objNull];

"close" call BIS_fnc_WLPurchaseMenu;

if (_tgt != 1) then {player setVariable ["BIS_WL_dropPos", player]} else {
	"Dropzone" call BIS_fnc_WLSoundMsg;
	
	_LZs = BIS_WL_sectorsArrayFriendly # 0;

	{
		_icon = _x getVariable "BIS_WL_pointer";
		_iconGrp = group _icon;
		_iconGrp setVariable ["BIS_WL_available", TRUE];
		_iconGrpPool pushBack _iconGrp;
		_iconGrp setVariable ["BIS_WL_dropPos", _x];
		_iconGrp setGroupIconParams [BIS_WL_sectorColors # (BIS_WL_sidesPool find ((_iconGrp getVariable "BIS_WL_sector") getVariable "BIS_WL_sectorSide")), "", 1, TRUE];
	} forEach _LZs;

	[toUpper localize "STR_A3_WL_popup_airdrop_selection"] spawn BIS_fnc_WLSmoothText;
	_iconGrpPool spawn BIS_fnc_WLOutlineIcons;
	processDiaryLink createDiaryLink ["Map", player, ""];

	{
		removeMissionEventHandler ["GroupIconClick", missionNamespace getVariable [_x, -1]];
	} forEach ["BIS_WL_dropPosSelectionHandler", "BIS_WL_fastTravelPosSelectionHandler", "BIS_WL_ScanPosSelectionHandler", "BIS_WL_sectorSelectionHandler"];
	BIS_WL_dropPosSelectionHandler = addMissionEventHandler ["GroupIconClick", {
		if ((_this # 1) getVariable "BIS_WL_available") then {
			removeMissionEventHandler ["GroupIconClick", BIS_WL_dropPosSelectionHandler];
			player setVariable ["BIS_WL_dropPos", (_this # 1) getVariable "BIS_WL_dropPos"];
		};
	}];
};

waitUntil {!isNull (player getVariable "BIS_WL_dropPos") || !visibleMap || !alive player || lifeState player == "INCAPACITATED"};

BIS_WL_currentSelection = "";
{[_x getVariable "BIS_WL_sector", "reset_shape"] call BIS_fnc_WLSectorIconUpdate; _x setVariable ["BIS_WL_available", FALSE]} forEach _iconGrpPool;
onMapSingleClick {};

if ((!visibleMap && _tgt == 1) || !alive player || lifeState player == "INCAPACITATED" || typeName (player getVariable "BIS_WL_dropPos") == typeName grpNull) exitWith {
	player setVariable ["BIS_WL_funds", ((player getVariable "BIS_WL_funds") + _dropCost) min BIS_WL_maxCP, TRUE];
	[toUpper toUpper localize "STR_A3_WL_airdrop_canceled"] spawn BIS_fnc_WLSmoothText;
	playSound "AddItemFailed";
	"Canceled" call BIS_fnc_WLSoundMsg;
};

BIS_WL_dropPool = [];

[toUpper localize "STR_A3_WL_airdrop_underway"] spawn BIS_fnc_WLSmoothText;
if (_tgt == 1) then {
	playSound "AddItemOK";
};

"Airdrop" call BIS_fnc_WLSoundMsg;

[player, _pool] call BIS_fnc_WLAirdrop;