/*
	Author: Jiri Wainar

	Description:
	Set view distance.

	Parameter(s):
	NUMBER - view distance

	Returns:
	NUMBER - view distance
*/

private ["_viewDistance"];

_viewDistance = _this param [0,viewDistance,[0]];

setViewDistance _viewDistance;

_viewDistance