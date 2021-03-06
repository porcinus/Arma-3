﻿#include "defines.inc"
/*
	Author: Jiri Wainar

	Description:
	Make a unit bleed out over time while incapacitated.

	Parameters:
		_this select 0: OBJECT - Unit that is bleeding out

	Returns:
	True if successful, false if not.
*/

private _unitVar = param [0, "", [""]];
private _unit = GET_UNIT(_unitVar);

if (isNull _unit || {!local _unit}) exitWith {};

//not bleeding yet
bis_revive_bleeding = false;

//init blood and damage
_unit setVariable [VAR_DAMAGE_BLEED, 0];
_unit setVariable [VAR_DAMAGE, 0];

//bleed out
_unit spawn
{
	scriptName "bis_fnc_reviveBleedOut: bleeding";

	private _unit = _this;

	sleep 0.1;	//delay the bleeding so all the dmg is properly recieved BEFORE bleeding mechannics start

	bis_revive_bleeding = true;

	//define the bleed out time
	private _timeStart = time;
	private _timeTotal = bis_revive_bleedOutDuration;
	private _blood = 1;
	private _bleed = 0;
	private _damage = 0;
	private _bloodLevel = 0;
	private _bloodLevelPrev = 0;

	//enable pp effects
	bis_revive_ppColor ppEffectAdjust [1,1,0.15,[0.3,0.3,0.3,0],[0.3,0.3,0.3,0.3],[1,1,1,1]];
	bis_revive_ppVig ppEffectAdjust [1,1,0,[0.15,0,0,1],[1.0,0.5,0.5,1],[0.587,0.199,0.114,0],[1,1,0,0,0,0.2,1]];
	bis_revive_ppBlur ppEffectAdjust [0];
	{_x ppEffectCommit 0; _x ppEffectEnable true; _x ppEffectForceInNVG true} forEach [bis_revive_ppColor, bis_revive_ppVig, bis_revive_ppBlur];

	waitUntil
	{
		sleep 0.1;

		waitUntil{!(IS_BEING_REVIVED(_unit))};

		//calculate damage & blood
		_damage = _unit getVariable [VAR_DAMAGE,0];
		_bleed = (time - _timeStart) / _timeTotal;

		//player incapacitated under water or in burning vehicle dies faster
		if (eyePos _unit select 2 < 0 || {!alive vehicle player}) then {_bleed = _bleed * 5;};

		_blood = 1 - _bleed - _damage;

		//get & set bleedout state
		_bloodLevel = floor(_blood * 5); if (_bloodLevel > 3) then {_bloodLevel = 3;};

		if (_bloodLevel != _bloodLevelPrev) then
		{
			_bloodLevelPrev = _bloodLevel;

			_unit setVariable [VAR_BLOOD_LEVEL,_bloodLevel,true];
		};

		if (IS_DISABLED(_unit)) then
		{
			_unit setVariable [VAR_DAMAGE_BLEED, _bleed];
		};

		//wait for unit to bleeding out be revived
		_unit != player || {_blood <= 0 || {!alive _unit || {!IS_DISABLED(_unit)}}}
	};

	//kill unit if it bled out
	if (_unit == player && {alive _unit && {_blood <=0 }}) then
	{
		if (eyePos _unit select 2 < 0) then
		{
			bis_revive_deathReason = DEATH_REASON_DROWNED;
		}
		else
		{
			bis_revive_deathReason = DEATH_REASON_BLEEDOUT;
		};

		_unit setDamage 1;
	};

	//disable pp effects
	bis_revive_ppColor ppEffectAdjust [1,1,0,[1,1,1,0],[0,0,0,1],[0,0,0,0]];
	bis_revive_ppVig ppEffectAdjust [1,1,0,[1,1,1,0],[0,0,0,1],[0,0,0,0]];
	bis_revive_ppBlur ppEffectAdjust [0];

	{_x ppEffectCommit 1} forEach [bis_revive_ppColor, bis_revive_ppVig, bis_revive_ppBlur];
	sleep 1;
	{_x ppEffectEnable false} forEach [bis_revive_ppColor, bis_revive_ppVig, bis_revive_ppBlur];
};