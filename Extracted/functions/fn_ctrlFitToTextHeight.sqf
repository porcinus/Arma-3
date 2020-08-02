/*
	Author: Karel Moricky
	
	Description:
	Resize structured text control to fit its text height
	
	Parameters:
		0: CONTROL
		1: NUMBER - height offset (default is 0)
		2: NUMBER - commit time (default is 0)
	
	Returns:
	NUMBER - text height
*/

disableserialization;

private ["_control"];
_control = _this param [0,controlnull,[controlnull]];
if (ctrltype _control == 13) then {
	private ["_commitTime","_textHeight","_controlPos"];
	_offset = _this param [1,0,[0]];
	_commitTime = _this param [2,0,[0]];
	_textHeight = ctrltextheight _control;
	_controlPos = ctrlposition _control;
	_controlPos set [3,_textHeight + _offset];
	_control ctrlsetposition _controlPos;
	_control ctrlcommit _commitTime;
	_textHeight
} else {
	["Control %1 is of type %2, only controls of type 13 (Structured Text) can be resized.",_control,ctrltype _control] call bis_fnc_error;
	-1
};
