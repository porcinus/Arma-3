/*
	Author: Bravo Zero One development
	- John_Spartan

	Description:
	- This is a sub function designed to update dynamic ships (multi-part structure) position in EDEN editor. Ship consists of multiple sub-objects that are linked together based on precise memory point positions in 3D space.
	Function will update initial object positions when player drags the object in EDEN editor.

	Execution:
	- Call from EH on the main ship base model (blank model with memory points and reference config).

		Example:
		class Eventhandlers
		{
			init = "_this call BIS_fnc_Destroyer01Init";								//main init fnc, will assemble ship in game
			AttributesChanged3DEN = "_this call BIS_fnc_Destroyer01EdenInit";			//function to update objects position in EDEN editor if attributes changed by player
			Dragged3DEN = "_this call BIS_fnc_Destroyer01PosUpdate";					//function to update objects position in EDEN editor if attributes changed by player
			RegisteredToWorld3DEN = "_this call BIS_fnc_Destroyer01EdenInit";			//initial EDEN init fnc (main init is still called)
			UnregisteredFromWorld3DEN = "_this call BIS_fnc_Destroyer01EdenDelete";		//function  to delete all ship objects in EDEN editor
		};

	Requirements:
	- An array of ship parts/objects as a variable attached to main ship base. This array is created by main BIS_fnc_Destroyer01Init.

	Parameter(s):
		_this select 0: mode (Scalar)
		0: ship Base/object
		and
		1: array of objects in variable in base objects name-space ["bis_carrierParts", []];


	Returns: nothing
	Result: Ship's position is updated in EDEN editor.

*/

if (!isServer) exitWith {};

private ["_dummy","_carrierPartPos"];

private _carrierBase = param [0, objNull];

private _carrierPartsArray = _carrierBase getVariable ["bis_carrierParts", []];
private _carrierDir = getdir _carrierBase;
private _carrierPitchBank = _carrierBase call BIS_fnc_getPitchBank;
_carrierPitchBank params [["_carrierPitch",0],["_carrierBank",0]];

{
	_dummy = _x select 0;
	_dummy setDir _carrierDir;
	[_dummy, _carrierPitch, _carrierBank] call BIS_fnc_setPitchBank;
	_carrierPartPos = _carrierBase modelToWorldWorld (_carrierBase selectionPosition (_x select 1));
	_dummy setPosWorld _carrierPartPos;
}
forEach _carrierPartsArray;