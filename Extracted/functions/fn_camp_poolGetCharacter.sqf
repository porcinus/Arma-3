/*

	Author: Jiri Wainar

	Description:
	Function returns all equipment on given unit. The array has this structure: [_weapons,_attachments,_magazines,_items,_uniforms,_vests,_backpacks,_headgears,_goggles]

	Example:
	[player] call BIS_fnc_camp_poolGetCharacter;

*/

private["_unit","_weapons","_attachments","_magazines","_vehicle","_items","_uniforms","_vests","_backpacks","_headgears","_goggles"];

_unit = [_this, 0, objNull, [objNull,""]] call bis_fnc_param;

if (typeName _unit == typeName "") then
{
	_unit = missionNamespace getVariable [_unit,objNull];
};

if (isNull _unit) exitWith {[[],[],[],[],[],[],[],[],[]]};

//get unit equipment
_weapons 	= [_unit] call BIS_fnc_camp_unitWeapons;
_attachments 	= [_unit] call BIS_fnc_camp_unitAttachments;
_magazines 	= [_unit] call BIS_fnc_camp_unitMagazines;

_items		= [_unit] call BIS_fnc_camp_unitItems;
_uniforms	= [_unit,"uniform"] call BIS_fnc_camp_unitOutfit;
_vests		= [_unit,"vest"] call BIS_fnc_camp_unitOutfit;
_backpacks	= [_unit,"backpack"] call BIS_fnc_camp_unitOutfit;
_headgears	= [_unit,"headgear"] call BIS_fnc_camp_unitOutfit;
_goggles	= [_unit,"goggles"] call BIS_fnc_camp_unitOutfit;

[_weapons,_attachments,_magazines,_items,_uniforms,_vests,_backpacks,_headgears,_goggles]