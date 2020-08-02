/*
	Author: 
		Karel Moricky, optimised by Killzone_Kid

	Description:
		Returns IDC of given control inside given display config

	Parameter(s):
		0: CONFIG - config path to display
		1: STRING - control name

	Returns:
		NUMBER - IDC
*/

scopeName "main";

params 
[
	["_base", configFile, [configNull]], 
	["_control", "", [""]],
	"_cfgIDC"
];

private _fnc_findIDC = 
{
	{
		_cfgIDC = _x >> _control >> "idc";
		
		comment"//--- check direct match";
		if (!isNull _cfgIDC) then {getNumber _cfgIDC breakOut "main"};

		comment"//--- check if control is in controls group";
		{_x call _fnc_findIDC} forEach configProperties [_x, "isClass _x && {getNumber (_x >> 'type') isEqualTo 15}", true];
	}
	forEach [_this, _this >> "controls", _this >> "controlsBackground"];
};

_base call _fnc_findIDC;

0 