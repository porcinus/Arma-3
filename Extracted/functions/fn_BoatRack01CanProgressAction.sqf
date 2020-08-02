/*
	Author: Bravo Zero One development
	- John_Spartan

	Description:
	- This is sub function for 'boat recovery' functionality.

	Execution:
	- Call from script that invokes the "Hold Action" for boat recovery.

	Example:
		[_target,_boatRack] call bis_fnc_boatRack01CanProgressAction;
		
	Required:
		Object (boat)
		Object (boat rack) must have vehicle in vehicle behavior configured (https://community.bistudio.com/wiki/Arma_3_Vehicle_in_Vehicle_Transport).
		
	Parameter(s):
		_this select 0: mode (Scalar)
		0: Object (boat)
		1: Object (boat rack)

	Returns: true if all conditions are met during the process of "Hold Action", can continue with action
	Result: Check to allow continue with "Hold Action".

*/
private _target= param [0, objNull];
private _boatRack = param [1, objNull];
private _canProgressAction = "false";

if(!(isNull _boatRack)) then
{
	//CHECK IS BOATRACK CARGO SPACE AVAILIBLE & BOAT NOT LOADED SOMEWHERE ELSE
	if((count (getVehicleCargo _boatRack) == 0) && {isNull (isVehicleCargo _target)} && {count (getVehicleCargo _boatRack) == 0})then
	{
		_canProgressAction = "true";
	};
};

_canProgressAction;

