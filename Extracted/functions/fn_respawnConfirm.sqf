_unit = _this param [0,objnull,[objnull]];
_respawnDelay = _this param [3,0,[0]];

if (!isplayer _unit && !isnull _unit) exitwith {["Attempting to use the function on AI unit %1, can be used only on players."] call bis_fnc_error;};

if (!alive _unit) then {

	waituntil {playerrespawntime <= 1 || alive player};
	if (alive player) exitwith {};
	setplayerrespawntime 99999;
	if !(dialog) then {createdialog "RscDisplayCommonMessage";};

	waituntil {!dialog || alive player};
	setplayerrespawntime -1;
} else {
	setplayerrespawntime _respawnDelay;
};