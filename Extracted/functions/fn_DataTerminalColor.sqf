private ["_dataTerminal", "_color1", "_color2", "_color3"];

_dataTerminal = [_this, 0, objNull, [objNull]] call BIS_fnc_param;
_color1 = [_this, 1, "undefined", ["string"]] call BIS_fnc_param;
_color2 = [_this, 2, "undefined", ["string"]] call BIS_fnc_param;
_color3 = [_this, 3, "undefined", ["string"]] call BIS_fnc_param;

if (isNull(_dataTerminal)) then
{
	false
}
else
{
	switch (toLower _color1) do
	{
		case "blue":	{_dataTerminal setObjectTextureGlobal [2, "#(argb,8,8,3)color(0,1,1,1.0,co)"];			_dataTerminal setObjectMaterialGlobal [2, "\A3\Props_F_Exp_A\Military\Equipment\Data\DataTerminal_blue.rvmat"];};
		case "orange":	{_dataTerminal setObjectTextureGlobal [2, "#(argb,8,8,3)color(0.75,0.5,0,1.0,co)"];		_dataTerminal setObjectMaterialGlobal [2, "\A3\Props_F_Exp_A\Military\Equipment\Data\DataTerminal_orange.rvmat"];};
		case "green":	{_dataTerminal setObjectTextureGlobal [2, "#(argb,8,8,3)color(0.25,0.75,0.25,1.0,co)"];	_dataTerminal setObjectMaterialGlobal [2, "\A3\Props_F_Exp_A\Military\Equipment\Data\DataTerminal_green.rvmat"];};
		case "red":		{_dataTerminal setObjectTextureGlobal [2, "#(argb,8,8,3)color(1,0.15,0.05,1.0,co)"];	_dataTerminal setObjectMaterialGlobal [2, "\A3\Props_F_Exp_A\Military\Equipment\Data\DataTerminal_red.rvmat"];};
		case "purple":	{_dataTerminal setObjectTextureGlobal [2, "#(argb,8,8,3)color(1,0.125,1,1.0,co)"];		_dataTerminal setObjectMaterialGlobal [2, "\A3\Props_F_Exp_A\Military\Equipment\Data\DataTerminal_purple.rvmat"];};
	};

	switch (toLower _color2) do
	{
		case "blue":	{_dataTerminal setObjectTextureGlobal [3, "#(argb,8,8,3)color(0,1,1,1.0,co)"];			_dataTerminal setObjectMaterialGlobal [3, "\A3\Props_F_Exp_A\Military\Equipment\Data\DataTerminal_blue.rvmat"];};
		case "orange":	{_dataTerminal setObjectTextureGlobal [3, "#(argb,8,8,3)color(0.75,0.5,0,1.0,co)"];		_dataTerminal setObjectMaterialGlobal [3, "\A3\Props_F_Exp_A\Military\Equipment\Data\DataTerminal_orange.rvmat"];};
		case "green":	{_dataTerminal setObjectTextureGlobal [3, "#(argb,8,8,3)color(0.25,0.75,0.25,1.0,co)"];	_dataTerminal setObjectMaterialGlobal [3, "\A3\Props_F_Exp_A\Military\Equipment\Data\DataTerminal_green.rvmat"];};
		case "red":		{_dataTerminal setObjectTextureGlobal [3, "#(argb,8,8,3)color(1,0.15,0.05,1.0,co)"];	_dataTerminal setObjectMaterialGlobal [3, "\A3\Props_F_Exp_A\Military\Equipment\Data\DataTerminal_red.rvmat"];};
		case "purple":	{_dataTerminal setObjectTextureGlobal [3, "#(argb,8,8,3)color(1,0.125,1,1.0,co)"];		_dataTerminal setObjectMaterialGlobal [3, "\A3\Props_F_Exp_A\Military\Equipment\Data\DataTerminal_purple.rvmat"];};
	};

	switch (toLower _color3) do
	{
		case "blue":	{_dataTerminal setObjectTextureGlobal [4, "#(argb,8,8,3)color(0,1,1,1.0,co)"];			_dataTerminal setObjectMaterialGlobal [4, "\A3\Props_F_Exp_A\Military\Equipment\Data\DataTerminal_blue.rvmat"];};
		case "orange":	{_dataTerminal setObjectTextureGlobal [4, "#(argb,8,8,3)color(0.75,0.5,0,1.0,co)"];		_dataTerminal setObjectMaterialGlobal [4, "\A3\Props_F_Exp_A\Military\Equipment\Data\DataTerminal_orange.rvmat"];};
		case "green":	{_dataTerminal setObjectTextureGlobal [4, "#(argb,8,8,3)color(0.25,0.75,0.25,1.0,co)"];	_dataTerminal setObjectMaterialGlobal [4, "\A3\Props_F_Exp_A\Military\Equipment\Data\DataTerminal_green.rvmat"];};
		case "red":		{_dataTerminal setObjectTextureGlobal [4, "#(argb,8,8,3)color(1,0.15,0.05,1.0,co)"];	_dataTerminal setObjectMaterialGlobal [4, "\A3\Props_F_Exp_A\Military\Equipment\Data\DataTerminal_red.rvmat"];};
		case "purple":	{_dataTerminal setObjectTextureGlobal [4, "#(argb,8,8,3)color(1,0.125,1,1.0,co)"];		_dataTerminal setObjectMaterialGlobal [4, "\A3\Props_F_Exp_A\Military\Equipment\Data\DataTerminal_purple.rvmat"];};
	};

	true
};