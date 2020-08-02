/*
WARLORDS-SPECIFIC FUNCTION

Author: Josef Zemánek

Description: Keeps track of player unit & its marker.
*/

_trackerGrp = createGroup CIVILIAN;
_trackerUnit = _trackerGrp createUnit ["Logic", position player, [], 0, "NONE"];
_trackerUnit enableSimulationGlobal FALSE;
_trackerUnit attachTo [player, [0,0,0]];
_trackerGrp addGroupIcon ["selector_selectable", [0,0]];
_trackerGrp setVariable ["BIS_WL_dangerState", ""];
_trackerGrp setGroupIconParams [[0,0.8,0,1], "", 2.5, FALSE];
_trackerGrp setVariable ["BIS_WL_sector", player];
player setVariable ["BIS_WL_sectorSide", side group player];
_trackerUnit setVariable ["BIS_WL_purchased", [], TRUE];
player setVariable ["BIS_WL_pointer", _trackerUnit, TRUE];
_trackerUnit setVariable ["BIS_WL_playerTracked", player, TRUE];
player addEventHandler ["Respawn", {
	_trackerUnit = (player getVariable "BIS_WL_pointer");
	_trackerGrp = group _trackerUnit;
	_trackerGrp setVariable ["BIS_WL_sector", player];
	_trackerUnit setVariable ["BIS_WL_playerTracked", player, TRUE];
	player setVariable ["BIS_WL_pointer", _trackerUnit, TRUE];
	detach _trackerUnit;
	_trackerUnit attachTo [player, [0,0,0]];
	group player selectLeader player;
}];
_null = [] spawn {
	scriptName "WLPlayersTracking (player icon)";
	_trackerUnit = (player getVariable "BIS_WL_pointer");
	_in = FALSE;
	waitUntil {BIS_WL_currentSelection != ""};
	while {BIS_WL_currentSelection != ""} do {
		if (vehicle player == player) then {
			if (_in) then {
				_in = FALSE;
				_trackerUnit attachTo [player, [0,0,0]];
			};
		} else {
			if !(_in) then {
				_in = TRUE;
				_trackerUnit attachTo [vehicle player, [0,0,0]];
			};
		};
		sleep 2;
	};
};

_null = _trackerUnit spawn {
	scriptName "WLPlayersTracking (player tracker)";
	while {TRUE} do {
		waitUntil {vehicle player != player};
		_this attachTo [vehicle player, [0,0,0]];
		waitUntil {vehicle player == player};
		_this attachTo [player, [0,0,0]];
	};
};

_null = _trackerUnit spawn {
	scriptName "WLPlayersTracking (purchased array manager)";
	while {TRUE} do {
		_tmout = 10 + random 10;
		sleep _tmout;
		_purchased = _this getVariable ["BIS_WL_purchased", []];
		_purchasedOld = +_purchased;
		_purchased = _purchased select {!isNull _x && alive _x};
		if !(_purchased isEqualTo _purchasedOld) then {
			_this setVariable ["BIS_WL_purchased", _purchased, TRUE];
		};
	};
};