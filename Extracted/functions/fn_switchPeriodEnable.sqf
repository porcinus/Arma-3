params [
	["_enable",true,[true]],
	["_showNotification",true,[true]]
];

BIS_switchPeriodEnabled = true;
BIS_canSwitchPeriod = _enable;

if (_showNotification) then {
	_keys = actionkeys "teamSwitch";
	if (count _keys > 0) then {
		["SwitchPeriodEnabled",[keyname (_keys select 0)]] call bis_fnc_showNotification;
	} else {
		["SwitchPeriodEnabled",[localize "str_a3_multiplayer_teamswitch1"]] call bis_fnc_showNotification;
	};
};