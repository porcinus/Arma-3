/*
	Author: Nelson Duarte <@Nelson_G_Duarte>

	Description:
	Whether given key is selected in 3den

	Parameter(s):
	_this select 0: Object	- The key object

	Returns:
	Bool - True if selected, false if not
*/

// Parameters
private _key = _this param [0, objNull, [objNull]];

// Key is selected
if (_key getVariable ["_edenSel", false]) exitWith
{
	true;
};

// Control points
private _arriveCP	= [_key] call BIS_fnc_key_getArriveControlPoint;
private _leaveCP	= [_key] call BIS_fnc_key_getLeaveControlPoint;

// No control points
if (isNull _arriveCP && {isNull _leaveCP}) exitWith
{
	false;
};

// Arrive selected
if (!isNull _arriveCP && {[_arriveCP] call BIS_fnc_controlPoint_edenIsSelected}) exitWith
{
	true;
};

// Leave selected
if (!isNull _leaveCP && {[_leaveCP] call BIS_fnc_controlPoint_edenIsSelected}) exitWith
{
	true;
};

// Return
false;