/*
WARLORDS-SPECIFIC FUNCTION

Author: Josef Zemánek

Description: Evaluates sector grid so it can be drawn on map.
*/

private ["_ret", "_network", "_color", "_owned"];

_ret = [];
_color = 0;
_network = _this # 0;
_owned = _this # 1;

{
	_x setVariable ["BIS_WL_linkedWith", []];
} forEach _network;

{
	_hub = _x;
	{
		_node = _x;
		if (!(_node in (_hub getVariable "BIS_WL_linkedWith")) && !(_hub in (_node getVariable "BIS_WL_linkedWith"))) then {
			if ([_node, _hub] findIf {_x in _owned} >= 0) then {
				_color = [0,1,0,1];
			} else {
				_color = [1,0,0,1];
			};
			_ret pushBack [_hub, _node, _color];
			_hub setVariable ["BIS_WL_linkedWith", (_hub getVariable "BIS_WL_linkedWith") + [_node]];
			_node setVariable ["BIS_WL_linkedWith", (_node getVariable "BIS_WL_linkedWith") + [_hub]];
		};
	} forEach (_hub getVariable "BIS_WL_connectedSectors");
} forEach _network;

_ret