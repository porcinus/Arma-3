#define COMMIT_TIME	15

/*
	Author: Karel Moricky

	Description:
	It's showtime!

	Parameter(s):
	_this select 0: STRUCTURED TEXT: Header text
	_this select 1: STRUCTURED TEXT: Bottom text (moving)

	Returns:
	Nothing
*/
disableserialization;

params [
	["_header",parsetext "",[parsetext ""]],
	["_line",parsetext "",[parsetext ""]]
];

_fnc_scriptname cutrsc ["rscAAN","plain"];
private _display = uinamespace getvariable "BIS_AAN";
private _textHeader = _display displayctrl 3001;
_textHeader ctrlsetstructuredtext _header;//parsetext "<t size='2.3'>Military press conference</t><br />Col. Kane announces the end of the op. Arrowhead";
_textHeader ctrlcommit 0;

private _textLine1 = _display displayctrl 3002;
private _textLine2 = _display displayctrl 3004;
private _textClock = _display displayctrl 3003;

_textLine1 ctrlsetstructuredtext _line;
_textLine2 ctrlsetstructuredtext _line;

(ctrlposition _textLine1) params ["_posX","_posY","_posW","_posH"];
private _posW = ctrltextwidth _textLine1;
private _speed = _posW / safezoneW;
_textLine1 ctrlsetposition [_posX,_posY,_posW,_posH];
_textLine2 ctrlsetposition [_posX + _posW,_posY,_posW,_posH];
_textLine1 ctrlcommit 0;
_textLine2 ctrlcommit 0;
_textLine1 ctrlsetposition [_posX - _posW,_posY,_posW,_posH];
_textLine2 ctrlsetposition [_posX - _posW,_posY,_posW,_posH];
_textLine1 ctrlcommit (_speed * COMMIT_TIME);
_textLine2 ctrlcommit (_speed * COMMIT_TIME * 2);

while {!isnull _display} do {

	_textClock ctrlsettext ([daytime,"HH:MM"] call bis_fnc_timetostring);
	_textClock ctrlcommit 0;
	private _minute = date # 4;
	waituntil {
		if (ctrlcommitted _textLine1) then {
			_textLine1 ctrlsetposition [_posX + _posW,_posY,_posW,_posH];
			_textLine1 ctrlcommit 0;
			_textLine1 ctrlsetposition [_posX - _posW,_posY,_posW,_posH];
			_textLine1 ctrlcommit (_speed * COMMIT_TIME * 2);
			private _textLineTemp = _textLine1;
			_textLine1 = _textLine2;
			_textLine2 = _textLineTemp;
		};
		(date # 4) != _minute || isnull _display
	};
};