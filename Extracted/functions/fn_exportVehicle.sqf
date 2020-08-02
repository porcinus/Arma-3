/*
	Author: Karel Moricky

	Description:
	Export vehicle settings

	Parameter(s):
		0: OBJECT
		1 (Optional):
			OBJECT - object class override. Use "" to skip createVehicle part and set components / textures only

	Returns:
	STRING - SQF code
*/

private ["_center","_centerType","_isCreate","_var","_centerSide","_cfg","_texture","_customization","_animations","_crew","_br","_export","_tab","_fnc_setTabs","_fnc_line"];
_center = _this param [0,player,[objnull]];
_centerType = _this param [1,typeof _center,[""]];
_isCreate = true;
_var = "_veh";
if (_centerType == "") then {
	_centerType = typeof _center;
	_isCreate = false;
	_var = "_this";
};
_centerSide = (_center call bis_fnc_objectSide);
_cfg = configfile >> "cfgvehicles" >> _centerType;

_customization = [_center,_centerType] call bis_fnc_getVehicleCUstomization;
_texture = _customization select 0;
_animations = _customization select 1; 

//--- Read crew
_crew = [];
{
	private ["_role"];
	_role = switch (tolower (_x select 1)) do {
		case "driver": {["driver"];};
		case "cargo": {["cargo",_x select 2];};
		case "gunner";
		case "commander";
		case "turret": {[_x select 1,_x select 3];};
		default {[]};
	};
	_crew pushback ([typeof (_x select 0)] + _role);
} foreach (fullcrew _center);


//--- Export
_br = tostring [13,10];
_export = "";

_tab = "";
_fnc_setTabs = {
	_tab = "";
	for "_t" from 1 to _this do {_tab = _tab + "	";};
};

_fnc_line = {
	_export = _export + _tab + _this + _br;
};
_fnc_lineComma = {
	_export = _export + _tab + _this + ", " + _br;
};
_fnc_lineformat = {
	(format _this) call _fnc_line;
};

//--- Header
0 call _fnc_setTabs;

//--- Create
if (_isCreate) then {["%1 = createVehicle [""%2"",position player,[],0,""NONE""];",_var,_centerType] call _fnc_lineformat;};

if (count _texture > 0 || count _animations > 0) then {
	"[" call _fnc_line;
	1 call _fnc_setTabs;
	format ["%1,",_var] call _fnc_line;

	//--- Set textures
	if (count _texture > 0) then {
		(str _texture) call _fnc_lineComma;
	} else {
		"nil," call _fnc_line;
	};

	//--- Set animations
	if (count _animations > 0) then {
		(str _animations) call _fnc_line;
	} else {
		"true" call _fnc_line;
	};

	0 call _fnc_setTabs;
	"] call BIS_fnc_initVehicle;" call _fnc_line;
};

if (count _crew > 0) then {
	"[" call _fnc_line;
	1 call _fnc_setTabs;

	format ["%1,",_var] call _fnc_line;
	"[" call _fnc_line;
	2 call _fnc_setTabs;

	//--- Set crew
	{
		if (_foreachindex < count _crew - 1) then {
			["%1,",_x] call _fnc_lineformat;
		} else {
			["%1",_x] call _fnc_lineformat;
		};
	} foreach _crew;

	1 call _fnc_setTabs;
	"]" call _fnc_line;

	0 call _fnc_setTabs;
	"] call BIS_fnc_initVehicleCrew;" call _fnc_line;
};
_export