/*
	Author: Karel Moricky

	Description:
	Return current move action (used in playAction, playActionNow and switchAction)

	Parameter(s):
		0: OBJECT
		1 (Optional): BOOL - true to return config path of the action, false to return just the action name (default: false)

	Returns:
	STRING or ARRAY
*/

private ["_unit","_returnConfig","_moves","_action"];
_unit = _this param [0,objnull,[objnull]];
_returnConfig = _this param [1,false,[false]];
_moves = gettext (configfile >> "cfgvehicles" >> (typeof _unit) >> "moves");
_action = gettext (configfile >> _moves >> "States" >> (animationstate _unit) >> "actions");

if (_returnConfig) then {
	configfile >> _moves >> "Actions" >> _action
} else {
	_action
};