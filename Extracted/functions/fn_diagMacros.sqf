/*
	Author: Karel Moricky

	Description:
	Exports config macros.

	Parameter(s):
		0: CONFIG or ARRAY - config container to be searched (e.g. configFile >> "CfgVehicles") or list of classes or classnames
		1: ARRAY - list of macro names to be used (e.g. ["MAPSIZE","NAMESOUND"])
		2 (Optional): STRING - macro category name (when param 0 is CONFIG, its classname is used by default - e.g. "CfgVehicles")

	Returns:
	STRING
*/

startloadingscreen [""];
_cfg = _this param [0, configFile, [configFile, []]];
_macros = _this param [1, [], [[]]];
_cfgName = _this param [2, "", [""]];
{
	_macros set [_forEachIndex, toUpper _x];
} foreach _macros;

_br = toString [13,10];
_result = "";
_macrosCount = count _macros - 1;
_cfgCount = count _cfg;

if ((_cfgName == "") && (typename _cfg == typename configFile)) then
{
	_cfgName = configName _cfg;
};
_cfgName = toUpper (_cfgName);

_classNamesArray = [];

for "_c" from 0 to (_cfgCount - 1) do
{
	_class = _cfg select _c;
	_class param [0, "", ["", configFile]];

	if ((typename _class == typename "") && {(isClass(configFile >> _cfgName >> _class))}) then
	{
		_classNamesArray pushback _class;
	};

	if ((typename _class == typename configFile) && {(isClass(_class))}) then
	{
		_classNamesArray pushback (configName _class);
	};
};

_classNamesArray = _classNamesArray call BIS_fnc_sortAlphabetically;

{
	_className = _x;

	_classResult = "// " + _className + _br;

	{
		_classMacro = _cfgName + "_" + _x + "_" + _className;
		_classResult = _classResult + "#ifndef " + _classMacro + _br +
		"	#define " + _classMacro + _br +
		"#endif" + _br;
	} foreach _macros;

	_classResult = _classResult + "#define " + _cfgName + "_" + _className + "\" + _br;

	{
		_classMacro = _cfgName + "_" + _x + "_" + _className;
		_classResult = _classResult + "	" + _classMacro + "\" + _br;
	} foreach _macros;
	_result = _result + _classResult + "	_generalMacro = " + str _className + ";" + _br + _br;

	progressloadingscreen ((_forEachIndex * _forEachIndex) / (((_cfgCount - 1) max 1) * ((_cfgCount - 1) max 1)));
} forEach _classNamesArray;

copytoclipboard _result;
endLoadingScreen;
hint "Finished diagMacros";
_result