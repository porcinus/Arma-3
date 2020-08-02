/*
	Author: 
		Karel Moricky

	Description:
		Return object's magazines as defined in config. Scans also turrets and pylons.
	
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
private _magazines = [];
{
	{
		_magazines pushback configname (configfile >> "CfgMagazines" >> _x);
	} foreach getarray (_x >> "magazines");
} foreach (_class call bis_fnc_getturrets);

//--- Pylons
{
	_magazines pushback configname (configfile >> "CfgMagazines" >> gettext (_x >> "attachment"));
} foreach configproperties [_cfg >> "Components" >> "TransportPylonsComponent" >> "Pylons"];

_magazines - [""]