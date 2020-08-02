/*
	Author: Vaclav "Watty Watts" Oliva

	Description:
	Limits the number of magazines carried by individual unit. Each container (uniform, vest and backpack) can be limited separately or left untouched.
	The function limits the number of magazines of each unique ammo category in respective container. Items like First Aid Kit or Mine Detector are not affected by the function.

	Set the minimum and maximum values in an array, for example [0.5,1] will set the magazine count anywhere between 50-100% of default count.

	Parameters:
	Select 0 - OBJECT: Target unit
	Select 1 - ARRAY: Uniform magazines, use [<0-1>,<0-1>] or [] to skip. Default is [0.4,0.8].
	Select 2 - ARRAY: Vest magazines, use [<0-1>,<0-1>] or [] to skip. Default is [0.4,0.8].
	Select 3 - ARRAY: Backpack magazines, use [<0-1>,<0-1>] or [] to skip. Default is [0.4,0.8].

	Returns:
	Boolean

	Examples:
	_limit = [player] call BIS_fnc_limitAmmunition;
	_limit = [player,[],[0.5,0.5],[0,1]] call BIS_fnc_limitAmmunition;
*/

// Params
params
[
	["_unit",objNull,[objNull]],
	["_uniformMags",[0.4,0.8],[[]]],
	["_vestMags",[0.4,0.8],[[]]],
	["_backpackMags",[0.4,0.8],[[]]]
];

// Private variables
private
[
	"_uniformMagsMin",
	"_uniformMagsMax",
	"_vestMagsMin",
	"_vestMagsMax",
	"_backpackMagsMin",
	"_backpackMagsMax",
	"_unitUniformContentFinal",
	"_unitUniformContent",
	"_unitVestContentFinal",
	"_unitVestContent",
	"_unitBackpackContentFinal",
	"_unitBackpackContent",
	"_unitMagazineType",
	"_unitMagazineSize",
	"_unitMagazineCount"
];

if (count _uniformMags == 2) then {_uniformMagsMin = _uniformMags select 0; _uniformMagsMax = _uniformMags select 1};
if (count _vestMags == 2) then {_vestMagsMin = _vestMags select 0; _vestMagsMax = _vestMags select 1};
if (count _backpackMags == 2) then {_backpackMagsMin = _backpackMags select 0; _backpackMagsMax = _backpackMags select 1};

// Check for validity
/*
if (isNull _unit) exitWith {["Unit magazine removal: unit %1 does not exist.",_unit] call BIS_fnc_logFormat; false};

if !((count _uniformMags) in [0,2]) exitWith {["Unit magazine removal: %1 wrong format %2 for uniform ammo - must be '[#x,#y]' or '[]'.",_unit,_uniformMags] call BIS_fnc_logFormat; false};
if ((count _uniformMags == 2) and {(_uniformMagsMin > _uniformMagsMax)}) exitWith {["Unit magazine removal: %1 uniform minimum %2 cannot be bigger than maximum %3",_unit,_uniformMagsMin,_uniformMagsMax] call BIS_fnc_logFormat; false};
if ((count _uniformMags == 2) and {(_uniformMagsMin < 0) or (_uniformMagsMin > 1)}) exitWith {["Unit magazine removal: %1 uniform minimum %2 must be in <0;1>",_unit,_uniformMagsMin] call BIS_fnc_logFormat; false};
if ((count _uniformMags == 2) and {(_uniformMagsMax < 0) or (_uniformMagsMax > 1)}) exitWith {["Unit magazine removal: %1 uniform maximum %2 must be in <0;1>",_unit,_uniformMagsMax] call BIS_fnc_logFormat; false};

if !((count _vestMags) in [0,2]) exitWith {["Unit magazine removal: %1 wrong format %2 for vest ammo - must be '[#x,#y]' or '[]'.",_unit,_vestMags] call BIS_fnc_logFormat; false};
if ((count _vestMags == 2) and {(_vestMagsMin > _vestMagsMax)}) exitWith {["Unit magazine removal: %1 vest minimum %2 cannot be bigger than maximum %3",_vestMagsMin,_vestMagsMax] call BIS_fnc_logFormat; false};
if ((count _vestMags == 2) and {(_vestMagsMin < 0) or (_vestMagsMin > 1)}) exitWith {["Unit magazine removal: %1 vest minimum %2 must be in <0;1>",_vestMagsMin] call BIS_fnc_logFormat; false};
if ((count _vestMags == 2) and {(_vestMagsMax < 0) or (_vestMagsMax > 1)}) exitWith {["Unit magazine removal: %1 vest maximum %2 must be in <0;1>",_vestMagsMax] call BIS_fnc_logFormat; false};

if !((count _backpackMags) in [0,2]) exitWith {["Unit magazine removal: %1 wrong format %2 for backpack ammo - must be [#x,#y].",_unit,_backpackMags] call BIS_fnc_logFormat; false};
if ((count _backpackMags == 2) and {_backpackMagsMin > _backpackMagsMax}) exitWith {["Unit magazine removal: %1 backpack minimum %2 cannot be bigger than maximum %3",_unit,_backpackMagsMin,_backpackMagsMax] call BIS_fnc_logFormat; false};
if ((count _backpackMags == 2) and {(_backpackMagsMin < 0) or (_backpackMagsMin > 1)}) exitWith {["Unit magazine removal: %1 backpack minimum %2 must be in <0;1>",_unit,_backpackMagsMin] call BIS_fnc_logFormat; false};
if ((count _backpackMags == 2) and {(_backpackMagsMax < 0) or (_backpackMagsMax > 1)}) exitWith {["Unit magazine removal: %1 backpack maximum %2 must be in <0;1>",_unit,_backpackMagsMax] call BIS_fnc_logFormat; false};
*/

