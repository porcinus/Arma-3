/*
	Author: 
		Killzone_Kid
		
	Description:
		Performs bitwise OR operation on decimal or hexadecimal unsigned 24 bit integer
		(Hexadecimal number representation is simply auto-converted into decimal by the engine)
		
	Parameters:
		0: [NUMBER] - decimal or hexadecimal unsigned 24 bit integer
		1: [NUMBER] - decimal or hexadecimal unsigned 24 bit integer
		
	Return:
		[NUMBER] - decimal number
		
	Examples:
		[2 + 4 + 8 + 32, 1] call BIS_fnc_bitwiseOR // 47
		[1 + 2 + 16 + 32, 4 + 8] call BIS_fnc_bitwiseOR // 63
		[1 + 2 + 16 + 32, 4 + 32] call BIS_fnc_bitwiseOR // 55
		[1 + 2 + 16 + 32, 16 + 32] call BIS_fnc_bitwiseOR // 51
		
	Limitations:
		Due to various limitations of the Real Virtuality engine this function is 
		intended to work with unsigned 24 bit integers only. This means that the 
		supported range is 2^0...2^24 (1...16777216)
*/

params [["_num1", 0, [0]], ["_num2", 0, [0]], "_num1rem", "_num2rem"];

private _res = 0;

for "_i" from 0 to 23 do 
{
	_num1rem = _num1 % 2; 
	_num2rem = _num2 % 2;
	
	if (_num1rem isEqualTo 1 || _num2rem isEqualTo 1) then {_res = _res + 2 ^ _i};
	
	_num1 = (_num1 - _num1rem) / 2; 
	_num2 = (_num2 - _num2rem) / 2;
};

_res 