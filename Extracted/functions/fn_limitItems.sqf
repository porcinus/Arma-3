/*
	Author: Vaclav "Watty Watts" Oliva

	Description:
	Keeps or removes unit's items (including NVGs and binocular/designator) based on probability user sets.
	- use 0-100 to randomize the chance of keeping the current attachment
	- use 100 to always keep the attachment
	- use 0 to always remove the attachment

	Parameters:
	Select 0 - OBJECT: Target unit
	Select 1 - NUMBER: Chance to keep the NVGs. Default is 50.
	Select 2 - NUMBER: Chance to keep the binocular. Default is 50.
	Select 3 - NUMBER: Chance to keep the GPS. Default is 50.
	Select 4 - NUMBER: Chance to keep the map. Default is 50.
	Select 5 - NUMBER: Chance to keep the radio. Default is 50.
	Select 6 - NUMBER: Chance to keep the compass. Default is 50.
	Select 7 - NUMBER: Chance to keep the watch. Default is 50.

	Returns:
	Boolean

	Examples:
	_limit = [player] call BIS_fnc_limitItems;
	_limit = [player,0,15,30,45,60,75,90] call BIS_fnc_limitItems;
*/

// Params
params
[
	["_unit",objNull,[objNull]],
	["_NVGChance",50,[999]],
	["_BinocularChance",50,[999]],
	["_GPSChance",50,[999]],
	["_MapChance",50,[999]],
	["_RadioChance",50,[999]],
	["_CompassChance",50,[999]],
	["_WatchChance",50,[999]]
];

// Check for validity
if (isNull _unit) exitWith {["Unit items removal: unit %1 does not exist.",_unit] call BIS_fnc_logFormat; false};
if ((_NVGChance < 0) or (_NVGChance > 100)) exitWith {["Unit items removal: NVG chance %1 not 0-100.",_NVGChance] call BIS_fnc_logFormat; false};
if ((_BinocularChance < 0) or (_BinocularChance > 100)) exitWith {["Unit items removal: Binocular chance %1 not 0-100.",_BinocularChance] call BIS_fnc_logFormat; false};
if ((_GPSChance < 0) or (_GPSChance > 100)) exitWith {["Unit items removal: GPS chance %1 not 0-100.",_GPSChance] call BIS_fnc_logFormat; false};
if ((_MapChance < 0) or (_MapChance > 100)) exitWith {["Unit items removal: Map chance %1 not 0-100.",_MapChance] call BIS_fnc_logFormat; false};
if ((_RadioChance < 0) or (_RadioChance > 100)) exitWith {["Unit items removal: Radio chance %1 not 0-100.",_RadioChance] call BIS_fnc_logFormat; false};
if ((_CompassChance < 0) or (_CompassChance > 100)) exitWith {["Unit items removal: Compass chance %1 not 0-100.",_CompassChance] call BIS_fnc_logFormat; false};
if ((_WatchChance < 0) or (_WatchChance > 100)) exitWith {["Unit items removal: Watch chance %1 not 0-100.",_WatchChance] call BIS_fnc_logFormat; false};

// Binoculars
private _unitBinoculars = getUnitLoadout _unit select 8;

if (count _unitBinoculars > 0)
then
{
	_random = random 100;
	if (_random > _BinocularChance) then
	{
		_unitBinoculars = [];
	};
};

// Items + NVGs
private _unitItems = getUnitLoadout _unit select 9;
private _unitMap = _unitItems select 0;
private _unitGPS = _unitItems select 1;
private _unitRadio = _unitItems select 2;
private _unitCompass = _unitItems select 3;
private _unitWatch = _unitItems select 4;
private _unitNVG = _unitItems select 5;

// Map
if (_unitMap != "")
then
{
	_random = random 100;
	if (_random > _MapChance)
	then
	{
	        _unitMap = "";
	};
};

// GPS
if (_unitGPS != "")
then
{
	_random = random 100;
	if (_random > _GPSChance)
	then
	{
		_unitGPS = "";
	};
};

// Radio
if (_unitRadio != "")
then
{
	_random = random 100;
	if (_random > _RadioChance)
	then
	{
		_unitRadio = "";
	};
};

// Compass
if (_unitCompass != "")
then
{
	_random = random 100;
	if (_random > _CompassChance)
	then
	{
		_unitCompass = "";
	};
};

// Watch
if (_unitWatch != "")
then
{
	_random = random 100;
	if (_random > _WatchChance)
	then
	{
		_unitWatch = "";
	};
};

// NVGs
if (_unitNVG != "")
then
{
	_random = random 100;
	if (_random > _NVGChance)
	then
	{
		_unitNVG = "";
	};
};

// Set final loadout
_unit setUnitLoadout [nil,nil,nil,nil,nil,nil,nil,nil,_unitBinoculars,[_unitMap,_unitGPS,_unitRadio,_unitCompass,_unitWatch,_unitNVG]];

// Returns
true
