/*
NNS
Not Mario Kart Knockoff
Switch kart color globally.
*/

params [
	["_obj", objNull], //kart object
	["_color", "red"] //wanted color
]; 

private _allowedColors = ["black", "blue", "green", "orange", "red", "white", "yellow"]; 

if (isNull _obj) exitWith {["MKK_fnc_switchKartColor: object is null"] call NNS_fnc_debugOutput};
if !(toLower _color in _allowedColors) exitWith {[format ["MKK_fnc_switchKartColor: wrong color : %1", _color]] call NNS_fnc_debugOutput};

private _textureArr = getArray (configfile >> "CfgVehicles" >> "C_Kart_01_F" >> "TextureSources" >> _color >> "textures"); //get textures list
private _textureCount = (count _textureArr) - 1; //texture count - 1

for "_i" from 0 to _textureCount do { //textures loop
	[_obj, [_i, _textureArr select _i]] remoteExec ["setObjectTexture", 0, true]; //set global texture
};

_obj //return object