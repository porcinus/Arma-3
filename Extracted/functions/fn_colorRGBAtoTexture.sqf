/*
	Author: 
		Karel Moricky, optimised by Killzone_Kid

	Description:
		Converts RGB color format to procedural texture.
		[0,0,0,1] becomes "#(argb,8,8,3)color(0,0,0,1)"

	Parameter(s):
		0: ARRAY - color in RGBA format [R,G,B,A]

	Returns:
		STRING
*/

/// --- validate input
#include "..\paramsCheck.inc"
#define arr [0,0,0,0]
paramsCheck(_this,isEqualTypeParams,arr)

params ["_r","_g","_b","_a"];

format [
	"#(argb,8,8,3)color(%1,%2,%3,%4)", 
	linearConversion [0, 1, _r, 0, 1, true],
	linearConversion [0, 1, _g, 0, 1, true],
	linearConversion [0, 1, _b, 0, 1, true],
	linearConversion [0, 1, _a, 0, 1, true]
]
