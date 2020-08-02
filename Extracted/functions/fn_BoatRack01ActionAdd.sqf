/*
	Author: Bravo Zero One development
	- John_Spartan

	Description:
	- This is sub function for 'boat recovery' functionality.

	Execution:
	- Call from trigger that is added to object (boat rack).

	Example:
		"[thisTrigger,thisList] call bis_fnc_boatRack01ActionAdd;"

	Required:
		Object (boat rack) must have vehicle in vehicle behavior configured (https://community.bistudio.com/wiki/Arma_3_Vehicle_in_Vehicle_Transport).
		Object (boat rack) must have triggers set up with continuous actions.

	Parameter(s):
		_this select 0: mode (Scalar)
		0: trigger object
		and
		other parameters from trigger's & players vehicle's names-pace's.

	Returns: nothing
	Result: Continuous action added for players vehicle.

*/
#include "defines.inc"

private _trigger = param [0, objNull];
private _target = param [1, objNull,[[],objNull]];
private _boatRack = GET_BOAT_RACK(_trigger);

//GET BOAT OBJECT
if (_target isEqualType []) then
{
	_target = (_target select {_x isKindOf "Ship" && {_x isEqualTo cameraOn}}) param [0, objNull];
};

//DEFINE ACTION PARAMETERS
private _duration = 5;
private _distance = 15;

//CONDITIONS
private _condShow = [_target,_boatRack] call bis_fnc_boatRack01CanExetuteAction;
private _condProgress = [_target,_boatRack] call bis_fnc_boatRack01CanProgressAction;

//STORE BOAT WITH ACTION ON TRIGGER
SET_BOAT(_trigger,_target);

//BEHAVIOUR
private _onStart =
{
	//NO NEED TO DO ANY ACTION HERE ATM (UNLESS WE GO FOR FULL MP DESYNC COMPATIBLITY WITH VARIABLE SYNC)
	params ["_target","_caller","_actionId","_arguments"];
};

private _onProgress =
{
	params ["_target","_caller","_actionId","_arguments"];
	private _boatRack = _arguments select 1;
	private _velocityTarget = velocity _target;
	private _dirTarget = direction _target;
	private _velocityDecrese = 0.5 * ((speed _target) / 10);
	
	//SLOW THE BOAT & HOLD THE BOAT IN PLACE, VELOCITY CAN BE IN ALL DIRECTIONS AND NEGATIVE
	if ((abs (speed _target)) >1) then
	{
		_target setVelocity [(_velocityTarget select 0)-(sin _dirTarget * _velocityDecrese),(_velocityTarget select 1)-(cos _dirTarget * _velocityDecrese),(_velocityTarget select 2)];
	}
	else
	{
		_target setVelocity [0,0,(_velocityTarget select 2)];
	};
};

private _onCompleted =
{
	params ["_target","_caller","_actionId","_arguments"];

	private _boatRackObj = _arguments select 1;
	if(count (getVehicleCargo _boatRackObj) == 0) then
	{
		private _isCargoLoaded = _boatRackObj setVehicleCargo _target;
		if(_isCargoLoaded) then
		{
			[_boatRackObj, _target] call bis_fnc_boatRack01AdjustZOffset;
		};
	};
};

private _onInterrupted =
{
	//NO NEED TO DO ANY ACTION HERE ATM (UNLESS WE GO FOR FULL MP DESYNC COMPATIBLITY WITH VARIABLE SYNC)
	params ["_target","_caller","_actionId","_arguments"];
};


//ADD ACTION
private _actionID =
[
/* 0 object */							_target,
/* 1 action title */					if (isLocalized "STR_A3_action_Recover_Boat") then {localize "STR_A3_action_Recover_Boat"} else {"Recover Boat"},
/* 2 idle icon */						"\A3\Data_F_Destroyer\Data\ui\igui\cfg\holdactions\holdaction_loadVehicle_ca.paa",
/* 3 progress icon */					"\A3\Data_F_Destroyer\Data\ui\igui\cfg\holdactions\holdaction_loadVehicle_ca.paa",
/* 4 condition to show */				_condShow,
/* 5 condition to progress */			_condProgress,
/* 6 code executed on start */			_onStart,
/* 7 code executed per tick */			_onProgress,
/* 8 code executed on completion */		_onCompleted,
/* 9 code executed on interruption */	_onInterrupted,
/* 10 arguments */						[_trigger,_boatRack],
/* 11 action duration */				_duration,
/* 12 priority */						1000,
/* 13 remove on completion */			true,
/* 14 show unconscious */				false
]
call BIS_fnc_holdActionAdd;

//STORE ASSOCIATED ACTION ID ARRAY (CAN BE MULTIPLE ACTIONS IF TWO BOAT RACKS IN CLOSE PROXIMITY)
private _actionIdList = GET_ACTION_ID_LIST(_target);
_actionIdList pushBack [_target,_trigger,_actionID];
SET_ACTION_ID_LIST(_target,_actionIdList);