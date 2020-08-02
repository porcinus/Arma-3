/*
	Author: 
		Killzone_Kid

	Description:
		Draws a static arrow (outline or color filled) on map

	Parameters:
		0: ARRAY - Arrow start in format [x,y] or [x,y,z]
		1: ARRAY - Arrow end in format [x,y] or [x,y,z]
		2 (Optional): ARRAY - Arrow line or fill color in format [r,g,b,a]. Default: [1,1,1,1]
		3 (Optional): ARRAY - Arrow geometry detail in format:
			0 (Optional): NUMBER - Arrow thickness in meters. Default: 10
			1 (Optional): NUMBER - Arrow head length compared to the total length of the arrow. Default: 1/3
			2 (Optional): NUMBER - Arrow head width compared to the arrow thickness. Default: 2
			3 (Optional): NUMBER - Arrow base width compared to the arrow thickness. Default: 1
		4 (Optional): BOOLEAN - TRUE to draw color filled arrow, FALSE to draw outline. Default: true
		5 (Optional): CONTROL - Map control. Default: control 51 of the main map display 12
		
		or
		
		ARRAY in format [idd, idc, ehId] - when arrow removal is wanted

	Returns:
		ARRAY - Arror removal information or [] on removal operation
		
	NOTE: The order in which arrows are drawn on map is reversed, arrow added last will be drawn under the arrow added first
*/

disableSerialization;

if (_this isEqualTypeParams [0,0,0]) exitWith 
{
	//--- removal wanted
	findDisplay (_this select 0) displayCtrl (_this select 1) ctrlRemoveEventHandler ["Draw", (_this select 2)];
	[]		
};

params 
[
	["_from", [0,0,0], [[]], [2,3]], 
	["_to", [0,0,0], [[]], [2,3]], 
	["_color", [1,1,1,1], [[]], [4]], 
	["_pars", []], 
	["_fill", true, [true]],
	["_map", findDisplay 12 displayCtrl 51, [controlNull]]
];

_to = +_to;
_to set [2, 0];

private _dir = _from getDir _to;
_pars params [["_width", 10, [0]], ["_headLCoef", 1/3, [0]], ["_headWCoef", 2, [0]], ["_baseWCoef", 1, [0]]];

// sanitise params
if (_width <= 0 || _headWCoef <= 0 || _headLCoef <= 0 || _baseWCoef <= 0) exitWith 
{
	["The arrow with given geometry %1 could not be drawn", _pars] call BIS_fnc_error;
	[]
};

private _pp = _to getPos [-(_from distance2D _to) * (_headLCoef min 1), _dir];
private _p1 = _pp getPos [_width * _headWCoef / 2, _dir - 90];
private _p2 = _pp getPos [_width * _headWCoef / 2, _dir + 90];

[
	ctrlIDD ctrlParent _map,
	ctrlIDC _map,
	_map ctrlAddEventHandler ["Draw", format 
	[
		"_this select 0 %1 [%2, %3%4", 
		["drawPolygon", "drawTriangle"] select _fill,
		call
		{
			if (_headLCoef < 1) exitWith
			{
				private _p3 = _pp getPos [_width / 2, _dir - 90];
				private _p4 = _pp getPos [_width / 2, _dir + 90];
				private _p5 = _from getPos [_width * _baseWCoef / 2, _dir - 90];
				private _p6 = _from getPos [_width * _baseWCoef / 2, _dir + 90];
				
				if (_fill) exitWith {[_to, _p1, _p2, _p3, _p5, _p6, _p6, _p4, _p3]};

				[_to, _p1, _p3, _p5, _p6, _p4, _p2]
			};
			
			[_to, _p1, _p2]
		},
		_color,
		["]", ",""#(rgb,1,1,1)color(1,1,1,1)""]"] select _fill
	]]
]