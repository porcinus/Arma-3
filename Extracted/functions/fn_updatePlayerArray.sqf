/*
	Author: Karel Moricky
	
	Description:
	Updates dead player objects to their current respawned  objects
	
	Parameters:
		_this: ARRAY
	
	Returns:
	ARRAY
*/

private ["_array","_object","_objectID","_objectOwner"];
_array = +([_this] param [0,[],[[]]]);
{
	_object = _x;
	if !(alive _object) then {
		_objectID = _foreachindex;
		_objectOwner = owner _x;
		{
			if (owner _x == _objectOwner) then {
				if (_x in _array) then {
					_array set [_objectID,-1];
				} else {
					_array set [_objectID,_x];
				};
			};
		} foreach playableunits;
	};
} foreach _array;
_array - [-1]