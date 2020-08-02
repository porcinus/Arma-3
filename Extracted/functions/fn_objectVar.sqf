/*
	Author: Karel Moricky, modified by Jiri Wainar

	Description:
	Return an unique object variable.
	The variable is preserved after unit respawn.

	Parameter(s):
		0: OBJECT
		1 (Optional): STRING - variable name (number will be added behind it)

	Returns:
	STRING
*/

private _object = param [0,objnull,[objnull]];
if (isnull _object) exitwith {""};

private _var = _object getvariable ["#var",""];

if (_var == "") then
{
	//calculate dynamic variable
	_var = vehiclevarname _object;
	if (_var == "") then
	{
		private ["_varID","_netID","_netIDseparator"];

		_var = param [1,"bis_o",[""]];

		if (ismultiplayer) then
		{
			_netID = netid _object;
			_netIDseparator = _netID find ":";
			_var = _var + (_netID select [0,_netIDseparator]) + "_" + (_netID select [_netIDseparator + 1,100]);
		}
		else
		{
			_varID = [_var,1] call bis_fnc_counter;
			_var = _var + str _varID;
		};
	};

	_object setvariable ["#var",_var,true];
	missionnamespace setvariable [_var,_object,true];

	//execute where the unit is local, otherwise changes would not be restored after respawn
	if !(local _object) then {[[_object,_var],_fnc_scriptName,_object] call bis_fnc_mp;};
};
if (local _object && vehiclevarname _object == "") then
{
	_object setvehiclevarname _var;
	_object addeventhandler ["local",{[[_this select 0],"bis_fnc_objectVar",_this select 0] call bis_fnc_mp;}];
};
_var