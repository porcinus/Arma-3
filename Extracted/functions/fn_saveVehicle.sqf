/*
	Author: Karel Moricky

	Description:
	Save vehicle's params (textures, animations, crew)

	Parameter(s):
		0: OBJECT - saved vehicle
		1: ARRAY in format
			0: NAMESPACE or GROUP or OBJECT - target in which namespace the loadout will be saved
			1: STRING - name
		2 (Optional): ARRAY - custom params to be saved along the params (default: [])
		3 (Optional): BOOL - true to delete the save (default: false)

	Returns:
	ARRAY - saved value
*/

private ["_center","_path","_custom","_delete","_namespace","_name"];
_center = _this param [0,player,[objnull]];
_path = _this param [1,[],[[]]];
_custom = _this param [2,[],[[]]];
_delete = _this param [3,false,[false]];

_namespace = _path param [0,missionnamespace,[missionnamespace,grpnull,objnull]];
_name = _path param [1,"",[""]];

//--- Get current values
private ["_animations","_crew","_export"];
_animations = [];
{
	_anim = configname _x;
	_animations pushback [_anim,_center animationphase _anim];
} foreach (configProperties [configfile >> "CfgVehicles" >> typeof _center >> "animationSources","isclass _x",true]);
_crew = [];
{
	_member = _x select 0;
	_role = _x select 1;
	_index = if (_role == "turret") then {_x select 3} else {_x select 2};
	_crew pushback [typeof _member,_role,_index];
} foreach fullcrew _center;

_export = [
	/* 00 */	typeof _center,
	/* 01 */	_animations,
	/* 02 */	getobjecttextures _center,
	/* 03 */	_crew,
	/* 04 */	_custom
];

//--- Store
private ["_data","_nameID"];
_data = _namespace getvariable ["bis_fnc_saveVehicle_data",[]];
_nameID = _data find _name;
if (_delete) then {
	if (_nameID >= 0) then {
		_data set [_nameID,objnull];
		_data set [_nameID + 1,objnull];
		_data = _data - [objnull];
	};
} else {
	if (_nameID < 0) then {
		_nameID = count _data;
		_data set [_nameID,_name];
	};
	_data set [_nameID + 1,_export];
};
_namespace setvariable ["bis_fnc_saveVehicle_data",_data];
profilenamespace setvariable ["bis_fnc_saveVehicle_profile",true];
if !(isnil {profilenamespace getvariable "bis_fnc_saveVehicle_profile"}) then {saveprofilenamespace};

_export