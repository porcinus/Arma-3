/*
Limit the number of First Aid Kits carried by units
- 50% chance to have a single FAK in a uniform (allUnits)
- 2-4 FAKs in a backpack (medics and ammo bearers)

Example: this call BIS_fnc_limitFAKs

*/

// Params
params
[
	["_unit",objNull,[objNull]]	// unit
];

// Privates
private [
	"_uniformContent",
	"_backpackContent",
	"_index",
	"_uniformFAKs",
	"_backpackFAKs"
];

_uniformsFAKs = 0;
_backpackFAKs = 0;

{if (_x == "FirstAidKit") then {_uniformsFAKs = _uniformsFAKs + 1}} forEach (uniformItems _unit);
{if (_x == "FirstAidKit") then {_backpackFAKs = _backpackFAKs + 1}} forEach (backpackItems _unit);

// Handle uniform
if ("FirstAidKit" in uniformItems _unit) then {
	_uniformContent = getUnitLoadout _unit select 3 select 1;
	_index = _uniformContent find ["FirstAidKit",_uniformsFAKs];
	_uniformContent set [_index,["FirstAidKit",(round random 1)]];
	_unit setUnitLoadout [nil,nil,nil,[nil,_uniformContent],nil,nil,nil,nil,nil,nil];
};

// Handle backpack
if ("FirstAidKit" in backpackItems _unit) then {
	_backpackContent = getUnitLoadout _unit select 5 select 1;
	_index = _backpackContent find ["FirstAidKit",_backpackFAKs];
	_backpackContent set [_index,["FirstAidKit",2 + (round random 2)]];
	_unit setUnitLoadout [nil,nil,nil,nil,nil,[nil,_backpackContent],nil,nil,nil,nil];
};
