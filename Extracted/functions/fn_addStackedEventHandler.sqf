/*
	Author:
		Nelson Duarte, improved by Killzone_Kid

	Description:
		This function adds a new item that will be stacked and called upon event handler selected has been executed

	Parameter(s):
		0:	STRING			- The unique ID of the item inside the stack
		1:	STRING			- The onXxx event handler to monitor and execute code upon
		2:	STRING or CODE	- The function name or code to execute upon the event triggering
		3:	ANY				- Arguments passed to function/code

	Returns:
		STRING - The stacked item ID or "" on failure
*/

// Supported event handlers - for backwards compatability
#define SUPPORTED_EVENTS ["oneachframe", "onpreloadstarted", "onpreloadfinished", "onmapsingleclick", "onplayerconnected", "onplayerdisconnected"]
#define EVENTS_WITH_PARAMS ["onmapsingleclick", "onplayerconnected", "onplayerdisconnected"]
#define NAMESPACE_ID "BIS_stackedEventHandlers_"

// Parameters
params [["_customId", "", [""]], ["_event", "", [""]], ["_code", {}, [{},""]], ["_args", [], [[]]]];

// empty id is not supported
if (_customId isEqualTo "") exitWith
{
	["ID cannot be empty"] call BIS_fnc_error;
	""
};

// unify naming
_event = toLower _event;

// validate event type
if !(_event in SUPPORTED_EVENTS) exitWith
{
	["Stack with ID (%1) could not be added because the Event (%2) is not supported or does not exist. Supported Events (%3)", _customId, _event, SUPPORTED_EVENTS] call BIS_fnc_error;
	""
};

if (_code isEqualTo {} || _code isEqualTo "") exitWith {""}; // nothing to add, ignore

// check if code is function name
if (
	_code isEqualType ""
	&&
	{
		isNil {missionNamespace getVariable _code}
		||
		{!(missionNamespace getVariable _code isEqualType {})}
	}
)
exitWith
{
	// function check fail
	["Given script function (%1)' does not exist or is invalid", _code] call BIS_fnc_error;
	""
};

private _nativeParamsString = _event call
{
    if (_this isEqualTo "onmapsingleclick") exitWith {"params ['_units','_pos','_alt','_shift']; "};
    if (_this in ["onplayerconnected", "onplayerdisconnected"]) exitWith {"params ['_id','_uid','_name','_jip','_owner']; "};
 	""
};

_code = compile format
[
	"%1%2%3 call %4",
 	_nativeParamsString,
	["", "_this + "] select (_event in EVENTS_WITH_PARAMS),
	["(missionNamespace getVariable format ['BIS_stackedEventHandlers_" + _event + "_%1', _thisEventHandler])", []] select (_args isEqualTo []),
	_code
];

// make sure the following runs in the same frame
isNil
{
	private _replaced = false;
	private _namespaceEvent = NAMESPACE_ID + _event;
	private _data = missionNamespace getVariable _namespaceEvent;

	if (isNil "_data") then
	{
		missionNamespace setVariable [_namespaceEvent, []];
		_data = missionNamespace getVariable _namespaceEvent;
	};

	if !(_data isEqualType []) exitWith
	{
		["Catastrophic Failure: Variable (%1) is read only!", _namespaceEvent] call BIS_fnc_error;
		_customId = "";
	};

	// Go through all event handler data and find if id is already defined, if so, we override it
	{
		if (_customId == _x select 0) exitWith
		{
			removeMissionEventHandler [_event select [2], _x select 1];
			missionNamespace setVariable [format ["%1_%2", _namespaceEvent, _x select 1], nil];
			_data deleteAt _forEachIndex;
			_replaced = true;
		};
	}
	forEach _data;

	private _ehId = addMissionEventHandler [_event select [2], _code];
	private _argsVarName = format ["%1_%2", _namespaceEvent, _ehId];

	missionNamespace setVariable [_argsVarName, nil];

	// make var only when we have something to store in it
	if !(_args isEqualTo []) then
	{
		// attempting to store args
		if (!isNil {missionNamespace getVariable _argsVarName}) exitWith
		{
			removeMissionEventHandler [_event, _ehId];
			["Catastrophic Failure: Variable (%1) is read only!", _argsVarName] call BIS_fnc_error;
			_customId = "";
		};

		missionNamespace setVariable [_argsVarName, _args];
	};

	if !(_customId isEqualTo "") then
	{
		// all good
		_data pushBack [_customId, _ehId];

		// Log?
		//["Stack as been updated with ID (%1) for Event (%2), Replaced: (%3)", _customId, _event, _replaced] call BIS_fnc_logFormat;
	};
};

_customId