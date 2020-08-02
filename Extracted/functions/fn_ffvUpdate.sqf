/*
	Author:
		Konrad Szumiec A.D. 2014

	Description:
		Update Firing From Vehicle feature depending on condition defined in turret's config.

	Parameter:
		OBJECT - vehicle

	Returns:
		nothing

	Example:
		if (local _vehicle) then {
			_vehicle animate ["Door_1",1];
			_vehicle call BIS_fnc_ffvUpdate;
		};
*/

private [
	"_turretPaths","_turretConfigs",
	"_turretCount",
	"_canShoot", "_condition"
];
	
// Find turret paths and configs
_turretPaths = [_this,[]] call bis_fnc_getTurrets;
_turretConfigs = [_this,configFile] call bis_fnc_getTurrets;

// Manage FFV
_turretCount = count _turretPaths;

for "_i" from 0 to (_turretCount - 1) do {
	private [
		"_turretPath","_turretConfig",
		"_canShoot"
	];
	_turretPath = _turretPaths select _i;
	_turretConfig = _turretConfigs select _i;
	
	_canShoot = getNumber (_turretConfig >> "isPersonTurret");
	
	if (_canShoot > 0) then {
		private "_condition";
		_condition = call compile (getText (_turretConfig >> "ffvCondition"));
		if (isNil "_condition") then {_condition = true};
		_this enablePersonTurret [_turretPath,_condition];
	};
};
