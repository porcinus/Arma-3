/*
	Author: 
		Karel Moricky, modified by Killzone_Kid

	Description:
		Export unit's loadout

	Parameter(s):
		0: OBJECT - unit of which loadout will be export
		1: STRING - export type
			"script" - scripting commands, target is referred to as _unit
			"init" - scripting commands, target is referred to as this
			"config" - CfgVehicles attributes
		2: BOOL - true to export identity (face, voice and insignia, if set)

	Returns:
		STRING - SQF code or config text depending on the export type argument
*/

params 
[
	["_center", player, [objnull]],
	["_type", "script", [""]],
	["_identity", true, [true]]
];

private _fnc_addComment = 
{
	_export = _export + endl;
	_export = _export + (if (_type isEqualTo "init") then { format ["comment %1;", str _this] } else { format ["// %1", _this] });
	_export = _export + endl;
};

private _export = "";

//--- Arsenal label
if !(isnil {uinamespace getvariable "BIS_fnc_arsenal_display"}) then 
{
	format ["Exported from Arsenal by %1", profilename] call _fnc_addComment;
};

switch _type do 
{
	case "script";
	case "init": 
	{
		private _fnc_addMultiple = 
		{
			params ["_items", "_expression"];
			
			private _countItems = count _items;
			while { _countItems > 0 } do
			{
				private _item = _items select 0;
				_items = _items - [_item];

				_countItems = count _items call 
				{
					private _itemCount = _countItems - _this;
					_export = _export + format [if (_itemCount > 1) then {format ["for ""_i"" from 1 to %1 do {%2};", _itemCount, _expression] } else { _expression }, _var, str _item] + endl;
					_this
				};
			};
		};

		"[!] UNIT MUST BE LOCAL [!]" call _fnc_addComment;
		
		private _var = if (_type isEqualTo "script") then { _export = _export + "_unit = player;" + endl; "_unit" } else { "this" };
		if (_type isEqualTo "init") then { _export = _export + format ["if (!local %1) exitWith {};",_var] + endl };
		
		"Remove existing items" call _fnc_addComment;
		
		_export = _export + format ["removeAllWeapons %1;", _var] + endl;
		_export = _export + format ["removeAllItems %1;", _var] + endl;
		_export = _export + format ["removeAllAssignedItems %1;", _var] + endl;
		_export = _export + format ["removeUniform %1;", _var] + endl;
		_export = _export + format ["removeVest %1;", _var] + endl;
		_export = _export + format ["removeBackpack %1;", _var] + endl;
		_export = _export + format ["removeHeadgear %1;", _var] + endl;
		_export = _export + format ["removeGoggles %1;", _var] + endl;

		//-- Weapons
		if (primaryWeapon _center != "" || secondaryWeapon _center != "" || handgunWeapon _center != "") then
		{
			"Add weapons" call _fnc_addComment;
			{
				_x params ["_weapon", "_command"];
				
				if (_weapon != "") then 
				{
					_export = _export + format ["%1 addWeapon %2;", _var, str _weapon] + endl;
					private _weaponItems = weaponsItems _center select { _x select 0 == _weapon } param [0, []] apply { _x param [0, ""] };
					{ if (_x != "") then { _export = _export + format ["%1 %2 %3;", _var, _command, str _x] + endl } } forEach (_weaponItems select [1, count _weaponItems - 1]);
				};
			}
			forEach 
			[
				[primaryWeapon _center, "addPrimaryWeaponItem"], 
				[secondaryWeapon _center, "addSecondaryWeaponItem"],
				[handgunWeapon _center, "addHandgunItem"] 
			];
		};
		
		private _hasUniform = uniform _center != "";
		private _hasVest = vest _center != "";
		private _hasBackpack = backpack _center != "";
		private _bareUnit = !_hasUniform && !_hasVest && !_hasBackpack;
		private _useTempUniform = false;
		
		//-- Containers add
		if (!_bareUnit) then 
		{ 
			"Add containers" call _fnc_addComment;
			if (_hasUniform) then { _export = _export + format ["%1 forceAddUniform %2;",_var, str uniform _center] + endl };
			if (_hasVest) then { _export = _export + format ["%1 addVest %2;", _var, str vest _center] + endl };
			if (_hasBackpack) then { _export = _export + format ["%1 addBackpack %2;", _var, str backpack _center] + endl };
		};
		
		private _binocs = binocular _center;
		if (_binocs != "") then
		{
			"Add binoculars" call _fnc_addComment;
			private _battery = weaponsItems _center select {_x select 0 == _binocs} param [0, []] param [4, []] param [0, ""];
			if (_battery != "") then
			{
				_useTempUniform = _bareUnit;
				if (_useTempUniform) then { _export = _export + format ["%1 forceAddUniform %2;",_var, str getText (configFile >> "CfgVehicles" >> "C_man_1" >> "uniformClass")] + endl };
				_export = _export + format ["%1 addMagazine %2;", _var, str _battery] + endl;
			};
			_export = _export + format ["%1 addWeapon %2;", _var, str _binocs] + endl;
			if (_useTempUniform) then { _export = _export + format ["removeUniform %1;", _var] + endl };
		};
		
		//-- Containers fill
		if (!_bareUnit && { count uniformitems _center > 0 || count vestitems _center > 0 || count backpackitems _center > 0 }) then 
		{ 
			"Add items to containers" call _fnc_addComment;
			if (_hasUniform) then { [uniformitems _center, "%1 addItemToUniform %2;"] call _fnc_addMultiple };
			if (_hasVest) then { [vestitems _center, "%1 addItemToVest %2;"] call _fnc_addMultiple };
			if (_hasBackpack) then { [backpackitems _center, "%1 addItemToBackpack %2;"] call _fnc_addMultiple };
		};
		
		if (headgear _center != "") then {_export = _export + format ["%1 addHeadgear %2;", _var, str headgear _center] + endl;};
		if (goggles _center != "") then {_export = _export + format ["%1 addGoggles %2;", _var, str goggles _center] + endl;};

		//--- Items	
		private _assignedItems = assigneditems _center - [binocular _center];
		if (count _assignedItems > 0) then
		{
			"Add items" call _fnc_addComment;
			[_assignedItems,"%1 linkItem %2;"] call _fnc_addMultiple;
		};

		//-- Identity
		if (_identity) then {
			"Set identity" call _fnc_addComment;
			_export = _export + format ["[%1,%2,%3] call BIS_fnc_setIdentity;", _var, str face _center, str speaker _center] + endl;
			_insignia = _center call bis_fnc_getUnitInsignia;
			if (_insignia != "") then { _export = _export + format ["[%1,%2] call BIS_fnc_setUnitInsignia;", _var, str _insignia] + endl };
		};
	};
	
	case "config": 
	{
		private _fnc_addArray = 
		{
			params ["_name", "_array"];
			
			_export = _export + format ["%1[] = {",_name];
			
			{
				if (_foreachindex > 0) then {_export = _export + ","};
				_export = _export + format ["""%1""",_x];
			} 
			foreach _array;
			
			_export = _export + "};" + endl;
		};

		_export = _export + format ["uniformClass = %1;", str uniform _center] + endl;
		_export = _export + format ["backpack = %1;", str backpack _center] + endl;

		private _weapons = [];
		private _weaponsMagazines = [];
		private _linkedItems = [];
		
		{
			_weapons pushback (_x select 0);
			{
				if (_x isEqualTypeParams ["",0]) then 
				{
					_weaponsMagazines pushBack (_x select 0);
				};
			}
			forEach _x;
		} 
		forEach weaponsItems _center;
		
		{
			if (_x != "") then { _linkedItems pushback _x };
		} 
		forEach [vest _center, headgear _center, goggles _center];
		
		["weapons", _weapons + ["Throw", "Put"]] call _fnc_addArray;
		["magazines", _weaponsMagazines + magazines _center] call _fnc_addArray;
		["items", items _center] call _fnc_addArray;
		["linkedItems", _linkedItems + assigneditems _center - weapons _center] call _fnc_addArray;
	};
};

//--- Export to clipboard
copytoclipboard _export;

_export 