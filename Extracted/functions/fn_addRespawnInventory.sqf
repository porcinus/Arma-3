/*
	Author: Karel Moricky

	Description:
	Add a respawn loadout

	Parameter(s):
		0:
			NAMESPACE
			SIDE
			GROUP
			OBJECT
		1: STRING - CfgRespawnInventory or CfgVehicles class

	Returns:
	ARRAY in format [target,id] (used in BIS_fnc_removeRespawnInventory)
*/

private ["_targetOrig","_target","_inventory","_varName","_inventoryData"];

_targetOrig = _this param [0,missionnamespace,[missionnamespace,sideunknown,grpnull,objnull]];
_inventoryParam = _this param [1,"",["",[]]];
_inventoryID = _this param [2,-1,[0]];

//--- Getting role/loadout limits
_inventory = "";
_inventoryLimit = -1;
_roleLimit = -1;
if ((typeName _inventoryParam) == (typeName "")) then {
	_inventory = _inventoryParam;
} else {
	_inventory = _inventoryParam param [0,"",[""]];
	_inventoryLimit = _inventoryParam param [1,-1,[0]];
	_roleLimit = _inventoryParam param [2,-1,[0]];
};

//--- Find correct config
if (
	!isclass (missionconfigfile >> "cfgrespawninventory" >> _inventory)
	&&
	!isclass (configfile >> "cfgvehicles" >> _inventory)
	&&
	_inventory != ""
) exitwith {["'%1' not found in CfgRespawnInventory or CfgVehicles",_inventory] call bis_fnc_error; [_targetOrig,-1]};

_varName = "BIS_fnc_getRespawnInventories_list";
_target = _targetOrig;

if (typename _target == typename sideunknown) then {
	_varName = _varName + str _target;
	_target = missionnamespace;
};
_inventories = _target getvariable [_varName,[-1,[],[],[],[]]];
_inventoryIDs = _inventories select 1;
_inventoryData = _inventories select 2;
_inventoryLimits = _inventories select 3;
_roleLimits = _inventories select 4;
if (_inventoryID < 0) then {

	//--- Add
	if !(_inventory in _inventoryData) then {
		_inventoryID = (_inventories select 0) + 1;
		_inventories set [0,_inventoryID];
		_inventoryIDs set [count _inventoryData,_inventoryID];
		_inventoryLimits set [count _inventoryData,_inventoryLimit];
		_roleLimits set [count _inventoryData,_roleLimit];
		_inventoryData set [count _inventoryData,_inventory];
	};
} else {

	//--- Remove
	private ["_inventoryItemID"];
	_inventoryItemID = if (_inventory == "") then {_inventoryIDs find _inventoryID} else {_inventoryData find _inventory};
	if (_inventoryItemID >= 0) then {
		_inventoryIDs set [_inventoryItemID,-2];
		_inventoryData set [_inventoryItemID,-2];
		_inventoryLimits set [_inventoryItemID,-2];
		_roleLimits set [_inventoryItemID,-2];
		_inventoryIDs = _inventoryIDs - [-2];
		_inventoryData = _inventoryData - [-2];
		_inventoryLimits = _inventoryLimits - [-2];
		_roleLimits = _roleLimits - [-2];
		_inventories set [1,_inventoryIDs];
		_inventories set [2,_inventoryData];
		_inventories set [3,_inventoryLimits];
		_inventories set [4,_roleLimits];
	};
};

//--- Commit
switch (typename _target) do {
	case (typename missionnamespace);
	case (typename sideunknown): {
		_target setvariable [_varName,_inventories];
		publicvariable _varName;
	};
	case (typename grpnull);
	case (typename objnull): {
		_target setvariable [_varName,_inventories,true];
	};
};

[_targetOrig,_inventoryID]