/*
	Author: Nelson Duarte <@Nelson_G_Duarte>

	Description:
	Pulsates a value from 0 to 1

	Parameter(s):
	_this select 0: Float - The frequency in Hz, 1 / _frequency = 0.1 second is the period

	Returns:
	Nothing
*/
private _frequency = _this param [0, 1, [0]];

0.5 * (1.0 + sin(2 * PI * _frequency * time));