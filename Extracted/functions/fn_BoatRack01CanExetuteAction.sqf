/*
	Author: Bravo Zero One development
	- John_Spartan

	Description:
	- This is sub function for 'boat recovery' functionality.

	Execution:
	- Call from script that invokes the "Hold Action" for boat recovery.

	Example:
		[_target,_boatRack] call bis_fnc_boatRack01CanExetuteAction;

	Required:
		Object (boat)
		Object (boat rack) must have vehicle in vehicle behavior configured (https://community.bistudio.com/wiki/Arma_3_Vehicle_in_Vehicle_Transport).
		
	Parameter(s):
		_this select 0: mode (Scalar)
		0: Object (boat)
		1: Object (boat rack)

	Returns: true if all conditions are met to display the "Hold Action"
	Result: Check to show "Hold Action" to player.

*/
private _target= param [0, objNull];
private _boatRack = param [1, objNull];
private _canShowAction = "false";

if(!(isNull _boatRack)) then 
{
	//CHECK CAN BOAT BE LOADED ON TO RACK (DIMENSIONS) & BOAT IS NOT LOADED IN ANOTHER CARGO HOLD ITSLEF
	if(((_boatRack canVehicleCargo _target) select 1) && {isNull (isVehicleCargo _target)} && {count (getVehicleCargo _boatRack) == 0})then
	{
		_canShowAction = "true";
	};
};

_canShowAction;
