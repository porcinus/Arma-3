/*
	Author: Bravo Zero One development
	- John_Spartan

	Description:
	- This is sub function for 'boat recovery' functionality.

	Execution:
	- Call from Init EH script that is added to object (boat rack) or from action code.

	Example:
		[_boatRack, _boat] call bis_fnc_boatRack01AdjustZOffset;

	Required:
		Object (boat rack) must have vehicle in vehicle behavior configured (https://community.bistudio.com/wiki/Arma_3_Vehicle_in_Vehicle_Transport).
		Object (boat rack) must have triggers set up with continuous actions.
		Object (boat rack) must have set of Z offset's predefined in cfgVehicles for know/supported boat types.

		Parameters used from cfgVehicles configuration:
		cargoBayAnimationSelection 		= "CargoBay_Move_Z";
		supportedVehicleOffsetsZ[]		= {{"C_Boat_Civil_01_F",0.55}};

	Parameter(s):
		_this select 0: mode (Scalar)
		0: boat rack object
		1: boat in cargo
		and
		other parameters from boat rack's cfgVehicles configuration.

	Returns: nothing
	Result: Adjusts the hight (Z offset) of boat rack suspension to prevent different boats clipping with visual mesh.

*/
private _boatRackObj = param [0, objNull];
private _boat = param [1, objNull];

if (!isNull _boatRackObj && !isNull _boat) then
{
	private _boatRackVehicleClass = typeOf _boatRackObj;
	private _targetVehicleClass = typeOf _boat;
	private _boatRackCfg = configFile >> "CfgVehicles" >> _boatRackVehicleClass >> "BoatRecoverySystem";
	private _cargoBayAnimationSelection = (_boatRackCfg >> "cargoBayAnimationSelection") call bis_fnc_getCfgData;
	private _supportedVehicleOffsetsZ = (_boatRackCfg >> "supportedVehicleOffsetsZ") call bis_fnc_getCfgData;

	private _offsetZ = 0;

	{
		if(_targetVehicleClass == (_x select 0)) exitWith {_offsetZ = (_x select 1)};
	}
	forEach _supportedVehicleOffsetsZ;

	_boatRackObj animate [_cargoBayAnimationSelection, _offsetZ, true];
};
