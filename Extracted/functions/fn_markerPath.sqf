/*
	Author: Karel Moricky

	Description:
	Creater marker(s) between two points

	Parameter(s):
	_this select 0: start (value type see _this select 1)
	_this select 1: end
		ARRAY - position [x,y] or [x,y,z] or waypoint position [GROUP,NUMBER]
		OBJECT - object's position
		LOCATION - location's position
		STRING - marker's position
	_this select 2 (Optional): NUMBER - distance between markers.
		When value is negative, line marker is used instead with thickness of this value
	_this select 3 (Optional): ARRAY - marker params (see BIS_fnc_markerCreate for details)

	Returns:
	ARRAY - list of created markers
*/

//--- Marker settings
private _markerCounterVar = _fnc_scriptName + "_counter";
private _markerCounter = if (isnil _markerCounterVar) then {0} else {missionnamespace getvariable _markerCounterVar};
missionnamespace setvariable [_markerCounterVar,_markerCounter + 1];
private _markerCounterLocal = 0;
private _markerParamsDefault = [
	[_fnc_scriptName + "_marker_%1",_markerCounter],
	"mil_triangle",
	"colorgreen"
];

//--- Init params
private _paramStart =	_this param [0,[0,0,0],[[],objnull,"",locationnull]];
private _paramEnd =	_this param [1,[0,0,0],[[],objnull,"",locationnull]];
private _markerDis =	_this param [2,1000,[0]];
private _markerParams =	_this param [3,_markerParamsDefault,[[]]];

//--- Convert position
_fnc_returnPos = {
	switch (typename _this) do {
		case (typename []): {
			private _px = _this param [0,0,[0,grpnull]];
			private _py = _this param [1,0,[0]];
			private _pz = _this param [2,0,[0]];
			if (typename _px == typename grpnull) then {

				//--- Waypoint
				waypointposition [_px,_py]
			} else {

				//--- Position
				[_px,_py,_pz]
			};
		};

		//-- Object
		case (typename objnull): {
			position _this
		};

		//--- Location
		case (typename locationnull): {
			locationposition _this
		};

		//--- Marker
		case (typename ""): {
			markerpos _this
		};
	};
};

private _posStart = _paramStart call _fnc_returnPos;
private _posEnd = _paramEnd call _fnc_returnPos;

private _dir = [_posStart,_posEnd] call bis_fnc_dirto;
private _dis = [_posStart,_posEnd] call bis_fnc_distance2D;

//--- Line marker
if (_markerDis <= 0) then {
	_markerParams = [[abs _markerDis,_dis/2]] + _markerParams;
	_markerDis = _dis/2;
};

private _listMarkers = [];
for "_m" from _markerDis to _dis step _markerDis do {
	if (round _m >= round _dis) exitwith {};
	private ["_marker","_markerPos"];
	_markerPos = [
		(_posStart select 0) + (sin _dir * _m),
		(_posStart select 1) + (cos _dir * _m),
		0
	];

	if (_m == _markerDis) then {
		_marker = _markerParams call bis_fnc_markerCreate;
		_marker setmarkerpos _markerPos;
		_marker setmarkerdir _dir;
		_markerParams = _marker call bis_fnc_markerParams;
		_markerParams set [0,((_markerParams select 0) select 0) + "_%1"];
	} else {
		_marker = createmarker [format [(_markerParams select 0),_markerCounterLocal],_markerPos];
		_marker setmarkerdir _dir;
		_marker setmarkersize (_markerParams select 2);
		_marker setmarkercolor (_markerParams select 3);
		_marker setmarkertype (_markerParams select 4);
		_marker setmarkerbrush (_markerParams select 5);
		_marker setmarkershape (_markerParams select 6);
		_marker setmarkeralpha (_markerParams select 7);
		_marker setmarkertext (_markerParams select 8);
	};
	_listMarkers set [count _listMarkers,_marker];
	_markerCounterLocal = _markerCounterLocal + 1;
};

_listMarkers