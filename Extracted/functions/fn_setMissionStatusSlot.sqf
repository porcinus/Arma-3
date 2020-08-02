/*
	Author: Karel Moricky

	Description:
	Set  a slot for mission status with sectors, respawn tickets, etc.

	Parameter(s):
		0: NUMBER - slot ID. Use -1 to assign it automatically
		1: STRING - text
		2: STRING - icon path
		3: ARRAY - color in RGBA format
		4: NUMBER - slot fade, 0 is fully visible, 0 hidden
		5: ARRAY in Position format - position top which camera moves after clicking on the slot
		6: NUMBER - slot progress bar height in range <0;1>

	Returns:
	NUMBER - slot ID
*/

private ["_id","_text","_texture","_color","_fade","_position","_barHeight","_icons"];
_id = _this param [0,-1,[0]];
_text = _this param [1,"",["",false]];
_texture = _this param [2,"",[""]];
_color = _this param [3,[0,0,0,0],[[]],4];
_fade = _this param [4,0,[0]];
_position = _this param [5,[],[[]]];
_barHeight = _this param [6,0,[0]];

_icons = missionnamespace getvariable ["RscMissionStatus_icons",[]];
if (_id < 0) then {_id = count _icons;};

if (typename _text == typename "") then {
	//--- Add
	_icons set [_id,[_text,_texture,_color,_fade,_position,_barHeight]];
} else {
	//--- Remove
	_icons set [_id,nil];
};

missionnamespace setvariable ["RscMissionStatus_icons",_icons];
_id