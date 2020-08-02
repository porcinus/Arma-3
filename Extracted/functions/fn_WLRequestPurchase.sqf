/*
WARLORDS-SPECIFIC FUNCTION

Author: Josef Zemánek

Description: Handles proper purchase subroutine based on asset type.
*/

_class = _this # 0;
_cost = _this # 1;
_category = _this # 2;
_requirements = _this # 3;
_offset = _this # 4;

_funds = player getVariable "BIS_WL_funds";
_isMan = _category == "Infantry";
_isAir = _category == "Aircraft";
_isStatic = _category == "Defences";
_isNaval = _category == "Naval";

player setVariable ["BIS_WL_funds", (player getVariable "BIS_WL_funds") - _cost, TRUE];
if (_isMan) then {BIS_WL_matesInBasket = BIS_WL_matesInBasket + 1} else {if !(_isStatic) then {BIS_WL_vehsInBasket = BIS_WL_vehsInBasket + 1}};

if (_isStatic) exitWith {"close" call BIS_fnc_WLPurchaseMenu; [_class, _cost, _offset] spawn BIS_fnc_WLDefenceSetup};
if (_isAir) exitWith {[_class, _cost, _requirements] call BIS_fnc_WLAircraftArrival};
if (_isNaval) exitWith {"close" call BIS_fnc_WLPurchaseMenu; [_class, _cost] spawn BIS_fnc_WLNavalArrival};

_display = uiNamespace getVariable ["BIS_WL_purchaseMenuDisplay", displayNull];
_purchase_queue = _display displayCtrl 109;
_purchase_items = _display displayCtrl 101;

_i = _purchase_queue lbAdd (_purchase_items lbText lbCurSel _purchase_items);
_purchase_queue lbSetValue [_i, _cost];
if (lbCurSel _purchase_queue == -1) then {
	_purchase_queue lbSetCurSel 0;
};

BIS_WL_dropPool pushBack [_class, _cost, _purchase_items lbText lbCurSel _purchase_items, _category];
call BIS_fnc_WLSubroutine_purchaseMenuRefresh;