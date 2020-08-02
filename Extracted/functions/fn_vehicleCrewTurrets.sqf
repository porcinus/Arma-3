/*
	Author:
		Killzone_Kid

	Description:
		Returns unoccupied vehicle crew turrets, which will be filled if createVehicleCrew command is executed on the vehicle
		If vehicle class is passed as param, all vehicle crew turrets are returned

	Parameter(s):
		STRING or OBJECT - vehicle

	Returns:
		ARRAY - array or turrets ([-1] - is for driver turret)
		
	Example:
		"B_APC_Wheeled_01_cannon_F" call BIS_fnc_vehicleCrewTurrets;
		car1 call BIS_fnc_vehicleCrewTurrets;
*/

params [["_vehicle", "", ["", objNull]]];

private _vehicleIsClass = _vehicle isEqualType "";
private _config = configFile >> "CfgVehicles" >> (if (_vehicleIsClass) then { _vehicle } else { typeOf _vehicle });
private _crewTurrets = [[],[[-1]]] select (getNumber (_config >> "hasDriver") > 0);
	
{
	private _turret = _config;
	{ _turret = (_turret >> "Turrets") select _x } forEach _x;
	
	call
	{
		if !(getNumber (_turret >> "hasGunner") > 0) exitWith {};
		if (getNumber (_turret >> "dontCreateAI") > 0) exitWith {};
		_crewTurrets pushBack _x;
	};
}
forEach (if (_vehicleIsClass) then { _vehicle call BIS_fnc_allTurrets } else { allTurrets _vehicle });

if (_vehicleIsClass) exitWith { _crewTurrets };

_crewTurrets select { isNull (_vehicle turretUnit _x) }