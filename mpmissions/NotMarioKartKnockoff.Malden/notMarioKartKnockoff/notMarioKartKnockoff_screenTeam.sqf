/*
NNS
Not Mario Kart Knockoff
Player side team selection script.
*/

["notMarioKartKnockoff_screenTeam.sqf: Start"] call NNS_fnc_debugOutput;

if ((call MKK_fnc_time) > MKK_teamEnd) exitWith {["notMarioKartKnockoff_screenTeam.sqf: team selection expired"] call NNS_fnc_debugOutput};

openMap false; //close map
//(vehicle player) lock 3; //lock player vehicle

//player has no team set, select a random one
if (player getVariable ["MKK_team", -1] == -1) then {player setVariable ["MKK_team", floor (random 4), true]};

_kartColorArr = ["blue", "red", "green", "yellow"]; //team to color array

_display = findDisplay 46 createDisplay "RscDisplayEmpty"; //team selection display

disableSerialization;

//colors
_bgColor = [0.05, 0.05, 0.05, 0.8];
_bgSoftColor = [0.1, 0.1, 0.1, 0.4];

_screenPadding = 0.025;

_screenWidth = 1.25;
_screenInnerWidth = _screenWidth - _screenPadding * 2;
_screenHeight = 4;
_teamCtrlWidth = (_screenInnerWidth - _screenPadding * 3) / 4; //teams column width

_ctrlArr = []; //contain all controls, used for removal
_playersCtrlArr = []; //contain players list controls

//create group
_grpCtrl = [_display, "RscControlsGroupNoHScrollbars", -1, -1, -1, safeZoneY + 0.2, _screenWidth + (getNumber (configfile >> "RscControlsGroupNoHScrollbars" >> "VScrollbar" >> "width")), safeZoneH - 0.4] call MKK_fnc_createRscControl;
_grpCtrl ctrlShow false; //hide group

//create background
_bgCtrl = [_display, "RscText", -1, _grpCtrl, 0, 0, _screenWidth, _screenHeight, "", _bgColor] call MKK_fnc_createRscControl;
_lastY = _screenPadding; //update Y position

//create title control
_titleCtrl = [_display, "RscStructuredText", -1, _grpCtrl, 0, _lastY, _screenInnerWidth, -1, format ["<t size='1.2' align='center' font='PuristaBold'>%1</t>", localize "STR_MKK_teamSelection_title"]] call MKK_fnc_createRscControl;

_lastY = _lastY + (ctrlTextHeight _titleCtrl) + _screenPadding; //update Y position

//generate fake players lists
_tmpFakePlayersList = []; for "_i" from 0 to count MKK_karts - 1 do {_tmpFakePlayersList pushBack ""};
_tmpFakePlayersList = format ["<t size='0.8' align='center'>%1</t>",_tmpFakePlayersList joinString "<br/>"];

_teamsStrArr = [localize "STR_MKK_Gamemode_teamdeathmatch_blueteam", localize "STR_MKK_Gamemode_teamdeathmatch_redteam", localize "STR_MKK_Gamemode_teamdeathmatch_greenteam", localize "STR_MKK_Gamemode_teamdeathmatch_yellowteam"];
_teamsColorArr = [[0, 0, 1, 1], [1, 0, 0, 1], [0, 1, 0, 1], [1, 1, 0, 1]];

_tmpY = _lastY; //current Y
for "_i" from 0 to 3 do { //column loop
	_tmpX = _screenPadding + (_teamCtrlWidth + _screenPadding) * _i; //current column X position
	_tmpY = _lastY; //current Y
	
	//team name
	_tmpCtrl = [_display, "RscStructuredText", -1, _grpCtrl, _tmpX, _tmpY, _teamCtrlWidth, -1, format ["<t size='1' align='center'>%1</t>", _teamsStrArr select _i], _bgColor, _teamsColorArr select _i] call MKK_fnc_createRscControl;
	_ctrlArr pushBack _tmpCtrl; //add to array
	_tmpY = _tmpY + ctrlTextHeight _tmpCtrl; //update Y
	
	//players list
	_tmpCtrl = [_display, "RscStructuredText", -1, _grpCtrl, _tmpX, _tmpY, _teamCtrlWidth, -1, _tmpFakePlayersList, _bgSoftColor] call MKK_fnc_createRscControl;
	_playersCtrlArr pushBack _tmpCtrl; //add to players list array
	_tmpY = _tmpY + ctrlTextHeight _tmpCtrl; //update Y
	
	//join button
	_tmpCtrl = [_display, "RscButton", -1, _grpCtrl, _tmpX, _tmpY, _teamCtrlWidth, 0.05, localize "STR_MKK_teamSelection_join", [], [], format ["player setVariable ['MKK_team', %1, true]", _i]] call MKK_fnc_createRscControl;
	_ctrlArr pushBack _tmpCtrl; //add to array
};

