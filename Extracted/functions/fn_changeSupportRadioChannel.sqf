/*
	Author: Josef Zemanek

	Description:
	Changes the radio channel for Support module-related protocol.

	Parameter(s):
	_this select 0: SIDE - Affected side
	_this select 1: ANY - Channel setting

	Returns:
	nothing
*/

private ["_channelSide", "_channelSetting", "_public"];
_channelSide 	= _this param [0, CIVILIAN, [CIVILIAN]];
_channelSetting = _this param [1, FALSE];
_public		= _this param [2, false, [false]];

if (isNil "BIS_SUPP_channels") then {
	[_channelSide, _channelSetting] spawn {
		waitUntil {!isNil "BIS_SUPP_channels"};
		BIS_SUPP_channels set [[WEST, EAST, RESISTANCE] find (_this select 0), (_this select 1)];
		
		//Broadcast if required
		if (_public) then {
			publicVariable "BIS_SUPP_channels";
		};
	};
} else {
	BIS_SUPP_channels set [[WEST, EAST, RESISTANCE] find _channelSide, _channelSetting];
	
	//Broadcast if required
	if (_public) then {
		publicVariable "BIS_SUPP_channels";
	};
};
