private["_module"];

_module = _this param [0,objNull,[objNull]];

/*--------------------------------------------------------------------------------------------------

	RUN ONCE

--------------------------------------------------------------------------------------------------*/
private["_initialized"];

_initialized 	= missionNamespace getVariable ["bis_fnc_moduleSpawnAISectorTactic_initialized",false];

//make sure the module script runs only once
if (_initialized) exitWith {}; missionNamespace setVariable ["bis_fnc_moduleSpawnAISectorTactic_initialized",true];

/*--------------------------------------------------------------------------------------------------

	LOAD FUNCTIONS

--------------------------------------------------------------------------------------------------*/
_path = "\A3\Modules_F_Heli\Misc\Functions\ModuleSpawnAISectorTactic\";
[
	_path,
	"bis_fnc_moduleSpawnAISectorTactic_",
	[
		"enableAI",
		"disableAI",
		"startFSM",
		"initGroup",
		"copyGroup",
		"getNearTransportVehicle",
		"getGrpAvgMagazines",
		"execWidgetFSM",
		"deployLocValid",
		"getGroupIdVar",
		"resetEventHandlerFlags",
		"adjustGear",
		"widgetInit",
		"widgetUpdate",
		"isVehicleArmed",
		"getVehicleWeapons",
		"vehicleHit",
		"splitGroup",
		"unstuck",
		"getClosestSector",
		"main"
	]
]
call bis_fnc_loadFunctions;

/*--------------------------------------------------------------------------------------------------

	INITIALIZE EMITTERS

--------------------------------------------------------------------------------------------------*/
private["_affectedEmitters","_allEmitters"];

_affectedEmitters = [_module,["ModuleSpawnAI_F"]] call bis_fnc_synchronizedObjects;
_allEmitters = allMissionObjects "ModuleSpawnAI_F";

if (count _affectedEmitters == 0) then
{
	_affectedEmitters =+ _allEmitters;
};

{
	if (_x in _affectedEmitters) then
	{
		_x setVariable ["useSectorTactic",true];
	}
	else
	{
		_x setVariable ["useSectorTactic",false];
	};
}
forEach _allEmitters;

/*--------------------------------------------------------------------------------------------------

	INITIALIZE SECTORS & AREAS & TRIGGERS

--------------------------------------------------------------------------------------------------*/
private["_fn_onSectorCaptured"];

bis_fnc_moduleSpawnAISectorTactic_areas			= [];
bis_fnc_moduleSpawnAISectorTactic_sectors		= [true] call bis_fnc_moduleSector;
bis_fnc_moduleSpawnAISectorTactic_sectorsWest		= [];
bis_fnc_moduleSpawnAISectorTactic_sectorsEast		= [];
bis_fnc_moduleSpawnAISectorTactic_sectorsGuer		= [];
bis_fnc_moduleSpawnAISectorTactic_sectorsNonWest 	= [];
bis_fnc_moduleSpawnAISectorTactic_sectorsNonEast 	= [];
bis_fnc_moduleSpawnAISectorTactic_sectorsNonGuer 	= [];
bis_fnc_moduleSpawnAISectorTactic_sectorsUnknown 	= [];

_fn_onSectorCaptured =
{
	private["_sector","_capper","_looser"];

	_sector = _this param [0,objNull,[objNull]];
	_capper = _this param [1,west,[west]];
	_looser = _this param [2,west,[west]];

	_capperSectors = missionNamespace getVariable [format["bis_fnc_moduleSpawnAISectorTactic_sectors%1",_capper],[]];
	_looserSectors = missionNamespace getVariable [format["bis_fnc_moduleSpawnAISectorTactic_sectors%1",_looser],[]];

	_capperSectors = _capperSectors + [_sector];
	_looserSectors = _looserSectors - [_sector];

	missionNamespace setVariable [format["bis_fnc_moduleSpawnAISectorTactic_sectors%1",_capper],_capperSectors];
	missionNamespace setVariable [format["bis_fnc_moduleSpawnAISectorTactic_sectors%1",_looser],_looserSectors];

	bis_fnc_moduleSpawnAISectorTactic_sectorsNonWest = bis_fnc_moduleSpawnAISectorTactic_sectors - bis_fnc_moduleSpawnAISectorTactic_sectorsWest;
	bis_fnc_moduleSpawnAISectorTactic_sectorsNonEast = bis_fnc_moduleSpawnAISectorTactic_sectors - bis_fnc_moduleSpawnAISectorTactic_sectorsEast;
	bis_fnc_moduleSpawnAISectorTactic_sectorsNonGuer = bis_fnc_moduleSpawnAISectorTactic_sectors - bis_fnc_moduleSpawnAISectorTactic_sectorsGuer;
};

private["_area","_sector"];

{
	if (true) then
	{
		_sector = _x;

		//setup event handler for tracking changes of the sector ownership
		[_sector,"ownerChanged",_fn_onSectorCaptured] call bis_fnc_addScriptedEventHandler;

		//get area synced with the sector
		_area = [_sector, "LocationArea_F", true] call bis_fnc_synchronizedObjects;

		if (count _area == 0) exitWith
		{
			["[x] No valid area is linked to the sector %1!", _sector] call bis_fnc_error;
		};

		if (count _area > 1) exitWith
		{
			["[x] More then 1 area is linked to the sector %1!", _sector] call bis_fnc_error;
		};

		_area = _area select 0;

		_sector setVariable ["area",_area];
		_sector setVariable ["position",getPos _area];
		_area setVariable ["sector",_sector];

		bis_fnc_moduleSpawnAISectorTactic_areas set [count bis_fnc_moduleSpawnAISectorTactic_areas, _area];
	};
}
forEach bis_fnc_moduleSpawnAISectorTactic_sectors;

//initialize gvars with sector owners
private["_sector","_owner","_sectors"];

{
	_sector  = _x;
	_owner   = _sector getVariable ["owner","Unknown"];
	_sectors = missionNamespace getVariable format["bis_fnc_moduleSpawnAISectorTactic_sectors%1",_owner];
	_sectors set [count _sectors, _sector];
}
forEach bis_fnc_moduleSpawnAISectorTactic_sectors;

bis_fnc_moduleSpawnAISectorTactic_sectorsNonWest = bis_fnc_moduleSpawnAISectorTactic_sectors - bis_fnc_moduleSpawnAISectorTactic_sectorsWest;
bis_fnc_moduleSpawnAISectorTactic_sectorsNonEast = bis_fnc_moduleSpawnAISectorTactic_sectors - bis_fnc_moduleSpawnAISectorTactic_sectorsEast;
bis_fnc_moduleSpawnAISectorTactic_sectorsNonGuer = bis_fnc_moduleSpawnAISectorTactic_sectors - bis_fnc_moduleSpawnAISectorTactic_sectorsGuer;

private["_area","_triggers"];

//get all triggeres and store them in areas and sectors
{
	_area = _x;
	_triggers = [_area,"EmptyDetector"] call bis_fnc_synchronizedObjects;

	_area setVariable ["triggers",_triggers];
	(_area getVariable "sector") setVariable ["triggers",_triggers];
}
forEach bis_fnc_moduleSpawnAISectorTactic_areas;

/*--------------------------------------------------------------------------------------------------

	START THE GROUP MONITOR

--------------------------------------------------------------------------------------------------*/
[] spawn bis_fnc_moduleSpawnAISectorTactic_main;