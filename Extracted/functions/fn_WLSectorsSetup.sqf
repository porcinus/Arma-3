/*
WARLORDS-SPECIFIC FUNCTION

Author: Josef Zemánek

Description: Sectors init (server-side).
*/

private ["_logicsPool", "_sector", "_sectors", "_data", "_hub", "_links", "_sectorsCnt", "_startingSectorsWEST", "_startingSectorsEAST", "_special", "_ownedWEST", "_ownedEAST"];

_sectors = [];

_logicsPool = (entities "ModuleWLSector_F") + (entities "ModuleWLBase_F");
_cnt = count _logicsPool;

_ownedWEST = 0;
_ownedEAST = 0;

_savedArr = +(profileNamespace getVariable ["BIS_WL_scenarioProgress", []]);
if ((typeName _savedArr) != typeName []) then {_savedArr = []};
_missionID = format ["%1.%2", missionName, worldName];
_scenarioServices = [];
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
	_data = [position _hub, (_hub getVariable "Size") / 2, _hub getVariable "Funds", _hubName, _hub getVariable "Side", _hub getVariable "Service_Runway", _hub getVariable "Service_Helipad", _hub getVariable "Service_Harbour"];
	switch (_data # 4) do {
		case 0: {_hub setVariable ["BIS_WL_sectorSide", RESISTANCE, TRUE]};
		case 1: {_hub setVariable ["BIS_WL_sectorSide", EAST, TRUE]; _ownedEAST = _ownedEAST + 1; if (typeOf _hub != "ModuleWLBase_F" && !(_hub in BIS_WL_conqueredSectors_EAST)) then {BIS_WL_conqueredSectors_EAST pushBack _hub; ["        Forced side [EAST]: %1", _data # 3] call BIS_fnc_WLdebug}};
		case 2: {_hub setVariable ["BIS_WL_sectorSide", WEST, TRUE]; _ownedWEST = _ownedWEST + 1; if (typeOf _hub != "ModuleWLBase_F" && !(_hub in BIS_WL_conqueredSectors_WEST)) then {BIS_WL_conqueredSectors_WEST pushBack _hub; ["        Forced side [WEST]: %1", _data # 3] call BIS_fnc_WLdebug}};
	};
	_desc = "";
	if ((typeOf _hub) == "ModuleWLBase_F") then {
		_hub setVariable ["BIS_WL_sectorActivated", TRUE, TRUE];
		if ((_hub getVariable "Side") == 1) then {
			BIS_WL_base_EAST = _hub; publicVariable "BIS_WL_base_EAST";
			if (_hubName == "") then {_desc = localize "STR_A3_WL_default_base_opfor"};
			BIS_WL_conqueredSectors_EAST pushBack BIS_WL_base_EAST;
		} else {
			BIS_WL_base_WEST = _hub; publicVariable "BIS_WL_base_WEST";
			if (_hubName == "") then {_desc = localize "STR_A3_WL_default_base_blufor"};
			BIS_WL_conqueredSectors_WEST pushBack BIS_WL_base_WEST;
		};
	} else {
		if (_desc == "") then {_desc = format [localize "STR_A3_WL_default_sector", _forEachIndex + 1]};
	};
	if (_hubName == "") then {_hub setVariable ["Name", _desc]};
	["Processing [SERVER] [%2/%3] %1", _hub getVariable "Name", _forEachIndex + 1, _cnt] call BIS_fnc_WLdebug;
	_special = [];
	if (_data # 5) then {_special pushBack "A"};
	if (_data # 6) then {_special pushBack "H"};
	if (_data # 7) then {_special pushBack "W"};
	_hub setVariable ["BIS_WL_sectorSpecial", _special, TRUE];
	{_scenarioServices pushBackUnique _x} forEach _special;
	_trgSizeIndex = ((_data # 1) * (_data # 1)) / 25e3;
	_sectorZR = createTrigger ["EmptyDetector", _data # 0];
	_sectorZR setVariable ["BIS_WL_parentSector", _hub, TRUE];
	_hub setVariable ["BIS_WL_sectorZR", _sectorZR, TRUE];
	_hub setVariable ["BIS_WL_handleServerRunning", FALSE];
	_hub setVariable ["BIS_WL_handleClientRunning", FALSE, TRUE];
	_hub spawn {
		scriptName "WLSectorsSetup (AI zone restriction)";
		while {TRUE} do {
			sleep 20;
			_toCheck = [];
			{
				_warlord = _x;
				if !(isPlayer _warlord) then {
					_toCheck = (units _warlord) select {alive _x};
				};
			} forEach BIS_WL_allWarlords;
			{
				_conqPool = BIS_WL_conqueredSectors_WEST;
				_curSector = BIS_WL_currentSector_WEST;
				if (side group _x == EAST) then {_conqPool = BIS_WL_conqueredSectors_EAST; _curSector = BIS_WL_currentSector_EAST};
				if !(_this in _conqPool || _this == _curSector) then {
					if ([_x, _this, TRUE] call BIS_fnc_WLInSectorArea) then {
						["Zone restriction: Killing %1 in %2", _x, _this getVariable "Name"] call BIS_fnc_WLdebug;
						_x setDamage 1;
						vehicle _x setDamage 1;
					};
				};
			} forEach _toCheck;
		};
	};
	_customTimeout = _hub getVariable ["SeizingTime", 0];
	if (_customTimeout > 0) then {
		_hub setVariable ["BIS_WL_timeoutBase", _customTimeout * 1.5, TRUE];
	} else {
		if ((typeOf _hub) == "ModuleWLBase_F") then {
			_hub setVariable ["BIS_WL_timeoutBase", (60 * _trgSizeIndex * 3) min 300, TRUE];
		} else {
			_hub setVariable ["BIS_WL_timeoutBase", (60 * _trgSizeIndex * 1.5) min 200, TRUE];
		};
	};
	_hub setVariable ["BIS_WL_timeoutCur_WEST", -1, TRUE];
	_hub setVariable ["BIS_WL_timeoutCur_EAST", -1, TRUE];
	_hub setVariable ["BIS_WL_timeoutCur_GUER", -1, TRUE];
	_hub setVariable ["BIS_WL_value", _data # 2, TRUE];
	_vehs = [];
	_spawnPosArr = [];
	_reinfArr = [];
	{
		_veh = vehicle _x;
		if !((typeOf _veh) in ["ModuleWLSector_F", "ModuleWLBase_F", "ModuleWLSpawnPoint_F", "ModuleWLResponse_F", "EmptyDetector"]) then {
			_grp = group effectiveCommander _x;
			_vehs pushBack [typeOf _veh, position _veh, direction _veh, _grp];
			["        %1 registered in %2", getText (BIS_WL_cfgVehs >> typeOf _veh >> "displayName"), _hub getVariable "Name"] call BIS_fnc_WLdebug;
			{_veh deleteVehicleCrew _x} forEach crew _veh;
			deleteVehicle _veh;
		} else {
			if (typeOf _veh in ["ModuleWLSpawnPoint_F", "EmptyDetector"]) then {
				_spawnPosArr pushBack position _veh;
				deleteVehicle _veh;
			};
			if (typeOf _veh == "ModuleWLResponse_F") then {
				_reinfArr pushBack _veh;
				_respPool = [];
				{
					if !(typeOf _x in ["ModuleWLSector_F", "ModuleWLBase_F"]) then {_respPool pushBack typeOf _x; deleteVehicle _x};
				} forEach synchronizedObjects _veh;
				_veh setVariable ["BIS_WL_responseVehs", _respPool];
			};
		};
	} forEach synchronizedObjects _hub;
	_hub setVariable ["BIS_WL_vehicles", _vehs];
	_hub setVariable ["BIS_WL_spawnPosArr", _spawnPosArr];
	_hub setVariable ["BIS_WL_responseArr", _reinfArr];
	_links = [];
	{
		if ((typeOf _x) in ["ModuleWLSector_F", "ModuleWLBase_F"]) then {
			_links pushBack _x;
		};
	} forEach synchronizedObjects _hub;
	_hub setVariable ["BIS_WL_connectedSectors", _links, TRUE];
	_sectors pushBack _hub;
	_pointerGrp = createGroup CIVILIAN;
	_pointerGrp setVariable ["BIS_WL_sector", _hub, TRUE];
	_pointerIcon = "Logic" createUnit [position _hub, _pointerGrp]; _pointerIcon = leader _pointerGrp;
	_pointerIcon enableSimulationGlobal FALSE;
	_pointerIcon attachTo [_hub, [0,0,0]];
	_pointerGrp setVariable ["BIS_WL_available", FALSE, TRUE];
	_hub setVariable ["BIS_WL_pointer", _pointerIcon, TRUE];
	_hub enableSimulationGlobal FALSE;
	_hub spawn {
		_sector = _this;
		waitUntil {!isNull (_sector getVariable ["BIS_WL_sectorScanTrg", objNull])};
		_scanTrg = _sector getVariable ["BIS_WL_sectorScanTrg", objNull];
		while {TRUE} do {
			_tmout = 3 + random 2;
			sleep _tmout;
			{
				_side = _x;
				_scanTime = _sector getVariable [format ["BIS_WL_sectorScanActiveSince_%1", _side], -1];
				if ((call BIS_fnc_WLSyncedTime) > _scanTime && _scanTime > 0) then {
					if (isDedicated) then {
						_sector setVariable [format ["BIS_WL_sectorScanActiveSince_%1", _side], -1];
						_scanTrg setTriggerActivation ["ANY", "PRESENT", TRUE];
						_scanTrg setTriggerArea [(_sector getVariable "Size") / 2, (_sector getVariable "Size") / 2, 0, TRUE];
					};
					sleep 5;
					_toReveal = +(list _scanTrg);
					{
						_warlord = _x;
						if (!isPlayer _warlord && side group _warlord == _side && _warlord distance _sector < (((_sector getVariable "Size") / 2) + 200)) then {{_warlord reveal [_x, 4]} forEach _toReveal};
					} forEach BIS_WL_allWarlords;
					if (isDedicated) then {
						_scanTrg setTriggerArea [0, 0, 0, TRUE];
						_scanTrg setTriggerActivation ["NONE", "PRESENT", FALSE];
					};
				};
			} forEach [WEST, EAST];
		};
	};
} forEach _logicsPool;

missionNamespace setVariable ["BIS_WL_scenarioServices", _scenarioServices, TRUE];

_sectorsCnt = _cnt - 2; //2 bases
_startingSectorsWEST = 0;
_startingSectorsEAST = 0;

switch (BIS_WL_forcedProgress) do {
	case 1: 	{_startingSectorsWEST = _sectorsCnt * 0; 	_startingSectorsEAST = _sectorsCnt * 0};
	case 2: 	{_startingSectorsWEST = _sectorsCnt * 0.25; 	_startingSectorsEAST = _sectorsCnt * 0.25};
	case 3: 	{_startingSectorsWEST = _sectorsCnt * 0.5; 	_startingSectorsEAST = _sectorsCnt * 0.5};
	case 4: 	{_startingSectorsWEST = _sectorsCnt * 0.25; 	_startingSectorsEAST = _sectorsCnt * 0};
	case 5: 	{_startingSectorsWEST = _sectorsCnt * 0; 	_startingSectorsEAST = _sectorsCnt * 0.25};
	case 6: 	{_startingSectorsWEST = _sectorsCnt * 0.5; 	_startingSectorsEAST = _sectorsCnt * 0.25};
	case 7: 	{_startingSectorsWEST = _sectorsCnt * 0.25; 	_startingSectorsEAST = _sectorsCnt * 0.5};
	case 8: 	{_startingSectorsWEST = _sectorsCnt * 0.75; 	_startingSectorsEAST = _sectorsCnt * 0.25};
	case 9: 	{_startingSectorsWEST = _sectorsCnt * 0.25; 	_startingSectorsEAST = _sectorsCnt * 0.75};
	case 10: 	{_startingSectorsWEST = _sectorsCnt * 0.5; 	_startingSectorsEAST = _sectorsCnt * 0};
	case 11: 	{_startingSectorsWEST = _sectorsCnt * 0; 	_startingSectorsEAST = _sectorsCnt * 0.5};
	case 12: 	{_startingSectorsWEST = _sectorsCnt * 0.75; 	_startingSectorsEAST = _sectorsCnt * 0};
	case 13:	{_startingSectorsWEST = _sectorsCnt * 0; 	_startingSectorsEAST = _sectorsCnt * 0.75};
};

if (random 1 >= 0.5) then {
	_startingSectorsWEST = ceil _startingSectorsWEST;
	_startingSectorsEAST = floor _startingSectorsEAST;
} else {
	_startingSectorsWEST = floor _startingSectorsWEST;
	_startingSectorsEAST = ceil _startingSectorsEAST;
};

while {_ownedWEST <= _startingSectorsWEST || _ownedEAST <= _startingSectorsEAST} do {
	if (_ownedWEST <= _startingSectorsWEST) then {
		_toAdd = objNull;
		_available = ([WEST, _sectors] call BIS_fnc_WLsectorListing) # 1;
		{
			if ((_x getVariable "BIS_WL_sectorSide") == RESISTANCE) then {
				if (isNull _toAdd) then {
					_toAdd = _x;
				} else {
					if (random 1 >= 0.5) then {
						_toAdd = _x;
					};
				};
			};
		} forEach _available;
		if !(isNull _toAdd) then {
			_toAdd setVariable ["BIS_WL_sectorSide", WEST, TRUE];
			_toAdd setVariable ["BIS_WL_sectorActivated", TRUE, TRUE];
			BIS_WL_conqueredSectors_WEST pushBack _toAdd;
			_toAdd setVariable ["BIS_WL_responseArr", []];
			["Forced progress [WEST]: %1", _toAdd getVariable "Name"] call BIS_fnc_WLdebug;
		};
		_ownedWEST = _ownedWEST + 1;
	};
	if (_ownedEAST <= _startingSectorsEAST) then {
		_toAdd = objNull;
		_available = ([EAST, _sectors] call BIS_fnc_WLsectorListing) # 1;
		{
			if ((_x getVariable "BIS_WL_sectorSide") == RESISTANCE) then {
				if (isNull _toAdd) then {
					_toAdd = _x;
				} else {
					if (random 1 >= 0.5) then {
						_toAdd = _x;
					};
				};
			};
		} forEach _available;
		if !(isNull _toAdd) then {
			_toAdd setVariable ["BIS_WL_sectorSide", EAST, TRUE];
			_toAdd setVariable ["BIS_WL_sectorActivated", TRUE, TRUE];
			BIS_WL_conqueredSectors_EAST pushBack _toAdd;
			_toAdd setVariable ["BIS_WL_responseArr", []];
			["Forced progress [EAST]: %1", _toAdd getVariable "Name"] call BIS_fnc_WLdebug;
		};
		_ownedEAST = _ownedEAST + 1;
	};
};

publicVariable "BIS_WL_conqueredSectors_EAST";
publicVariable "BIS_WL_conqueredSectors_WEST";

_sectors