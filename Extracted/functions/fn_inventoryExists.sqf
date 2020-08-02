/*
	Author: Nelson Duarte

	Description:
	Check if loadout with given name exists

	Parameter(s):
		0: NAMESPACE or GROUP or OBJECT - target in which namespace the loadout will be saved
		1: STRING - loadout name

	Returns:
	BOOL - True if existent, false if not
*/

private ["_namespace", "_name"];
_namespace 	= _this param [0, missionNamespace, [missionnamespace,grpnull,objnull]];
_name 		= _this param [1, "", [""]];

private ["_data","_nameID"];
_data 	= _namespace getvariable ["bis_fnc_saveInventory_data",[]];
_nameID = _data find _name;

if (_nameID >= 0) then
{
	true;
}
else
{
	false;
};