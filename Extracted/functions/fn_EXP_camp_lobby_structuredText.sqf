/*

	PROJECT: R&D
	AUTHOR:  Endstar
	DATE:    18-04-2016

	fn_EXP_camp_lobby_structuredText.sqf

		Campaign Lobby: Formats structured text

	Params

		0:

	Return

		0:
*/

private _text			= _this select 0;
private _params			= _this select 1;

private _font 			= _params select 0;
private _color			= _params select 1;
private _align			= _params select 2;
private _valign			= _params select 3;
private _shadow			= _params select 4;
private _shadowColor	= _params select 5;
private _size			= _params select 6;

format
[
	"<t font='%1' t color='%2' t align='%3' t valign='%4' t shadow='%5' t shadowColor='%6' t size='%7'>%8</t>",
	_font,
	_color,
	_align,
	_valign,
	_shadow,
	_shadowColor,
	_size,
	_text
]