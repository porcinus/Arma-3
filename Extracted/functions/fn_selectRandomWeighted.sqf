/*
	Author:
		Joris-Jan van 't Land, optimized by Karel Moricky, optimised by Killzone_Kid, optimiception by Julien Vida

	Description:
		Select a random item from an array, taking into account item weight

	Parameters:
		0: ARRAY - items array (Array of ANYTHING) or array of items and weights [item, weight, item, weight...]
		1: ARRAY - weights array (Array of NUMBERS)

	Returns:
		ANYTHING - selected item

	Example:
		[["apples","pears","bananas","diamonds"],[0.3,0.2,0.4,0.1]] call BIS_fnc_selectRandomWeighted
		["apples",.3,"pears",.2,"bananas",.4,"diamonds",.1,"unicorns",.00001] call BIS_fnc_selectRandomWeighted

	NOTE:
		The weights don't have to total to 1
		The length of weights and items arrays may not match, in which case the shortest array is used for length
*/

// --- [[item, item], [weight, weight]]
if (_this isEqualTypeArray [[],[]]) exitWith {_this select 0 selectRandomWeighted (_this select 1)};

// --- [item, weight, item, weight]
if (_this isEqualType []) exitWith {selectRandomWeighted _this};

["Input format must be [[item, item, ...], [weight, weight, ...], ...] or [item, weight, item, weight, ...]"] call BIS_fnc_error;
nil 