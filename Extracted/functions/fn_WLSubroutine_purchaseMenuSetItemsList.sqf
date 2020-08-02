_display = uiNamespace getVariable ["BIS_WL_purchaseMenuDisplay", displayNull];
_purchase_category = _display displayCtrl 100;
lbClear (_display displayCtrl 101);
_id = _purchase_category lbValue _this;

{
	(_display displayCtrl 101) lbAdd (_x # 3);
	if ((_x # 0) == "RemoveUnits") then {uiNamespace setVariable ["BIS_WL_removeUnitsListID", -1 + lbSize (_display displayCtrl 101)]};
	if (_id == 3) then {
		(_display displayCtrl 101) lbSetData [_forEachIndex, format ["%1|%2|%3|%4|%5|%6|%7", _x # 0, _x # 2, _x # 3, _x # 4, _x # 5, _x # 6, _x # 7]];
	} else {
		(_display displayCtrl 101) lbSetData [_forEachIndex, format ["%1|%2|%3|%4|%5|%6", _x # 0, _x # 2, _x # 3, _x # 4, _x # 5, _x # 6]];
	};
	(_display displayCtrl 101) lbSetValue [_forEachIndex, _x # 1];
} forEach ((player getVariable "BIS_WL_purchasable") # _id);
(_display displayCtrl 101) lbSetCurSel ((uiNamespace getVariable ["BIS_WL_purchaseMenuLastSelection", [0, 0, 0]]) # 1);;
_purchase_items = _display displayCtrl 1;
(_display displayCtrl 103) ctrlSetStructuredText parseText format [
	"<t align = 'center' size = '%2'>%1</t>",
	[
		format [localize "STR_A3_WL_asset_infantry_info", BIS_WL_maxSubordinates + 1],
		localize "STR_A3_WL_asset_vehicles_info",
	 	localize "STR_A3_WL_asset_aircraft_info",
	 	localize "STR_A3_WL_asset_naval_info",
	 	localize "STR_A3_WL_asset_defences_info",
	 	localize "STR_A3_WL_asset_gear_info",
	 	""
	] # parseNumber (_purchase_category lbData _this),
	(0.85 call BIS_fnc_WLSubroutine_purchaseMenuGetUIScale)
];
call BIS_fnc_WLSubroutine_purchaseMenuSetAssetDetails;