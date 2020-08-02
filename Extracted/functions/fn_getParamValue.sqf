/*
	Author: Karel Moricky, optimised by Killzone_Kid

	Description:
	Return value of mission param defined in Description.ext

	Parameter(s):
		0: STRING - param class
		1 (Optional): NUMBER - default value used when the param is not found

	Returns:
	NUMBER
*/

params [["_param", -1], ["_default", 0]];
if !([_param, _default] isEqualTypeParams ["", 0]) exitWith {0};

private _value = _param call (missionNamespace getVariable ["BIS_fnc_storeParamsValues_data", {}]);
if (isNil "_value") exitWith {if (_this isEqualType [] && {_this isEqualTypeArray ["", nil]}) then {nil} else {_default}};

_value