/*
	Author: 
		Killzone_Kid

	Description:
		Extracts area information from trigger, marker, location or array

	Parameter(s):
		_this: 	
				OBJECT - trigger
				STRING - marker
				ARRAY - array in format [center, distance] or [center, [a, b, angle, rect, (height)]] or [center, a, b, angle, rect, (height)]
				LOCATION - location

	Returns:
		ARRAY in format [center, a, b, angle, isRectangle, height]

*/

// is trigger
if (_this isEqualType objNull && {_this isKindOf "EmptyDetector"}) exitWith {[ASLToAGL getPosASL _this] + triggerArea _this};

// is marker
if (_this isEqualType "" && {markerShape _this in ["ELLIPSE", "RECTANGLE"]}) exitWith {[markerPos _this] + markerSize _this + [markerDir _this, markerShape _this isEqualto "RECTANGLE", -1]};

// is location
if (_this isEqualType locationNull) exitWith {[locationPosition _this] + size _this + [direction _this, rectangular _this, -1]};

// array in format [center, a, b, angle, rect, (height)]
if (_this isEqualTypeArray [[], 0, 0, 0, false]) exitWith {_this + [-1]};
if (_this isEqualTypeArray [[], 0, 0, 0, false, -1]) exitWith {_this};

// array in format [center, [a, b, angle, rect, (height)]]
private _center = [param [0] call BIS_fnc_position] param [0, [0, 0, 0]];
private _area = param [1, [0, 0, 0, false, -1]];

// area is radius
if (_area isEqualType 0) exitWith {[_center, _area, _area, 0, false, -1]};

// area is array
if !(_area isEqualType []) exitWith {[[0, 0, 0], 0, 0, 0, false, -1]};
if (_area isEqualTypeArray [0, 0, 0, false, -1]) exitWith {[_center] + _area};
if (_area isEqualTypeArray [0, 0, 0, false]) exitWith {[_center] + _area + [-1]};

// is unknown
[[0, 0, 0], 0, 0, 0, false, -1]