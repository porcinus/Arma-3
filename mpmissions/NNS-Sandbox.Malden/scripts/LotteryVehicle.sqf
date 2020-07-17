/*
NNS
WIP, ujst for a quick fun





[LotteryVehicleSpawner] execVM "scripts\LotteryVehicle.sqf"



*/

params [
["_spawnLocation", objNull], //object or location to use as spawn point
["_allowedKind", ["Car", "Armored", "Tank", "Air"]], //allowed kind
["_spawnDir", 0] //spawn direction, not used if spawn location is a object
];

private _tmpVehi = objNull;
if (isNull _spawnLocation) exitWith {["LotteryVehicle.sqf : spawn location needed, object is allowed",true,true] call NNS_fnc_debugOutput;};
if (count _allowedKind == 0) then {_allowedKind = ["Car", "Armored", "Tank", "Air"]}; //allowed kind not set, set to default
if !(_spawnLocation isEqualType []) then {_spawnDir = getDir _spawnLocation; _spawnLocation = getPos _spawnLocation}; //_spawnLocation is a object

_conflitObjs = nearestObjects [_spawnLocation, ["Car", "Truck", "Tank", "Air"], 10, true]; //look for conflicting objects around spawn
if (count _conflitObjs > 0) then {
	[format ["LotteryVehicle.sqf : conflicting objects will be deleted : %1", _conflitObjs]] call NNS_fnc_debugOutput;
	{_x setPos [0,0,0]; deleteVehicle _x} forEach _conflitObjs; //move object by security then delete it
};

_allowedClasses = (format ["(getText (_x >> 'vehicleClass') in %1)", _allowedKind]) configClasses (configFile >>"CfgVehicles"); //extract all wanted kind

if (count _allowedClasses == 0) exitWith {[format ["LotteryVehicle.sqf : no class found for defined kind : %1", _allowedKind],true,true] call NNS_fnc_debugOutput};

_classToUse = selectRandom _allowedClasses; //select a random class
_tmpVehi = createVehicle [configName _classToUse, [0,0,0], [], 0, "CAN_COLLIDE"]; //spawn a vehicle
_tmpVehi setDir _spawnDir; //set vehicle direction
_tmpVehi setPos _spawnLocation; //set vehicle position

["Lottery", format ["God granted you a %1 (%2)", [_classToUse] call BIS_fnc_displayName, configName _classToUse]] remoteExec ["BIS_fnc_showSubtitle",0];
diag_log format ["God granted you a %1 (%2)", [_classToUse] call BIS_fnc_displayName, configName _classToUse];