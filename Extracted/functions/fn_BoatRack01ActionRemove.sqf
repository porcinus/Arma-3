/*
	Author: Bravo Zero One development
	- John_Spartan

	Description:
	- This is sub function for 'boat recovery' functionality.  

	Execution:
	- Call from trigger that is added to object (boat rack).

	Example:
		"[thisTrigger] call bis_fnc_boatRack01ActionRemove;"
			
	Required:
		Object (boat rack) must have vehicle in vehicle behavior configured (https://community.bistudio.com/wiki/Arma_3_Vehicle_in_Vehicle_Transport). 
		Object (boat rack) must have triggers set up with continuous actions. 

	Parameter(s):
		_this select 0: mode (Scalar)
		0: trigger object
		and
		other parameters from trigger's & players vehicle's names-pace's.

	Returns: nothing
	Result: Continuous action removed from player. 

*/
#include "defines.inc"

private _trigger = param [0, objNull, [objNull]];
private _target = GET_BOAT(_trigger);
private _actionIdList = GET_ACTION_ID_LIST(_target);
private _actionID = -1;
private _actionIdListSize = count _actionIdList;
//hintSilent format["Array: %1",_actionIdList];

if(_actionIdListSize > 0) then 
{
	for "_i" from 0 to (_actionIdListSize -1) do
	{
		private _selectedElement = _actionIdList select _i;
		private _storedTarget = _selectedElement select 0;
		private _storedTrigger = _selectedElement select 1;
		_actionID = _selectedElement select 2;
		if(_storedTarget == _target && {_storedTrigger == _trigger}) exitWith 
		{
			[_target,_actionID] call bis_fnc_holdActionRemove;
			_actionIdList deleteRange [_i, 1]; 
			SET_ACTION_ID_LIST(_target,_actionIdList);
		};
		
	};
};
_actionIdList = GET_ACTION_ID_LIST(_target);
//hintSilent format["Array new: %1",_actionIdList];

