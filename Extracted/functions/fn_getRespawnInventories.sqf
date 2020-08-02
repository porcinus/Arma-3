/*
	Author: Karel Moricky

	Description:
	Return respawn inventories available for the given unit

	Parameter(s):
		0: OBJECT, GROUP, SIDE or NAMESPACE
		1 (Optional): BOOL - true to show even inventories disabled by curator
		2 (Optional): BOOL - true to return namespace, inventory and role limits (used in the new respawn screen) instead of inventories itself

	Returns:
	ARRAY
*/

private ["_target","_ignoreCuratorBlacklist","_varName","_inventories","_default","_objectInventories","_groupInventories","_sideInventories","_globalInventories","_side"];

_target = _this param [0,player,[objnull,grpnull,sideunknown,missionnamespace]];
_ignoreCuratorBlacklist = _this param [1,false,[false]];
_returnLimits = _this param [2,false,[false]];

_varName = "BIS_fnc_getRespawnInventories_list";
_inventories = [];
_inventoryLimits = [];
_roleLimits = [];
_namespaces = [];

_default = [-1,[],[],[],[]];
_objectInventories = _default;
_groupInventories = _default;
_sideInventories = _default;
_globalInventories = missionnamespace getvariable [_varName,_default];
_side = sideunknown;
_group = grpNull;

switch (typename _target) do {
	case (typename objnull): {
		_side = _target call bis_fnc_objectSide;
		_group = group _target;
		_objectInventories = if (isnull _target) then {_default} else {_target getvariable [_varName,_default]};
		_groupInventories = if (isnull _group) then {_default} else {_group getvariable [_varName,_default]};
		_sideInventories = missionnamespace getvariable [_varName + str _side,_default];
	};
	case (typename grpnull): {
		_side = _target call bis_fnc_objectSide;
		_group = _target;
		_groupInventories = if (isnull _target) then {_default} else {(_target) getvariable [_varName,_default]};
		_sideInventories = missionnamespace getvariable [_varName + str _side,_default];
	};
	case (typename sideunknown): {
		_side = _target;
		_sideInventories = missionnamespace getvariable [_varName + str (_side),_default];
	};
	case (typename missionNamespace): {
	};
};

//--- Combine all available inventories
_i = 0;
{
	_inventories = _inventories + (_x select 2);
	_currentSize = count _inventories;
	
	if (_returnLimits) then {	//handle limits only if requested
		if ((count _x) == 3) then {	//no limits in array, create limits array with -1 (unlimited) items and use it
			_j = count (_x select 2);
			_emptyLimits = [];
			while {_j > 0} do {
				_emptyLimits = _emptyLimits + [-1];
				_j = _j - 1;
			};
			_inventoryLimits = _inventoryLimits + _emptyLimits;
			_roleLimits = _roleLimits + _emptyLimits;
		} else {	//limites defined in array, use it
			_inventoryLimits = _inventoryLimits + (_x select 3);
			_roleLimits = _roleLimits + (_x select 4);
		};
		
		switch (_forEachIndex) do {
			case 0: {while {_currentSize != _i} do {_namespaces = _namespaces + [missionnamespace];_i = _i + 1}};
			case 1: {while {_currentSize != _i} do {_namespaces = _namespaces + [_side];_i = _i + 1}};
			case 2: {while {_currentSize != _i} do {_namespaces = _namespaces + [_group];_i = _i + 1}};
			case 3: {while {_currentSize != _i} do {_namespaces = _namespaces + [_target];_i = _i + 1}};
		}
	};
} foreach [_globalInventories,_sideInventories,_groupInventories,_objectInventories];

//--- Remove empty inventories
if (_returnLimits) then {	//handle limits only if requested
	{if (_x == "") then {_inventoryLimits set [_forEachIndex,""];_roleLimits set [_forEachIndex,""];_namespaces set [_forEachIndex,""]}} forEach _inventories;
	_inventoryLimits = _inventoryLimits - [""];
	_roleLimits = _roleLimits - [""];
	_namespaces = _namespaces - [""];
};
_inventories = _inventories - [""];

//--- Remove duplicates
{
	_item = _x;
	if (({_x == _item} count _inventories) > 1) then {	//duplicated item, set empty string on given position in all arrays (inevntories + limits)
		{
			if (_item == _x) then {
				_inventories set [_forEachIndex, ""];
				_inventoryLimits set [_forEachIndex, ""];
				_roleLimits set [_forEachIndex, ""];
				_namespaces set [_forEachIndex, ""];
			};
		} forEach _inventories;
	};
} forEach _inventories;
_inventories = _inventories - [""];
_inventoryLimits = _inventoryLimits - [""];
_roleLimits = _roleLimits - [""];
_namespaces = _namespaces - [""];

//---Return limits if requested
if (_returnLimits) then {
	_result = [];
	{_result = _result + [[_namespaces select _forEachIndex,_inventoryLimits select _forEachIndex,_roleLimits select _forEachIndex]]} forEach _inventories;
	_inventories = _result;
};
_inventories