/*
	Author: Karel Moricky

	Description:
	Return base vehicle (i.e., vehicle which is not jsut derivative of other with different texturesd / animations)
	
	Parameter(s):
		0: STRING - vehicle class
	
	Returns:
	STRING - vehicle class
*/

private ["_class","_cfg"];
_class = _this param [0,"",[""]];

//--- Incorrect vehilce class - terminate
_cfg = configfile >> "cfgvehicles" >> _class;
if !(isclass _cfg) exitwith {
	if (_class != "") then {["Class '%1' not found in CfgVehicles",_class] call bis_fnc_error};
	_class
};

//--- Get manual base vehicle
private ["_base"];
_base = gettext (_cfg >> "baseVehicle");
if (isclass (configfile >> "cfgvehicles" >> _base)) exitwith {_base};

//--- Get first parent without any attachments
private ["_return","_model"];
_return = _class;
_model = gettext (configfile >> "cfgvehicles" >> _class >> "model");
{
	if (gettext (_x >> "model") == _model && getnumber (_x >> "scope") == 2) then {_return = configname _x;};
} foreach (_cfg call bis_Fnc_returnparents);
_return