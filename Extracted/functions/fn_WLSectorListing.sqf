/*
WARLORDS-SPECIFIC FUNCTION

Author: Josef Zemánek

Description: Keeps track of sectors status for a given side.
*/

private ["_owned", "_available", "_pool", "_side"];

_side = _this # 0;
_pool = []; if (isNil "BIS_WL_sectors") then {_pool = _this # 1} else {_pool = BIS_WL_sectors};
_available = [];
_knots = []; if (_side == WEST) then {_knots = [BIS_WL_base_WEST]} else {_knots = [BIS_WL_base_EAST]};
_linked = _knots;

_owned = _pool select {(_x getVariable "BIS_WL_sectorSide") == _side};

while {count _knots > 0} do {
	_knotsCurrent = _knots;
	_knots = [];
	{
		{
			_link = _x;
			if (!(_link in _linked) && (_link in _owned)) then {_linked pushBack _link; _knots pushBack _link}
		} forEach (_x getVariable "BIS_WL_connectedSectors");
	} forEach _knotsCurrent;
};

{
	_sector = _x;
	if ((_sector getVariable "BIS_WL_sectorSide") != _side && _linked findIf {_sector in (_x getVariable "BIS_WL_connectedSectors")} >= 0) then {
		_available pushBack _sector;
	}
} forEach (_pool - _owned);

[_owned, _available, _linked]