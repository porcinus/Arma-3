#include "defines.inc"
/*
	Author: Jiri Wainar

	Description:
	Used to execute specific code localy on every client whenever unit's state changes.

	Parameters:
		_this select 0: STRING - Variable that carries the state value over the network, defined by macro VAR_TRANSFER_STATE.
		_this select 1: SCALAR - State.
		_this select 2: OBJECT - Unit to set the status for.


	Returns:
	True if successful, false if not.

	States:
		#define STATE_RESPAWNED			0
		#define STATE_REVIVED			1
		#define STATE_INCAPACITATED		2
		#define STATE_DEAD				3
*/

//["[ ] %1",_this] call bis_fnc_logFormat;

private ["_unitVar","_statePrev","_playerVar","_source","_reason"];

private _state 	= param [1, STATE_RESPAWNED, [123,[]]];
private _unit  	= param [2, objNull, [objNull]];

if (isNull _unit) exitWith {};

if (_state isEqualType []) then
{
	_source	= _state param [1, objNull, [objNull]];
	_reason	= _state param [2, DEATH_REASON_UNKNOWN, [123]];
	_state 	= _state param [0, STATE_RESPAWNED, [123]];
}
else
{
	_source	= objNull;
	_reason = DEATH_REASON_UNKNOWN;
};

_unitVar = GET_UNIT_VAR(_unit);
_playerVar = GET_UNIT_VAR(player);

//store previous state
_statePrev = GET_STATE(_unit);

//stop if state didn't change
if (_statePrev == _state) exitWith {};

//set the actual state
_unit setVariable [VAR_STATE, _state];

