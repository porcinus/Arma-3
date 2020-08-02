_blacklist = ["gm"];

_cfgWpns = configFile >> "CfgWeapons";
_cfgVehs = configFile >> "CfgVehicles";
_cfgGlasses = configFile >> "CfgGlasses";
_cfgMags = configFile >> "CfgMagazines";

{
	_cfg = switch (_x) do {
		case 5: {_cfgVehs};
		case 7: {_cfgGlasses};
		case 22;
		case 23;
		case 26: {_cfgMags};
		case 24: {_cfgMags};
		default {_cfgWpns}
	};
	_arr = +(BIS_fnc_arsenal_data select _x);
	_arr = _arr select {!(toLower getText (_cfg >> _x >> "DLC") in _blacklist)};
	BIS_fnc_arsenal_data set [_x, _arr];
} forEach [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 22, 23, 24, 26];