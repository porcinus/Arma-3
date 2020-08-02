private ["_curator","_addons","_placeableAddons","_addon","_cfgPatch"];
_curator = _this param [0,objnull,[objnull]];
_addons = _this param [1,[],[[]]];

_placeableAddons = _curator getvariable ["bis_fnc_curatorSystem_placeableAddons",[]];
{
	_addon = _x;
	if !(_addon in _placeableAddons) then {
		_cfgPatch = configfile >> "cfgpatches" >> _addon;
		if (isclass _cfgPatch) then {
			_placeableAddons set [count _placeableAddons,_addon];
		} else {
			["Class %1 not found in CfgPatches",_addon] call bis_fnc_error;
		};
	};
} foreach _addons;
_curator setvariable ["bis_fnc_curatorSystem_placeableAddons",_placeableAddons,true];

_placeableAddons