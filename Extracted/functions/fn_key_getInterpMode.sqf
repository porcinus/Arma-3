/*
	Author: Nelson Duarte <@Nelson_G_Duarte>

	Description:
	Returns the key interp mode index
	* 0  - Linear
	* 1  - Cubic
	* 2  - EaseIn
	* 3  - EaseOut
	* 4  - EaseInOut
	* 5  - Hermite
	* 6  - Berp
	* 7  - BounceIn
	* 8  - BounceOut
	* 9  - BounceInOut
	* 10 - QuinticIn
	* 11 - QuinticOut
	* 12 - QuinticInOut
	* 13 - ElasticIn
	* 14 - ElasticOut
	* 15 - ElasticInOut

	Parameter(s):
	_this select 0: Object - The key

	Returns:
	Integer - The mode as integer
*/

// Parameters
private _key = _this param [0, objNull, [objNull]];

// Return the time of this key
if (is3DEN) then
{
	(_key get3DENAttribute "InterpMode") select 0;
}
else
{
	_key getVariable ["InterpMode", 0];
};