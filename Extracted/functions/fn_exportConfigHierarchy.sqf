/*
	Author: Karel Moricky

	Description:


	Parameter(s):
		0: CONFIG - config path
		1 (Optional): STRING - topmost class

	Examples:
		// Export config hierarchy of all weapons
		[configFile >> "CfgWeapons"] call BIS_fnc_exportConfigHierarchy

		// Export config hierarchy of all classes inherited from class LandVehicle
		[configFile >> "CfgVehicles","LandVehicle"] call BIS_fnc_exportConfigHierarchy

	Returns:
	STRIGN - exported text
*/


#define ID_CFG		0
#define ID_WIDTH	1
#define ID_CHILDREN	2

startloadingscreen [""];
_cfg = param [0,configfile >> "CfgVehicles",[confignull]];
_cfgParent = _cfg >> param [1,"",[""]];

_cfgClasses = "isclass _x" configclasses _cfg;
_cfgCount = count _cfgClasses;

//--- Create hierarchy
_paths = [];
_data = [];
{
	_parentData = _data;
	_parentPath = [];
	_parent = inheritsfrom _x;
	if (isclass _parent) then {
		_parentID = _cfgClasses find _parent;
		if (_parentID < count _paths) then {
			_parentPath = _paths select _parentID;
			{
				_parentData = (_parentData select _x) select ID_CHILDREN;
			} foreach _parentPath;
		} else {
			["Class %1 not registered yet!",configname _parent] call bis_fnc_error;
		};
	};
	_paths set [_foreachindex,_parentPath + [count _parentData]];
	_parentData append [[_x,0,[]]];

	progressloadingscreen (_foreachindex / _cfgCount);
} foreach _cfgClasses;

//--- Calculate width and depth of each item
_data = [confignull,0,_data];
_fnc_getWidth = {
	private _width = _this select ID_WIDTH;
	{
		_width = _width + (_x call _fnc_getWidth);
	} foreach (_this select ID_CHILDREN);
	_width = _width max 1;
	_this set [ID_WIDTH,_width];
	_width
};
_data call _fnc_getWidth;

//--- Output init
_text = "";
_br = tostring [13,10];
_canWrite = !isclass _cfgParent;
_fnc_addLine = {
	_text = _text + _this + _br;
};

_fnc_writeItems = {
	private _input = _this select 0;
	private _depth = _this select 1;
	private _canWrite = _this select 2;

	private _class = _input select ID_CFG;
	_canWrite = _canWrite || (_class == _cfgParent);
	private _width = _input select ID_WIDTH;
	private _children = _input select ID_CHILDREN;

	_cfgScope = _class >> "scope";
	_color = if (isnumber _cfgScope) then {
		switch getnumber _cfgScope do {
			case 0: {"#ffcccc"};
			case 1: {"#cccccc"};
			default {"#eeeeee"};
		};
	} else {
		"#eeeeee"
	};

	if (_canWrite) then {
		format [
			"| rowspan=""%1"" style=""background-color:%4;"" | <span title=""%3"" style=""font-family:Lucida Console,monospace;"">%2</span>",
			_width,
			configname _class,
			gettext(_class >> "displayName"),
			_color//,
			//if (getnumber _cfgScope == 2) then {format ["<br/>[[File:Arma3 CfgVehicles %1.jpg|200px]]",configname _class]} else {""}
		] call _fnc_addLine;
		if (count _children == 0) then {"|-" call _fnc_addLine};
	};

	//--- We need to go deeper!
	{
		[_x,_depth + 1,_canWrite] call _fnc_writeItems;
	} foreach _children;
};


"{| class=""wikitable""" call _fnc_addLine;
[_data,0,_canWrite] call _fnc_writeItems;
"|}" call _fnc_addLine;

copytoclipboard _text;

endloadingscreen;
_text
