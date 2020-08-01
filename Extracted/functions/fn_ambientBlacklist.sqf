/*
	Author: 
		Karel Moricky, optimised by Killzone_Kid

	Description:
		Check if area is blacklisted.
		Blacklist triggers are to be named 'bis_ambientBlacklist_#', where # is number from 0 to 99.

	Parameter(s):
		_this:	BIS_fnc_position compatible position - check if position is blacklisted
				NUMBER - initialize blacklisted areas

	Returns:
		BOOL - true when in blacklisted area
		NOTHING - blacklisted areas registration
*/

if (_this isEqualTypeAny 0) exitWith
{
	//--- Register blacklist areas
	if (isNil "BIS_ambientBlacklist") then {BIS_ambientBlacklist = []};
	for "_i" from 0 to 99 do 
	{
		private _trigger = missionNamespace getVariable format ["BIS_ambientBlacklist_%1", _i];
		if (!isNil "_trigger" && {!(_trigger in BIS_ambientBlacklist)}) then {BIS_ambientBlacklist pushBack _trigger};
	};
	nil
};

//--- Check if pos is in blacklist areas
BIS_ambientBlacklist = BIS_ambientBlacklist - [objNull]; //--- Remove deleted triggers
private _pos = _this call BIS_fnc_position;
{if (_pos inArea _x) exitWith {1}} count BIS_ambientBlacklist > 0


