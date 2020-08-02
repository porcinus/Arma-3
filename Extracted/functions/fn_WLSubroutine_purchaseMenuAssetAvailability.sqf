private ["_ret", "_tooltip", "_class"];
_class = _assetDetails # 0;
_ret = TRUE;
_tooltip = "";
_DLCOwned = TRUE;
_DLCTooltip = "";
if (_cost > _funds) then {_ret = FALSE; _tooltip = localize "STR_A3_WL_low_funds"};
if (!alive player) then {_ret = FALSE; _tooltip = localize "STR_A3_WL_fasttravel_restr6"};
if (lifeState player == "INCAPACITATED") then {_ret = FALSE; _tooltip = format [localize "STR_A3_Revive_MSG_INCAPACITATED", name player]};
if (_ret) then {
	switch (_class) do {
		case "FTSeized": {
			if (vehicle player != player) exitWith {_ret = FALSE; _tooltip = localize "STR_A3_WL_fasttravel_restr3"};
			if (BIS_WL_travelling) exitWith {_ret = FALSE; _tooltip = localize "STR_A3_WL_menu_resetvoting_restr1"};
			if ((player nearObjects 200) findIf {(side _x in BIS_WL_sidesPool) && count crew _x > 0 && ((side group _x) getFriend (side group player)) == 0} >= 0) exitWith {_ret = FALSE; _tooltip =  localize "STR_A3_WL_fasttravel_restr4"};
		};
		case "FTConflict": {
			_currentSectorVarID = format ["BIS_WL_currentSector_%1", side group player];
			_currentSector = missionNamespace getVariable _currentSectorVarID;
			if (isNull _currentSector) exitWith {_ret = FALSE; _tooltip = localize "STR_A3_WL_no_conflict"};
			if (_currentSector in [BIS_WL_base_EAST, BIS_WL_base_WEST]) exitWith {_ret = FALSE; _tooltip = localize "STR_A3_WL_fasttravel_restr1"};
			if !(_currentSector getVariable ["FastTravelEnabled", TRUE]) exitWith {_ret = FALSE; _tooltip = localize "STR_A3_WL_fasttravel_restr2"};
			if !(_currentSector in (BIS_WL_sectorsArrayFriendly # 1)) exitWith {_ret = FALSE; _tooltip = localize "STR_A3_WL_fasttravel_restr5"};
			if (vehicle player != player) exitWith {_ret = FALSE; _tooltip = localize "STR_A3_WL_fasttravel_restr3"};
			if (BIS_WL_travelling) exitWith {_ret = FALSE; _tooltip = localize "STR_A3_WL_menu_resetvoting_restr1"};
			if ((player nearObjects 200) findIf {(side _x in BIS_WL_sidesPool) && count crew _x > 0 && ((side group _x) getFriend (side group player)) == 0} >= 0) exitWith {_ret = FALSE; _tooltip =  localize "STR_A3_WL_fasttravel_restr4"};
		};
		case "LastLoadout": {
			if (count BIS_WL_lastLoadout == 0) exitWith {_ret = FALSE; _tooltip = localize "STR_A3_WL_no_loadout_saved"};
			if (BIS_WL_loadoutApplied) exitWith {_ret = FALSE; _tooltip = localize "STR_A3_WL_loadout_reapply_info"};
			_owned = BIS_WL_sectorsArrayFriendly # 0;
			if (_owned findIf {[player, _x, TRUE] call BIS_fnc_WLInSectorArea} == -1) then {
				_ret = FALSE;
				_tooltip = localize "STR_A3_WL_menu_arsenal_restr1"
			};
		};
		case "FundsTransfer": {
			if (count (BIS_WL_allWarlords select {side group _x == side group player}) < 2) exitWith {_ret = FALSE; _tooltip = localize "STR_A3_WL_transfer_restr1"};
		};
		case "VotingReset": {
			_currentSectorVarID = format ["BIS_WL_currentSector_%1", side group player];
			_currentSector = missionNamespace getVariable _currentSectorVarID;
			if (isNull _currentSector) exitWith {_ret = FALSE; _tooltip = localize "STR_A3_WL_no_conflict"};
			_sectorSelectedTimestampVarID = format ["BIS_WL_sectorSelectedTimestamp_%1", side group player];
			if ((call BIS_fnc_WLSyncedTime) < ((missionNamespace getVariable [_sectorSelectedTimestampVarID, 0]) + BIS_WL_votingResetTimeout)) exitWith {_ret = FALSE; _tooltip = localize "STR_A3_WL_menu_resetvoting_restr1"};
		};
		case "Arsenal": {
			_owned = BIS_WL_sectorsArrayFriendly # 0;
			if (_owned findIf {[player, _x, TRUE] call BIS_fnc_WLInSectorArea} == -1) then {
				_ret = FALSE;
				_tooltip = localize "STR_A3_WL_menu_arsenal_restr1"
			};
		};
		case "RemoveUnits": {
			if (count ((groupSelectedUnits player) - [player]) == 0) then {_ret = FALSE};
		};
		default {
			_vehiclesCnt = count (((player getVariable ["BIS_WL_pointer", objNull]) getVariable ["BIS_WL_purchased", []]) select {!isPlayer _x && !(_x isKindOf "Man")});
			if (_requirements findIf {!(_x in BIS_WL_servicesAvailable)} >= 0) exitWith {_ret = FALSE; _tooltip = localize "STR_A3_WL_airdrop_restr1"};
			if (_category == "Infantry" && (count units group player) - 1 + BIS_WL_matesInBasket >= BIS_WL_matesAvailable) exitWith {_ret = FALSE; _tooltip = localize "STR_A3_WL_airdrop_restr2"};
			if (_category in ["Vehicles", "Gear", "Defences", "Aircraft", "Naval", "Gear_custom"] && _vehiclesCnt + BIS_WL_vehsInBasket >= 20) exitWith {_ret = FALSE; _tooltip = localize "STR_A3_WL_airdrop_restr2"};
			if (_category == "Defences") exitWith {
				if (vehicle player != player) then {
					_ret = FALSE;
					_tooltip = localize "STR_A3_WL_defence_restr1"
				} else {
					if (triggerActivated BIS_WL_enemiesCheckTrigger) then {
						_ret = FALSE;
						_tooltip = localize "STR_A3_WL_tooltip_deploy_enemies_nearby";
					} else {
						_owned = BIS_WL_sectorsArrayFriendly # 0;
						if (_owned findIf {[player, _x, TRUE] call BIS_fnc_WLInSectorArea} == -1) then {
							_ret = FALSE;
							_tooltip = localize "STR_A3_WL_defence_restr1";
						};
						if (getNumber (BIS_WL_cfgVehs >> _class >> "isUav") == 1) then {
							if (count (player getVariable ["BIS_WL_autonomousPool", []]) >= BIS_RET_WL_autonomous_limit) then {
								_ret = FALSE;
								_tooltip = format [localize "STR_A3_WL_tip_max_autonomous", BIS_RET_WL_autonomous_limit];
							};
						};
					};
				};
			};
			_DLCOwned = [_class, "IsOwned"] call BIS_fnc_WLSubroutine_purchaseMenuHandleDLC;
			_DLCTooltip = [_class, "GetTooltip"] call BIS_fnc_WLSubroutine_purchaseMenuHandleDLC;
		};
	};
};
[_ret, _tooltip, _DLCOwned, _DLCTooltip]