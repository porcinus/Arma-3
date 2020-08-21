/*
NNS
Not Mario Kart Knockoff
Create a marker.
Warning: Marker name is set by the function and return by it.
*/

params [
	["_pos", objNull], //marker position, object compatible
	["_dir", 0], //marker direction
	["_color", "ColorRed"], //marker color, https://community.bistudio.com/wiki/CfgMarkerColors_Arma_3
	["_type", "mil_destroy"], //marker type, https://community.bistudio.com/wiki/cfgMarkers
	["_text", ""] //marker text
];

if !(_pos isEqualType []) then {_pos = getPos _pos}; //is object, get position
private _tmpMarkerName = format ["mrk%1%2%3%4", round(random 1000), round(random 1000), round(random 1000), round(random 1000)]; //random name, a bit overkill but seeing how Arma random works, it is needed
private _tmpMarker = createMarker [_tmpMarkerName, _pos]; //create marker
_tmpMarkerName setMarkerColor _color; //set color
_tmpMarkerName setMarkerType _type; //set type
_tmpMarkerName setMarkerDir _dir; //set direction
_tmpMarkerName setMarkerText _text; //set text
_tmpMarkerName //return marker name