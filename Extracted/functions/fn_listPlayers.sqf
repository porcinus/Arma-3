/*
	Author: Karel Moricky, modified by Killzone_Kid

	Description:
	Returns list of playable units

	Returns:
	ARRAY - list of units
*/

(allUnits + allDead) select {isPlayer _x}