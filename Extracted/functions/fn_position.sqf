/*
	Author: 
		Karel Moricky, optimised by Killzone_Kid

	Description:
		Returns position AGL, unless passed position is array, then the same array is returned.
		When position is object and alternative position stored in "BIS_fnc_position_forced" variable
		on this object, the stored position is used rather than actual object position.

	Parameter(s):
		ARRAY - position in format [x,y] or [x,y,z]
		or
		OBJECT - object
		or
		GROUP - group, group leader position is used
		or
		LOCATION - location
		or
		STRING - marker or variable name containing object

	Returns:
		ARRAY - position in format [x,y] or [x,y,z]
		
	Example:
		_pos = player call BIS_fnc_position;
*/

#define POSITION_FORCED_VAR "BIS_fnc_position_forced"

if (_this isEqualType [] && {_this isEqualTypeArray [0,0] || _this isEqualTypeArray [0,0,0]}) exitWith {_this};
if (_this isEqualType objNull) exitWith {if (isNull _this) exitWith {[0,0,0]}; _this getVariable [POSITION_FORCED_VAR, ASLToAGL getPosASL _this]};
if (_this isEqualType grpNull) exitWith {if (isNull _this) exitWith {[0,0,0]}; leader _this getVariable [POSITION_FORCED_VAR, ASLToAGL getPosASL leader _this]};
if (_this isEqualType [] && {_this isEqualTypeArray [grpNull,0]}) exitWith {waypointPosition _this};
if (_this isEqualType locationNull) exitWith {locationPosition _this};
if (_this isEqualType "") exitWith 
{
	private _obj = missionNamespace getVariable [_this, objNull];
	if (_obj isEqualType objNull && {!isNull _obj}) then {_obj getVariable [POSITION_FORCED_VAR, ASLToAGL getPosASL _obj]} else {getMarkerPos _this};
};

// failed, show error
#include "..\paramsCheck.inc"
// invalid type
#define arr1 [[],objNull,grpNull,locationNull,""]
paramsCheck(_this,isEqualTypeAny,arr1)
// bad position array
#define arr2 [0,0,0]
paramsCheck(_this,isEqualTypeArray,arr2)