//#define FULL_DEBUG

//scriptName "Functions\systems\fn_modulefriendlyfire.sqf";
/*******************************************************************************
	Version:			2.0
	Name:					Friendly Fire
	Author:				Zozo
	DESCRIPTION:	Handles the friendly fire. Use either the module interface in the editor, or call individual functions.
	PARAMETERS:		1) function called - string, list of functions:
								- Init
								- Destroy
								- AddUnits
								- RemoveUnits
								- ChangePriority
								- ListActiveUnit
								2) parameter for the function
								RETURNED VALUE:	depends on the function called

EXAMPLES:
							// Initializes the module if not added in editor
							// No units are directly checked for friendly fire, but renegade state is checked anyway
							_ret = [ "Init", [] ] call BIS_fnc_moduleFriendlyFire

							// Initializes the module if not added in editor
							// BIS_vip1, BIS_vip2, BIS_noVip units are directly checked for friendly fire
							x = [ "Init", [ [ BIS_vip1, BIS_vip2, BIS_noVip],true ] ] call BIS_fnc_moduleFriendlyFire

							// De-initializes the module
							_ret = [ "Destroy" ] call BIS_fnc_moduleFriendlyFire

							// Add BIS_vip3 unit to be checked for friendly fire
							x = [ "AddUnits", [ [BIS_vip3] ] ] call BIS_fnc_moduleFriendlyFire

							// Remove BIS_vip1 unit from active units
							x = [ "RemoveUnits", [ [ BIS_vip1 ] ] ] call BIS_fnc_moduleFriendlyFire

							// set another priority for a vehicle- if it is hit once, considered as friendly fire
							x = [ "ChangePriority",  [BIS_vip,1] ] call BIS_fnc_moduleFriendlyFire
*******************************************************************************/

/* TODO:
		+ AddUnitToFriendlyFire
		+ RemoveUnitFromFriendlyFire - will need to change data structure - must remember eventhandlers :-(
		+ CheckRenegadeStatus
		- StopChecking the status (pause?)
		+ RemoveEventhandlers on Destroy - will need to change data structure - must remember eventhandlers :-(
		+ change calling of execVM "fn_moduleFriendlyFire.sqf"
		- Display a warning message if player will shoot a civilian
		- handle deleted units (clear array from NULL-OBJECT)
		+ add priority - if object is shot one time - friendly fire will happen
		+ vehicle crew is checked for friendly fire - valid just for the time of being the crew
		- detection of destroying VIP vehicle by another vehicle (hit eventhandler doesnt detect it correctly)
		- Find out why engine EHs are not registering instigators of drone collisions correctly (objNull now) */

//Functions interface
private[ "_Init", "_Destroy" ];

/*******************************************************************************
 *	Name:		Init - constructor
 *	Description:	Initializes
 *	Parameters:	1)
 *	Return value:	none
 ******************************************************************************/
_Init =
{
	private["_array", "_logic", "_units", "_activated", "_tmpunits", "_unit" ];
	_array = _this param [0,[],[[]]];

	//_logic = _array param [0,objnull,[objnull]];
	_units = _array param [0,[],[[]]];
	_activated = _array param [1,true,[true]];

/*
	["[FriendlyFire::Init] _units are: %1", _units ] call BIS_fnc_LogFormat;
	["[FriendlyFire::Init] _array is: %1", _array ] call BIS_fnc_LogFormat;
*/

	if(isNil "BIS_FriendlyFire") then
	{
		BIS_FriendlyFireGroup = createGroup sideLogic;
		//BIS_InstructorGroup = createGroup WEST;
		//"Logic" createUnit [[0,0,0], BIS_FriendlyFire, "BIS_FriendlyFire = this"];
		"Logic" createUnit [[0,0,0], BIS_FriendlyFireGroup, "BIS_FriendlyFire = this; this setGroupID [""FriendlyFire"", ""GroupColor0""]"];
		PublicVariable "BIS_FriendlyFire";

		_tmpunits = [];

		{
						//unit, handler, priority
			_tmpunits = _tmpunits + [[_x, -1, 0]];
			//if a vehicle - try add its crew as well

				if( crew _x select 0 != _x ) then
				{
					{
						_tmpunits = _tmpunits + [[_x, -1, 0]];
					} forEach (crew _x);
				};
		}  foreach _units;

		#ifdef FULL_DEBUG
			["_tmpunit: %1", _tmpunits] call BIS_fnc_LogFormat;
		#endif

		BIS_FriendlyFire setVariable [ "units", _tmpunits, TRUE ];
		BIS_FriendlyFire setVariable [ "playerkilledfriendly", false, TRUE ];
		BIS_FriendlyFire setVariable [ "checkStatusInLoop", true, TRUE ];

		[ _tmpunits ] call _AddEventHandlers;
		[] spawn _Main;

		#ifdef FULL_DEBUG
			["=================Friendly Fire================="] call BIS_fnc_Log;
		#endif
		["[Friendly Fire] Successfully initialized:"] call BIS_fnc_Log;

		#ifdef FULL_DEBUG
			["==============================================="] call BIS_fnc_Log;
		#endif

		[] call _ListActiveUnits;

		_returnValue = true;
	}
	else
	{
		#ifdef FULL_DEBUG
			["=================Friendly Fire================="] call BIS_fnc_Log;
		#endif
		["[Friendly Fire] Already initialized!"] call BIS_fnc_Log;
		#ifdef FULL_DEBUG
			["================================================"] call BIS_fnc_Log;
		#endif
		_returnValue = false;
	};
	_returnValue
};

