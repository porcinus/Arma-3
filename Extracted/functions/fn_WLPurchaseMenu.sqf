/*
WARLORDS-SPECIFIC FUNCTION

Author: Josef Zemánek

Description: Purchase interface handle.
*/

disableSerialization;

switch (_this) do {
	case "open": {
		uiNamespace setVariable ["BIS_WL_purchaseMenuDiscovered", TRUE];
		if (BIS_WL_purchaseMenuVisible) exitWith {};
		BIS_WL_purchaseMenuVisible = TRUE;
		if (random 10 > 7) then {
			playSound selectRandom ["RadioAmbient6", "UAV_01", "UAV_03"];
		};
		hintSilent "";

		_xDef = safezoneX;
		_yDef = safezoneY;
		_wDef = safezoneW;
		_hDef = safezoneH;
		
		_myDisplay = (findDisplay 46) createDisplay "RscDisplayEmpty";
		_myDisplay displayAddEventHandler ["Unload", {
			_display = _this # 0;
			uiNamespace setVariable ["BIS_WL_purchaseMenuLastSelection", [lbCurSel (_display displayCtrl 100), lbCurSel (_display displayCtrl 101), lbCurSel (_display displayCtrl 109)]];
			if (ctrlEnabled (_display displayCtrl 120)) then {
				playSound "AddItemFailed";
				player setVariable ["BIS_WL_funds", ((player getVariable "BIS_WL_funds") + BIS_WL_transferCost) min BIS_WL_maxCP, TRUE];
			};
			BIS_WL_purchaseMenuVisible = FALSE;
		}];
		
		_myDisplay displayAddEventHandler ["KeyDown", {
			_key = _this # 1;
			if (_key in actionKeys "Gear" && !BIS_gearKeyPressed) then {
				"close" call BIS_fnc_WLPurchaseMenu;
				TRUE
			};
		}];
		
		_myDisplay displayAddEventHandler ["KeyUp", {
			_key = _this # 1;
			if (_key in actionKeys "Gear") then {
				BIS_gearKeyPressed = FALSE;
			};
		}];
		
		_purchase_background = _myDisplay ctrlCreate ["RscText", -1];
		_purchase_background_1 = _myDisplay ctrlCreate ["RscText", -1];
		_purchase_background_2 = _myDisplay ctrlCreate ["RscText", -1];
		_purchase_title_assets = _myDisplay ctrlCreate ["RscStructuredText", -1];
		_purchase_title_details = _myDisplay ctrlCreate ["RscStructuredText", -1];
		_purchase_title_deployment = _myDisplay ctrlCreate ["RscStructuredText", -1];
		_purchase_category = _myDisplay ctrlCreate ["RscListBox", 100];
		_purchase_items = _myDisplay ctrlCreate ["RscListBox", 101];
		_purchase_pic = _myDisplay ctrlCreate ["RscStructuredText", 102];
		_purchase_info = _myDisplay ctrlCreate ["RscStructuredText", 103];
		_purchase_income = _myDisplay ctrlCreate ["RscStructuredText", 104];
		_purchase_info_asset = _myDisplay ctrlCreate ["RscStructuredText", 105];
		_purchase_title_cost = _myDisplay ctrlCreate ["RscStructuredText", 106];
		_purchase_request = _myDisplay ctrlCreate ["RscStructuredText", 107];
		_purchase_title_queue = _myDisplay ctrlCreate ["RscStructuredText", 108];
		_purchase_queue = _myDisplay ctrlCreate ["RscListBox", 109];
		_purchase_remove_item = _myDisplay ctrlCreate ["RscStructuredText", 110];
		_purchase_remove_all = _myDisplay ctrlCreate ["RscStructuredText", 111];
		_purchase_title_drop = _myDisplay ctrlCreate ["RscStructuredText", 114];
		_purchase_drop_sector = _myDisplay ctrlCreate ["RscStructuredText", 112];
		_purchase_drop_player = _myDisplay ctrlCreate ["RscStructuredText", 113];
		
		_purchase_transfer_background = _myDisplay ctrlCreate ["RscText", 115];
		_purchase_transfer_units = _myDisplay ctrlCreate ["RscListBox", 116];
		_purchase_transfer_amount = _myDisplay ctrlCreate ["RscEdit", 117];
		_purchase_transfer_cp_title = _myDisplay ctrlCreate ["RscStructuredText", 118];
		_purchase_transfer_ok = _myDisplay ctrlCreate ["RscStructuredText", 119];
		_purchase_transfer_cancel = _myDisplay ctrlCreate ["RscStructuredText", 120];
		
		uiNamespace setVariable ["BIS_WL_purchaseMenuDisplay", _myDisplay];
		
		_purchase_background ctrlSetPosition [_xDef, _yDef + (_hDef * 0.15), _wDef, _hDef * 0.7];
		_purchase_background ctrlSetBackgroundColor [0, 0, 0, 0.5];
		_purchase_background ctrlEnable FALSE;
		_purchase_background ctrlCommit 0;
		
		_purchase_title_assets ctrlSetPosition [_xDef, _yDef + (_hDef * 0.15), _wDef / 2, _hDef * 0.045];
		_purchase_title_assets ctrlSetBackgroundColor [0, 0, 0, 0.5];
		_purchase_title_assets ctrlSetTextColor [0.65, 0.65, 0.65, 1];
		_purchase_title_assets ctrlEnable FALSE;
		_purchase_title_assets ctrlCommit 0;
		_purchase_title_assets ctrlSetStructuredText parseText format ["<t size = '%2' align = 'center' shadow = '2'>%1</t>", localize "STR_A3_WL_purchase_menu_title_assets", (1.5 call BIS_fnc_WLSubroutine_purchaseMenuGetUIScale)];
		
		_purchase_title_details ctrlSetPosition [_xDef + (_wDef / 2), _yDef + (_hDef * 0.15), _wDef / 4, _hDef * 0.045];
		_purchase_title_details ctrlSetBackgroundColor [0, 0, 0, 0.5];
		_purchase_title_details ctrlSetTextColor [0.65, 0.65, 0.65, 1];
		_purchase_title_details ctrlEnable FALSE;
		_purchase_title_details ctrlCommit 0;
		_purchase_title_details ctrlSetStructuredText parseText format ["<t size = '%2' align = 'center' shadow = '2'>%1</t>", localize "STR_A3_WL_purchase_menu_title_detail", (1.5 call BIS_fnc_WLSubroutine_purchaseMenuGetUIScale)];
		
		_purchase_title_deployment ctrlSetPosition [_xDef + (_wDef * 0.75), _yDef + (_hDef * 0.15), _wDef / 4, _hDef * 0.045];
		_purchase_title_deployment ctrlSetBackgroundColor [0, 0, 0, 0.5];
		_purchase_title_deployment ctrlSetTextColor [0.65, 0.65, 0.65, 1];
		_purchase_title_deployment ctrlEnable FALSE;
		_purchase_title_deployment ctrlCommit 0;
		_purchase_title_deployment ctrlSetStructuredText parseText format ["<t size = '%2' align = 'center' shadow = '2'>%1</t>", localize "STR_A3_WL_purchase_menu_title_deployment", (1.5 call BIS_fnc_WLSubroutine_purchaseMenuGetUIScale)];
		
		_purchase_income ctrlSetPosition [_xDef, _yDef + (_hDef * 0.805), _wDef, _hDef * 0.045];
		_purchase_income ctrlSetBackgroundColor [0, 0, 0, 0.5];
		_purchase_income ctrlSetTextColor [0.65, 0.65, 0.65, 1];
		_purchase_income ctrlEnable FALSE;
		_purchase_income ctrlCommit 0;
		
		_purchase_category ctrlSetPosition [_xDef, _yDef + (_hDef * 0.195), _wDef * 0.25, _hDef * 0.5];
		_purchase_category ctrlCommit 0;
		
		{
			_id = switch (_forEachIndex) do {
				case 0: {0};
				case 1: {1};
				case 2: {4};
				case 3: {5};
				case 4: {3};
				case 5: {2};
				case 6: {7};
				default {0};
			};
			if (count ((player getVariable "BIS_WL_purchasable") # _id) > 0) then {
				_purchase_category lbAdd _x;
				_purchase_category lbSetValue [(lbSize _purchase_category) - 1, _id];
				_purchase_category lbSetData [(lbSize _purchase_category) - 1, str _forEachIndex];
			};
		} forEach [
			localize "STR_A3_cfgmarkers_nato_inf",
			localize "STR_dn_vehicles",
			localize "STR_A3_WL_menu_aircraft",
			localize "STR_A3_rscdisplaygarage_tab_naval",
			localize "STR_A3_WL_menu_defences",
			localize "STR_A3_rscdisplaywelcome_exp_parb_list4_title",
			localize "STR_A3_WL_menu_strategy"
		];
		
		_purchase_category lbSetCurSel ((uiNamespace getVariable ["BIS_WL_purchaseMenuLastSelection", [0, 0, 0]]) # 0);
		
		_purchase_category ctrlAddEventHandler ["LBSelChanged", {
			(_this # 1) call BIS_fnc_WLSubroutine_purchaseMenuSetItemsList;
		}];
		
		_purchase_items ctrlSetPosition [_xDef + (_wDef * 0.25), _yDef + (_hDef * 0.195), _wDef * 0.25, _hDef * 0.5];
		_purchase_items ctrlCommit 0;
		
		_purchase_items ctrlAddEventHandler ["LBSelChanged", {
			call BIS_fnc_WLSubroutine_purchaseMenuSetAssetDetails;
		}];
		
		_purchase_info ctrlSetPosition [_xDef, _yDef + (_hDef * 0.695), _wDef * 0.5, _hDef * 0.11];
		_purchase_info ctrlSetBackgroundColor [0, 0, 0, 0.3];
		_purchase_info ctrlSetTextColor [0.65, 0.65, 0.65, 1];
		_purchase_income ctrlEnable FALSE;
		_purchase_info ctrlCommit 0;
		
		_purchase_pic ctrlSetPosition [_xDef + (_wDef * 0.5), _yDef + (_hDef * 0.195), _wDef * 0.25, _hDef * 0.23];
		_purchase_pic ctrlSetBackgroundColor [0, 0, 0, 0.3];
		_purchase_pic ctrlEnable FALSE;
		_purchase_pic ctrlCommit 0;
		
		_purchase_info_asset ctrlSetPosition [_xDef + (_wDef * 0.5), _yDef + (_hDef * 0.425), _wDef * 0.25, _hDef * 0.38];
		_purchase_info_asset ctrlSetBackgroundColor [0, 0, 0, 0.3];
		_purchase_info_asset ctrlSetTextColor [0.65, 0.65, 0.65, 1];
		_purchase_info_asset ctrlEnable FALSE;
		_purchase_info_asset ctrlCommit 0;
		
		_purchase_background_1 ctrlSetPosition [_xDef + (_wDef * 0.75), _yDef + (_hDef * 0.195), _wDef, _hDef * 0.1625];
		_purchase_background_1 ctrlSetBackgroundColor [0, 0, 0, 0.3];
		_purchase_background_1 ctrlEnable FALSE;
		_purchase_background_1 ctrlCommit 0;
		
		_purchase_title_cost ctrlSetPosition [_xDef + (_wDef * 0.75), _yDef + (_hDef * 0.195), _wDef / 4, _hDef * 0.04];
		_purchase_title_cost ctrlSetTextColor [0.65, 0.65, 0.65, 1];
		_purchase_title_cost ctrlEnable FALSE;
		_purchase_title_cost ctrlCommit 0;
		
		_purchase_request ctrlSetPosition [_xDef + (_wDef * 0.75), _yDef + (_hDef * 0.235), _wDef / 4, _hDef * 0.055];
		_purchase_request ctrlSetBackgroundColor (BIS_WL_sectorColors # ([EAST, WEST] find side group player));
		_purchase_request ctrlCommit 0;
		_purchase_request ctrlSetStructuredText parseText format ["<t font = 'PuristaLight' align = 'center' shadow = '2' size = '%2'>%1</t>", toUpper localize "STR_A3_WL_menu_request", (1.75 call BIS_fnc_WLSubroutine_purchaseMenuGetUIScale)];
		
		_purchase_request ctrlAddEventHandler ["MouseEnter", {
			_button = _this # 0;
			if (uiNamespace getVariable ["BIS_WL_purchaseMenuItemAffordable", FALSE]) then {
				_color = (BIS_WL_sectorColors # ([EAST, WEST] find side group player));
				_button ctrlSetBackgroundColor [(_color # 0) * 1.25, (_color # 1) * 1.25, (_color # 2) * 1.25, _color # 3];
				uiNamespace setVariable ["BIS_WL_purchaseMenuButtonHover", TRUE];
				playSound "click";
			};
		}];
		_purchase_request ctrlAddEventHandler ["MouseExit", {
			_button = _this # 0;
			_color = (BIS_WL_sectorColors # ([EAST, WEST] find side group player));
			if (uiNamespace getVariable ["BIS_WL_purchaseMenuItemAffordable", FALSE]) then {
				_button ctrlSetTextColor [1, 1, 1, 1];
				_button ctrlSetBackgroundColor _color;
			} else {
				_button ctrlSetTextColor [0.5, 0.5, 0.5, 1];
				_button ctrlSetBackgroundColor [(_color # 0) * 0.5, (_color # 1) * 0.5, (_color # 2) * 0.5, _color # 3];
			};
			uiNamespace setVariable ["BIS_WL_purchaseMenuButtonHover", FALSE];
		}];
		_purchase_request ctrlAddEventHandler ["MouseButtonDown", {
			if (uiNamespace getVariable ["BIS_WL_purchaseMenuItemAffordable", FALSE]) then {
				_button = _this # 0;
				_button ctrlSetTextColor [0.75, 0.75, 0.75, 1];
			};
		}];
		_purchase_request ctrlAddEventHandler ["MouseButtonUp", {
			if (uiNamespace getVariable ["BIS_WL_purchaseMenuItemAffordable", FALSE]) then {
				_button = _this # 0;
				_button ctrlSetTextColor [1, 1, 1, 1];
			};
		}];
		_purchase_request ctrlAddEventHandler ["ButtonClick", {
			if (uiNamespace getVariable ["BIS_WL_purchaseMenuItemAffordable", FALSE]) then {
				playSound "AddItemOK";
				_display = uiNamespace getVariable ["BIS_WL_purchaseMenuDisplay", displayNull];
				_purchase_items = _display displayCtrl 101;
				_curSel = (lbCurSel _purchase_items) max 0;
				_assetDetails = (_purchase_items lbData _curSel) splitString "|";
				_cost = _purchase_items lbValue lbCurSel _purchase_items;
				_class = _assetDetails # 0;
				_category = _assetDetails # 5;
				_offset = [];
				if (count _assetDetails > 6) then {
					_offset = call compile (_assetDetails # 6);
				};
				_requirements = call compile (_assetDetails # 1);
				switch (_class) do {
					case "Arsenal": {call BIS_fnc_WLopenArsenal};
					case "LastLoadout": {player call BIS_fnc_WLloadoutApply};
					case "Scan": {[] spawn BIS_fnc_WLrequestSectorScan};
					case "FTSeized": {[] spawn BIS_fnc_WLrequestFastTravel};
					case "FTConflict": {1 spawn BIS_fnc_WLrequestFastTravel};
					case "FundsTransfer": {call BIS_fnc_WLrequestFundsTransfer};
					case "VotingReset": {call BIS_fnc_WLrequestVotingReset};
					case "LockVehicles": {_vehs = ((player getVariable ["BIS_WL_pointer", objNull]) getVariable ["BIS_WL_purchased", []]); {_x lock TRUE} forEach (_vehs select {alive _x}); [toUpper localize "STR_A3_WL_feature_lock_all_msg"] spawn BIS_fnc_WLSmoothText};
					case "UnlockVehicles": {_vehs = ((player getVariable ["BIS_WL_pointer", objNull]) getVariable ["BIS_WL_purchased", []]); {_x lock FALSE} forEach (_vehs select {alive _x}); [toUpper localize "STR_A3_WL_feature_unlock_all_msg"] spawn BIS_fnc_WLSmoothText};
					case "RemoveUnits": {{_x setPos position _x; deleteVehicle _x} forEach ((groupSelectedUnits player) - [player])};
					default {[_class, _cost, _category, _requirements, _offset] call BIS_fnc_WLrequestPurchase};
				};
			} else {
				playSound "AddItemFailed";
			};
		}];

		_purchase_title_queue ctrlSetPosition [_xDef + (_wDef * 0.75), _yDef + (_hDef * 0.3175), _wDef / 4, _hDef * 0.04];
		_purchase_title_queue ctrlSetTextColor [0.65, 0.65, 0.65, 1];
		_purchase_title_queue ctrlEnable FALSE;
		_purchase_title_queue ctrlCommit 0;
		
		_purchase_queue ctrlSetPosition [_xDef + (_wDef * 0.75), _yDef + (_hDef * 0.3575), _wDef / 4, _hDef * 0.1875];
		_purchase_queue ctrlCommit 0;
		
		_purchase_background_2 ctrlSetPosition [_xDef + (_wDef * 0.75), _yDef + (_hDef * 0.5452), _wDef, _hDef * 0.2598];
		_purchase_background_2 ctrlSetBackgroundColor [0, 0, 0, 0.3];
		_purchase_background_2 ctrlEnable FALSE;
		_purchase_background_2 ctrlCommit 0;
		
		_purchase_remove_item ctrlSetPosition [_xDef + (_wDef * 0.75), _yDef + (_hDef * 0.5502), _wDef / 4, _hDef * 0.035];
		_purchase_remove_item ctrlSetBackgroundColor (BIS_WL_sectorColors # ([EAST, WEST] find side group player));
		_purchase_remove_item ctrlCommit 0;
		_purchase_remove_item ctrlSetStructuredText parseText format ["<t font = 'PuristaLight' align = 'center' shadow = '2' size = '%2'>%1</t>", toUpper localize "STR_A3_WL_menu_remove_item", (1.15 call BIS_fnc_WLSubroutine_purchaseMenuGetUIScale)];
		
		_purchase_remove_all ctrlSetPosition [_xDef + (_wDef * 0.75), _yDef + (_hDef * 0.59), _wDef / 4, _hDef * 0.035];
		_purchase_remove_all ctrlSetBackgroundColor (BIS_WL_sectorColors # ([EAST, WEST] find side group player));
		_purchase_remove_all ctrlCommit 0;
		_purchase_remove_all ctrlSetStructuredText parseText format ["<t font = 'PuristaLight' align = 'center' shadow = '2' size = '%2'>%1</t>", toUpper localize "STR_A3_WL_menu_remove_all", (1.15 call BIS_fnc_WLSubroutine_purchaseMenuGetUIScale)];
		
		{
			_x ctrlAddEventHandler ["MouseEnter", {
				_display = uiNamespace getVariable ["BIS_WL_purchaseMenuDisplay", displayNull];
				if (ctrlEnabled (_display displayCtrl 107)) then {
					_button = _this # 0;
					_color = (BIS_WL_sectorColors # ([EAST, WEST] find side group player));
					_button ctrlSetBackgroundColor [(_color # 0) * 1.25, (_color # 1) * 1.25, (_color # 2) * 1.25, _color # 3];
					playSound "click";
				};
			}];
			_x ctrlAddEventHandler ["MouseExit", {
				_display = uiNamespace getVariable ["BIS_WL_purchaseMenuDisplay", displayNull];
				if (ctrlEnabled (_display displayCtrl 107)) then {
					_button = _this # 0;
					_color = (BIS_WL_sectorColors # ([EAST, WEST] find side group player));
					_button ctrlSetTextColor [1, 1, 1, 1];
					_button ctrlSetBackgroundColor _color;
				};
			}];
			_x ctrlAddEventHandler ["MouseButtonDown", {
				_display = uiNamespace getVariable ["BIS_WL_purchaseMenuDisplay", displayNull];
				if (ctrlEnabled (_display displayCtrl 107)) then {
					_button = _this # 0;
					_button ctrlSetTextColor [0.75, 0.75, 0.75, 1];
				};
			}];
			_x ctrlAddEventHandler ["MouseButtonUp", {
				_display = uiNamespace getVariable ["BIS_WL_purchaseMenuDisplay", displayNull];
				if (ctrlEnabled (_display displayCtrl 107)) then {
					_button = _this # 0;
					_button ctrlSetTextColor [1, 1, 1, 1];
				};
			}];
		} forEach [_purchase_remove_item, _purchase_remove_all];
		
		_purchase_remove_item ctrlAddEventHandler ["ButtonClick", {
			_display = uiNamespace getVariable ["BIS_WL_purchaseMenuDisplay", displayNull];
			if (ctrlEnabled (_display displayCtrl 107)) then {
				playSound "AddItemOK";
				_display = uiNamespace getVariable ["BIS_WL_purchaseMenuDisplay", displayNull];
				_purchase_queue = _display displayCtrl 109;
				_refund = _purchase_queue lbValue lbCurSel _purchase_queue;
				if (_refund > 0) then {
					_class = _purchase_queue lbData lbCurSel _purchase_queue;
					_i = -1;
					{if ((_x # 0) == _class) then {_i = _forEachIndex}} forEach BIS_WL_dropPool;
					_inf = ((BIS_WL_dropPool # _i) # 3) == "Infantry";
					BIS_WL_dropPool deleteAt _i;
					player setVariable ["BIS_WL_funds", ((player getVariable "BIS_WL_funds") + _refund) min BIS_WL_maxCP, TRUE];
					if (_inf) then {BIS_WL_matesInBasket = BIS_WL_matesInBasket - 1} else {BIS_WL_vehsInBasket = BIS_WL_vehsInBasket - 1};
					_display = uiNamespace getVariable ["BIS_WL_purchaseMenuDisplay", displayNull];
					_purchase_items = _display displayCtrl 101;
					call BIS_fnc_WLSubroutine_purchaseMenuRefresh;
				};
			};
		}];
		
		_purchase_remove_all ctrlAddEventHandler ["ButtonClick", {
			_display = uiNamespace getVariable ["BIS_WL_purchaseMenuDisplay", displayNull];
			if (ctrlEnabled (_display displayCtrl 107)) then {
				playSound "AddItemOK";
				_refundTotal = 0;
				{
					_refundTotal = _refundTotal + (_x # 1);
				} forEach BIS_WL_dropPool;
				player setVariable ["BIS_WL_funds", ((player getVariable "BIS_WL_funds") + _refundTotal) min BIS_WL_maxCP, TRUE];
				BIS_WL_matesInBasket = 0;
				BIS_WL_vehsInBasket = 0;
				BIS_WL_dropPool = [];
				_display = uiNamespace getVariable ["BIS_WL_purchaseMenuDisplay", displayNull];
				_purchase_items = _display displayCtrl 101;
				call BIS_fnc_WLSubroutine_purchaseMenuRefresh;
			};
		}];
		
		_purchase_title_drop ctrlSetPosition [_xDef + (_wDef * 0.75), _yDef + (_hDef * 0.6502), _wDef / 4, _hDef * 0.04];
		_purchase_title_drop ctrlSetTextColor [0.65, 0.65, 0.65, 1];
		_purchase_title_drop ctrlEnable FALSE;
		_purchase_title_drop ctrlCommit 0;
		_purchase_title_drop ctrlSetStructuredText parseText format ["<t size = '%2' align = 'center' shadow = '0'>%1</t>", localize "STR_A3_WL_airdrop_target", (1.25 call BIS_fnc_WLSubroutine_purchaseMenuGetUIScale)];
		
		_purchase_drop_sector ctrlSetPosition [_xDef + (_wDef * 0.75), _yDef + (_hDef * 0.6902), _wDef / 4, _hDef * 0.055];
		_purchase_drop_sector ctrlSetBackgroundColor (BIS_WL_sectorColors # ([EAST, WEST] find side group player));
		_purchase_drop_sector ctrlCommit 0;
		_purchase_drop_sector ctrlSetStructuredText parseText format ["<t font = 'PuristaLight' align = 'center' shadow = '2' size = '%4'>%1</t>", toUpper localize "STR_A3_WL_airdrop_owned_sector", BIS_WL_dropCost, localize "STR_A3_WL_unit_cp", (1.75 call BIS_fnc_WLSubroutine_purchaseMenuGetUIScale)];
		_purchase_drop_sector ctrlSetTooltip format ["%1%4: %2 %3", localize "STR_A3_WL_menu_cost", BIS_WL_dropCost, localize "STR_A3_WL_unit_cp", if (toLower language == "french") then {" "} else {""}];
		
		_purchase_drop_sector ctrlAddEventHandler ["MouseEnter", {
			if (uiNamespace getVariable ["BIS_WL_purchaseMenuDropSectorAffordable", FALSE]) then {
				uiNamespace setVariable ["BIS_WL_purchaseMenuButtonDropSectorHover", TRUE];
				_button = _this # 0;
				_color = (BIS_WL_sectorColors # ([EAST, WEST] find side group player));
				_button ctrlSetBackgroundColor [(_color # 0) * 1.25, (_color # 1) * 1.25, (_color # 2) * 1.25, _color # 3];
				playSound "click";
			};
		}];
		_purchase_drop_sector ctrlAddEventHandler ["MouseExit", {
			if (uiNamespace getVariable ["BIS_WL_purchaseMenuDropSectorAffordable", FALSE]) then {
				uiNamespace setVariable ["BIS_WL_purchaseMenuButtonDropSectorHover", FALSE];
				_button = _this # 0;
				_color = (BIS_WL_sectorColors # ([EAST, WEST] find side group player));
				_button ctrlSetTextColor [1, 1, 1, 1];
				_button ctrlSetBackgroundColor _color;
			};
		}];
		_purchase_drop_sector ctrlAddEventHandler ["MouseButtonDown", {
			if (uiNamespace getVariable ["BIS_WL_purchaseMenuDropSectorAffordable", FALSE]) then {
				_button = _this # 0;
				_button ctrlSetTextColor [0.75, 0.75, 0.75, 1];
			};
		}];
		_purchase_drop_sector ctrlAddEventHandler ["MouseButtonUp", {
			if (uiNamespace getVariable ["BIS_WL_purchaseMenuDropSectorAffordable", FALSE]) then {
				_button = _this # 0;
				_button ctrlSetTextColor [1, 1, 1, 1];
			};
		}];
		_purchase_drop_sector ctrlAddEventHandler ["ButtonClick", {
			if (uiNamespace getVariable ["BIS_WL_purchaseMenuDropSectorAffordable", FALSE]) then {
				playSound "AddItemOK";
				[BIS_WL_dropPool, 1] spawn BIS_fnc_WLdropPurchase
			} else {
				playSound "AddItemFailed";
			};
		}];
		
		_purchase_drop_player ctrlSetPosition [_xDef + (_wDef * 0.75), _yDef + (_hDef * 0.75), _wDef / 4, _hDef * 0.055];
		_purchase_drop_player ctrlSetBackgroundColor (BIS_WL_sectorColors # ([EAST, WEST] find side group player));
		_purchase_drop_player ctrlCommit 0;
		_purchase_drop_player ctrlSetStructuredText parseText format ["<t font = 'PuristaLight' align = 'center' shadow = '2' size = '%4'>%1</t>", toUpper localize "STR_A3_WL_airdrop_player", BIS_WL_dropCost * 40, localize "STR_A3_WL_unit_cp", (1.75 call BIS_fnc_WLSubroutine_purchaseMenuGetUIScale)];
		_purchase_drop_player ctrlSetTooltip format ["%1%4: %2 %3", localize "STR_A3_WL_menu_cost", BIS_WL_dropCost * 40, localize "STR_A3_WL_unit_cp", if (toLower language == "french") then {" "} else {""}];
		
		_purchase_drop_player ctrlAddEventHandler ["MouseEnter", {
			if (uiNamespace getVariable ["BIS_WL_purchaseMenuDropPlayerAffordable", FALSE]) then {
				uiNamespace setVariable ["BIS_WL_purchaseMenuButtonDropPlayerHover", TRUE];
				_button = _this # 0;
				_color = (BIS_WL_sectorColors # ([EAST, WEST] find side group player));
				_button ctrlSetBackgroundColor [(_color # 0) * 1.25, (_color # 1) * 1.25, (_color # 2) * 1.25, _color # 3];
				playSound "click";
			};
		}];
		_purchase_drop_player ctrlAddEventHandler ["MouseExit", {
			if (uiNamespace getVariable ["BIS_WL_purchaseMenuDropPlayerAffordable", FALSE]) then {
				uiNamespace setVariable ["BIS_WL_purchaseMenuButtonDropPlayerHover", FALSE];
				_button = _this # 0;
				_color = (BIS_WL_sectorColors # ([EAST, WEST] find side group player));
				_button ctrlSetTextColor [1, 1, 1, 1];
				_button ctrlSetBackgroundColor _color;
			};
		}];
		_purchase_drop_player ctrlAddEventHandler ["MouseButtonDown", {
			if (uiNamespace getVariable ["BIS_WL_purchaseMenuDropPlayerAffordable", FALSE]) then {
				_button = _this # 0;
				_button ctrlSetTextColor [0.75, 0.75, 0.75, 1];
			};
		}];
		_purchase_drop_player ctrlAddEventHandler ["MouseButtonUp", {
			if (uiNamespace getVariable ["BIS_WL_purchaseMenuDropPlayerAffordable", FALSE]) then {
				_button = _this # 0;
				_button ctrlSetTextColor [1, 1, 1, 1];
			};
		}];
		_purchase_drop_player ctrlAddEventHandler ["ButtonClick", {
			if (uiNamespace getVariable ["BIS_WL_purchaseMenuDropPlayerAffordable", FALSE]) then {
				playSound "AddItemOK";
				[BIS_WL_dropPool, 40] spawn BIS_fnc_WLdropPurchase
			} else {
				playSound "AddItemFailed";
			};
		}];
		
		_purchase_transfer_background ctrlSetPosition [_xDef + (_wDef / 3), _yDef + (_hDef / 3), _wDef / 3, _hDef / 3];
		_purchase_transfer_background ctrlSetBackgroundColor [0, 0, 0, 1];
		_purchase_transfer_background ctrlSetFade 1;
		_purchase_transfer_background ctrlEnable FALSE;
		_purchase_transfer_background ctrlCommit 0;
		
		_purchase_transfer_units ctrlSetPosition [_xDef + (_wDef / 3), _yDef + (_hDef / 3), _wDef / 6, _hDef / 3];
		_purchase_transfer_units ctrlSetFade 1;
		_purchase_transfer_units ctrlEnable FALSE;
		_purchase_transfer_units ctrlCommit 0;
		
		_purchase_transfer_amount ctrlSetPosition [_xDef + (_wDef / 3) + (_wDef / 6), _yDef + (_hDef * 0.425), _wDef / 12, _hDef * 0.035];
		_purchase_transfer_amount ctrlSetFade 1;
		_purchase_transfer_amount ctrlEnable FALSE;
		_purchase_transfer_amount ctrlCommit 0;
		
		_purchase_transfer_cp_title ctrlSetPosition [_xDef + (_wDef / 3) + (_wDef / 6) + (_wDef / 12), _yDef + (_hDef * 0.425), _wDef / 12, _hDef * 0.035];
		_purchase_transfer_cp_title ctrlSetFade 1;
		_purchase_transfer_cp_title ctrlEnable FALSE;
		_purchase_transfer_cp_title ctrlCommit 0;
		_purchase_transfer_cp_title ctrlSetStructuredText parseText format ["<t align = 'center' size = '%2'>%1</t>", localize "STR_A3_WL_unit_cp", (1.25 call BIS_fnc_WLSubroutine_purchaseMenuGetUIScale)];

		_purchase_transfer_ok ctrlSetPosition [_xDef + (_wDef / 3) + (_wDef / 6), _yDef + (_hDef * 0.5502), _wDef / 6, _hDef * 0.035];
		_purchase_transfer_ok ctrlSetBackgroundColor (BIS_WL_sectorColors # ([EAST, WEST] find side group player));
		_purchase_transfer_ok ctrlSetFade 1;
		_purchase_transfer_ok ctrlEnable FALSE;
		_purchase_transfer_ok ctrlCommit 0;
		_purchase_transfer_ok ctrlSetStructuredText parseText format ["<t align = 'center' shadow = '2' size = '%2'>%1</t>", localize "STR_A3_WL_button_transfer", (1.25 call BIS_fnc_WLSubroutine_purchaseMenuGetUIScale)];
		
		_purchase_transfer_ok ctrlAddEventHandler ["MouseEnter", {
			if (uiNamespace getVariable ["BIS_WL_fundsTransferPossible", FALSE]) then {
				_button = _this # 0;
				_color = (BIS_WL_sectorColors # ([EAST, WEST] find side group player));
				_button ctrlSetBackgroundColor [(_color # 0) * 1.25, (_color # 1) * 1.25, (_color # 2) * 1.25, _color # 3];
				playSound "click";
			};
		}];
		_purchase_transfer_ok ctrlAddEventHandler ["MouseExit", {
			if (uiNamespace getVariable ["BIS_WL_fundsTransferPossible", FALSE]) then {
				_button = _this # 0;
				_color = (BIS_WL_sectorColors # ([EAST, WEST] find side group player));
				_button ctrlSetTextColor [1, 1, 1, 1];
				_button ctrlSetBackgroundColor _color;
			};
		}];
		_purchase_transfer_ok ctrlAddEventHandler ["MouseButtonDown", {
			if (uiNamespace getVariable ["BIS_WL_fundsTransferPossible", FALSE]) then {
				_button = _this # 0;
				_button ctrlSetTextColor [0.75, 0.75, 0.75, 1];
			};
		}];
		_purchase_transfer_ok ctrlAddEventHandler ["MouseButtonUp", {
			if (uiNamespace getVariable ["BIS_WL_fundsTransferPossible", FALSE]) then {
				_button = _this # 0;
				_button ctrlSetTextColor [1, 1, 1, 1];
			};
		}];
		_purchase_transfer_ok ctrlAddEventHandler ["ButtonClick", {
			if (uiNamespace getVariable ["BIS_WL_fundsTransferPossible", FALSE]) then {
				_display = uiNamespace getVariable ["BIS_WL_purchaseMenuDisplay", displayNull];
				_targetName = (_display displayCtrl 116) lbText lbCurSel (_display displayCtrl 116);
				//_amount = call compile [ctrlText (_display displayCtrl 117), TRUE];
				_amount = (call compile ctrlText (_display displayCtrl 117)) min (player getVariable "BIS_WL_funds");
				_targetArr = BIS_WL_allWarlords select {name _x == _targetName};
				if (count _targetArr > 0) then {
					playSound "AddItemOK";
					_target = _targetArr # 0;
					_targetFunds = _target getVariable "BIS_WL_funds";
					_maxTransfer = BIS_WL_maxCP - _targetFunds;
					_finalTransfer = (_amount min _maxTransfer) max 0;
					player setVariable ["BIS_WL_funds", (player getVariable "BIS_WL_funds") - _finalTransfer, TRUE];
					_target setVariable ["BIS_WL_funds", ((_target getVariable "BIS_WL_funds") + _finalTransfer) min BIS_WL_maxCP, TRUE];
					for [{_i = 100}, {_i <= 114}, {_i = _i + 1}] do {
						(_display displayCtrl _i) ctrlEnable TRUE;
					};
					for [{_i = 115}, {_i <= 120}, {_i = _i + 1}] do {
						(_display displayCtrl _i) ctrlEnable FALSE;
						(_display displayCtrl _i) ctrlSetFade 1;
						(_display displayCtrl _i) ctrlCommit 0;
					};
				} else {
					playSound "AddItemFailed";
				};
			};
		}];

		_purchase_transfer_cancel ctrlSetPosition [_xDef + (_wDef / 3) + (_wDef / 6), _yDef + (_hDef * 0.59), _wDef / 6, _hDef * 0.035];
		_purchase_transfer_cancel ctrlSetBackgroundColor (BIS_WL_sectorColors # ([EAST, WEST] find side group player));
		_purchase_transfer_cancel ctrlSetFade 1;
		_purchase_transfer_cancel ctrlEnable FALSE;
		_purchase_transfer_cancel ctrlCommit 0;
		_purchase_transfer_cancel ctrlSetStructuredText parseText format ["<t align = 'center' shadow = '2' size = '%2'>%1</t>", localize "STR_disp_cancel", (1.25 call BIS_fnc_WLSubroutine_purchaseMenuGetUIScale)];
		
		_purchase_transfer_cancel ctrlAddEventHandler ["MouseEnter", {
			_button = _this # 0;
			_color = (BIS_WL_sectorColors # ([EAST, WEST] find side group player));
			_button ctrlSetBackgroundColor [(_color # 0) * 1.25, (_color # 1) * 1.25, (_color # 2) * 1.25, _color # 3];
			playSound "click";
		}];
		_purchase_transfer_cancel ctrlAddEventHandler ["MouseExit", {
			_button = _this # 0;
			_color = (BIS_WL_sectorColors # ([EAST, WEST] find side group player));
			_button ctrlSetTextColor [1, 1, 1, 1];
			_button ctrlSetBackgroundColor _color;
		}];
		_purchase_transfer_cancel ctrlAddEventHandler ["MouseButtonDown", {
			_button = _this # 0;
			_button ctrlSetTextColor [0.75, 0.75, 0.75, 1];
		}];
		_purchase_transfer_cancel ctrlAddEventHandler ["MouseButtonUp", {
			_button = _this # 0;
			_button ctrlSetTextColor [1, 1, 1, 1];
		}];
		_purchase_transfer_cancel ctrlAddEventHandler ["ButtonClick", {
			_display = uiNamespace getVariable ["BIS_WL_purchaseMenuDisplay", displayNull];
			for [{_i = 100}, {_i <= 114}, {_i = _i + 1}] do {
				(_display displayCtrl _i) ctrlEnable TRUE;
			};
			for [{_i = 115}, {_i <= 120}, {_i = _i + 1}] do {
				(_display displayCtrl _i) ctrlEnable FALSE;
				(_display displayCtrl _i) ctrlSetFade 1;
				(_display displayCtrl _i) ctrlCommit 0;
			};
			playSound "AddItemFailed";
			player setVariable ["BIS_WL_funds", ((player getVariable "BIS_WL_funds") + BIS_WL_transferCost) min BIS_WL_maxCP, TRUE];
		}];
		
		((uiNamespace getVariable ["BIS_WL_purchaseMenuLastSelection", [0, 0, 0]]) # 0) call BIS_fnc_WLSubroutine_purchaseMenuSetItemsList;
		
		while {BIS_WL_purchaseMenuVisible} do {
			if (isNull _myDisplay) exitWith {BIS_WL_purchaseMenuVisible = FALSE};
			call BIS_fnc_WLSubroutine_purchaseMenuRefresh;
			sleep 0.25;
		};
	};
	case "close": {
		(uiNamespace getVariable ["BIS_WL_purchaseMenuDisplay", displayNull]) closeDisplay 1;
	};
};