//["[x][SimManager] Grabbing objects..."] call bis_fnc_logFormat;

//grab the objects, vehicle crew excluded
private _ret = entities [["All"],["Logic","Helper_Base_F"]];
_ret = _ret - BIS_simulationManager_checkFor;

//grab vehicle crew
{
	_ret append (crew _x);
}
count vehicles;

//update persistent array
{
	if (vehicleVarName _x != "" || {(_excludeAir && {_x isKindOf "Air"})}) then {BIS_persistent pushBackUnique _x};
}
forEach _ret;

//add vehicles manned by persistent units into the persistent array
private _vehicle = objNull;
{
	_vehicle = vehicle _x;

	if (_x != _vehicle) then {BIS_persistent pushBackUnique _vehicle};
}
forEach BIS_persistent;

bis_ret = _ret;

_ret