//Destroy(): deinitialize the Friendly Fire module
_Destroy =
{
	deleteVehicle BIS_FriendlyFire;
	BIS_FriendlyFire = nil;
	deleteGroup BIS_FriendlyFireGroup;

	#ifdef FULL_DEBUG
		["=================Friendly Fire================="] call BIS_fnc_Log;
	#endif
	["[Friendly Fire] Deinitialized!"] call BIS_fnc_Log;
	#ifdef FULL_DEBUG
		["================================================"] call BIS_fnc_Log;
	#endif
	true;
};

/*******************************************************************************
 *	Name:		ListActiveUnits
 *	Description:	List active checked units for friendly fire
 *	Parameters:	none
 *	Return value:   true
 *	Note:
 ******************************************************************************/
private["_ListActiveUnit"];
_ListActiveUnits =
{
	if (count (BIS_FriendlyFire getVariable "units") > 0) then {
		#ifdef FULL_DEBUG
		["=================Friendly Fire================="] call BIS_fnc_Log;
		["[Friendly Fire] List of active units:"] call BIS_fnc_Log;
		{ ["- %1", _x select 0] call BIS_fnc_LogFormat; } forEach (BIS_FriendlyFire getVariable "units");
		["================================================"] call BIS_fnc_Log;
		#endif
	};

};
/*******************************************************************************
 *	Name:		_AddUnits
 *	Description:	Added units will be checked against Friendly Fire
 *	Parameters:
 *	Return value:   true
 *	Note:
 ******************************************************************************/
private["_AddUnits"];
_AddUnits =
{
	private ["_array", "_units", "_unitscount", "_unit", "_actualunits", "_tmpunits" ];

	_array = _this param [0,[],[[]]];
	_units = _array param [0,[],[[]]];

	_actualunits = BIS_FriendlyFire getVariable "units";

	_tmpunits = [];
	{
		if( !isNil "_x" ) then
		{ _tmpunits = _tmpunits + [[_x, -1, 0]] };
	}  foreach _units;

	{
		_unit = _x select 0;
		//[ "_unit = %1 | _x = %2", _unit, _x] call BIS_fnc_LogFormat;
		_tmpfound = [_actualunits, _unit] call BIS_fnc_findNestedElement;
		//[ "_tmpfound = %1", _tmpfound ] call BIS_fnc_LogFormat;
		if( count _tmpfound == 0 ) then
		{
			_actualunits = _actualunits + [_x];
		};
		//DEBUGLOG format ["_actualunits: %1", _actualUnits];
	} forEach _tmpunits;

	BIS_FriendlyFire setVariable [ "units", _actualunits, TRUE ];

	[_tmpunits] call _AddEventHandlers;

	[] call _ListActiveUnits;

	true
};

/*******************************************************************************
 *	Name:		RemoveUnits
 *	Description:	Added units will be checked against Friendly Fire
 *	Parameters:
 *	Return value:   true
 *	Note:
 ******************************************************************************/
private["_RemoveUnits"];
_RemoveUnits =
{
	private ["_array", "_units", "_unitscount", "_unit", "_actualunits", "_tmpunits", "_foundunit", "_foundhandler", "_actualunits2" ];

	_array = _this param [0,[],[[]]];
	_units = _array param [0,[],[[]]];
	_actualunits = BIS_FriendlyFire getVariable "units";

	{
		if( !isNil "_x" ) then
		{
			_unit = _x;
			_tmpfound = [_actualunits, _unit] call BIS_fnc_findNestedElement;

			if( count _tmpfound != 0 ) then
			{
				_foundunit = (_actualunits select (_tmpfound select 0)) select 0;
				_foundhandler = (_actualunits select (_tmpfound select 0)) select 1;
				_foundunit removeEventHandler [ "killed", _foundhandler ];
				_actualunits2 = [_actualunits, (_tmpfound select 0)] call BIS_fnc_removeIndex;
				_actualunits = _actualunits2;
			};
		};
	} forEach _units;

	BIS_FriendlyFire setVariable [ "units", _actualunits, TRUE ];

	[] call _ListActiveUnits;

	true
};

