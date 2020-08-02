/*
	Author: 
		Killzone_Kid

	Description:
		Delete given counter

	Parameter(s):
		0: 
			STRING - variable name of counter
			ARRAY in format [variableName,nameSpace], where nameSpace can be object, group or missionNameSpace/uiNameSpace
	Returns:
		NOTHING
*/

#define VAR_SPACES [currentNamespace, objNull, displayNull, controlNull, grpNull, locationNull, taskNull, teamMemberNull]

params ["_varName"];
[_varName] params ["_varName", ["_varSpace", missionNamespace]];

if ([_varName] isEqualTypeArray [""] && _varSpace isEqualTypeAny VAR_SPACES) exitWith
{
	_varSpace setVariable [_varName, nil];
};

/// --- param error, suggest default format
#include "..\paramsCheck.inc"
#define arr1 [_varName,_varSpace]
#define arr2 ["",currentNamespace]
paramsCheck(arr1,isEqualTypeArray,arr2)