/*
NNS
Draw a "line" on the map using a rectangle marker

Example: _null = [marker_name,old_pos,new_pos,"ColorBlack",line_width,alpha,timeout] call NNS_fnc_MapDrawLine;
*/

params [
	["_id","marker0"],
	["_pos_start",[0,0,0]],
	["_pos_end",[1000,1000,0]],
	["_color","ColorRed"],
	["_width",1],
	["_alpha",1],
	["_timeout",0] //0 = no timeout
];

[format["NNS_fnc_MapDrawLine : start: %1, end: %2, color: %3, width: %4, alpha: %5, timeout: %6",_pos_start,_pos_end,_color,_width,_alpha,_timeout]] call NNS_fnc_debugOutput; //debug

if (getMarkerColor _id != "") then {deleteMarker _id;}; // if marker already exist, remove it

if (count _pos_start < 3) then {_pos_start append [0];}; //add z axis if needed
if (count _pos_end < 3) then {_pos_end append [0];}; //add z axis if needed

_center =  _pos_end vectorAdd ((_pos_start vectorDiff _pos_end) vectorMultiply 0.5); //marker center
_length =  (_pos_start vectorDistance _pos_end)/2; //marker length
_angle = round(((_pos_start select 0)-(_pos_end select 0)) atan2 ((_pos_start select 1)-(_pos_end select 1))); //marker angle

_marker = createMarker [_id,_center];
_marker setMarkerDir _angle;
_marker setMarkerShape "RECTANGLE";
_marker setMarkerBrush "SOLID";
_marker setMarkerColor _color;
_marker setMarkerSize [_width,_length];
_marker setMarkerAlpha _alpha;

if(_timeout > 0) then {
	_nul = [_marker,_timeout] spawn {sleep (_this select 1); deleteMarker (_this select 0);}; //remove marker after timeout
}else{_marker}; //return marker if no timeout