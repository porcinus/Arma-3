/*
	Author: 
		Killzone_Kid
		
	Description:
		Performs bitwise NOT operation on decimal or hexadecimal unsigned 24 bit integer
		(Hexadecimal number representation is simply auto-converted into decimal by the engine)
		
	Parameter:
		0: [NUMBER] - decimal or hexadecimal unsigned 24 bit integer
		
	Return:
		[NUMBER] - decimal number
		
	Examples:
		873687 call BIS_fnc_bitwiseNOT // 15903528
		[2 + 4 + 8 + 32 + 256 + 1024] call BIS_fnc_bitwiseNOT // 16775889
		
	Limitations:
		Due to various limitations of the Real Virtuality engine this function is 
		intended to work with unsigned 24 bit integers only. This means that the 
		supported range is 2^0...2^24 (1...16777216)
*/

params [["_num", 0, [0]], "_numrem"];
	
private _res = 0;

for "_i" from 0 to 23 do 
{
	_numrem = _num % 2;
	
	if (_numrem isEqualTo 0) then {_res = _res + 2 ^ _i};
	
	_num = (_num - _numrem) / 2;
};

_res 