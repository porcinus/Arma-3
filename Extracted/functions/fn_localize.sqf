/*
	Author: Karel Moricky, optimised by Killzone_Kid

	Description:
	Checks if text is localization key and if so, return the localized text.

	Parameter(s):
	_this: STRING

	Returns:
	STRING
*/

/// --- validate general input
#include "..\paramsCheck.inc"
paramsCheck(_this,isEqualType,"")

if (isLocalized _this) then {localize _this} else {_this};