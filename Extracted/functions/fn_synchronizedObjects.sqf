/*
	Author: Jiri Wainar

	Description:
	Get all objects of given type directly synchronized to the given object. Works in EDEN too.

	Parameter(s):
	0: OBJECT - parent object
	1: STRING or ARRAY - class name filter; 1 or more classnames of objects we are interested about
	2: BOOL - precise match; default: true - only precise class names are considered, if false, inheritance is considered

	Returns:
	ARRAY - array of synchronized objects

	Example:
	[BIS_Poliakko,"LocationArea_F"] call BIS_fnc_synchronizedObjects;
*/

private _parent 		= _this param [0,objNull,[objNull]];
private _classnames 	= _this param [1,[],[[],""]];
private _preciseMatch 	= _this param [2,true,[true]];
private _output 		= [];
private _synced 		= objNull;

if (_classnames isEqualType "") then
{
	_classnames = [_classnames];
};

private _condition = if (_preciseMatch) then
{
	{typeOf _synced == _x};
}
else
{
	{_synced isKindOf _x};
};

private _objects = if (is3DEN) then
{
	(get3DENConnections _parent select {_x select 0 == "Sync"}) apply {_x select 1}
}
else
{
	synchronizedObjects _parent
};


{
	_synced = _x;

	if (_condition count _classnames > 0) then
	{
		_output pushBack _synced;
	};
}
forEach _objects;

_output