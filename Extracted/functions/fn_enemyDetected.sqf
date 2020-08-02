/*
	Author: Jiri Wainar

	Description:
	Return true if unit knows about nearby enemy unit or driven vehicle.

	Parameter(s):
	_this: unit that is inspected

	Returns:
	_knowsAboutEnemy:bool

	Example:
	_knowsAboutEnemy:bool = _unit call BIS_fnc_enemyDetected;
	_knowsAboutEnemy:bool = [_unit(,_distance)] call BIS_fnc_enemyDetected;
*/

private _unit     = _this param [0,objNull,[objNull]];
private _distance = _this param [1,300,[123]];

private _detected   = false;

private _targets = _unit targetsQuery [objNull, sideUnknown, "", [], 0];
private _enemySides = _unit call BIS_fnc_enemySides;

if (_distance == -1) then
{
	{if ((_x select 2) in _enemySides) exitWith {_detected = true}} forEach _targets;
}
else
{
	{if ((_x select 2) in _enemySides && {_unit distance (_x select 4) < _distance}) exitWith {_detected = true}} forEach _targets;
};

_detected