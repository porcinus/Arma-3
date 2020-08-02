/*
	Author: 
		Karel Moricky, optimised by Killzone_Kid

	Description:
		Detects whether position is within trigger area
		or
		Calculates distance to the nearest edge of trigger area by using optional params

	Parameters:
		0: Area definition in any of the following formats:
			OBJECT - Trigger
			ARRAY - Area in format [center, distance] or [center, [a, b, angle, rect]] or [center, [a, b, angle, rect, height]]
			STRING - Marker
			LOCATION - Location
		1: ARRAY or OBJECT - Position to check
		2: BOOL (Optional) - true to return distance to closest edge of trigger area. Default: false
		3: BOOL (Optional) - true to include trigger area floor and ceiling in calculation when calculating distance to nearest edge. Default: false

	Returns:
		BOOL - true when position is in area, false if not
		or
		SCALAR (when _this select 2 is true) - distance from closest border: negative distance - from inside, positive distance - from outside
*/

params [["_area", objNull], ["_pos", [0,0,0]], ["_returnDistance", false], ["_includeFloorCeiling", false]];

_pos = _pos call BIS_fnc_position;
if (isNil "_pos") exitWith {false};

_area = _area call BIS_fnc_getArea; 

//--- Simple inside trigger area check
if !(_returnDistance isEqualTo true) exitWith {_pos inArea _area};

//--- Optional distance to closest border calculation
_area params ["_apos", "_ax", "_ay", "_adir", "_ashape", "_height"];

private _dist = call
{
	if (_ashape) exitWith 
	{
		//--- RECTANGLE
		private _reldir = _adir - (_apos getDir _pos);
		(_pos distance2D _apos) - (abs (_ax / cos (90 - _reldir)) min abs (_ay / cos _reldir))
	};
	
	//--- CIRCLE
	if (_ax == _ay) exitWith {(_pos distance2D _apos) - abs _ax};
	
	private ["_tmp", "_e", "_diff", "_posF1", "_posF2", "_dF1", "_dF2", "_delta"];
	
	//--- ELLIPSE
	if (_ax < _ay) then
	{
		_adir = _adir + 90;
		_tmp = _ax; _ax = _ay; _ay = _tmp;
	};
	
	_e = sqrt (_ax ^ 2 - _ay ^ 2);
	_diff = [(cos _adir) * _e, -(sin _adir) * _e, 0];
	
	_posF1 = _apos vectorDiff _diff;
	_posF2 = _apos vectorAdd _diff;
	
	_dF1 = _posF1 distance2D _pos;
	_dF2 = _posF2 distance2D _pos;
	
	_delta = ((_dF1 + _dF2) - 2 * _ax) * 0.5;
	
	if (_delta == 0) exitWith {0};
	
	private ["_d", "_r1", "_r2", "_a", "_p2"];
	
	_d = _posF1 distance2D _posF2;

	_r1 = _dF1 - _delta;
	_r2 = _dF2 - _delta;
	
	_a = (_r1 ^ 2 - _r2 ^ 2 + _d ^ 2 ) / (2 * _d);
	_p2 = _posF1 vectorAdd (_posF1 vectorFromTo _posF2 vectorMultiply _a);
  	
	((_posF2 vectorDiff _posF1) vectorMultiply (sqrt abs (_r1 ^ 2 - _a ^ 2) / _d)) params ["_vx", "_vy"];
	
	([1, -1] select (_delta < 0)) * (
		(_pos distance2D (_p2 vectorAdd [-_vy, _vx, 0])) 
		min 
		(_pos distance2D (_p2 vectorAdd [_vy, -_vx, 0]))
	) 
};

if (_height <= 0) exitWith {_dist}; //--- 2D border

//--- 3D border
private _az = _apos param [2, 0];
private _pz = _pos param [2, 0];

//--- Inside of 3D shape
if (_pos inArea _area) exitWith 
{
	//--- Distance to the nearest surface: top, bottom or border
	if (_includeFloorCeiling isEqualTo true) exitWith {(_pz - _az - _height) max (_az - _pz - _height) max _dist};
	//--- Distance to the nearest trigger area edge
	_dist
};

//--- Outside of 3D shape
if (_includeFloorCeiling isEqualTo true) exitWith 
{
	//--- Distance to the nearest surface: top, bottom or border
	sqrt ((_dist max 0) ^ 2 + (((_pz - _az - _height) max 0) + ((_pz - _az + _height) min 0)) ^ 2)
};
//--- Distance to the nearest trigger area edge
sqrt (_dist ^ 2 + (((_pz - _az - _height) max 0) + ((_pz - _az + _height) min 0)) ^ 2)