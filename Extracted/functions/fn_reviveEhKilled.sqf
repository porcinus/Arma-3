#include "defines.inc"

params[["_unit", objNull, [objNull]], ["_killer", objNull, [objNull]], ["_instigator", objNull, [objNull]]];

if (REVIVE_ENABLED(_unit)) then
{
	//replace default kill-feed messages
	if (bis_revive_killfeedShow && !bis_revive_hudLocked) then
	{
		private _deathReason = missionNamespace getVariable ["bis_revive_deathReason",DEATH_REASON_UNKNOWN];

		//detect force respawn option from pause menu
		if (_unit isEqualTo _killer && {_deathReason == DEATH_REASON_UNKNOWN}) then
		{
			_deathReason = if (isNull _instigator) then {DEATH_REASON_FORCED_RESPAWN} else {DEATH_REASON_SUICIDED};
		};

		//detect secure action
		if (_unit isEqualTo _killer && {_deathReason == DEATH_REASON_SECURED}) then
		{
			_killer = missionNamespace getVariable ["bis_revive_deathSource",objNull];
			bis_revive_deathSource = objNull;
		};

		if (_deathReason > DEATH_REASON_UNKNOWN) then
		{
			SET_STATE_XTRA2(_unit,STATE_DEAD,_killer,_deathReason);
		}
		else
		{
			SET_STATE_XTRA(_unit,STATE_DEAD,_killer);
		};

		bis_revive_deathReason = DEATH_REASON_UNKNOWN;
	}
	else
	{
		SET_STATE(_unit,STATE_DEAD);
	};
};

true