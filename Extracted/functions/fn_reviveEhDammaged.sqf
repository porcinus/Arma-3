#include "defines.inc"

/*
unit: Object - Object the event handler is assigned to
hitSelection: String - Name of the selection where the unit was damaged
damage: Number - Resulting level of damage
hitPartIndex: Number - hit index of the hit selection
hitPoint: String - hit point Cfg name
shooter: Object - shooter reference (to get instigator use getShotParents on projectile)
projectile: Object - the projectile that caused damage
*/

params ["_unit", "", "_damage","","_hitPoint","_source"];

if (alive _unit && {_damage >= 1 && {_hitPoint == "Incapacitated" && {IS_ACTIVE(_unit)}}}) then
{
	private _isCrash = vehicle _unit == _source;

	//handle incapacitation score and rating
	if (!isNull _source && {_source isEqualType objNull && {isPlayer _source && {_source != _unit && {!_isCrash}}}}) then
	{
		if ((side group _unit) getFriend (side group _source) < 0.6) then
		{
			//["[ ] %1 incapacitated enemy %2 | %1 score %3 rating %4",_source,_unit,1,RATING_KILL] call bis_fnc_logFormat;

			[_source,[1,0,0,0,0]] remoteExec ["addPlayerScores",2,false];
			[_source,RATING_KILL] remoteExec ["addRating",_source,false];
		}
		else
		{
			//["[ ] %1 incapacitated friendly %2 | %1 score %3 rating %4",_source,_unit,-1,RATING_TEAMKILL] call bis_fnc_logFormat;

			[_source,[-1,0,0,0,0]] remoteExec ["addPlayerScores",2,false];
			[_source,RATING_TEAMKILL] remoteExec ["addRating",_source,false];
		};
	};

	//make incapacitated unit covered by blood, needed for smooth secure transition (which is actually kill)
	_unit setDamage MAX_SAFE_DAMAGE;

	//incapacitate unit
	if (isNull _source || {!bis_revive_killfeedShow || {_isCrash}}) then
	{
		SET_STATE(_unit,STATE_INCAPACITATED);
	}
	else
	{
		SET_STATE_XTRA(_unit,STATE_INCAPACITATED,_source);
	};
};