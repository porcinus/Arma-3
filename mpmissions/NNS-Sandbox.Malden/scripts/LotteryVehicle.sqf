/*
NNS
"Lottery" script to allow player to "win" a vehicle.

Example:
	On server : [LotteryVehicleSpawner] execVM "scripts\LotteryVehicle.sqf";
	On clients : 
		missionNamespace setVariable ["LotteryVehReq", true, true]; //request a "roll"
		missionNamespace setVariable ["LotteryVehRes", true, true]; //remove spawned vehicle
	
Dependencies:
	in description.ext:
		class CfgFunctions {
			class NNS {
				class missionfunc {
					file = "nns_functions";
					class debugOutput {};
				};
			};
		};
		
	in stringtable.csv:
		STR_NNS_lottery_title and STR_NNS_lottery_vehicle_won lines
		
	nns_functions folder:
		fn_debugOutput.sqf
		
	script folder:
		LotteryVehicle.sqf
	
*/

params [
["_spawnLocation", objNull], //object or location to use as spawn point
["_allowedKind", ["Car", "Armored", "Tank", "Air"]], //allowed kind
["_spawnDir", 0] //spawn direction, not used if spawn location is a object
];

if (isNull _spawnLocation) exitWith {["LotteryVehicle.sqf : spawn location needed, object is allowed",true,true] call NNS_fnc_debugOutput};
if (count _allowedKind == 0) then {_allowedKind = ["Car", "Armored", "Tank", "Air"]}; //allowed kind not set, set to default
if !(_spawnLocation isEqualType []) then {_spawnDir = getDir _spawnLocation; _spawnLocation = getPos _spawnLocation}; //_spawnLocation is a object

_allowedClasses = (format ["(getText (_x >> 'vehicleClass') in %1) && (getNumber (_x >> 'scope') == 2)", _allowedKind]) configClasses (configFile >>"CfgVehicles"); //extract all wanted kind
if (count _allowedClasses == 0) exitWith {[format ["LotteryVehicle.sqf : no class found for defined kind : %1", _allowedKind],true,true] call NNS_fnc_debugOutput};

while {sleep 0.5; true} do {
	_request = missionNamespace getVariable ["LotteryVehReq", false]; //roll request
	_reset = missionNamespace getVariable ["LotteryVehRes", false]; //reset request
	
	if (_reset) then {
		missionNamespace setVariable ["LotteryVehRes", false, true]; //reset variable
		_conflitObjs = nearestObjects [_spawnLocation, ["Car", "Truck", "Tank", "Air"], 10, true]; //look for conflicting objects around spawn
		{_x setPos [0,0,0]; deleteVehicle _x} forEach _conflitObjs; //delete all vehicles in spawn area
	};
	
	if (_request) then {
		missionNamespace setVariable ["LotteryVehReq", false, true]; //reset current "roll"
		_conflitObjs = nearestObjects [_spawnLocation, ["Car", "Truck", "Tank", "Air"], 10, true]; //look for conflicting objects around spawn
		if (count _conflitObjs == 0) then { //no objects in spawn area
			_classToUse = selectRandom _allowedClasses; //select a random class
			_tmpVehi = createVehicle [configName _classToUse, [0,0,0], [], 0, "CAN_COLLIDE"]; //spawn a vehicle
			_tmpVehi setDir _spawnDir; //set vehicle direction
			_tmpVehi setPos _spawnLocation; //set vehicle position
			[localize "STR_NNS_lottery_title", format [localize "STR_NNS_lottery_vehicle_won", [_classToUse] call BIS_fnc_displayName]] remoteExec ["BIS_fnc_showSubtitle",0];
		};
	};
};
