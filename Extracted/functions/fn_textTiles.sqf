/*
	Author: Karel Moricky

	Description:
	Show animated text

	Parameter(s):
	0: Content
		STRING - Picture
		STRUCTURED TEXT - Text
	1 (Optional):
		ARRAY - Position in format [x,y,w,h]
		BOOL - Use "Mission" area position (customizable in Layout options menu)
	2 (Optional): ARRAY - Tile size in format [w,h]
	3 (Optional): NUMBER - Duration in seconds (default: 5)
	4 (Optional): NUMBER - Fade in/out time (default: 0.5)
	5 (Optional): NUMBER - Tile transparency (default: 0.3)

	Returns:
	BOOL - true
*/

if (!canSuspend) exitWith { _this spawn BIS_fnc_textTiles; true };

#include "\A3\ui_f\hpp\defineCommonGrids.inc"

disableserialization;

params
[
	["_content", "#(argb,8,8,3)color(1,0,1,1)", ["", parsetext ""]],
	["_pos", [0,0,1,1], [[], true], 4],
	["_size", 10, [0, []]],
	["_duration", 5, [0]],
	["_fade", [], [0, []]],
	["_maxAlpha", 0.3, [0]]
];

if (_size isEqualType 0) then { _size = [_size,_size] };

private _fadeIn = _fade param [0, 0.5, [0]];
private _fadeOut = _fade param [1, _fadeIn, [0]];

if (_pos isEqualType true) then 
{
	if (_pos) then 
	{
		_pos = 
		[
			IGUI_GRID_MISSION_X,
			IGUI_GRID_MISSION_Y,
			IGUI_GRID_MISSION_WAbs,
			IGUI_GRID_MISSION_HAbs
		];
		_size = 
		[
			IGUI_GRID_MISSION_WAbs / IGUI_GRID_MISSION_W / 2,
			IGUI_GRID_MISSION_HAbs / IGUI_GRID_MISSION_H
		];
	} 
	else 
	{
		_pos = [safeZoneX, safeZoneY, safeZoneW, safeZoneH];
	};
};

_pos params ["_posX", "_posY", "_posW", "_posH"];
_size params ["_sizeX", "_sizeY"];

private _sizeW = _posW / _sizeX;
private _sizeH = _posH / _sizeY;

("bis_fnc_textTiles" call bis_fnc_rscLayer) cutrsc ["RscTilesGroup","plain"];
private _display = uinamespace getvariable "RscTilesGroup";

private _xList = [0,1,2,3,4,5,6,7,8,9];
private _yList = [0,1,2,3,4,5,6,7,8,9];
private _groupContent = controlNull;

_xList resize _sizeX;
_yList resize _sizeY;

private _gridsDef = [];

for "_x" from 0 to _sizeX - 1 do 
{
	for "_y" from 0 to _sizeY - 1 do 
	{
		_gridsDef pushBack [_x,_y];
	};
};

private _grids = +_gridsDef;

while {count _grids > 0} do 
{
	private _index = floor random count _grids;
	_grids deleteAt _index params ["_ix", "_iy"];

	//--- Group
	private _group = _display displayctrl (1000 + _ix * 10 + _iy);
	_group ctrlsetposition [
		_posX + _ix * _sizeW,
		_posY + _iy * _sizeH,
		_sizeW,
		_sizeH
	];
	_group ctrlcommit 0;
	
	//--- Content
	if (_content isEqualType "") then 
	{
		_groupContent = _display displayctrl (1200 + _ix * 10 + _iy);
		_groupContent ctrlsettext _content;
	} 
	else 
	{
		_groupContent = _display displayctrl (1100 + _ix * 10 + _iy);
		_groupContent ctrlsetstructuredtext _content;
	};
	
	_groupContent ctrlsetposition [
		- _ix * _sizeW,
		- _iy * _sizeH - 0.1 + random 0.2,
		_posW,
		_posH
	];
	//_color = random 0.5;
	private _color = random 0.4;

	//_alpha = if (random 1 > 0.1) then {0.3} else {0};
	private _alpha = if (random 1 > 0.1) then {_maxAlpha} else {_maxAlpha * 0.5};

	_groupContent ctrlsetbackgroundcolor [_color,_color,_color,_alpha];
	_groupContent ctrlsetfade 1;
	_groupContent ctrlcommit 0;

	//--- Animate
	_groupContent ctrlsetposition [
		- _ix * _sizeW,
		- _iy * _sizeH,
		_posW,
		_posH
	];
	
	_groupContent ctrlsetfade 0;
	_groupContent ctrlcommit (random _fadeIn);
	//sleep 0.01;
};

sleep (_fadeIn + _duration);

_grids = +_gridsDef;

while {count _grids > 0} do 
{
	private _index = floor random count _grids;
	_grids deleteAt _index params ["_ix", "_iy"];

	if (_content isEqualType "") then 
	{
		_groupContent = _display displayctrl (1200 + _ix * 10 + _iy);
	} 
	else 
	{
		_groupContent = _display displayctrl (1100 + _ix * 10 + _iy);
	};

	_groupContent ctrlsetposition [
		- _ix * _sizeW,
		- _iy * _sizeH - 0.1 + random 0.2,
		_posW,
		_posH
	];
	//_groupContent ctrlsetbackgroundcolor [0,0,0,0];
	_groupContent ctrlsetfade 1;
	_groupContent ctrlcommit (random _fadeOut);
	//sleep 0.01;
};

true 