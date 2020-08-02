#define VAR_OBJECT_BBD			"BIS_EGSpectator_objectBBD"

private "_object";
_object = _this select 0;

// Extract bounding box dimension only once per vehicle
if (!isNull _object && { _object isKindOf "Man" || { isNil { _object getVariable VAR_OBJECT_BBD } } }) then
{
	private ["_bbr", "_p1", "_p2", "_maxWidth", "_maxLength", "_maxHeight"];
	_bbr = boundingBoxReal _object;
	_p1 = _bbr select 0;
	_p2 = _bbr select 1;
	_maxWidth = abs ((_p2 select 0) - (_p1 select 0));
	_maxLength = abs ((_p2 select 1) - (_p1 select 1));
	_maxHeight = abs ((_p2 select 2) - (_p1 select 2));

	_object setVariable [VAR_OBJECT_BBD, [_maxWidth, _maxLength, _maxHeight]];
};

_object getVariable [VAR_OBJECT_BBD, [1,1,1]];