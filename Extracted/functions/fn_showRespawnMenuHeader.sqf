disableserialization;

_maxRespawnTickets = param [0, 0];
_textDefault = param [1, localize "STR_A3_RscRespawnControls_Respawn"];	//localize "STR_A3_RscDisplayRespawn_ctrlButtonOK";
_textDisabled = localize "STR_A3_RscRespawnControls_RespawnDisabled";	//localize "STR_A3_RscDisplayRespawn_ctrlButtonOK_disabled";

_autorespawnTooltips = uiNamespace getVariable "BIS_RscRespawnControls_autorespawnTooltips";

_ctrlHeaderButton = uiNamespace getVariable "BIS_RscRespawnControlsMap_ctrlHeaderRespawnButton";
_ctrlTeam = uiNamespace getVariable "BIS_RscRespawnControlsMap_ctrlTeam";
_ctrlTickets = uiNamespace getVariable "BIS_RscRespawnControlsMap_ctrlTickets";
_ctrlCounter = uiNamespace getVariable "BIS_RscRespawnControlsMap_ctrlCounter";
_ctrlCounterText = uiNamespace getVariable "BIS_RscRespawnControlsMap_ctrlCounterText";
_ctrlAutorespawn = uiNamespace getVariable "BIS_RscRespawnControlsMap_ctrlAutorespawn";

if (missionNamespace getVariable ["BIS_RscRespawnControlsSpectate_shown", false]) then {	//controls for UI in Spectate Camera
	_ctrlHeaderButton = uiNamespace getVariable "BIS_RscRespawnControlsSpectate_ctrlHeaderRespawnButton";
	_ctrlTeam = uiNamespace getVariable "BIS_RscRespawnControlsSpectate_ctrlTeam";
	_ctrlTickets = uiNamespace getVariable "BIS_RscRespawnControlsSpectate_ctrlTickets";
	_ctrlCounter = uiNamespace getVariable "BIS_RscRespawnControlsSpectate_ctrlCounter";
	_ctrlCounterText = uiNamespace getVariable "BIS_RscRespawnControlsSpectate_ctrlCounterText";
	_ctrlAutorespawn = uiNamespace getVariable "BIS_RscRespawnControlsSpectate_ctrlAutorespawn";
};

_uiState = [missionNamespace getVariable ["BIS_RscRespawnControlsMap_shown", false], missionNamespace getVariable ["BIS_RscRespawnControlsSpectate_shown", false]];
_terminate = false;
_respawnTime = -1;
_timeCounter = time;
_timeUpdate = time;
_tickets = -1;
_noRespawnPositions = false;
_ctrlCounter ctrlShow true;
_ctrlCounterText ctrlShow true;
_ctrlAutorespawn ctrlShow true;
_ctrlHeaderButton ctrlShow false;
_ctrlHeaderButton ctrlEnable false;

//Set proper state of autorespawn
if (uiNamespace getVariable ["BIS_RscRespawnControls_autorespawn", false]) then {
	_ctrlAutorespawn ctrlSetTextColor [(profilenamespace getvariable ['GUI_BCG_RGB_R',0.77]),(profilenamespace getvariable ['GUI_BCG_RGB_G',0.51]),(profilenamespace getvariable ['GUI_BCG_RGB_B',0.08]),(profilenamespace getvariable ['GUI_BCG_RGB_A',0.8])];
	_ctrlAutorespawn ctrlSetActiveColor [(profilenamespace getvariable ['GUI_BCG_RGB_R',0.77]),(profilenamespace getvariable ['GUI_BCG_RGB_G',0.51]),(profilenamespace getvariable ['GUI_BCG_RGB_B',0.08]),1];
	_ctrlAutorespawn ctrlSetTooltip (_autorespawnTooltips select 1);
} else {
	_ctrlAutorespawn ctrlSetTextColor [1,1,1,0.3];
	_ctrlAutorespawn ctrlSetActiveColor [1,1,1,1];
	_ctrlAutorespawn ctrlSetTooltip (_autorespawnTooltips select 0);
};


//--- Unit and ticket count function (_ctrlTeam and _ctrlTickets variables expected)
_fnc_info = {
	_playersList = allPlayers - entities "HeadlessClient_F";	//all players without headless clients
	_side = side group player;
	_playersCount = {_side == (side group _x)} count _playersList;
	_livingCount = {(alive _x) && {_side == (side group _x)}} count _playersList;
	_tickets = [player,0,true] call (uiNamespace getVariable ["bis_fnc_respawnTickets", {}]);
	_timeUpdate = time + 1;

	//--- Players
	_playersText = format ["%1/%2",_livingCount,_playersCount];
	_ctrlTeam ctrlSetText _playersText;

	//--- Tickets
	if (_tickets >= 0) then
	{
		// display max tickets as well (for coop only)
		_ctrlTickets ctrlsetstructuredtext parseText format [
			if (_maxRespawnTickets > 0) then {"<t align='right'>%1/%2</t>"} else {"<t align='right'>%1</t>"},
			_tickets,
			_maxRespawnTickets
		];
	}
	else
	{
		_ctrlTickets ctrlsetstructuredtext parseText format [
			"<t align='right'>%1</t>",
			localize "STR_A3_RscRespawnControls_TicketsUnlimited"
		];
	};

	_noRespawnPositions = count ((player call (uiNamespace getVariable ["bis_fnc_getRespawnPositions", {}])) + ((player call (uiNamespace getVariable ["bis_fnc_objectSide", {}])) call (uiNamespace getVariable ["bis_fnc_getRespawnMarkers", {}]))) == 0;
};

