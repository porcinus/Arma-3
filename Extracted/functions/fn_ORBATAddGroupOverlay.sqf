/*
	Author: Karel Moricky

	Description:
	Register texture(s) to be displayed over CfgORBAT group.

	Parameter(s):
		0: CONFIG - path to group in CfgORBAT.
		1: STRING - texture
		2: ARRAY - color in format [R,G,B,A]
		3: NUMBER - original icon width multiplier
		4: NUMBER - original icon height multiplier
		5: NUMBER - angle
		6: STRING - text
		7: BOOL - shadow

	Returns:
	NUMBER - overlay ID (used by BIS_fnc_ORBATRemoveGroupOverlay)
*/
private ["_group","_texture","_color","_width","_height","_angle","_text","_shadow","_groupArray","_params","_paramID"];
_group = _this param [0,configfile,[configfile]];
_texture = _this param [1,"#(argb,8,8,3)color(1,0,1,1)",[""]];
_color = _this param [2,[1,1,1,1],[[],{}]];
_width = _this param [3,1,[0,{}]];
_height = _this param [4,1,[0,{}]];
_angle = _this param [5,0,[0,{}]];
_text = _this param [6,"",[""]];
_shadow = _this param [7,false,[false]];

_texture = _texture call bis_fnc_textureMarker;

_groupArray = [_texture,_color,_width,_height,_angle,_text,_shadow];

if (isnil "BIS_fnc_ORBATAddGroupOverlay_groups") then {BIS_fnc_ORBATAddGroupOverlay_groups = [];};
_groupID = BIS_fnc_ORBATAddGroupOverlay_groups find _group;
if (_groupID < 0) then {
	//--- Create a new entry
	BIS_fnc_ORBATAddGroupOverlay_groups set [count BIS_fnc_ORBATAddGroupOverlay_groups,_group];
	BIS_fnc_ORBATAddGroupOverlay_groups set [count BIS_fnc_ORBATAddGroupOverlay_groups,[_groupArray]];
	0
} else {
	//--- Expand existing entry
	_params = BIS_fnc_ORBATAddGroupOverlay_groups select (_groupID + 1);
	_paramID = count _params;
	_params set [_paramID,_groupArray];
	_paramID
};