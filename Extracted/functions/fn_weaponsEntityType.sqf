/*
	Author: 
		Karel Moricky

	Description:
		Return object's weapons as defined in config. Scans also turrets and pylons.
	
	Parameter(s):
		0: STRING - object class
	
	Returns:
		ARRAY of STRINGs
*/

params [
	["_class","",[""]]
];
private _cfg = configfile >> "CfgVehicles" >> _class;

//--- Not a valid class
if !(isclass _cfg) exitwith {["Class %1 not found in CfgVehicles",_class] call bis_fnc_error;};

//--- Vehicle and turrets
private _weapons = [];
{
	{
		_weapons pushbackunique configname (configfile >> "CfgWeapons" >> _x);
	} foreach getarray (_x >> "weapons");
} foreach (_class call bis_fnc_getturrets);

//--- Pylons
{
	_weapons pushbackunique configname (configfile >> "CfgWeapons" >> gettext (configfile >> "CfgMagazines" >> gettext (_x >> "attachment") >> "pylonWeapon"));
} foreach configproperties [_cfg >> "Components" >> "TransportPylonsComponent" >> "Pylons"];

_weapons - [""]