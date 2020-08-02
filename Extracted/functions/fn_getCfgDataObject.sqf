/*
	Author: Jiøí Wainar (Warka), optimised by Killzone_Kid

	Description:
	Get the object defined in cfg by its name (global variable).

	Remark(s):
	* Can by called 2 ways:
		* 1st way (general) works for any config.
		* 2nd way is for comfortable working with mission description.ext.

	Parameter(s):
		_this: CFG
		_this: ARRAY of STRINGS - missionConfigFile classes and an attribute.

	Example:

	* 1st way of calling:

		_value = (missionconfigfile >> "Hubs" >> "A1" >> "QuickStart" >> "trigger") call BIS_fnc_getCfgDataObject;

	* 2nd way of calling:

		_value = ["Hubs","A1","QuickStart","trigger"] call BIS_fnc_getCfgDataObject;

	Returns:
		OBJECT or OBJNULL
*/

private _cfg = _this call BIS_fnc_getCfg;

if (isText _cfg) exitWith {missionNamespace getVariable [getText _cfg, objNull]};

objNull