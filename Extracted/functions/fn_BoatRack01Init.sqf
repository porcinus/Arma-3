/*
	Author: Bravo Zero One development
	- John_Spartan

	Description:
	- This is main function for 'boat recovery' functionality.

	Execution:
	- Call from assets init EH.

	Example:
		class Eventhandlers
		{
			init = "_this call BIS_fnc_BoatRack01Init;";
		};

	Required:
		Object (boat rack) must have vehicle in vehicle behavior configured (https://community.bistudio.com/wiki/Arma_3_Vehicle_in_Vehicle_Transport).

	Parameter(s):
		_this select 0: mode (Scalar)
		0: boat rack object
		and
		other parameters from configuration

	Returns: nothing
	Result: Two triggers are added near object to allow user to interact with feature.

*/

//EXIT IN CASE WE ARE IN 3DEN
if (is3DEN) exitWith {};

//DEFINES
private _boatRack= param [0, objNull];

//EXIT IN CASE NO VEHICLE
if (isNull _boatRack) exitWith {};

private _boatRackVehicleClass = "";
private _boatRackCfg = configNull;
private _triggerAreaSizeX = 0;
private _triggerAreaSizeY = 0;
private _triggerAreaSizeZ = 0;
private _boatRecoveryPointClass = "";
private _boatRecoveryPointList = [];
private _boatRecoveryPointPosLoad = "";


//GET PARAMS
_boatRackVehicleClass = typeOf _boatRack;
_boatRackCfg = configFile >> "CfgVehicles" >> _boatRackVehicleClass >> "BoatRecoverySystem";
_triggerAreaSizeX = (_boatRackCfg >> "triggerAreaSizeX") call bis_fnc_getCfgData;
_triggerAreaSizeY = (_boatRackCfg >> "triggerAreaSizeY") call bis_fnc_getCfgData;
_triggerAreaSizeZ = (_boatRackCfg >> "triggerAreaSizeZ") call bis_fnc_getCfgData;

{
	_boatRecoveryPointClass = _x;
	_boatRecoveryPointPosLoad = (_boatRackCfg >> _boatRecoveryPointClass >> "memoryPointPosLoad") call bis_fnc_getCfgData;
	_boatRecoveryPointList pushBack [_boatRecoveryPointClass,_boatRecoveryPointPosLoad];
}
forEach (_boatRackCfg call bis_fnc_getCfgSubClasses);

{
	//CREATE TRIGGERS FOR EACH DEFINED LOADING POINT IN VEHICLE
	private _triggerLoad = (_x select 0);
	private _triggerLoadMemoryPoint = (_x select 1);
	private _boatRackDir = getDir _boatRack;
	_triggerLoad = createTrigger ["EmptyDetector", (_boatRack ModelToWorld (_boatRack selectionposition _triggerLoadMemoryPoint)), false];
	_triggerLoad setTriggerArea [_triggerAreaSizeX, _triggerAreaSizeY, _boatRackDir, true, _triggerAreaSizeZ];
	_triggerLoad setTriggerActivation ["ANY", "PRESENT", true];
	_triggerLoad setDir _boatRackDir;
	_triggerLoad setTriggerStatements
	[
		"cameraOn in thisList && {cameraOn isKindOf 'Ship'} && {player == driver cameraOn} && {speed (vehicle player) < 25} && {(count (getVehicleCargo (thisTrigger getVariable ['BIS_linkedBoatRack',objNull]))) == 0} && {((thisTrigger getVariable ['BIS_linkedBoatRack',objNull]) canVehicleCargo (vehicle player)) select 1} && {isNull (isVehicleCargo (vehicle player))}",
		"[thisTrigger,thisList] call bis_fnc_boatRack01ActionAdd;",
		"[thisTrigger] call bis_fnc_boatRack01ActionRemove;"
	];

	//STORE THE BOAT RACK OBJECT FOR LATER
	//TO AVOID GRABING WRONG OBJECT IN CASE TWO OBJECTS IN CLOSE PROXIMITY
	_triggerLoad setVariable ["BIS_linkedBoatRack", _boatRack, true];
}
forEach _boatRecoveryPointList;


//ANIMATE Z OFFSET IF VEHICLE IS LOADED ON STARTUP
//EXECUTE IN DIFERENT TREAD
[_boatRack] spawn bis_fnc_boatRack01InitAdjustZOffsets;