/*
	Author: 
		Killzone_Kid

	Description:
		Returns true if object or a group contains given item in inventory / cargo storage.
		NOTE: This function performs a deep search of inventory / cargo storage, thus is not suitable for per-frame execution.

	Parameter(s):
		0: OBJECT or GROUP - unit, vehicle, cargo container or a group
		1: STRING - item to find
		2: BOOLEAN (Optional) - true to search vehicle crew as well if object is a vehicle. Default - false

	Returns:
		BOOLEAN - true if object has item

	Examples:
		[player, "ItemMap"] call BIS_fnc_hasItem; 
		[group player, "ItemMap"] call BIS_fnc_hasItem; 
		[tank, "FirstAidKit", true] call BIS_fnc_hasItem;
*/

params 
[
	["_object", objNull, [objNull, grpNull]], 
	["_item", "", [""]],
	["_includeCrew", false, [true]]
];

private _fnc_findItem = { _this findIf { _x isEqualType "" && { _x == _item } || { _x isEqualType [] && { _x call _fnc_findItem } } } > -1 };

private _fnc_searchContainer = 
{	
	private _found = 
	{
		private _container = _x select 1;
		
		if (_container call _fnc_searchContainer) exitWith { true };
		if (getItemCargo _container select 0 call _fnc_findItem) exitWith { true };
		if (magazinesAmmoCargo _container call _fnc_findItem) exitWith { true };
		if (weaponsItemsCargo _container call _fnc_findItem) exitWith { true };
		
		false
	}
	forEach everyContainer _this;
	
	[false, _found] select !isNil "_found"
};

if (_object isEqualType grpNull) exitWith { units _object findIf { getUnitLoadout _x call _fnc_findItem } > -1 }; 
if (_object isKindOf "Man") exitWith { getUnitLoadout _object call _fnc_findItem };
_object call _fnc_searchContainer || { _includeCrew && { crew _object findIf { getUnitLoadout _x call _fnc_findItem } > -1 } }