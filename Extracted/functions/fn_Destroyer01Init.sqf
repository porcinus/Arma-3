/*
	Author: Bravo Zero One development
	- John_Spartan

	Description:
	- This is a main function designed to assemble dynamic ship (multi-part structure). Ship consists of multiple sub-objects that are linked together based on precise memory point positions in 3D space.

	Execution:
	- Call from EH on the main ship's base model (blank model with memory points and reference config).

		Example:
		class Eventhandlers
		{
			init = "_this call bis_fnc_Destroyer01Init";								//main init fnc, will assemble ship in game
			AttributesChanged3DEN = "_this call bis_fnc_Destroyer01EdenInit";			//function to update objects position in EDEN editor if attributes changed by player
			Dragged3DEN = "_this call bis_fnc_Destroyer01PosUpdate";					//function to update objects position in EDEN editor if attributes changed by player
			RegisteredToWorld3DEN = "_this call bis_fnc_Destroyer01EdenInit";			//initial EDEN init fnc (main init is still called)
			UnregisteredFromWorld3DEN = "_this call bis_fnc_Destroyer01EdenDelete";		//function  to delete all ship objects in EDEN editor
		};

	Requirements:
	- Compatible object (carrier/ship) must have a base model with reference memory points and set of parts defined as separate objects in cfgVehicles config with their own models.
	Main ship base must have a definition of all listed sub parts and memory point position to reference it's placement in 3D space.

		Example in cfgVehicles class for ship base
		multiStructureParts[] = {
						{"Land_Destroyer_01_hull_01_F","pos_hull_1"},
						{"Land_Destroyer_01_hull_02_F","pos_hull_2"},
						{"Land_Destroyer_01_hull_03_F","pos_hull_3"},
						{"Land_Destroyer_01_hull_04_F","pos_hull_4"},
						{"Land_Destroyer_01_hull_05_F","pos_hull_5"},
						{"Land_Destroyer_01_interior_02_F","pos_hull_2"},
						{"Land_Destroyer_01_interior_03_F","pos_hull_3"},
						{"Land_Destroyer_01_interior_04_F","pos_hull_4"},
						{"Land_HelipadEmpty_F","pos_heliPad"},
						{"ShipFlag_US_F","pos_Flag"}

					};

	Parameter(s):
		_this select 0: mode (Scalar)
		0: ship Base/object

		and parameters from config

	Returns: exposes and array of objects (ship parts) to other scripts for easy access as variable in it's own object name-space.
	Result: Destroyer (ship) is assembled

*/
if (!isServer) exitWith {};

private _carrierBase = param [0, objNull];
private _carrierDir = getDir _carrierBase;
private _carrierPos = getPosWorld _carrierBase;

private _carrierPitchBank = _carrierBase call bis_fnc_getPitchBank;
_carrierPitchBank params [["_carrierPitch",0],["_carrierBank",0]];

private _cfgVehicles = configFile >> "CfgVehicles";
private _carrierParts = (_cfgVehicles >> typeOf _carrierBase >> "multiStructureParts") call bis_fnc_getCfgData;
private _carrierPartsArray = [];

//create and assemble the carrier on server
private ["_dummy","_dummyClassName","_carrierPartPos"];

{
	_dummyClassName = _x select 0;
	_dummy = createVehicle [_dummyClassName, _carrierPos, [], _carrierDir, "CAN_COLLIDE"];
	_dummy setDir _carrierDir;
	[_dummy, _carrierPitch, _carrierBank] call bis_fnc_setPitchBank;
	_carrierPartPos = _carrierBase modelToWorldWorld (_carrierBase selectionPosition (_x select 1));
	_dummy setPosWorld _carrierPartPos;
	_carrierPartsArray pushBack [_dummy,_x select 1];
	_dummy allowDamage false;
}
foreach _carrierParts;

_carrierBase setVariable ["bis_carrierParts", _carrierPartsArray, true];