/*
Earthquake effect happening in Escape from Tanoa
*/

private _power = selectRandom [1,2,3,4];
private _delay = (600 + (random 300));

// ["Next Earthquake - Power: %1 Delay: %2",_power,_delay] call BIS_fnc_logFormat;

sleep _delay;

[_power, "BIS_fnc_earthquake"] call BIS_fnc_MP;
_null = [] execVM "Scripts\Earthquake.sqf";