/*******************************************************************************
 *	Name:            AddEventHandlers
 *	Description:     Add Killed eventhandlers to units passed as a parameter
 *	Parameters:	 none
 *	Return value:    true
 ******************************************************************************/
private _HandlerKilled = {
	_whohit = _this param [1, objNull, [objNull] ];
	_whowashit = _this param [0, objNull, [objNull] ];

	//[ "[Friendly Fire] %1 was damaged by %2",_whowashit, _whohit ] call BIS_fnc_LogFormat;

	if( (_whohit == player) || (_whohit == vehicle player) || ((vehicle _whohit) == (getConnectedUAV player)) ) then
	{
		BIS_FriendlyFire setVariable ["playerkilledfriendly", true, TRUE];
	};
	true
};
private _HandlerHit = {
	private _whohit = _this param [1, objNull, [objNull] ];
	private _whowashit = _this param [0, objNull, [objNull] ];

	//[ "[Friendly Fire] %1 was damaged by %2",_whowashit, _whohit ] call BIS_fnc_LogFormat;

	if( (_whohit == player) || (_whohit == vehicle player) || ((vehicle _whohit) == (getConnectedUAV player)) ) then
	{
		//_damage = _this param [2, 0, [0]];
		 //["1:%1", 1 ] call BIS_fnc_LogFormat;
		_actualunits = BIS_FriendlyFire getVariable "units";
		_tmpfound = [_actualunits, _whowashit] call BIS_fnc_findNestedElement ;
		_priority = (_actualunits select (_tmpfound select 0)) select 2;

		if( _priority > 0 ) then
		{
			//if priority object was hit, then friendly fire event
			BIS_FriendlyFire setVariable ["playerkilledfriendly", true, TRUE];
		}
		else
		{

			//["1b:%1", 1 ] call BIS_fnc_LogFormat;
			if( !canMove _whowashit ) then
			{
				//if vehicle is destroyed, then friendly fire event
				BIS_FriendlyFire setVariable ["playerkilledfriendly", true, TRUE];
			}
			else
			{
				//put some warnings here'
				//["[Friendly Fire] Avoid Friendly Fire on %1", _whowashit ] call BIS_fnc_LogFormat;
			};
		};
	};
	true
};

private["_AddEventHandlers"];
_AddEventHandlers =
{
	 private[ "_handler", "_units", "_unit", "_locatedunit", "_tmpunits" ];
	_units = _this param [0, [], [[]] ];
	if (ismultiplayer) then {
		{
			private _unit = _x select 0;

			if ( _unit isKindOf "man" ) then
			{
				_handler = _unit addMPEventHandler ["MPKilled",_HandlerKilled];
			}
			else
			{
				_handler = _unit addMPEventHandler ["MPHit",_HandlerHit];
			};
			_locatedunit = ([_units, _unit] call BIS_fnc_findNestedElement) select 0;	//	[2,0]
			[_units, [_locatedunit, 1], _handler] call BIS_fnc_setNestedElement;

		} forEach _units;
	} else {
		//--- Don't use MP event handlers in SP because they are not serialized
		{
			private _unit = _x select 0;

			if ( _unit isKindOf "man" ) then
			{
				_handler = _unit addEventHandler ["Killed",_HandlerKilled];
			}
			else
			{
				_handler = _unit addEventHandler ["Hit",_HandlerHit];
			};
			_locatedunit = ([_units, _unit] call BIS_fnc_findNestedElement) select 0;	//	[2,0]
			[_units, [_locatedunit, 1], _handler] call BIS_fnc_setNestedElement;

		} forEach _units;
	};
	true
};
/*******************************************************************************
 *	Name:		ChangePriority
 *	Description:	default priority is 0, if it is bigger friendly fire will happen sooner (currently one shot = friendly fire, doesn't matter if object is destroyed/killed or not)
 *			works now just for vehicles
 *	Parameters:	none
 *	Return value:   true
 *	Note:
 ******************************************************************************/
