/*
WARLORDS-SPECIFIC FUNCTION

Author: Josef Zemánek

Description: Fast travel routine.
*/

_currentSectorVarID = format ["BIS_WL_currentSector_%1", side group player];
_currentSector = missionNamespace getVariable _currentSectorVarID;
_myBase = BIS_WL_base_EAST;
if (side group player == WEST) then {_myBase = BIS_WL_base_WEST};

if (typeName _this == typeName FALSE) exitWith {
	player setVariable ["BIS_WL_FTPos", group player];
};

_toSectorInConflict = (typeName _this == typeName 0);
"close" call BIS_fnc_WLPurchaseMenu;

BIS_WL_currentSelection = "fastTravel";
[toUpper localize "STR_A3_WL_popup_destination"] spawn BIS_fnc_WLSmoothText;
processDiaryLink createDiaryLink ["Map", player, ""];

if (_toSectorInConflict) then {player setVariable ["BIS_WL_funds", (player getVariable "BIS_WL_funds") - BIS_WL_FTCost, TRUE]};

"Destination" call BIS_fnc_WLSoundMsg;

_iconGrpPool = [];
player setVariable ["BIS_WL_FTPos", objNull];

_available = [];

if (_toSectorInConflict) then {
	_dist = 200 + ((_currentSector getVariable "Size") / 2);
	_dir = [_currentSector, player] call BIS_fnc_dirTo;
	_pos = [_currentSector, _dist, _dir] call BIS_fnc_relPos;
	_i = 5;
	while {surfaceIsWater _pos && _i < 180} do {
		_pos = [_currentSector, _dist, _dir + _i] call BIS_fnc_relPos;
		if (_i > 0) then {_i = _i + 5} else {_i = -_i};
	};
	if (_i >= 180) then {
		_pos = [_currentSector, _dist, _dir] call BIS_fnc_relPos;
	};
	_pointerGrp = createGroup CIVILIAN;
	_pointerIcon = "Logic" createUnit [_pos, _pointerGrp]; _pointerIcon = leader _pointerGrp;
	_pointerIcon enableSimulationGlobal FALSE;
	_pointerIcon setPos _pos;
	_pointerGrp addGroupIcon ["respawn_inf", [0,0]];
	_pointerGrp setVariable ["BIS_WL_dangerState", ""];
	_pointerGrp setGroupIconParams [[0,0,0,0], "", 1, FALSE];
	_pointerGrp setVariable ["BIS_WL_sector", _pointerIcon];
	_pointerGrp setVariable ["BIS_WL_conflict", TRUE];
	_pointerIcon setVariable ["BIS_WL_pointer", _pointerIcon];
	_pointerIcon setVariable ["Name", _currentSector getVariable "Name"];
	_pointerIcon setVariable ["BIS_WL_sectorSide", _currentSector getVariable "BIS_WL_sectorSide"];
	_available = [_pointerIcon];
} else {
	_available = (BIS_WL_sectorsArrayFriendly # 0) select {_x getVariable ["FastTravelEnabled", TRUE]};
	if (BIS_WL_baseFTDisabled) then {
		_available = _available - [_myBase];
	};
};

{
	_icon = _x getVariable "BIS_WL_pointer";
	_iconGrp = group _icon;
	_iconGrp setVariable ["BIS_WL_available", TRUE];
	_iconGrpPool pushBack _iconGrp;
	_iconGrp setVariable ["BIS_WL_FTPos", _x];
	_iconGrp setVariable ["BIS_WL_dangerState", ""];
	[_iconGrp, _toSectorInConflict] spawn {
		scriptName "WLRequestFastTravel (near enemies marking)";
		_iconGrp = _this # 0;
		_inConflict = _this # 1;
		_center = position leader _iconGrp;
		_color = BIS_WL_sectorColors # (BIS_WL_sidesPool find (if !(_inConflict) then {((_iconGrp getVariable "BIS_WL_sector") getVariable "BIS_WL_sectorSide")} else {side group player}));
		_iconGrp setGroupIconParams [_color, "", 1, TRUE];
		while {BIS_WL_currentSelection != ""} do {
			_near100 = _center nearObjects 100;
			if (_near100 findIf {alive _x && (side group _x) in [WEST, EAST, RESISTANCE] && ((side group _x) getFriend (side group player)) == 0} >= 0) then {
				_iconGrp setVariable ["BIS_WL_dangerState", " !!!"];
			} else {
				_near200 = _center nearObjects 200;
				if (_near200 findIf {alive _x && (side group _x) in [WEST, EAST, RESISTANCE] && ((side group _x) getFriend (side group player)) == 0} >= 0) then {
					_iconGrp setVariable ["BIS_WL_dangerState", " !!"];
				} else {
					_near300 = _center nearObjects 300;
					if (_near300 findIf {alive _x && (side group _x) in [WEST, EAST, RESISTANCE] && ((side group _x) getFriend (side group player)) == 0} >= 0) then {
						_iconGrp setVariable ["BIS_WL_dangerState", " !"];
					};
				};
			};
			sleep 3;
		};
	};
	if (_x == _myBase) then {
		(group _icon) spawn {
			while {!isNull _this} do {
				scriptName "WLRequestFastTravel (base check)";
				waitUntil {BIS_WL_baseFTDisabled || isNull _this};
				if !(isNull _this) then {
					[_this getVariable "BIS_WL_sector", "reset_shape"] call BIS_fnc_WLSectorIconUpdate;
					_this setVariable ["BIS_WL_available", FALSE];
					waitUntil {!BIS_WL_baseFTDisabled || isNull _this};
					if !(isNull _this) then {
						_inConflict = FALSE;
						_color = BIS_WL_sectorColors # (BIS_WL_sidesPool find (if !(_inConflict) then {((_this getVariable "BIS_WL_sector") getVariable "BIS_WL_sectorSide")} else {side group player}));
						_this setGroupIconParams [_color, "", 1, TRUE];
						_this setVariable ["BIS_WL_available", TRUE];
					};
				};
			};
		};
	};
} forEach _available;

_iconGrpPool spawn BIS_fnc_WLOutlineIcons;

{
	removeMissionEventHandler ["GroupIconClick", missionNamespace getVariable [_x, -1]];
} forEach ["BIS_WL_dropPosSelectionHandler", "BIS_WL_fastTravelPosSelectionHandler", "BIS_WL_ScanPosSelectionHandler", "BIS_WL_sectorSelectionHandler"];
BIS_WL_fastTravelPosSelectionHandler = addMissionEventHandler ["GroupIconClick", {if ((_this # 1) getVariable "BIS_WL_available") then {removeMissionEventHandler ["GroupIconClick", BIS_WL_fastTravelPosSelectionHandler]; player setVariable ["BIS_WL_FTPos", (_this # 1) getVariable "BIS_WL_FTPos"]}}];

waitUntil {!isNull (player getVariable "BIS_WL_FTPos") || !visibleMap || !alive player || lifeState player == "INCAPACITATED"};

{_x setVariable ["BIS_WL_available", FALSE]} forEach _iconGrpPool;
BIS_WL_currentSelection = "";

if (!visibleMap || !alive player || lifeState player == "INCAPACITATED" || typeName (player getVariable "BIS_WL_FTPos") == typeName grpNull) exitWith {
	[toUpper localize "STR_A3_WL_menu_fasttravel_canceled"] spawn BIS_fnc_WLSmoothText;
	playSound "AddItemFailed";
	"Canceled" call BIS_fnc_WLSoundMsg;
	if (_toSectorInConflict) then {
		player setVariable ["BIS_WL_funds", ((player getVariable "BIS_WL_funds") + BIS_WL_FTCost) min BIS_WL_maxCP, TRUE];
		{
			deleteVehicle leader _x;
			deleteGroup _x;
		} forEach _iconGrpPool;
	} else {
		{
			[_x getVariable "BIS_WL_sector", "reset_shape"] call BIS_fnc_WLSectorIconUpdate;
			_x setVariable ["BIS_WL_available", FALSE];
		} forEach _iconGrpPool;
	};
};

if !(_toSectorInConflict) then {
	{
		[_x getVariable "BIS_WL_sector", "reset_shape"] call BIS_fnc_WLSectorIconUpdate;
		_x setVariable ["BIS_WL_available", FALSE];
	} forEach _iconGrpPool;
};

BIS_WL_travelling = TRUE;
"Fast_travel" call BIS_fnc_WLSoundMsg;
playSound "AddItemOK";
titleCut ["", "BLACK OUT", 1];
openMap [FALSE, FALSE];
sleep 1;

_grpVehs = [];
_oldPos = position player;

_grpVehs = (units group player) select {_x distance player < 200 && vehicle _x == _x};

{
	_x hideObjectGlobal TRUE;
	_x allowDamage FALSE;
} forEach _grpVehs;

[toUpper format [localize "STR_A3_WL_popup_travelling", (player getVariable "BIS_WL_FTPos") getVariable "Name"], nil, 3] spawn BIS_fnc_WLSmoothText;
sleep 5;

{
	_pos = [];
	_findPos = [];
	if (_toSectorInConflict) then {
		_findPos = (position (player getVariable "BIS_WL_FTPos")) findEmptyPosition [0, 50, typeOf player];
	} else {
		_rad = 100;
		_radCoef = 1;
		_radTries = 0;
		while {_findPos isEqualTo []} do {
			while {_radTries < (_rad * _radCoef) && _findPos isEqualTo []} do {
				_posStart = [player getVariable "BIS_WL_FTPos", random (_rad * _radCoef), random 360] call BIS_fnc_relPos;
				_findPos = _posStart isFlatEmpty [3, -1, 0.2, 5, 0, FALSE, player];
				if !(_findPos isEqualTo []) then {
					_findPos = ASLToATL _findPos;
					_nearObjs = _findPos nearObjects ["All", 10];
					if (count _nearObjs > 0) then {
						_findPos = [];
					};
				};
				_radTries = _radTries + 1;
			};
			_radCoef = _radCoef + 1;
			_radTries = 0;
		};
	};
	if (count _findPos == 0) then {
		_dummy = createVehicle [typeOf _x, position (player getVariable "BIS_WL_FTPos"), [], 30, "NONE"];
		_pos = position _dummy;
		deleteVehicle _dummy;
	} else {
		_pos = _findPos;
	};
	_x setDir ([_oldPos, player getVariable "BIS_WL_FTPos"] call BIS_fnc_dirTo);
	_pos set [2, 0];
	if (_toSectorInConflict) then {
		_x setPos (_pos vectorAdd [-10 + random 20,-10 + random 20,50]);
		_zDif = ((getPosATL _x) # 2) - ((getPos _x) # 2);
		_x setPosATL ([(position _x) # 0, (position _x) # 1, 0] vectorAdd [0,0,_zDif + 0.1]);
	} else {
		_x setPos _pos;
	};
} forEach _grpVehs;

if (_toSectorInConflict) then {
	{deleteVehicle leader _x; deleteGroup _x} forEach _iconGrpPool;
};

sleep 0.5;

{
	_x hideObjectGlobal FALSE;
	_x allowDamage TRUE;
	if (BIS_WL_fatigueEnabled != 0) then {_x setStamina 0};
} forEach _grpVehs;

BIS_WL_travelling = FALSE;
titleCut ["", "BLACK IN", 1];