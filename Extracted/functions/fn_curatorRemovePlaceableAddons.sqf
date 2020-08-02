private ["_curator","_addons","_placeableAddons"];
_curator = _this param [0,objnull,[objnull]];
_addons = _this param [1,[],[[]]];

_placeableAddons = _curator getvariable ["bis_fnc_curatorSystem_placeableAddons",[]];
{
	_unitID = _placeableAddons find _x;
	if (_unitID >= 0) then {_placeableAddons set [_unitID,-1];}
} foreach _addons;
_placeableAddons = _placeableAddons - [-1];
_curator setvariable ["bis_fnc_curatorSystem_placeableAddons",_placeableAddons,true];
_placeableAddons