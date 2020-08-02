/*
	Author: 
		Nelson Duarte, improved by Killzone_Kid

	Description:
		This function removes an item that is stacked in some event

	Parameter(s):
		0:	STRING	- The unique ID of the item inside the stack
		1:	STRING	- The onXxx event handler

	Returns:
		BOOLEAN - TRUE if successfully removed, FALSE if not
*/

#define SUPPORTED_EVENTS ["oneachframe", "onpreloadstarted", "onpreloadfinished", "onmapsingleclick", "onplayerconnected", "onplayerdisconnected"]
#define NAMESPACE_ID "BIS_stackedEventHandlers_"

// Parameters
params [["_customId", "", [""]], ["_event", "", [""]]];

// empty id is not supported
if (_customId isEqualTo "") exitWith
{
	["ID cannot be empty"] call BIS_fnc_error;
	false
};

// unify naming
_event = toLower _event;

// validate event type
if !(_event in SUPPORTED_EVENTS) exitWith
{
	["Stack with ID (%1) could not be removed because the Event (%2) is not supported or does not exist. Supported Events (%3)", _customId, _event, SUPPORTED_EVENTS] call BIS_fnc_error;
	false
};

// Mission namespace id
private _namespaceEvent = NAMESPACE_ID + _event;
private _removed = false;

// make sure the following runs in the same frame
isNil
{
	private _data = missionNamespace getVariable _namespaceEvent;

	if (isNil "_data" && {!(_data isEqualType [])}) exitWith {};
	
	// Go through all event handler data and find the correct index
	{
		if (_customId == _x select 0) exitWith
		{
			removeMissionEventHandler [_event select [2], _x select 1];
			missionNamespace setVariable [format ["%1_%2", _namespaceEvent, _x select 1], nil];
			_data deleteAt _forEachIndex;
			_removed = true;
		};
	}
	forEach _data;
};

_removed 