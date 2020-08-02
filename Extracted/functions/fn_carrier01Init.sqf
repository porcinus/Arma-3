/*
	Author: Bravo Zero One development
	- John_Spartan

	Description:
	- This is a main function designed to assemble dynamic aircrfat carrier. Carrier consists of multiple sub-objects that are linked together based on precise memory point positions in 3D space.

	Exucution:
	- Call from EH on the main carrier base model (blank model with momory points and reference config).

		Example:
		class Eventhandlers
		{
			init = "_this call bis_fnc_Carrier01Init";								//main init fnc, will assemble carrier in game
			AttributesChanged3DEN = "_this call bis_fnc_Carrier01EdenInit";			//function to update objects position in EDEN editor if attributes changed by player
			Dragged3DEN = "_this call bis_fnc_Carrier01PosUpdate";					//function to update objects position in EDEN editor if attributes changed by player
			RegisteredToWorld3DEN = "_this call bis_fnc_Carrier01EdenInit";			//initial EDEN init fnc (main init is still called)
			UnregisteredFromWorld3DEN = "_this call bis_fnc_Carrier01EdenDelete";	//function  to delete all carrier objects in EDEN editor
		};

	Requirments:
	- Compatible object (carrier/ship) must have a base model with reference momory points and set of parts defined as separate objects in cfgVehicles config with their own models.
	Main carrier base must have a definition of all listed sub parts and memory point position to refernece it's placement in 3D space.

		Example in cfgVehicles class for carrier base
		multiStructureParts[] = {
						{"Land_Carrier_01_hull_01_F","pos_Hull1"},
						{"Land_Carrier_01_hull_02_F","pos_Hull2"},
						{"Land_Carrier_01_hull_03_F","pos_Hull3"},
						{"Land_Carrier_01_hull_04_F","pos_Hull4"},
						{"Land_Carrier_01_hull_05_F","pos_Hull5"},
						{"Land_Carrier_01_hull_06_F","pos_Hull6"},
						{"Land_Carrier_01_hull_07_F","pos_Hull7"},
						{"Land_Carrier_01_hull_08_F","pos_Hull8"},
						{"Land_Carrier_01_hull_09_F","pos_Hull9"},
						{"Land_Carrier_01_island_01_F","pos_Island1"},
						{"Land_Carrier_01_island_02_F","pos_Island1"},
						{"DynamicAirport_01_F","pos_Airport"}

					};

	Parameter(s):
		_this select 0: mode (Scalar)
		0: carrier Base/object

		and parameters from config

	Returns: exposes and array of objects (carrier parts) to other scripts for easy acccess as variable in it's own object namespace.
	Result: Aircraft Carrier is assembled

*/

#include "defines.inc"
#include "initCarrier.inc"

//terminate if there is no player (dedicated server or hc) or it's running in EDEN
if (!hasInterface || is3DEN) exitWith {};

//create local trigger for auto-adding & removing of catapult action
_carrierBase spawn
{
	private _carrierBase = _this;
	private _carrierPartsArray = [];

	//wait for all parts to be properly initialized on client
	waitUntil
	{
		_carrierPartsArray = _carrierBase getVariable ["bis_carrierParts", []];
		count _carrierPartsArray > 0
	};

	private _bbox = boundingBoxReal _carrierBase;
	private _a = _bbox select 0;
	private _c = _bbox select 1;
	private _center = (_a vectorAdd _c) apply {_x/2};

	private _maxWidth = abs ((_c select 0) - (_a select 0));
	private _maxLength = abs ((_c select 1) - (_a select 1));

	private _b = [_c select 0,_a select 1];
	private _d = [_a select 0,_c select 1];

	private _dir = getDir _carrierBase;

	//DEBUG
	/*
	private _height = 24.5;
	private _color = [1,0,0,1];

	bis_lines = [[_a,_b],[_b,_c],[_c,_d],[_d,_a]];

	{
		_x set [0,_carrierBase modelToWorld (_x select 0)];
		_x set [1,_carrierBase modelToWorld (_x select 1)];
		_x set [2,_color];

		(_x select 0) set [2,_height];
		(_x select 1) set [2,_height];
	}
	forEach bis_lines;

	addMissionEventHandler ["Draw3D",
	{
		{
			drawLine3D _x;
		}
		forEach bis_lines;
	}];
	*/

	//create trigger for monitoring carrier surface
	private _trgCarrierDeck = createTrigger ["EmptyDetector", _carrierBase modelToWorld _center, false];
	_trgCarrierDeck setTriggerArea [_maxWidth/2, _maxLength/2, _dir, true];
	_trgCarrierDeck setTriggerActivation ["ANY", "PRESENT", true];
	_trgCarrierDeck setTriggerStatements
	[
		"cameraOn in thisList && {cameraOn isKindOf 'Plane'}",
		"[thisTrigger,thisList] call bis_fnc_carrier01CatapultActionAdd;",
		"[thisTrigger] call bis_fnc_carrier01CatapultActionRemove;"
	];

	//store carrier parts in the trigger
	_trgCarrierDeck setVariable ["bis_carrierParts",_carrierPartsArray];

	//get all needed data from carrier and store them in the trigger
	private _catapultsData = [];

	private _part = objNull;
	private _partClass = "";
	private _partCfg = configNull;

	private _catapultClass = "";
	private _catapultMemoryPoint = "";
	private _catapultDirOffset = 0;
	private _catapultAnimations = [];
	private _catapultActionName = "";

	//detect catapult data
	{
		_part = _x param [0, objNull];

		if (!isNull _part) then
		{
			_partClass = typeOf _part;
			_partCfg = configFile >> "CfgVehicles" >> _partClass >> "Catapults";

			{
				_catapultClass = _x;
				_catapultMemoryPoint = (_partCfg >> _catapultClass >> "memoryPoint") call bis_fnc_getCfgData;
				_catapultDirOffset 	 = (_partCfg >> _catapultClass >> "dirOffset") call bis_fnc_getCfgData;
				_catapultAnimations  = (_partCfg >> _catapultClass >> "animations") call bis_fnc_getCfgData;
				_catapultActionName  = (_partCfg >> _catapultClass >> "launchActionName") call bis_fnc_getCfgData;

				_catapultsData pushBack [_part,_catapultMemoryPoint,_catapultDirOffset,_catapultAnimations,_catapultActionName];
			}
			forEach (_partCfg call bis_fnc_getCfgSubClasses);
		};
	}
	forEach _carrierPartsArray;

	//store catapult data to trigger
	SET_CATAPULTS_DATA(_trgCarrierDeck,_catapultsData);
};