private["_ChangePriority"];
_ChangePriority =
{
	private[ "_unit", "_priority" ];
	_array = _this param [0,[],[[]]];
	_unit = _array param [0, objNull, [objNull]];
	_priority = _array param [1, 0, [0]];
	_actualunits = BIS_FriendlyFire getVariable "units";

	_tmpfound = [_actualunits, _unit] call BIS_fnc_findNestedElement;

	if( count _tmpfound != 0 ) then
	{
		[ _actualunits, [ (_tmpfound select 0),2 ], _priority ] call BIS_fnc_setNestedElement;
		["[Friendly Fire] The priority has been changed for %1", _unit ] call BIS_fnc_LogFormat;
	}
	else
	{
		["[Friendly Fire] %1 not found - cannot change the priority", _unit ] call BIS_fnc_LogFormat;
	};
	true
};
/*******************************************************************************
 *	Name:		FriendlyFire
 *	Description:	Friendly Fire happened - handles the situation
 *	Parameters:	none
 *	Return value:   true
 *	Note:
 ******************************************************************************/
private["_FriendlyFire"];
_FriendlyFire =
{
	["[Friendly Fire] Friendly Fire happened! Handling the situation"] call BIS_fnc_Log;
	["FriendlyFire", FALSE] RemoteExec ["BIS_fnc_endMission", 0, TRUE];
	[] call _Destroy;
	true
};


/*******************************************************************************
 *	Name:		CheckStatus
 *	Description:	Check status of friendly fire
 *	Parameters:	none
 *	Return value:   BOOL: renegade status
 *	Note:
 ******************************************************************************/
private["_CheckStatus"];
_CheckStatus =
{
	private["_returnValue","_playerkilledfriendly"];
	//["[Friendly Fire::CheckStatus] Checking status"] call BIS_fnc_Log;
	_returnValue = false;
	_playerkilledfriendly = BIS_FriendlyFire getVariable "playerkilledfriendly";
	if( side player == sideEnemy || _playerkilledfriendly ) then
	{
		_returnValue = true
	};
	_returnValue
};

/*******************************************************************************
 *	Name:		Main
 *	Description:	Main loop
 *	Parameters:	none
 *	Return value:   true
 *	Note:
 ******************************************************************************/
private["_Main"];
_Main =
{
	private["_playerKilledFriendly", "_checkInLoop"];

	while{ BIS_FriendlyFire getVariable "checkStatusInLoop" } do
	{
		//["[Friendly Fire::Main] Looping"] call BIS_fnc_Log;
		_playerKilledFriendly = ["CheckStatus", []] call BIS_fnc_moduleFriendlyFire;
		if( _playerKilledFriendly ) then
		{
			BIS_FriendlyFire setVariable [ "checkStatusInLoop", false, TRUE ];
		};
		Sleep 1;
	};
	if( _playerKilledFriendly ) then { ["FriendlyFire", []] call BIS_fnc_moduleFriendlyFire; };
	true
};

/*******************************************************************************
 *	Name:		ENTRY_POINT
 *	Description:	Entry point for the Friendly Fire module
 *	Parameters:	function called: name of the function without starting
 *		  	"_" symbol
 *			[] parameter for the function
 *	Return value:	it depends on the function called
 *	NOTE:		The main entry point for the FF module
 *			This part calls functions declared above
 *******************************************************************************/
private[ "_functionCalled", "_returnValue", "_subset" ];

_returnValue = false;
_functionCalled = _this param [0,["", objNull], ["", objNull]];

if( typeName _functionCalled == "OBJECT" ) then
{
	//If called from MODULE
	_functionCalled = "Init";
	_subset = [];
	_subset = _subset + [[ _this, 1] call BIS_fnc_subSelect];
}
else
{
	//If called directly by designer
	_subset = [ _this, 1] call BIS_fnc_subSelect;
};

_functionCalledCode = call compile format [ "_%1", _functionCalled ];

/*
[ "[FriendlyFire::ENTRY POINT] _this: 			%1", _this ] call BIS_fnc_LogFormat;
[ "[FriendlyFire::ENTRY POINT] function: 	%1", _functionCalled ] call BIS_fnc_LogFormat;
[ "[FriendlyFire::ENTRY POINT] params: 			%1", _subset ] call BIS_fnc_LogFormat;
*/


if!(isNil "BIS_FriendlyFire" && _functionCalled != "Init") then
{
	//if ( call compile format ["typeName _%1 != ""CODE""", _functionCalled] ) then
	if ( isNil {call compile format ["typeName _%1", _functionCalled]} ) then
	{
		["FriendlyFire::ENTRY POINT] Function %1 doesn't exist!", _functionCalled ] call BIS_fnc_LogFormat;
		_returnValue = false;
	}
	else
	{
     	_returnValue = _subset call _functionCalledCode;
		//[ "_returnValue is: %1", _returnValue ] call BIS_fnc_LogFormat;
	};
}
	else
{
	["[FriendlyFire::ENTRY POINT]: Initialize the Friendly Fire system first using Init parameter please!"] call BIS_fnc_LogFormat;
	_returnValue = false;
};

_returnValue
