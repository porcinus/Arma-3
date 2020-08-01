/*
	Author: 
		Killzone_Kid

	Description:
		Compares all elements of passed array between each other and returns true is all are defined and identical.
		Very fast. Different from to BIS_fnc_areEqual in that nil values will not be considered equal to each other.

	Parameter(s):
		ARRAY of ANYTHING

	Returns:
		BOOL
		
	Example1: 
		[[1,2,[3,[4,5]]],[1,2,[3,[4,5]]],[1,2,[3,[4,5]]]] call BIS_fnc_areEqualNotNil; //true
		
	Example2: 
		[[1,2,[3,[4,nil]]],[1,2,[3,[4,nil]]],[1,2,[3,[4,nil]]]] call BIS_fnc_areEqualNotNil; //false
*/

/// --- validate general input
#include "..\paramsCheck.inc"
paramsCheck(_this,isEqualType,[])

if (!params [["_el", nil]]) exitWith {false};

(_this - [_el]) isEqualTo []