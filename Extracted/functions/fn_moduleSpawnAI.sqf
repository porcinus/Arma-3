private["_emitter","_activated","_initialized"];

_emitter 	= _this param [0,objNull,[objNull]];
_activated 	= _this param [2,true,[true]];

_initialized 	= _emitter getVariable ["initialized",false];

//make sure the emitter is initialized only once
if (_initialized) exitWith {_emitter setVariable ["activated",_activated];};

_emitter setVariable ["initialized",true];
_emitter setVariable ["activated",_activated];

/*--------------------------------------------------------------------------------------------------

	DEBUG LOG FLAG

--------------------------------------------------------------------------------------------------*/
BIS_fnc_moduleSpawnAI_debug = false;

/*--------------------------------------------------------------------------------------------------

	RUN ONCE PER SIDE

--------------------------------------------------------------------------------------------------*/
private["_engine","_side","_var"];

_side 	= _emitter getVariable ["side","West"];
_var	= format["bis_fnc_moduleSpawnAI_%1",_side];
_engine = missionNamespace getVariable [_var,objNull];

//make sure the main script runs only once per side
if (!isNull _engine) exitWith {}; missionNamespace setVariable [_var,_emitter];

//["[!] Emitter logic for side |%2| executed on |%1|.",_emitter,_side] call bis_fnc_logFormat;

/*--------------------------------------------------------------------------------------------------

	CREATE STORAGE FOR UNIT COSTS

--------------------------------------------------------------------------------------------------*/
private["_storage"];

_storage = missionNamespace getVariable ["bis_fnc_moduleSpawnAI_costs",objNull];

//make sure the main script runs only once per side
if (isNull _storage) then
{
	missionNamespace setVariable ["bis_fnc_moduleSpawnAI_costs",_emitter];

	//["[!] Cost storage logic set to |%1|.",_emitter] call bis_fnc_logFormat;
};

/*--------------------------------------------------------------------------------------------------

	LOAD FUNCTIONS & DO PRE-INIT

--------------------------------------------------------------------------------------------------*/
//make sure module is initialized only once
if (isNil "bis_fnc_moduleSpawnAI_initialized") then
{
	bis_fnc_moduleSpawnAI_initialized = true;

	_path = "\A3\Modules_F_Heli\Misc\Functions\ModuleSpawnAI\";
	[
		_path,
		"bis_fnc_moduleSpawnAI_",
		[
			"init",
			"initEmitters",
			"initSpawnpoints",
			"initGroups",
			"getManpower",
			"getRandomGroup",
			"getRandomPoint",
			"getGroupUnitCount",
			"getGroupCost",
			"getGroupWeight",
			"getGroupComposition",
			"getUnitCost",
			"getGroupType",
			"spawnGroup",
			"spawnVehicle",
			"cleanGroups",
			"cleanGroup",
			"startGarbageCollector",
			"deleteGroup",
			"getCargoSlots",
			"countCargoSlots",
			"logFormat",
			"log",
			"mergeGroup",
			"generateGroupId",
			"main"
		]
	]
	call bis_fnc_loadFunctions;

	_path = "\A3\Modules_F_Heli\Misc\Functions\ModuleSpawnAI\";
	[
		_path,
		"b",
		[
			"is_fnc_param"
		]
	]
	call bis_fnc_loadFunctions;

	[] call bis_fnc_moduleSpawnAI_init;
};

/*--------------------------------------------------------------------------------------------------

	PRE-PROCESS EMITTERS

--------------------------------------------------------------------------------------------------*/
private["_emitters"];

_emitters = [_side] call bis_fnc_moduleSpawnAI_initEmitters;

/*--------------------------------------------------------------------------------------------------

	PRE-PROCESS SPAWNPOINTS

--------------------------------------------------------------------------------------------------*/
private["_points"];

{
	_points = [_x] call bis_fnc_moduleSpawnAI_initSpawnpoints;

	if (count _points == 0) then
	{
		_emitters set [_forEachIndex,objNull];

		["[x] Emitter |%1| was deleted as it has now spawnpoints.",_x] call bis_fnc_moduleSpawnAI_logFormat;
	};
}
forEach _emitters; _emitters = _emitters - [objNull];

//terminate the module if there are no emitters
if (count _emitters == 0) exitWith {};

//save the emitters
missionNamespace setVariable [format["bis_fnc_moduleSpawnAI_%1_emitters",_side],_emitters];

/*--------------------------------------------------------------------------------------------------

	PRE-PROCESS GROUPS CONFIGS

--------------------------------------------------------------------------------------------------*/
{
	[_x] call bis_fnc_moduleSpawnAI_initGroups;
}
forEach _emitters;

/*--------------------------------------------------------------------------------------------------

	EXECUTE MAIN LOOP

--------------------------------------------------------------------------------------------------*/
[_emitters] spawn bis_fnc_moduleSpawnAI_main;