//--- Counter function (_ctrlCounter variables expected)
_fnc_counter = {
	if (playerrespawntime < 3600 && !_noRespawnPositions) then {
		if (playerrespawntime != _respawnTime) then {
			_respawntime = playerrespawntime;
			_timeCounter = time;
		};
		_time = (playerrespawntime - (time - _timeCounter)) max 0;
		_text = [_time,"MM:SS"] call (uiNamespace getVariable ["bis_fnc_secondsToString", {}]);

		_ctrlCounter ctrlsetstructuredtext parseText format ["<t size='1.75' align='center'>%1</t>",_text];
		_ctrlCounterText ctrlShow true;
		_ctrlAutorespawn ctrlShow true;
	} else {
		_ctrlCounter ctrlsetstructuredtext parseText format ["<t align='center'>%1</t>", missionNamespace getVariable ["BIS_fnc_respawnMenuPosition_text", _textDisabled]];
		_ctrlCounterText ctrlShow false;
		_ctrlAutorespawn ctrlShow false;
	};
};

//====== Main loop (counting until respawn) ======
while {playerrespawntime > 0 && !alive player && !_terminate && !(uiNamespace getVariable ["BIS_RscRespawnControls_CountDone", false])} do {

	if (time > _timeUpdate) then {call _fnc_info};	//Update code
	call _fnc_counter;	//Counter

	sleep 0.05;
	_terminate = !(_uiState isEqualTo [missionNamespace getVariable ["BIS_RscRespawnControlsMap_shown", false], missionNamespace getVariable ["BIS_RscRespawnControlsSpectate_shown", false]]);
};

//--- Enable respawn and start another loop
if (!_terminate) then {
	if (uiNamespace getVariable ["BIS_RscRespawnControls_autorespawn", false]) then {
		//--- Autorespawn enabled
		_locList = uiNamespace getVariable "BIS_RscRespawnControlsMap_ctrlLocList";
		_roleList = uiNamespace getVariable "BIS_RscRespawnControlsMap_ctrlRoleList";
		_loadoutCombo = uiNamespace getVariable "BIS_RscRespawnControlsMap_ctrlComboLoadout";
		if (missionNamespace getVariable ["BIS_RscRespawnControlsSpectate_shown", false]) then {
			_locList = uiNamespace getVariable "BIS_RscRespawnControlsSpectate_ctrlLocList";
			_roleList = uiNamespace getVariable "BIS_RscRespawnControlsSpectate_ctrlRoleList";
			_loadoutCombo = uiNamespace getVariable "BIS_RscRespawnControlsSpectate_ctrlComboLoadout";
		};
		uiNamespace setVariable ["BIS_RscRespawnControls_selected", [lbCurSel _locList, lbCurSel _roleList, lbCurSel _loadoutCombo]];
		setplayerrespawntime 0;
	} else {
		//--- Autorespawn disabled
		uiNamespace setVariable ["BIS_RscRespawnControls_CountDone", true];
		_ctrlCounter ctrlSetStructuredText parseText format ["<t size='1.75' align='center'>%1</t>", "00:00"];
		_ctrlCounter ctrlShow false;
		_ctrlCounterText ctrlShow false;
		_ctrlAutorespawn ctrlShow false;
		_ctrlHeaderButton ctrlShow true;
		_ctrlHeaderButton ctrlEnable true;

		_noRespawnPositions = false;
		while {!alive player && !_terminate} do {
			//--- Update code
			if (time > _timeUpdate) then {call _fnc_info};

			_respawnDisabled = playerrespawntime > 99999 || _noRespawnPositions;
			_text = if (_respawnDisabled) then {missionNamespace getVariable ["BIS_fnc_respawnMenuPosition_text", _textDisabled]} else {_textDefault};
			_ctrlCounter ctrlShow false;
			_ctrlCounterText ctrlShow false;
			_ctrlAutorespawn ctrlShow false;
			_ctrlHeaderButton ctrlShow true;
			_ctrlHeaderButton ctrlEnable !_respawnDisabled;
			_ctrlHeaderButton ctrlsettext _text;

			setplayerrespawntime (99999 max playerrespawntime);
			sleep 0.05;
			_terminate = !(_uiState isEqualTo [missionNamespace getVariable ["BIS_RscRespawnControlsMap_shown", false], missionNamespace getVariable ["BIS_RscRespawnControlsSpectate_shown", false]]);
		};
	};
};