/*
	Author: Karel Moricky

	Description:
	Return scripted respawn positions available for the given unit

	Parameter(s):
		0: OBJECT, GROUP, SIDE or NAMESPACE
		1 (Optional): BOOL - false to return positions, true to their names (default: false) 
					  NUMBER - 1 to return positions, 2 to return their names, 3 to return show info

	Returns:
	ARRAY
*/

private ["_target","_returnNames","_varName","_positions","_default","_objectPositions","_groupPositions","_sidePositions","_globalPositions"];

_target = _this param [0,player,[objnull,grpnull,sideunknown,missionnamespace]];
_returnNames = false;
_returnInfo = false;

if (((typeName _this) == (typeName [])) && {(count _this) > 1}) then {
	switch (typeName (_this select 1)) do {
		case (typeName true): {_returnNames = _this param [1,false,[false]]};
		case (typeName 0): {
			switch (_this select 1) do {
				case 0: {};
				case 1: {_returnNames = true};
				case 2: {_returnInfo = true};
			};
		};
	};
};


_varName = "BIS_fnc_getRespawnPositions_list";
_positions = [];

_default = [-1,[],[],[],[]];
_objectPositions = _default;
_groupPositions = _default;
_sidePositions = _default;
_globalPositions = missionnamespace getvariable [_varName,_default];

switch (typename _target) do {
	case (typename objnull): {
		_objectPositions = if (isnull _target) then {_default} else {_target getvariable [_varName,_default]};
		_groupPositions = if (isnull group _target) then {_default} else {(group _target) getvariable [_varName,_default]};
		_sidePositions = missionnamespace getvariable [_varName + str (_target call bis_fnc_objectSide),_default];
	};
	case (typename grpnull): {
		_groupPositions = if (isnull _target) then {_default} else {(_target) getvariable [_varName,_default]};
		_sidePositions = missionnamespace getvariable [_varName + str (_target call bis_fnc_objectSide),_default];
	};
	case (typename sideunknown): {
		_sidePositions = missionnamespace getvariable [_varName + str (_target),_default];
	};
	case (typename missionnamespace): {
	};
};

if (_returnNames) then {
	{
		{
			_positions pushback (_x call bis_fnc_localize);
		} foreach (_x select 3);
	} foreach [_objectPositions,_groupPositions,_sidePositions,_globalPositions];
} else {
	if (_returnInfo) then {
		{
			{
				_positions pushback _x;
			} foreach (_x select 4);
		} foreach [_objectPositions,_groupPositions,_sidePositions,_globalPositions];
	} else {
		private ["_fnc_canRespawnOn","_sidePlayer"];
		_fnc_canRespawnOn = {
			private ["_sideThis"];
			_sideThis = side group _this;
			alive _this && simulationenabled _this && canmove _this && (_sideThis == sideunknown || {[_sideThis,_sidePlayer] call bis_fnc_areFriendly}) && !(_this getVariable ["BIS_revive_incapacitated", false])
		};
		_sidePlayer = if (_target isequalto player) then {side group player} else {sidelogic};
		{
			{
				private ["_pos","_useObj","_xObj"];
				_positions = _positions - [_x];
				_useObj = false;
				_xObj = switch (typename _x) do {
					case (typename ""): {
						_useObj = true;
						missionnamespace getvariable _x
					};
					case (typename grpnull): {
						private ["_group","_leader"];
						_useObj = true;
						_group = if (isnull _x) then {group player} else {_x}; //--- When group is null, player's group is used

						//--- Find the first alive unit in the group
						_leader = leader _x;
						if !(_leader call _fnc_canRespawnOn) then {
							{if (_x call _fnc_canRespawnOn) exitwith {_leader = _x;}} foreach units _group;
						};
						_leader
					};
					default {objnull};
				};
				_pos = if (_useObj) then {
					//--- Check if the string points to an object or marker
					if !(isnil {_xObj}) then {
						_xObj
					} else {
						if (markerpos _x distance [0,0] > 0) then {_x};
					};
				} else {
					_x;
				};
				if !(isnil "_pos") then {
					_positions pushback _pos;
				};
			} foreach (_x select 2);
		} foreach [_objectPositions,_groupPositions,_sidePositions,_globalPositions];
		_positions = _positions - [""];
	};
};

//remove all object with simulation disabled and objNulls
_remove = [objNull];
{if ((typeName _x == typeName objNull) && {!simulationEnabled _x}) then {_remove = _remove + [_x]}} forEach _positions;
_positions = _positions - _remove;

_positions