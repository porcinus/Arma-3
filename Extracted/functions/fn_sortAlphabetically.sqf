/*
	Author: Karel Moricky, optimised by Killzone_Kid

	Description:
	Sort an array of strings alphabetically

	Parameter(s):
	ARRAY ot STRINGs

	Returns:
	ARRAY ot STRINGs
*/

/// --- validate general input
#include "..\paramsCheck.inc"
paramsCheck(_this,isEqualType,[])

_this = +_this;

_this sort true;

_this