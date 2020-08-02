/*
	Author: Jiri Wainar

	Description:
	Returns a consolidated array with all container's attachments (attachments mounted on weapons included).

	Example:
	[[_item1class:string,_item1count:number],...] = [_container:object] call BIS_fnc_camp_containerAttachments;
*/

private["_container"];

_container = [_this, 0, objNull, ["",objNull]] call bis_fnc_param;

if (typeName _container == typeName "") then
{
	_container = missionNamespace getVariable [_container, objNull];
};
if (isNull _container) exitWith
{
	["[x] Container is null!"] call BIS_fnc_logFormat;
};

//reformat cargo content to pair array
private["_content","_pairs","_classes","_counts","_type"];

_content = getItemCargo _container;
_pairs   = [];
_classes = _content select 0;
_counts  = _content select 1;

{
	_type = _x call BIS_fnc_camp_getEquipType;

	if (_type == "attachment") then
	{
		_pairs set [count _pairs,[toLower _x,_counts select _forEachIndex]];
	};
}
forEach _classes;

//add attachments on weapons
private["_class","_data"];

{
	_data = _x;

	{
		if (_forEachIndex > 0 && {typeName _x == typeName ""} && {_x != ""}) then
		{
			_pairs = [_pairs,toLower _x,1] call BIS_fnc_addToPairs;
		};
	}
	forEach _data;
}
forEach (weaponsItemsCargo _container);

_pairs