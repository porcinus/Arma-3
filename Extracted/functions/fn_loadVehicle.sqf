/*
	Author: Karel Moricky

	Description:
	Load vehicle look

	Parameter(s):
		0: OBJECT - object which will receive the params
		1: ARRAY in format [NAMESPACE or GROUP or OBJECT,STRING] - params saved using BIS_fnc_saveVehicle

	Returns:
	BOOL
*/

private ["_object","_input","_namespace","_name","_data","_nameID"];
_object = _this param [0,objnull,[objnull]];
_input = _this param [1,[],[[]]];
_namespace = _input param [0,missionnamespace,[missionnamespace,grpnull,objnull]];
_name = _input param [1,"",[""]];
_data = _namespace getvariable ["bis_fnc_saveVehicle_data",[]];
_nameID = _data find _name;
if (_nameID >= 0) then {
	private ["_params"];
	_params = +(_data select (_nameID + 1));
	if (typeof _object == (_params select 0)) then {
		{_x set [2,true]; _object animate _x; _object animateDoor _x;} foreach (_params select 1);
		{_object setobjecttexture [_foreachindex,_x];} foreach (_params select 2);
		[_object,(_params select 3),true] call bis_fnc_initVehicleCrew;
		true
	} else {
		["Vehicle params '%1' require vehicle class '%2', is '%3'",_name,_params select 0,typeof _object] call bis_fnc_error;
		false
	};
} else {
	["Vehicle params '%1' not found",_name] call bis_fnc_error;
	false
};