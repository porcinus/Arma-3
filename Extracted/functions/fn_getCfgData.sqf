/*
	Author: Jiøí Wainar (Warka), optimised by Killzone_Kid

	Description:
	Smart-return number, text or array value from config.

	Remark(s):
	* Can by called 2 ways:
		* 1st way (general) works for any config.
		* 2nd way is for comfortable working with mission description.ext.

	Parameter(s):
		_this: CFG
		_this: ARRAY of STRINGS - missionConfigFile classes and an attribute.

	Example:

	* 1st way of calling:

		_value = (configfile >> "BulletBubbles" >> "BulletBubbles1") call BIS_fnc_getCfgData;
		_value = (missionconfigfile >> "Hubs" >> "A1" >> "QuickStart" >> "trigger") call BIS_fnc_getCfgData;

	* 2nd way of calling:

		_value = ["Hubs","A1","QuickStart","trigger"] call BIS_fnc_getCfgData;

	Returns:
		STRING or NUMBER or ARRAY or nil (if value not found)
*/

private _cfg = _this call BIS_fnc_getCfg;

if (isNumber _cfg) exitWith {getNumber _cfg};
if (isText _cfg) exitWith {getText _cfg};
if (isArray _cfg) exitWith {getArray _cfg};

nil