_lastY = _tmpY + 0.05 + _screenPadding; //update Y position

//debug skip, only here in solo
if !(isMultiplayer) then {
	[_display, "RscButton", -1, _grpCtrl, 0, 0, 0.25, 0.05, "Debug Skip Team Selection", [], [], "missionNamespace setVariable ['MKK_teamEnd', -1, true]"] call MKK_fnc_createRscControl;
};

//remaining time
_timeRemainCtrl = [_display, "RscStructuredText", -1, _grpCtrl, -1, _lastY, _screenInnerWidth, -1, format ["<t size='1' align='center' shadow='2'>%1 %2 %3</t>", localize "STR_MKK_teamSelection_menuclosein", floor (MKK_teamEnd - (call MKK_fnc_time)), localize "STR_MKK_seconds"]] call MKK_fnc_createRscControl;
_ctrlArr pushBack _timeRemainCtrl; //add to array

_lastY = _lastY + (ctrlTextHeight _timeRemainCtrl) + _screenPadding; //update Y position

_grpCtrlPos = ctrlPosition _grpCtrl; //get control position and size
_grpCtrl ctrlSetPosition [_grpCtrlPos select 0, safeZoneY + (safeZoneH - _lastY) / 2, _grpCtrlPos select 2, _lastY + 0.05]; _grpCtrl ctrlCommit 0; //set position and size
_bgCtrl ctrlSetPosition [0, 0, _screenWidth, _lastY]; _bgCtrl ctrlCommit 0; //set position and size
_ctrlArr pushBack _bgCtrl; //add to array
_ctrlArr pushBack _grpCtrl; //add to array
_grpCtrl ctrlShow true; //show group

//update loop
_loop = 0; //loop counter
while {sleep 0.25; (call MKK_fnc_time) < MKK_teamEnd && {!(isNull _display)} && {(vehicle player) != player}} do {
	_playersList = [[], [], [], []]; //reset players list
	
	{ //all players loop
		if (_x getVariable ["MKK_init", false] && {_x getVariable ["MKK_team", -1] != -1}) then { //player in a kart
			_tmpTeam = _x getVariable "MKK_team"; //recover player selected team
			_tmpTeamArr = _playersList select _tmpTeam; //right team pointer
			_tmpTeamArr pushBack (name _x); //add player name to right list
		};
	} forEach allPlayers;
	
	for "_i" from 0 to 3 do {(_playersCtrlArr select _i) ctrlSetStructuredText parseText format ["<t size='0.8' align='center'>%1</t>", (_playersList select _i) joinString "<br/>"]}; //compile players list
	
	if (_loop == 2) then { //0.75sec
		_timeRemainCtrl ctrlSetStructuredText parseText format ["<t size='1' align='center' shadow='2'>%1 %2 %3</t>", localize "STR_MKK_teamSelection_menuclosein", floor (MKK_teamEnd - (call MKK_fnc_time)), localize "STR_MKK_seconds"]; //set text
		_loop = 0;
	} else {_loop = _loop + 1}; //increment loop counter
};

//clean controls
{ctrlDelete _x} forEach _ctrlArr;
{ctrlDelete _x} forEach _playersCtrlArr;
{ctrlDelete _x} forEach [_titleCtrl, _bgCtrl, _grpCtrl]; //remove remaining controls

_display closeDisplay 1; //close display
//(vehicle player) lock 0; //unlock player vehicle

[vehicle player, _kartColorArr select (player getVariable "MKK_team")] call MKK_fnc_switchKartColor; //set kart color

["notMarioKartKnockoff_screenTeam.sqf: End"] call NNS_fnc_debugOutput;