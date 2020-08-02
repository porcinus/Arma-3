/*
	Author: Karel Moricky

	Description:
	Adds money to heliport account.
	If account does not exist yet, it will create one.

	Parameter(s):
	_this select 0: NUMBER - Added amount

	Returns:
	NUMBER - Amount of money after transaction
*/

private ["_add","_money","_show"];

_add = _this param [0,0,[0]];
_show =	_this param [1,true,[true]];

//--- Get money
_money = [hsim_heliportDB,["money"]] call BIS_fnc_dbValueReturn;
if (isnil "_money") then {_money = 0;};

//--- Add money
_money = _money + _add;

//--- Save
[hsim_heliportDB,["money"],_money] call BIS_fnc_dbValueSet;

//--- Display
if (_add != 0) then {
	[_show,_add] spawn BIS_fnc_heliportMoneyDisplay;
};

_money