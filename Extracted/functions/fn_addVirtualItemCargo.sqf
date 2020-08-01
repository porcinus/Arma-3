/*
	Author: 
		Karel Moricky, modified by Killzone_Kid

	Description:
		Add virtual items to an object (e.g., ammo box).
		Virtual items can be selected in the Arsenal.

	Parameter(s):
		0: OBJECT - object to which items will be added
		1: STRING or ARRAY of STRINGs - item class(es) to be added
		2: (Optional): BOOL - true to add items globally (default: false)
		3: (Optional): BOOL - true to add Arsenal action (default: true)
		4: (Optional Internal): NUMBER - action: 1 add items, 0 return current content, -1 remove items (default: 1)
		5: (Optional Internal): NUMBER - type of cargo: 0 - item cargo, 1 - weapon cargo, 2 - magazine cargo, 3 - backpack cargo (default: 0)

	Returns:
		ARRAY of ARRAYs - all virtual items within the object's space in format [<items>,<weapons>,<magazines>,<backpacks>]
*/

params
[
	["_object", missionnamespace,[missionnamespace,objnull]],
	["_classes",[],["",true,[]]],
	["_isGlobal",false,[false]],
	["_initAction",true,[true]],
	["_add",1,[1]],
	["_type",0,[0]]
];

//--- Get cargo list
private _cargo = _object getvariable ["bis_addVirtualWeaponCargo_cargo",[[],[],[],[]]];
private _cargoArray = _cargo select _type;

if (_add == 0) exitwith { _cargoArray };

//--- Modify cargo list
private _save = false;

if !(_classes isEqualType []) then {_classes = [_classes]};

if (count _classes == 0 && _add < 0) then 
{
	_cargoArray = [];
	_save = true;
} 
else 
{
	{
		//--- Use config classnames (conditions are case sensitive)
		_x = _x param [0,"",["",true]];
		
		if (_x isEqualType true) then { _x = "%ALL" } else { if (_x == "%all") then { _x = "%ALL" } }; // force upper case for %ALL as well
		
		private _class = switch _type do 
		{
			case 0;
			case 1: { configname (configfile >> "cfgweapons" >> _x) };
			case 2: { configname (configfile >> "cfgmagazines" >> _x) };
			case 3: { configname (configfile >> "cfgvehicles" >> _x) };
			default { "" };
		};
		
		if (_class == "") then { _class = _x };
		
		if (_add > 0) then 
		{
			if (_class != "") then { _cargoArray pushBackUnique _class };
		} 
		else 
		{
			_cargoArray = _cargoArray - [_class];
		};
		
		_save = true;
	} 
	foreach _classes;
};

_cargo set [_type, _cargoArray];

if (_save) then { _object setvariable ["bis_addVirtualWeaponCargo_cargo",_cargo,_isGlobal] };

if (!is3DEN && _initAction && _object isEqualType objnull) then 
{
	[["AmmoboxExit", "AmmoboxInit"] select ({ count _x > 0 } count _cargo > 0), _object] call bis_fnc_arsenal;
};

_cargoArray 