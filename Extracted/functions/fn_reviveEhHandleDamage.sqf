#include "defines.inc"

params ["_unit","","_damage","_source","","_index"];

//ignore damage under the threshold
if (_damage < 0.1) exitWith {0};

if (alive _unit) then
{
	if (IS_DISABLED(_unit)) then
	{
		//to fix issue where vehicle destruction can happen after player receives damage and get incapacitated
		if (bis_revive_unconsciousStateMode != 0 && {!alive vehicle _unit}) exitWith
		{
			//bis_revive_deathReason = DEATH_REASON_NONE;
			_damage = 100;
		};

		if (bis_revive_bleeding && {_index == -1}) then
		{
			private _damagePrev = damage _unit;
			private _damageRecieved = _damage - _damagePrev;

			private _damageBleed = _unit getVariable [VAR_DAMAGE_BLEED,0];
			private _damageAccumulated = (_unit getVariable [VAR_DAMAGE,0]) + _damageRecieved;

			_unit setVariable [VAR_DAMAGE,_damageAccumulated];

			if (_damageBleed + _damageAccumulated > 0.99) then
			{
				_damage = _damage max 100;

				//negate built-in score and rating rating adjustments; executing someone now always nets -1 score
				if (!isNull _source && _source != _unit) then
				{
					bis_revive_deathReason = DEATH_REASON_EXECUTED;

					if ((side group _unit) getFriend (side group _source) < 0.6) then
					{
						[_source,[-1,0,0,0,0]] remoteExec ["addPlayerScores",2,false];						//-1 to negate award (+1) given by game
						[_source,-RATING_KILL+RATING_EXECUTE] remoteExec ["addRating",_source,false];		//negate engine bonus and add execute penalty
					}
					else
					{
						[_source,[1,0,0,0,0]] remoteExec ["addPlayerScores",2,false];
						[_source,-RATING_TEAMKILL+RATING_EXECUTE] remoteExec ["addRating",_source,false];	//negate engine ff penaly and add execute penalty
					};
				}
				else
				{
					bis_revive_deathReason = DEATH_REASON_NONE;
				};
			}
			else
			{
				_damage = MAX_SAFE_DAMAGE min _damage;
			};
		}
		else
		{
			_damage = MAX_SAFE_DAMAGE min _damage;
		};
	}
	else
	{
		//incapacitation mode: basic
		if (bis_revive_unconsciousStateMode == 0) then
		{
			_damage = if (_index < 8) then {_damage min MAX_SAFE_DAMAGE};
		}
		//incapacitation mode: advanced
		else
		{
			if (_index == -1) then
			{
				_damage = if (!alive vehicle _unit) then {100} else {_damage min MAX_SAFE_DAMAGE};
			};
		};
	};
};

_damage