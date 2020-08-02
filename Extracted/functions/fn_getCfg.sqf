/*
	Author: 
		Killzone_Kid

	Description:
		Smart-return config (extension for BIS_fnc_getCfgXXXX functions)

	Remark(s):
		Can by called 2 ways:
			* 1st way - passing config directly
			* 2nd way - passing array of strings or config and strings

	Parameter(s):
		_this: CONFIG
		_this: ARRAY

	Example 1:
		1st way of calling:

			_cfg = (configfile >> "BulletBubbles" >> "BulletBubbles1") call BIS_fnc_getCfg;
			_cfg = (missionconfigfile >> "Hubs" >> "A1" >> "QuickStart" >> "trigger") call BIS_fnc_getCfg;
			
	Example 2:
		2nd way of calling:
			_cfg = [configfile >> "BulletBubbles" >> "BulletBubbles1"] call BIS_fnc_getCfg;
			_cfg = [configfile, "BulletBubbles", "BulletBubbles1"] call BIS_fnc_getCfg;
			_cfg = ["Hubs"] call BIS_fnc_getCfg;
			_cfg = ["Hubs", "A1", "QuickStart", "trigger"] call BIS_fnc_getCfg;

	Returns:
		CONFIG
*/

// is array [string(, string...)]
if (_this isEqualTypeParams [""]) exitWith
{
	private _cfg = missionConfigFile;
	{_cfg = _cfg >> _x} count _this;

	_cfg
};

// is array [config(, string....)]
if (_this isEqualTypeParams [configNull]) exitWith
{
	_this =+ _this;
	private _cfg = _this deleteAt 0;
	{_cfg = _cfg >> _x} count _this;

	_cfg
};

// is config
if (_this isEqualType configNull) exitWith {_this};

// is neither
configNull