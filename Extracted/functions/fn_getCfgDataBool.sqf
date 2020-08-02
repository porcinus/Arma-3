/*
	Author: Jiøí Wainar (Warka), optimised by Killzone_Kid

	Description:
	Get a number defined in cfg and retype it into a bool. Everything bigger then 0 is true, otherwise it's false.

	Remark(s):
	* Can by called 2 ways:
		* 1st way (general) works for any config.
		* 2nd way is for comfortable working with mission description.ext.

	Parameter(s):
		_this: CFG
		_this: ARRAY of STRINGS - missionConfigFile classes and an attribute.

	Example:

	* 1st way of calling:

		_value = (missionconfigfile >> "Characters" >> "Default" >> "equipAdjust") call BIS_fnc_getCfgDataBool;

	* 2nd way of calling:

		_value = ["Characters","Default","equipAdjust"] call BIS_fnc_getCfgDataBool;

	Returns:
		BOOL
*/

private _cfg = _this call BIS_fnc_getCfg;

if (isNumber _cfg) exitWith {getNumber _cfg > 0};

false