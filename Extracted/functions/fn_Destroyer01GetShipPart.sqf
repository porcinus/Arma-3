/*
	Author: Bravo Zero One development
	- John_Spartan

	Description:
	- This is a helper function to get ship components (objects) by class name from stored array in ships master component's name-space ("BIS_CarrierParts" array).

	Execution:
	- Call from script or config.

		Example:
		[_this, 'Land_Destroyer_01_hull_05_F'] call bis_fnc_destroyer01GetShipPart;

	Requirements:
	- Ships master object must be present. Ships master object must have initialized the array of sub components.

	Parameter(s):
		_this select 0: mode (Scalar)
		0: ship Base/object
		1: ship part class name to find


	Returns: object (ship part that matches selected class name)
	Result: n/a

*/

if (!isServer) exitWith {};

private _shipBase = param [0, objNull];
private _shipPartClassNameToFind = param [1, "undefined"];
private _shipPartList = _shipBase getVariable ["BIS_CarrierParts",[]];

if (_shipBase == objNull || {count _shipPartList == 0 || {_shipPartClassNameToFind == "undefined"}}) exitWith {};

private _shipPart = objNull;

{
	private _arrayItemClassName = typeOf (_x select 0);

	if(_arrayItemClassName == _shipPartClassNameToFind) then
	{
		_shipPart = (_x select 0);
	};
} 
foreach _shipPartList;

_shipPart