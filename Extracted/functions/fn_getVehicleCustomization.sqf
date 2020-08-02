/*
	Author: 
		Karel Moricky, optimized by Julien `Tom_48_97` V., modified by Killzone_Kid

	Description:
		Return vehicle customization settings

	Parameter(s):
		0: OBJECT
		1 (Optional) STRING - object class override

	Returns:
		ARRAY in format [<texture>,<animations>]
		e.g., [["wasp",1],["AddTread",0,"AddTread_Short",1]]
*/

private _fnc_compareTextures = 
{
	params ["_vehtex", "_cfgtex"];
	if (_cfgtex isEqualTo "") exitWith { true }; // empty/absent config texture == any texture
	if (_vehtex find "\" != 0) then {_vehtex = "\" + _vehtex};
	if (_cfgtex find "\" != 0) then {_cfgtex = "\" + _cfgtex};
	_vehtex == _cfgtex
};

private _center = param [0,objnull,[objnull]];
private _centerType = param [1,typeof _center,[""]];
private _cfg = configFile >> "cfgVehicles" >> _centerType;

//--- Read textures
private _texture = [];
private _currentTextures = getObjectTextures _center;
{
	if (
		!(getText (_x >> "displayName") isEqualTo "") 
		&& 
		{ !isNumber (_x >> "scope") }
		&& 
		{ !(getNumber (_x >> "scope") > 0) } 
		&& 
		{ 	
			private _textures = getArray (_x >> "textures");
			private _decals = getArray (_x >> "decals");
			{
				if !(_forEachIndex in _decals || { [_x, _textures param [_forEachIndex, ""]] call _fnc_compareTextures }) exitWith { false };
				true
			}
			forEach _currentTextures;
		}
	) 
	exitWith 
	{ 
		_texture = [configName _x, 1]; 
	};
} 
forEach configProperties [_cfg >> "textureSources", "isClass _x", true];

//--- Read animations
private _animations = [];
{
	if (
		!(getText (_x >> "displayName") isEqualTo "")
		&& 
		{ !isNumber (_x >> "scope") }
		&& 
		{ !(getNumber (_x >> "scope") > 0) }
	) 
	then
	{
		private _animation = configName _x;
		_animations append [_animation, _center animationPhase _animation];
	};
} 
forEach configProperties [_cfg >> "animationSources", "isClass _x", true];

[_texture, _animations]