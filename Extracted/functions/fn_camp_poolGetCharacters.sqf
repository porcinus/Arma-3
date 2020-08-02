/*

	Author: Jiri Wainar

	Description:
	Function uses 'BIS_fnc_camp_poolGetCharacter' to get equipment of single units and applies it on array of units. Returned value is array with equipment of all given units.

	The array has this structure: [_weapons,_attachments,_magazines,_items,_uniforms,_vests,_backpacks,_headgears,_goggles]

	Example:
	[player,"bis_inf"] call BIS_fnc_camp_poolGetCharacters;

*/

private["_units","_unit","_unitGear","_allGear","_type","_typeIndex","_unitData","_allData"];

_allGear = [[],[],[],[],[],[],[],[],[]];

if (typeName _this != typeName []) exitWith {_allGear};

{
	_unit = _x;
	_unitGear = [_unit] call BIS_fnc_camp_poolGetCharacter;

	{
		_type		= _x;
		_typeIndex	= _forEachIndex;
		_unitData	= _unitGear select _typeIndex;
		_allData	= _allGear select _typeIndex;

		{
			[_allData,_x select 0,_x select 1] call BIS_fnc_addToPairs;
		}
		forEach _unitData;
	}
	forEach ["weapon","attachment","magazine","item","uniform","vest","backpack","headgear","goggles"];
}
forEach _this;

_allGear