_logic = _this param [0,objnull,[objnull]];
_units = _this param [1,[],[[]]];
_activated = _this param [2,true,[true]];

if (_activated) then {
	_pos = position _logic;
	_dir = direction _logic;

	_texture = _logic getvariable ["Texture","#(argb,8,8,3)color(0,0,0,0)"];
	_color = call compile (_logic getvariable "Color");
	_w = (_logic getvariable ["Width","100"]) call bis_fnc_parsenumber;
	_h = (_logic getvariable ["Height","100"]) call bis_fnc_parsenumber;
	_text = _logic getvariable ["Text",""];
	_shadow = call compile (_logic getvariable "Shadow");

	if (isnil "_color") then {_color = [1,1,1,1];};
	if (isnil "_shadow") then {_shadow = false;};

	_texture = _texture param [0,"#(argb,8,8,3)color(0,0,0,0)",[""]];
	_color = [_color] param [0,[0,0,0,0],[[]],4];
	_w = _w param [0,100,[0]];
	_h = _h param [0,100,[0]];
	_text = _text param [0,"",[""]];
	_shadow = _shadow param [0,false,[false]];

	_logic setvariable ["data",[_texture,_color,_pos,_w,_h,_dir,_text,_shadow]];
};