// Uniform
if (count _uniformMags == 2) then {_unitUniformContentFinal = []} else {_unitUniformContentFinal = getUnitLoadout _unit select 3 select 1};
if ((count _uniformMags == 2) and {count (getUnitLoadout _unit select 3) > 0})
then
{
	_unitUniformContent =  getUnitLoadout _unit select 3 select 1;
	{
		_unitMagazineType = _x select 0;
		_unitMagazineSize = _x select 2;

		if (count _x > 2)
		then
		{
			_unitMagazineCount = _x select 1;
			_unitMagazineCount = round (_unitMagazineCount * (random (_uniformMagsMax - _uniformMagsMin) + _uniformMagsMin));
			_x set [1,_unitMagazineCount];
		};
	        _unitUniformContentFinal pushBack _x;
	} forEach _unitUniformContent;
};

// Vest
if (count _vestMags == 2) then {_unitVestContentFinal = []} else {_unitVestContentFinal = getUnitLoadout _unit select 4 select 1};
if ((count _vestMags == 2) and {count (getUnitLoadout _unit select 4) > 0})
then
{
	_unitVestContent = getUnitLoadout _unit select 4 select 1;
	{
		_unitMagazineType = _x select 0;
		_unitMagazineSize = _x select 2;

		if (count _x > 2)
		then
		{
			_unitMagazineCount = _x select 1;
			_unitMagazineCount = round (_unitMagazineCount * (random (_vestMagsMax - _vestMagsMin) + _vestMagsMin));
			_x set [1,_unitMagazineCount];
		};
	        _unitVestContentFinal pushBack _x;
	} forEach _unitVestContent;
};

// Backpack
if (count _backpackMags == 2) then {_unitBackpackContentFinal = []} else {_unitBackpackContentFinal = getUnitLoadout _unit select 5 select 1};
if ((count _backpackMags == 2) and {count (getUnitLoadout _unit select 5) > 0})
then
{
	_unitBackpackContent = getUnitLoadout _unit select 5 select 1;
	{
		_unitMagazineType = _x select 0;
		_unitMagazineSize = _x select 2;

		if (count _x > 2)
		then
		{
			_unitMagazineCount = _x select 1;
			_unitMagazineCount = round (_unitMagazineCount * (random (_backpackMagsMax - _backpackMagsMin) + _backpackMagsMin));
			_x set [1,_unitMagazineCount];
		};
		_unitBackpackContentFinal pushback _x;
	} forEach _unitBackpackContent;
};

// Check the uniform
if (count (getUnitLoadout _unit select 3) > 0) then {_unitUniformContentFinal = [uniform _unit, _unitUniformContentFinal]};
// Check the vest
if (count (getUnitLoadout _unit select 4) > 0) then {_unitVestContentFinal = [vest _unit, _unitVestContentFinal]};
// Check the backpack
if (count (getUnitLoadout _unit select 5) > 0) then {_unitBackpackContentFinal = [backpack _unit, _unitBackpackContentFinal]};

// Set final loadout
_unit setUnitLoadout [nil,nil,nil,_unitUniformContentFinal,_unitVestContentFinal,_unitBackpackContentFinal,nil,nil,nil,nil];

true
