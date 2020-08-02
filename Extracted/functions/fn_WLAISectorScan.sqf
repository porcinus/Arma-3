/*
WARLORDS-SPECIFIC FUNCTION

Author: Josef Zemánek

Description: Sector scan routine for AI.
*/

private ["_sector", "_side", "_rtmout", "_varActiveSinceID", "_requesters", "_requester"];

_sector = _this # 0;
_side = _this # 1;

_rtmout = 90 + random 30;
if ((_sector getVariable "BIS_WL_sectorSide") == _side) then {_rtmout = 10 + random 10};

sleep _rtmout;

_varActiveSinceID = format ["BIS_WL_sectorScanActiveSince_%1", _side];
_varLastRequestID = format ["BIS_WL_sectorScanLastRequest_%1", _side];

if ((_sector getVariable _varActiveSinceID) > 0 || (_sector getVariable _varLastRequestID) > ((call BIS_fnc_WLSyncedTime) - BIS_WL_scanDuration - BIS_WL_scanCooldown - 5)) exitWith {};

_requesters = +BIS_WL_allWarlords;

{
	if (!alive _x || isPlayer _x || side group _x != _side || ((_x getVariable "BIS_WL_funds") < BIS_WL_scanCost)) then {
		_requesters = _requesters - [_x];
	};
} forEach _requesters;

if (count _requesters == 0) exitWith {};

_requester = _requesters # floor random count _requesters;

_requester setVariable ["BIS_WL_funds", (_requester getVariable "BIS_WL_funds") - BIS_WL_scanCost, TRUE];

_sector setVariable [_varActiveSinceID, (call BIS_fnc_WLSyncedTime), TRUE];
_sector setVariable [_varLastRequestID, (call BIS_fnc_WLSyncedTime), TRUE];