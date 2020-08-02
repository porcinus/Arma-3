/*
	Author: Karel Moricky

	Description:
	Create a building ruin and hide the original object

	Parameter(s):
		0: OBJECT

	Returns:
	OBJECT - ruin
*/

private _object = param [0,objnull,[objnull]];
if !(isnil {_object getvariable "BIS_fnc_createRuin_ruin"}) exitwith {objnull};

//--- Get ruin model and convert it to a class
private _ruinModel = gettext (configfile >> "CfgVehicles" >> typeof _object >> "DestructionEffects" >> "Ruin1" >> "type");
if (_ruinModel == "") exitwith {objnull};

private _ruinParsed = _ruinModel splitstring "\.";
if (count _ruinParsed < 2) exitwith {objnull};

//--- Create ruin
private _ruinClass = if ((_ruinParsed select (count _ruinParsed - 1) == "p3d")) then {_ruinParsed select (count _ruinParsed - 2)} else {_ruinParsed select (count _ruinParsed - 1)};
private _ruin = createvehicle ["Land_" + _ruinClass,position _object,[],0,"can_collide"];
_ruin setdir direction _object;
_ruin setpos (_object modeltoworldvisual (boundingCenter _object vectormultiply -1));
_ruin setVectorDirAndUp [vectordir _object,vectorup _object];

//--- Hide original object and create a link between them
_ruin setvariable ["BIS_fnc_createRuin_object",_object];
_object setvariable ["BIS_fnc_createRuin_ruin",_ruin];
_object hideobject true;

_ruin