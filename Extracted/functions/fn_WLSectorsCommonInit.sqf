/*
WARLORDS-SPECIFIC FUNCTION

Author: Josef Zemánek

Description: Sectors init (client-side).
*/

private ["_hub"];

setGroupIconsVisible [TRUE,FALSE];
setGroupIconsSelectable TRUE;

_cnt = count _this;

_currentSectorVarID = format ["BIS_WL_currentSector_%1", side group player];
_locationsCfg = "getText (_x >> 'name') != ''" configClasses (BIS_WL_cfgWrld >> "Names");
{
	_hub = _x;
	_hubName = _hub getVariable "Name";
	_useLocatioName = _hub getVariable ["LocationName", if (typeOf _hub == "ModuleWLBase_F") then {FALSE} else {TRUE}];
	if (_useLocatioName && _hubName == "") then {
		_nearest = _locationsCfg # 0;
		_dist = 10e10;
		{
			_pos = getArray (_x >> "position");
			if (_pos distance _hub < 1000 && _pos distance _hub < _dist) then {
				_nearest = _x;
				_dist = _pos distance _hub;
			};
		} forEach _locationsCfg;
		if (_dist < 1000) then {
			_hubName = getText (_nearest >> "name");
			_firstLetter = _hubName select [0, 1];
			if ((toArray _firstLetter) isEqualTo [65533]) then {_firstLetter = _hubName select [0, 2]};
			_toUpperFirstLetter = toUpper _firstLetter;
			_toUpperFirstLetter = (toArray _toUpperFirstLetter) # 0;
			_hubNameArr = toArray _hubName;
			_hubNameArr set [0, _toUpperFirstLetter];
			_hubName = toString _hubNameArr;
		};
	};
	if (_hubName != "") then {
		if (isLocalized _hubName) then {_hubName = localize _hubName};
	};
	_hub setVariable ["Name", _hubName];
	_desc = "";
	if ((typeOf _hub) == "ModuleWLBase_F") then {
		if ((_hub getVariable "Side") == 1) then {
			if (_hubName == "") then {_desc = localize "STR_A3_WL_default_base_opfor"};
		} else {
			if (_hubName == "") then {_desc = localize "STR_A3_WL_default_base_blufor"};
		};
	} else {
		if (_desc == "") then {_desc = format [localize "STR_A3_WL_default_sector", _forEachIndex + 1]};
	};
	if (_hubName == "") then {_hub setVariable ["Name", _desc]};
	_data = [position _hub, (_hub getVariable "Size") / 2, objNull, _hub getVariable "Name", (_hub getVariable "BIS_WL_value") * BIS_WL_CPIncomeMult, _hub getVariable "BIS_WL_sectorSpecial"];
	_trgSize = _data # 1;
	["Processing [%4] [%2/%3] %1 [%5]", _hub getVariable "Name", _forEachIndex + 1, _cnt, name player, "+" + str (_data # 4)] call BIS_fnc_WLdebug;
	_seizeCondId = format ["BIS_WL_currentSector_%1", side group player];
	_conqCondId = format ["BIS_WL_conqueredSectors_%1", side group player];
	_trgZR = _hub getVariable "BIS_WL_sectorZR";
	_trgZR setTriggerArea [_trgSize + (_hub getVariable ["Border", 200]), _trgSize + (_hub getVariable ["Border", 200]), 0, TRUE];
	_trgZR triggerAttachVehicle [player];
	_trgZR setTriggerActivation ["MEMBER", "PRESENT", TRUE];
	_trgZR setTriggerStatements [
		format ["this && (thisTrigger getVariable 'BIS_WL_parentSector') != (missionNamespace getVariable '%1') && !((thisTrigger getVariable 'BIS_WL_parentSector') in (missionNamespace getVariable '%2'))", _seizeCondId, _conqCondId],
		"{if !(isPlayer _x) then {_x setDamage 1}} forEach thislist",
		""
	];
	_trgZR setTriggerTimeout [20, 20, 20, TRUE];
	_mrkrName = format ["BIS_WL_sectorMrkr_%1", _forEachIndex];
	_null = createMarkerLocal [_mrkrName, position _hub];
	_mrkrName setMarkerShapeLocal "RECTANGLE";
	_mrkrName setMarkerBrushLocal "Border";
	_mrkrName setMarkerSizeLocal [_trgSize, _trgSize];
	_mrkrName setMarkerColorLocal ((["colorOPFOR", "colorBLUFOR", "colorIndependent"]) # (BIS_WL_sidesPool find (_hub getVariable "BIS_WL_sectorSide")));
	_mrkrNameText = format ["BIS_WL_sectorMrkrText_%1", _forEachIndex];
	_null = createMarkerLocal [_mrkrNameText, _data # 0];
	_mrkrNameText setMarkerTypeLocal "Empty";
	_mrkrNameText setMarkerSizeLocal [0, 0];
	_mrkrText = (_data # 3) + format [" [+%1]", _data # 4];
	_mrkrNameText setMarkerTextLocal _mrkrText;
	_mrkrNameLock1 = format ["BIS_WL_sectorMrkrLock1_%1", _forEachIndex];
	_mrkrNameLock2 = format ["BIS_WL_sectorMrkrLock2_%1", _forEachIndex];
	_mrkrNameLock3 = format ["BIS_WL_sectorMrkrLock3_%1", _forEachIndex];
	_mrkrNameLock4 = format ["BIS_WL_sectorMrkrLock4_%1", _forEachIndex];
	_hub setVariable ["BIS_WL_sectorText", parseText format [
		"<t shadow = '2' size = '%6'>%1<br/>+%2 %8/%7</t><br/>%3%4%5",
		_data # 3,
		_data # 4,
		if ("A" in (_data # 5)) then {format ["<img shadow = '0' size = '%1' image = '\A3\ui_f\data\map\markers\nato\c_plane.paa'/> ", (1.25 call BIS_fnc_WLSubroutine_purchaseMenuGetUIScale)]} else {""},
		if ("H" in (_data # 5)) then {format ["<img shadow = '0' size = '%1' image = '\A3\ui_f\data\map\markers\nato\c_air.paa'/> ", (1.25 call BIS_fnc_WLSubroutine_purchaseMenuGetUIScale)]} else {""},
		if ("W" in (_data # 5)) then {format ["<img shadow = '0' size = '%1' image = '\A3\ui_f\data\map\markers\nato\c_ship.paa'/> ", (1.25 call BIS_fnc_WLSubroutine_purchaseMenuGetUIScale)]} else {""},
		(1 call BIS_fnc_WLSubroutine_purchaseMenuGetUIScale),
		localize "STR_A3_rscmpprogress_min",
		localize "STR_A3_WL_unit_cp"
	]];
	_relPosArr = [[1, 1, 0, 0, 1], [1, -1, 90, 1, 0], [-1, -1, 0, 0, -1], [-1, 1, 90, -1, 0]];
	{
		_relPos = _relPosArr # _forEachIndex;
		_borderHalf = (_hub getVariable ["Border", 200]) / 2;
		_null = createMarkerLocal [_x, [((_data # 0) # 0) + (_trgSize * (_relPos # 3)) + (_borderHalf * (_relPos # 0)), ((_data # 0) # 1) + (_trgSize * (_relPos # 4)) + (_borderHalf * (_relPos # 1))]];
		_x setMarkerShapeLocal "RECTANGLE";
		_x setMarkerBrushLocal "Solid";
		_x setMarkerDirLocal (_relPos # 2);
		_x setMarkerSizeLocal [(_data # 1) + _borderHalf, _borderHalf];
		_x setMarkerColorLocal ((["colorOPFOR", "colorBLUFOR", "colorIndependent"]) # (BIS_WL_sidesPool find (_hub getVariable "BIS_WL_sectorSide")));
		_x setMarkerAlphaLocal 0.35;
		if ((missionNamespace getVariable _currentSectorVarID) == _hub || _hub in (missionNamespace getVariable _conqCondId)) then {
			_x setMarkerAlphaLocal 0;
		};
	} forEach [_mrkrNameLock1, _mrkrNameLock2, _mrkrNameLock3, _mrkrNameLock4];
	_hub setVariable ["BIS_WL_sectorMrkrs", [_mrkrName, _mrkrNameText]];
	_hub setVariable ["BIS_WL_sectorLockMrkrs", [_mrkrNameLock1, _mrkrNameLock2, _mrkrNameLock3, _mrkrNameLock4]];
	_mrkrNameText setMarkerColorLocal "ColorBlack";
	if (_hub getVariable "BIS_WL_sectorActivated" && !(_hub getVariable "BIS_WL_handleClientRunning")) then {
		_hub call BIS_fnc_WLsectorHandle;
		if (BIS_WL_scanEnabled == 1) then {[_hub, side group player] call BIS_fnc_WLsectorScanHandle};
	};
	if ((_hub getVariable "BIS_WL_sectorSide") != side group player) then {
		_hub spawn {
			scriptName "WLSectorsCommonInit (zone restriction)";
			_currentSectorVarID = format ["BIS_WL_currentSector_%1", side group player];
			_conqueredSectorsVarID = format ["BIS_WL_conqueredSectors_%1", side group player];
			_trgZR = _this getVariable ["BIS_WL_sectorZR", objNull];
			while {TRUE} do {
				if ([player, _this] call BIS_fnc_WLInSectorArea && !(_this in (missionNamespace getVariable _conqueredSectorsVarID)) && !(_this == (missionNamespace getVariable _currentSectorVarID))) then {
					_killTimeout = (triggerTimeout _trgZR) select 0;
					["Sector Access Violation [WARN]: %1 in %2", name player, _this getVariable "Name"] call BIS_fnc_WLdebug;
					[toUpper localize "STR_A3_WL_zone_warn"] spawn BIS_fnc_WLSmoothText;
					playSound "air_raid";
					_t = time + _killTimeout;
					while {time < _t && [player, _this] call BIS_fnc_WLInSectorArea && !(_this in (missionNamespace getVariable _conqueredSectorsVarID)) && !(_this == (missionNamespace getVariable _currentSectorVarID))} do {
						[objNull, 3, _killTimeout, _t - time] call BIS_fnc_WLSeizingBarHandle;
						sleep 1;
					};
					[] call BIS_fnc_WLSeizingBarHandle;
					if (!(_this in (missionNamespace getVariable _conqueredSectorsVarID)) && !(_this == (missionNamespace getVariable _currentSectorVarID))) then {
						if ([player, _this] call BIS_fnc_WLInSectorArea) then {
							["Sector Access Violation [KILL]: %1 in %2", name player, _this getVariable "Name"] call BIS_fnc_WLdebug;
							player setDamage 1;
							vehicle player setDamage 1;
						};
					};
				};
				sleep 1;
			};
		};
	};
	_pointerGrp = group (_hub getVariable "BIS_WL_pointer");
	if (_hub in [BIS_WL_base_EAST, BIS_WL_base_WEST]) then {
		_pointerGrp addGroupIcon [BIS_WL_baseMarker, [0,0]];
		_pointerGrp setVariable ["BIS_WL_dangerState", ""];
	} else {
		_pointerGrp addGroupIcon [BIS_WL_sectorMarker, [0,0]];
		_pointerGrp setVariable ["BIS_WL_dangerState", ""];
	};
	[_hub, "default"] call BIS_fnc_WLSectorIconUpdate;
	if !(isMultiplayer) then {
		_hub spawn {
			sleep 0.5;
			[_this, "default"] call BIS_fnc_WLSectorIconUpdate;
		};
	};
} forEach _this;

call BIS_fnc_WLrecalculateServices;