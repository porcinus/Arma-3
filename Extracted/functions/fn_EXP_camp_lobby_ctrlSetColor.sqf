/*

	PROJECT: R&D
	AUTHOR:  Endstar
	DATE:    18-04-2016

	fn_EXP_camp_lobby_ctrlSetColor.sqf

		Campaign Lobby: Updates controls with defined colors

	Params

		0:

	Return

		0:
*/

disableSerialization;

// Init params
private _ctrl					= _this select 0;
private _params					= _this select 1;
private _bCommit				= _this select 2;

private _colorBackground		= _params select 0;
private _colorText				= _params select 1;

if (_colorBackground != "") then
{
	// Apply background colour
	_ctrl ctrlSetBackgroundColor	([_colorBackground] call BIS_fnc_HEXtoRGB);
};

if (_colorText != "") then
{
	// Apply text colour
	_ctrl ctrlSetTextColor			([_colorText] call BIS_fnc_HEXtoRGB);
};

if (_bCommit) then
{
	_ctrl ctrlCommit 0;
};