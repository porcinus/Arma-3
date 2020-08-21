/*
NNS
Not Mario Kart Knockoff
Apply rainbow color to object locally.
*/

params [
	["_obj", objNull], //object to apply color on, only affect selection 0
	["_alpha", 0.06], //alpha, default is a good value for sphere, from 0 to 1
	["_interval", 0.1] //update interval in sec
];

if (isNull _obj) exitWith {["MKK_fnc_objectRainbow: object is null"] call NNS_fnc_debugOutput};
if (_alpha < 0.001 || _alpha > 1) then {_alpha = 0.06}; //invalid alpha 
if (_interval < 0.01) then {_interval = 0.2}; //invalid interval 

private _hue = 0; //start hue value
while {sleep _interval; !isNull _obj} do { //loop until object become null
	_obj setObjectTexture [0, format ["#(argb,8,8,1)color(%1,%2,%3,%4,ca)", //set object texture
	linearConversion [0, 1, abs (((_hue + 1) mod 1) * 6 - 3) - 1, 0, 1, true], //red channel
	linearConversion [0, 1, abs (((_hue + (2/3)) mod 1) * 6 - 3) - 1, 0, 1, true], //green channel
	linearConversion [0, 1, abs (((_hue + (1/3)) mod 1) * 6 - 3) - 1, 0, 1, true], //blue channel
	_alpha]]; //alpha channel
	
	_hue = _hue + (_interval * 0.15); //next hue value
	if (_hue > 1) then {_hue = 0}; //hue overflow, reset to 0
};
