/*
	Author: Jiri Wainar

	Description:
	Returns closest available catapult to player.

	Parameter(s):
		0: availability condition
		1: distance

	Returns:
	Number with ID of the catapult, counting starting with 0.

	Example:
	[_condShow,_distance] call bis_fnc_carrier01CatapultID;
*/

#include "defines.inc"

params
[
	["_condShow",{true},["",{}]],
	["_distance",15,[123]]
];

if (_condShow isEqualType "") then
{
	["[ ] Custom show condition '%1' retyped from STRING to CODE!",_condShow] call bis_fnc_logFormat;

	_condShow = compile _condShow;
};

//exit if custom condition is not met
if (!alive player || {!canMove player}) exitWith {SET_CATAPULT_ID(CATAPULT_NONE);CATAPULT_NONE};

//exit if player is not capable of piloting
if !(call _condShow) exitWith {SET_CATAPULT_ID(CATAPULT_NONE);CATAPULT_NONE};

private _plane = cameraOn;

//exit if player is not piloting an airplane
if (player == _plane || {(driver _plane != player && (UAVControl _plane) param [1,""] != "DRIVER") || {!(_plane isKindOf 'Plane')}}) exitWith {SET_CATAPULT_ID(CATAPULT_NONE);CATAPULT_NONE};

//exit if plane is not capable of flying or getting attached to catapult (e.g. too high speed)
if (!alive _plane || {!canMove _plane || {!isEngineOn _plane || {speed _plane > ATTACH_MAX_SPEED}}}) exitWith {SET_CATAPULT_ID(CATAPULT_NONE);CATAPULT_NONE};

//check if airplane has unfolded wings
if (isNil{_plane getVariable "bis_wingFoldAnimations"}) then
{
	private _configPath = configFile >> "CfgVehicles" >> typeOf _plane  >> "AircraftAutomatedSystems";
	private _wingFoldAnimationsList = getArray (_configPath >> "wingFoldAnimations");
	private _wingStateUnFolded = getNumber (_configPath >> "wingStateUnFolded");

	_plane setVariable ["bis_wingFoldAnimations",_wingFoldAnimationsList];
	_plane setVariable ["bis_wingStateUnFolded",_wingStateUnFolded];
};
private _wingFoldAnimationsList = _plane getVariable ["bis_wingFoldAnimations",[]];
private _wingStateUnFolded = _plane getVariable ["bis_wingStateUnFolded",-1];

if ({_plane animationPhase _x != _wingStateUnFolded} count _wingFoldAnimationsList > 0) exitWith {SET_CATAPULT_ID(CATAPULT_NONE);CATAPULT_NONE};

//sort catapults according to distance to given plane
private _catapultsData = GET_CATAPULTS_DATA(GET_TRIGGER);
private _catapultsPositions = _catapultsData apply {(_x select 0) modelToWorldWorld ((_x select 0) selectionPosition (_x select 1))};

private _posPlane = getPosWorld _plane;
private _catapultsSorted = [_catapultsPositions,[],{_posPlane distance _x},"ASCEND",{_posPlane distance _x < _distance}] call BIS_fnc_sortBy;

//remove catapults that are occupied by other airplanes
_catapultsSorted = _catapultsSorted select {count((_x nearObjects ["Plane", 15]) - [_plane]) == 0};

//exit if there are no catapults nearby
if (count _catapultsSorted == 0) exitWith {SET_CATAPULT_ID(CATAPULT_NONE);CATAPULT_NONE};

private _catapultSelected = _catapultsPositions find (_catapultsSorted select 0);

SET_CATAPULT_ID(_catapultSelected);
SET_CATAPULT_LAST_ID(_catapultSelected);

_catapultSelected