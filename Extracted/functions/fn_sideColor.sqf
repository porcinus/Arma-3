/*
	Author: 
		Karel Moricky, optimised by Killzone_Kid

	Description:
		Returns side color in RGBA format or marker color

	Parameter(s):
		0: SIDE or NUMBER - either side or side ID
		1: (Optional) - true to return marker color

	Returns:
		ARRAY [r,g,b,a] or STRING for marker color
*/

params [["_side", 7], ["_returnMarkerColor", false]];

/// --- engine constants
#define SIDES_ENUM [east, west, independent, civilian, sideUnknown, sideEnemy, sideFriendly, sideLogic, sideEmpty, sideAmbientLife]
#define MARKER_COLORS ["ColorEAST", "ColorWEST", "ColorGUER", "ColorCIV", "ColorUnknown", "ColorUnknown", "ColorUnknown", "ColorWEST", "ColorUnknown", "ColorCIV"]
#define SIDE_COLORS_CFG ["colorEnemy", "colorCivilian", "colorFriendly", "colorNeutral", "colorUnknown", "colorUnknown", "colorUnknown", "colorCivilian", "colorUnknown", "colorCivilian"]

if (_side isEqualType sideUnknown) then {_side = SIDES_ENUM find _side};

/// --- validate input
#include "..\paramsCheck.inc"
#define arr1 [_side,_returnMarkerColor]
#define arr2 [0,false]
paramsCheck(arr1,isEqualTypeParams,arr2)

if (_returnMarkerColor) exitWith {MARKER_COLORS param [_side, "ColorUnknown"]};

call compile format ["[%1]", getArray (configFile >> "cfgInGameUI" >> "isLandMap" >> SIDE_COLORS_CFG param [_side, "colorUnknown"]) joinString ","]