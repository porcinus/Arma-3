/*
	Author: 
		Karel Moricky, optimised by Killzone_Kid

	Description:
		Modify given counter (create it if doesn't exist yet)

	Parameter(s):
		0: 
			STRING - variable name of counter
			ARRAY in format [variableName,nameSpace], where nameSpace can be object, group or missionNameSpace/uiNameSpace
		1: NUMBER (Optional) - added value
		2: NUMBER (Optional) - modulo value

	Returns:
		NUMBER - current counter's value
*/

#define VAR_SPACES [currentNamespace, objNull, displayNull, controlNull, grpNull, locationNull, taskNull, teamMemberNull]

params [["_varName", -1], ["_add", 0], ["_mod", -1]];
_varName params ["_varName", ["_varSpace", missionNamespace]];

if ([_varName, _add, _mod] isEqualTypeArray ["", 0, 0] && _varSpace isEqualTypeAny VAR_SPACES) exitWith
{
	/// --- exit with current counter value fast or 0 if counter doesn't exist
	/// --- until we have something to add no point in creating the counter variable
	if (_add isEqualTo 0) exitWith {_varSpace getVariable [_varName, 0]};
	
	private _var = (_varSpace getVariable [_varName, 0]) + _add;
		
	if (_mod > 0) then {_var = _var % _mod};
		
	_varSpace setVariable [_varName, _var];
	
	_var
};

/// --- param error, suggest default format
#include "..\paramsCheck.inc"
#define arr ["",0]
paramsCheck(_this,isEqualTypeParams,arr)