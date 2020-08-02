/*
	Author: Nelson Duarte

	Description:
		Returns name of a unit
		Name of unit is stored in it's namespace so it can be retrieved later, mainly for when unit dies

	Parameters:
		OBJECT: Unit to get the name from
		BOOL: Whether to force reading the name if not stored already in namespace and unit is dead

	Returns:
		STRING: Name of the unit
*/
#define VAR_NAME "BIS_fnc_getName_name"

params [["_object", objNull], ["_bForced", false], ["_maxCharacters", -1]];

private _name = "";

if (!isNull _object && { _object isKindOf "Man" }) then
{
	if (alive _object) then
	{
		_name = name _object;
		_object setVariable [VAR_NAME, _name];
	}
	else
	{
		private _nameSaved = _object getVariable VAR_NAME;

		if (!isNil { _nameSaved }) then
		{
			_name = _nameSaved;
		}
		else
		{
			if (_bForced) then
			{
				_name = name _object;
			};
		};
	};
};

if (_maxCharacters > -1) then
{
	_name = _name select [0, _maxCharacters];
};

_name;