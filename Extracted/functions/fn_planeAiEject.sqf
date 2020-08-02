/*
	Author: Bravo Zero One development
	- John_Spartan

	Description:
	- This function is designed as part of set of functions to implement semi-authenthic ejection system on fixed wing aircrfat that have such functionality enabled/configured.
	- AI behaviour handler.

	Exucution:
	- Call the function via attached EH to the aircrfat itself.

		Example:
		class Eventhandlers: Eventhandlers
		{
			Hit = "_this call BIS_fnc_planeAiEject";
		};

	Requirments:
	- Compatible aircrfat must have a config definition for all subsytems that will be invoked by ejection system (see BIS_fnc_PlaneEjection).

	Parameter(s):
		_this select 0: mode (Scalar)
		0: plane/object


	Returns: nothing
	Result: AI pilot will be forced to eject from aircrfat upon damage treshold reached. Semi-authenthic behaviour.

*/

private _plane = param [0,objNull];

if (speed _plane < 1) exitWith {};

if (_plane getVariable ["bis_aiEjected",false]) exitWith {};
_plane setVariable ["bis_aiEjected",true];

_plane spawn
{
	private _plane = _this;

	sleep 1.5;	//sleep to simulate Ai human-like reaction time

	//check validity of plane
	if (isNull _plane || {!alive _plane || {damage _plane < 0.1 || {unitIsUAV _plane}}}) exitWith {};

	private _driver = driver _plane;

	//check validity of pilot
	if (isNull _driver || {!alive _driver || {isPlayer _driver}}) exitWith {};

	[_this] call bis_fnc_planeEjection;
};