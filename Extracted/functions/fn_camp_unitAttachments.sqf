/*
	Author: Jiri Wainar

	Example:
	[[_attachment1class:string,attachment1count:number],...] = [player] call BIS_fnc_camp_unitAttachments;
*/

private["_unit","_output","_type","_data"];

_unit 	= [_this, 0, objNull, ["",objNull]] call bis_fnc_param;
_output = [];

if (typeName _unit == typeName "") then
{
	_unit = missionNamespace getVariable [_unit, objNull];
};

//add loose attachments (sitting in inventory)
{
	_type = _x call BIS_fnc_camp_getEquipType;

	if (_type == "attachment") then
	{
		_output set [count _output, toLower _x];
	};
}
forEach (items _unit);

//add attachments on weapons
{
	_data = _x;

	{
		if (_forEachIndex > 0 && {typeName _x == typeName ""} && {_x != ""}) then
		{
			_output set [count _output, toLower _x];
		};
	}
	forEach _data;
}
forEach (weaponsItems _unit);

//remove empty strings caused by non-existant attachments
_output = _output - [""];

//consolidate array
_output = _output call BIS_fnc_consolidateArray;

_output