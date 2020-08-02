/*
	Author: Jiri Wainar

	Description:
	Return list of nearby enemy targets for given unit.

	Parameter(s):
	_this: unit that is inspected

	Returns:
	_targets:array (empty array if unit doesn't know about any enemy)

	Example:
	_targets:array = _unit call BIS_fnc_enemyTargets;
	_targets:array = [_unit(,_distance)] call BIS_fnc_enemyTargets;
*/

private _unit     = _this param [0,objNull,[objNull]];
private _distance = _this param [1,300,[123]];

private _enemySides = _unit call BIS_fnc_enemySides;

private _targets = if (_distance == -1) then
{
	((_unit targetsQuery [objNull, sideUnknown, "", [], 0]) select {(_x select 2) in _enemySides}) apply {_x select 1};
	//0.687758 ms
}
else
{
	//((_unit targetsQuery [objNull, sideUnknown, "", [], 0]) select {(_x select 2) in _enemySides && {_unit distance (_x select 4) < _distance}}) apply {_x select 1};
	//1.20627 ms

	//(_unit nearTargets _distance) apply {_x select 4} select {side _x in _enemySides}
	//0.788022 ms

	((_unit nearTargets _distance) select {(_x select 2) in _enemySides}) apply {_x select 4}
	//0.752445 ms
};

_targets