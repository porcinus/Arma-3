/*
NNS
Limit Weapon / Ammo into Ammo box
If min and max not set and BIS_ammoboxAmount variable set in missionNamespace, this will be used as default.
Allow to replace 'if possible' ammo by tracer equivalent.

Example:
_null = [ammobox] call NNS_fnc_AmmoboxLimiter;
[ammobox] execVM 'nns_functions\fn_AmmoboxLimiter.sqf';

_null = [ammobox,0.1, 0.75] call NNS_fnc_AmmoboxLimiter;
[ammobox,0.1, 0.75] execVM 'nns_functions\fn_AmmoboxLimiter.sqf';

*/

// Params
params [
	["_box",objNull],	//ammobox
	["_min",-1], //min ratio
	["_max",-1], //max ratio
	["_replaceByTracer",false] //replace ammo by tracer when possible
];

// Check for validity
if (isNull _box) exitWith {[format["NNS_fnc_AmmoboxLimiter : Non-existing ammo box %1 used!",_box]] call NNS_fnc_debugOutput;};

_default = missionNamespace getVariable ["BIS_ammoboxAmount",[]];
if (count (_default) > 0) then {
	_min = _default select 0; _max = _default select 1;
} else {
	if (_min == -1) then {_min = 0.25;};
	if (_max == -1) then {_max = 0.5;};
};

if (_max <= 0) exitWith {["NNS_fnc_AmmoboxLimiter : Max value <= 0"] call NNS_fnc_debugOutput;};
if (_min >= 1) exitWith {["NNS_fnc_AmmoboxLimiter : Min value >= 1"] call NNS_fnc_debugOutput;};

_maxRnd = abs (_max - _min); //max random value

_boxItems = getItemCargo _box; //ammobox content
_items = _boxItems select 0; //items array
_itemsQuantity = _boxItems select 1; //quantity array
_itemsCount = count (_items) - 1; //amount of items

_boxMag = getMagazineCargo _box; //ammobox content
_mags = _boxMag select 0; //items array
_magsQuantity = _boxMag select 1; //quantity array
_magsCount = count (_mags) - 1; //amount of items

_magsTracer = [];
if (_replaceByTracer) then {
	_magsTracer  = missionNamespace getVariable ["BIS_magsTracerClass",[]];
	if (count _magsTracer == 0) then {
		_magsTracer  = "getNumber (_x >> 'tracersEvery') == 1" configClasses (configFile >> "CfgMagazines") apply {configName _x};
		missionNamespace setVariable ["BIS_magsTracerClass",_magsTracer];
	};
};

if (_itemsCount == 0 && _magsCount == 0) exitWith {["NNS_fnc_AmmoboxLimiter : Ammobox contain nothing"] call NNS_fnc_debugOutput;};

_itemsNew = []; _itemsQuantityNew = []; _magsNew = []; _magsQuantityNew = []; //new arrays

for "_i" from 0 to _itemsCount do { //items loop
	_tmpNewQuantity = round ((_itemsQuantity select _i) * (_min + random (_maxRnd))); //compute new quantity
	if (_tmpNewQuantity > 0) then {_itemsNew pushBack (_items select _i); _itemsQuantityNew pushBack _tmpNewQuantity;};
};

for "_i" from 0 to _magsCount do { //mags loop
	_tmpNewQuantity = round ((_magsQuantity select _i) * (_min + random (_maxRnd))); //compute new quantity
	if (_tmpNewQuantity > 0) then {
		_mag = (_mags select _i);
		if (_replaceByTracer) then {
			_tmpmag = _magsTracer select {toUpper _x find toUpper _mag >= 0};
			if (count _tmpmag > 0) then {_mag = _tmpmag select 0;};
		};
		
		_magsNew pushBack _mag;
		_magsQuantityNew pushBack _tmpNewQuantity;
	};
};

clearMagazineCargoGlobal _box; clearWeaponCargoGlobal _box; clearItemCargoGlobal _box; clearBackpackCargoGlobal _box; //clear ammobox

//set new items / mags
_itemsNewCount = count (_itemsNew) - 1; //amount of new items
_magsNewCount = count (_magsNew) - 1; //amount of new mags
for "_i" from 0 to _itemsNewCount do {_box addItemCargoGlobal [(_itemsNew select _i), (_itemsQuantityNew select _i)];};
for "_i" from 0 to _magsNewCount do {_box addMagazineCargoGlobal [(_magsNew select _i), (_magsQuantityNew select _i)];};