switch (_state) do
{
	case STATE_INCAPACITATED:
	{
		private _sidePlayer = side group player;
		private _sideUnit = side group _unit;

		//flag player as being incapacitated
		_unit setVariable ["BIS_revive_incapacitated", true];

		//display 'incapacitated' message in kill-feed
		if (bis_revive_killfeedShow) then
		{
			if (isNull _source) then
			{
				systemChat format [MSG_INCAPACITATED,name _unit];
			}
			else
			{
				private _name = if (isPlayer _source) then
				{
					name _source;
				}
				else
				{
					format [MSG_NAME_TEMPLATE_AI, name _source];
				};

				if (side group _source getFriend side group _unit >= 0.6) then
				{
					systemChat format [MSG_INCAPACITATED_BY_FF,name _unit,_name];
				}
				else
				{
					systemChat format [MSG_INCAPACITATED_BY,name _unit,_name];
				};
			};
		};

		if (local _unit) then
		{
			//apply unconscious state
			_unit setUnconscious true;

			//prevent AI from shooting the unit
			AI_PROTECTION_ACTIVATE(_unit);

			//store player's camera so we can restore it if player is revived
			player setVariable [VAR_CAMERA_VIEW,cameraView];

			//start bleeding
			[_unitVar] call bis_fnc_reviveBleedOut;

			//disable player's action menu
			{inGameUISetEventHandler [_x, "true"]} forEach ["PrevAction", "NextAction"];
		}
		else
		{
			//init icon for everyone but player
			[ICON_STATE_ADD, _unitVar] call bis_fnc_reviveIconControl;
		};

		//update pool of incapacitated units
		if (_playerVar != _unitVar && {_sidePlayer getFriend _sideUnit > 0 && {_sideUnit getFriend _sidePlayer > 0}}) then
		{
			bis_revive_incapacitatedUnits pushBackUnique _unitVar;
		};

		//make unit play dead/unconscious animation in vehicles
		if (IN_VEHICLE(_unit)) then
		{
			_unit playAction "Unconscious";
		};

		if (local _unit) then
		{
			if (bis_revive_3rdPersonViewAllowed) then
			{
				[] spawn
				{
					if (cameraView != "external") then
					{
						titleCut ["","BLACK OUT",0.5];
						sleep 0.5;
						player switchCamera "external";
						titleCut ["","BLACK IN",0.5];
					};

					//create force-respawn action
					#include "_addAction_respawn.inc"

					//lock player camera to external while incapacitated or dead
					while {!IS_ACTIVE(player)} do
					{
						if (cameraView != "external") then {player switchCamera "external";};
						sleep 0.001;
					};
				};
			}
			else
			{
				//create force-respawn action
				#include "_addAction_respawn.inc"
			};
		}
		else
		{
			//show incapacitated icon for everyone but player
			[ICON_STATE_INCAPACITATED, _unitVar] call bis_fnc_reviveIconControl;

			//create revive & secure actions
			if (side group player getFriend side group _unit >= 0.6) then
			{
				#include "_addAction_revive.inc"
			}
			else
			{
				#include "_addAction_secure.inc"
			};
		};
	};
	case STATE_DEAD:
	{
		bis_revive_incapacitatedUnits = bis_revive_incapacitatedUnits - [_unitVar];

		//flag unit as being NOT incapacitated
		_unit setVariable ["BIS_revive_incapacitated", false];

		//display 'incapacitated' message in kill-feed
		if (bis_revive_killfeedShow && !bis_revive_hudLocked) then
		{
			//do not display 'friend only' messages to enemies
			if (_reason > 10 && {side group _unit getFriend side group player < 0.6}) exitWith {};

			private _name = if (!isNull _source) then
			{
				if (isPlayer _source) then
				{
					name _source;
				}
				else
				{
					format [MSG_NAME_TEMPLATE_AI, name _source];
				};
			};

			switch (_reason) do
			{
				case DEATH_REASON_NONE:
				{
					systemChat format [MSG_DIED,name _unit];
				};
				case DEATH_REASON_SECURED:
				{
					if (isNull _source) then
					{
						systemChat format [MSG_SECURED,name _unit];
					}
					else
					{
						systemChat format [MSG_SECURED_BY,name _unit,_name];
					};
				};
				case DEATH_REASON_FORCED_RESPAWN:
				{
					systemChat format [MSG_FORCED_RESPAWN,name _unit];
				};
				case DEATH_REASON_BLEEDOUT:
				{
					systemChat format [MSG_BLEDOUT,name _unit];
				};
				case DEATH_REASON_EXECUTED:
				{
					if (isNull _source) then
					{
						systemChat format [MSG_EXECUTED,name _unit];
					}
					else
					{
						if (side group _source getFriend side group _unit >= 0.6) then
						{
							systemChat format [MSG_EXECUTED_BY_FF,name _unit,_name];
						}
						else
						{
							systemChat format [MSG_EXECUTED_BY,name _unit,_name];
						};
					};
				};
				case DEATH_REASON_SUICIDED:
				{
					systemChat format [MSG_SUICIDED,name _unit];
				};
				case DEATH_REASON_DROWNED:
				{
					systemChat format [MSG_DROWNED,name _unit];
				};
				default
				{
					if (isNull _source) then
					{
						systemChat format [MSG_KILLED,name _unit];
					}
					else
					{
						if (side group _source getFriend side group _unit >= 0.6) then
						{
							systemChat format [MSG_KILLED_BY_FF,name _unit,_name];
						}
						else
						{
							systemChat format [MSG_KILLED_BY,name _unit,_name];
						};
					};
				};
			};
		};

		//init and show dead icon for everyone but player
		if (!local _unit) then
		{
			//init icon for everyone but player
			if (lifeState _unit != 'INCAPACITATED') then
			{
				[ICON_STATE_ADD, _unitVar] call bis_fnc_reviveIconControl;
			};

			//reset 'being revived' and 'forcing respawn' flags locally
			SET_BEING_REVIVED_LOCAL(_unit, false);
			SET_FORCING_RESPAWN_LOCAL(_unit, false);

			//remove revive and secure user actions
			{if (_x != -1) then {[_unit,_x] call bis_fnc_holdActionRemove}} forEach [_unit getVariable [VAR_ACTION_ID_REVIVE,-1],_unit getVariable [VAR_ACTION_ID_SECURE,-1]];

			[ICON_STATE_DEAD, _unitVar] call bis_fnc_reviveIconControl;
		}
		else
		{
			//not bleeding
			bis_revive_bleeding = false;

			//remove user action
			private _actionID = _unit getVariable [VAR_ACTION_ID_RESPAWN,-1];
			if (_actionID != -1) then {[_unit,_actionID] call bis_fnc_holdActionRemove;};

			//reset 'being revived' and 'forcing respawn' flags
			if (IS_BEING_REVIVED(_unit)) then {SET_BEING_REVIVED(_unit, false);};
			if (IS_FORCING_RESPAWN(_unit)) then {SET_FORCING_RESPAWN(_unit, false);};
		};
	};
	case STATE_REVIVED:
	{
		if (_statePrev != STATE_INCAPACITATED) exitWith {};

		bis_revive_incapacitatedUnits = bis_revive_incapacitatedUnits - [_unitVar];

		//flag unit as being NOT incapacitated
		_unit setVariable ["BIS_revive_incapacitated", false];

		//display 'revived' message in kill-feed; only if revived unit is friendly
		if (bis_revive_killfeedShow && {side group player getFriend side group _unit >= 0.6}) then
		{
			if (isNull _source) then
			{
				systemChat format [MSG_REVIVED,name _unit];
			}
			else
			{
				systemChat format [MSG_REVIVED_BY,name _unit,name _source];
			};
		};

		if (local _unit) then
		{
			//reset death reason
			bis_revive_deathReason = DEATH_REASON_UNKNOWN;

			//not bleeding
			bis_revive_bleeding = false;

			//remove unconscious state
			_unit setUnconscious false;

			//allow AI shooting the unit
			AI_PROTECTION_DEACTIVATE(_unit);

			//hotfix: revived while performing an action & playing animation
			_unit playAction "Stop";

			//hotfix: revived while having no weapon or binocular
			if ({currentWeapon player == _x} count ["",binocular player] > 0) then
			{
				[] spawn
				{
					sleep 0.1;
					if (({currentWeapon player == _x} count ["",binocular player] > 0) && {IS_ACTIVE(player)}) then {player playAction "Civil";};
				};
			};

			//reset blood level and stored bleed damage
			_unit setVariable [VAR_DAMAGE_BLEED, 0];
			_unit setVariable [VAR_DAMAGE, 0];

			//reset 'being revived' and 'forcing respawn' flags
			if (IS_BEING_REVIVED(_unit)) then {SET_BEING_REVIVED(_unit, false);};
			if (IS_FORCING_RESPAWN(_unit)) then {SET_FORCING_RESPAWN(_unit, false);};

			//enable player's action menu
			{inGameUISetEventHandler [_x, ""]} forEach ["PrevAction", "NextAction"];

			//restore player's camera
			if (cameraView != (player getVariable [VAR_CAMERA_VIEW, "internal"])) then
			{
				[] spawn
				{
					titleCut ["","BLACK OUT",0.5];
					sleep 0.5;
					player switchCamera (player getVariable [VAR_CAMERA_VIEW, "internal"]);
					titleCut ["","BLACK IN",0.5];
				};
			};

			//remove user action
			private _actionID = _unit getVariable [VAR_ACTION_ID_RESPAWN,-1];
			if (_actionID != -1) then {[_unit,_actionID] call bis_fnc_holdActionRemove;};

			//ALWAYS heal to full
			[] call bis_fnc_reviveDamageReset;
		}
		else
		{
			//reset 'being revived' and 'forcing respawn' flags locally
			SET_BEING_REVIVED_LOCAL(_unit, false);
			SET_FORCING_RESPAWN_LOCAL(_unit, false);

			//remove revive and secure user actions
			{if (_x != -1) then {[_unit,_x] call bis_fnc_holdActionRemove}} forEach [_unit getVariable [VAR_ACTION_ID_REVIVE,-1],_unit getVariable [VAR_ACTION_ID_SECURE,-1]];

			//remove incap/dead icon
			[ICON_STATE_REMOVE,_unitVar] call bis_fnc_reviveIconControl;
		};
	};
	case STATE_RESPAWNED:
	{
		bis_revive_incapacitatedUnits = bis_revive_incapacitatedUnits - [_unitVar];

		//flag player as being NOT incapacitated
		_unit setVariable ["BIS_revive_incapacitated", false];

		if (local _unit) then
		{
			//allow AI shooting the unit
			AI_PROTECTION_DEACTIVATE(_unit);

			//reset death reason
			bis_revive_deathReason = DEATH_REASON_UNKNOWN;

			//not bleeding
			bis_revive_bleeding = false;

			//reset blood level and stored bleed damage
			_unit setVariable [VAR_DAMAGE_BLEED, 0];
			_unit setVariable [VAR_DAMAGE, 0];

			//reset 'being revived' and 'forcing respawn' flags
			if (IS_BEING_REVIVED(_unit)) then {SET_BEING_REVIVED(_unit, false);};
			if (IS_FORCING_RESPAWN(_unit)) then {SET_FORCING_RESPAWN(_unit, false);};

			//enable player's action menu
			{inGameUISetEventHandler [_x, ""]} forEach ["PrevAction", "NextAction"];

			//restore player's camera
			_unit switchCamera (_unit getVariable [VAR_CAMERA_VIEW, "internal"]);

			//remove user action
			private _actionID = _unit getVariable [VAR_ACTION_ID_RESPAWN,-1];
			if (_actionID != -1) then {[_unit,_actionID] call bis_fnc_holdActionRemove;};

			//reset wound data
			[] call bis_fnc_reviveDamageReset;
		}
		else
		{
			//reset 'being revived' and 'forcing respawn' flags locally
			SET_BEING_REVIVED_LOCAL(_unit, false);
			SET_FORCING_RESPAWN_LOCAL(_unit, false);

			//remove revive and secure user actions
			{if (_x != -1) then {[_unit,_x] call bis_fnc_holdActionRemove}} forEach [_unit getVariable [VAR_ACTION_ID_REVIVE,-1],_unit getVariable [VAR_ACTION_ID_SECURE,-1]];

			//remove incap/dead icon
			[ICON_STATE_REMOVE,_unitVar] call bis_fnc_reviveIconControl;
		};
	};
	default
	{
	};
};