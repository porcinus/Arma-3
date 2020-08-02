/*
	Author: 
		Karel Moricky, optimised by Killzone_Kid

	Description:
		Register RSC layer.

	Parameter(s):
		_this select 0: STRING - layer name. Parent function name is used automatically when param is nil.

	Returns:
		NUMBER
*/

scopeName "function";

params [["_layer", ""]];
	
/// --- validate input
#include "..\paramsCheck.inc"
paramsCheck(_layer,isEqualType,"")	

if (_layer isEqualTo "") then 
{
	if (_fnc_scriptNameParent isEqualTo _fnc_scriptName) then 
	{
		"RSC Layer name cannot be empty string" call BIS_fnc_error;
		-1 breakOut "function";
	};
	
	_layer = _fnc_scriptNameParent;
};

private _id = allCutLayers find _layer;
if (_id < 0) exitWith {_layer cutFadeOut 0};

_id