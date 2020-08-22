/*
NNS
Not Mario Kart Knockoff
Player side score script.
*/

["notMarioKartKnockoff_screenScore.sqf: Start"] call NNS_fnc_debugOutput;

if ((call MKK_fnc_time) > MKK_scoreEnd) exitWith {["notMarioKartKnockoff_screenScore.sqf: score expired"] call NNS_fnc_debugOutput};

_display = displayNull;

if !(isMultiplayer) then { //debug skip, only here in solo
	_display = findDisplay 46 createDisplay "RscDisplayEmpty"; //create score display
} else {
	"scoreDisplay" cutRsc ["RscTitleDisplayEmpty", "PLAIN"]; //create score display
	_display = uiNamespace getVariable "RscTitleDisplayEmpty"; //recover display variable
};

//reset points related vars
_playersPointsArr = []; //[points, player]
_playersPointsStrArr = []; //string array
_playersPointsStr = ""; //string to display

_gameModeDuration = 0; //mode duration in sec
if !(MKK_mode == -1) then {
	_playersPointsStrArr pushBack format ["<t size='1.5' font='PuristaBold' align='center'>&#160;%1&#160;</t>", [MKK_modeNameArr select MKK_mode] call MKK_fnc_strUnbreakSpace]; //game mode header
	_gameModeDuration = MKK_roundEnd - MKK_introEnd; //round duration
};

_playersPointsStrArr pushBack format ["<t size='1'><t align='left'>&#160;%1:</t>&#160;&#160;&#160;<t align='right'>%2&#160;%3&#160;</t></t>", [localize "STR_MKK_round_duration"] call MKK_fnc_strUnbreakSpace, floor (_gameModeDuration), localize "STR_MKK_seconds"];

_playersPointsStrArr pushBack format ["<t size='1' font='PuristaBold' underline='1' align='center'>&#160;%1&#160;</t>", [localize "STR_MKK_round_finalscore"] call MKK_fnc_strUnbreakSpace]; //player header

_cupImg = "cup.paa";
if (MKK_mode == 3) then { //team deathmatch mode
	_playersPointsArr = [[], [], [], []]; //player points array: [[[points, player],...], [[points, player],...], ...]
	_teamsPointsArr = [[-1, 0, _playersPointsArr select 0], [-1, 1, _playersPointsArr select 1], [-1, 2, _playersPointsArr select 2], [-1, 3, _playersPointsArr select 3]]; //teams scores array: [score, team index, player array pointer]
	
	{ //all players loop
		if (_x getVariable ["MKK_init", false] && {_x getVariable ["MKK_team", -1] != -1}) then { //player in a kart, team set with points over 0
			_tmpTeam = _x getVariable "MKK_team"; //current player team
			_tmpPoints = _x getVariable "MKK_points"; //recover player selected team and points
			
			_tmpTeamPointsArr = _teamsPointsArr select _tmpTeam; //team points array pointer
			if (_tmpTeamPointsArr select 0 == -1) then {_tmpTeamPointsArr set [0, 0]}; //init team score if needed
			_tmpTeamPointsArr set [0, (_tmpTeamPointsArr select 0) + _tmpPoints]; //add player points to its team
			
			_tmpPlayersPointsArr = _playersPointsArr select _tmpTeam; //players points array pointer
			_tmpPlayersPointsArr pushBack [_tmpPoints, name (_x)]; //add to array
		};
	} forEach allPlayers;
	
	/*
	//debug fake entry
	_playersPointsArr = [[[15,"15esfs"], [1,"1esk uut fs"], [5,"5esdd dfs"], [20,"20es fj hjs"]],
	[[15,"15es ffs"], [2,"2ess dh fs"], [8,"8es ddt rhs"], [10,"10gfhd hjs"]],
	[[1,"1e dysfs"], [10,"10es ktr h fs"], [2,"2esd rthd fs"], [5,"5esjyyt s"]],
	[[25,"25eh sj gjs"], [3,"3eszht rtrb trs"], [5,"5estr hd  dfs"], [30,"30esrth hjs"]]];
	_teamsPointsArr = [[15, 0, _playersPointsArr select 0], [2, 1, _playersPointsArr select 1], [25, 2, _playersPointsArr select 2], [3, 3, _playersPointsArr select 3]]; //teams scores array: [score, team index, player array pointer]
	*/
	
	for "_i" from 0 to 3 do {(_playersPointsArr select _i) sort false}; //sort players arrays by points
	_teamsPointsArr sort false; //sort teams array
	
	_teamColorStrArr = [localize "STR_MKK_Gamemode_teamdeathmatch_blueteam", localize "STR_MKK_Gamemode_teamdeathmatch_redteam", localize "STR_MKK_Gamemode_teamdeathmatch_greenteam", localize "STR_MKK_Gamemode_teamdeathmatch_yellowteam"]; //team to localized name array
	_teamColorArr = ["#0000ff", "#ff0000", "#00ff00", "#ffff00"]; //team to color array
	
	_firstTeam = true; _teamPaddingStr = "";
	{
		_tmpTeamPoints = _x select 0; //recover points
		if (_tmpTeamPoints != -1) then { //not empty team
			_tmpTeamName = _teamColorStrArr select (_x select 1); //team name
			_tmpTeamColor = _teamColorArr select (_x select 1); //color name
			if !(_firstTeam) then {
				_teamPaddingStr = "<br/>"
			} else {
				_cupImg = format ["&#160;<img image='notMarioKartKnockoff\img\generic\cup.paa' size='0.7' color='%1'/>", _tmpTeamColor];
			};
			
			_firstTeam = false; //allow to add a line return before team title
			
			_playersPointsStrArr pushBack format ["%1<t size='1'><t align='left' color='%2'>%5&#160;%3</t>&#160;&#160;&#160;&#160;<t align='right'>%4&#160;</t></t>", _teamPaddingStr, _tmpTeamColor, [_tmpTeamName] call MKK_fnc_strUnbreakSpace, _tmpTeamPoints, _cupImg]; //add to str array
			_cupImg = "";
			
			_tmpPlayersArr = _x select 2; //players array
			{
				_tmpPlayerPoints = _x select 0; //recover points
				_tmpPlayerName = _x select 1; //player name
				_playersPointsStrArr pushBack format ["<t size='1'><t align='left'>&#160;&#160;&#160;&#160;%1</t>&#160;&#160;&#160;&#160;<t align='right'>%2&#160;</t></t>", [_tmpPlayerName] call MKK_fnc_strUnbreakSpace, _tmpPlayerPoints]; //add to str array
			} forEach _tmpPlayersArr;
		};
	} forEach _teamsPointsArr;
	
	_playersPointsStr = _playersPointsStrArr joinString "<br/>"; //array to string
} else { //any other modes
	{ //all players loop
		if (_x getVariable ["MKK_init", false]) then { //player in a kart
			_points = _x getVariable ["MKK_points", -1]; //recover player points
			_playersPointsArr pushBack [_points, name (_x)]; //add to array
		};
	} forEach allPlayers;
	/*
	//debug fake entry
	_playersPointsArr pushBack [100, "tests"]; _playersPointsArr pushBack [20, "hd djfg fjgdg"]; _playersPointsArr pushBack [1500, "-gfdhj -gfj -"]; _playersPointsArr pushBack [25, "gfhsj sj ggsj s"]; _playersPointsArr pushBack [10, "sfgj"]; _playersPointsArr pushBack [1, "ytyjtyty"];
	*/
	_playersPointsArr sort false; //sort array by points

	{
		_tmpPoints = _x select 0; //recover points
		_tmpPlayerName = _x select 1; //player name
		_playersPointsStrArr pushBack format ["<t size='1'><t align='left'>&#160;<img image='notMarioKartKnockoff\img\generic\%3' size='0.7'/>&#160;%1</t>&#160;&#160;&#160;&#160;<t align='right'>%2&#160;</t></t>",[_tmpPlayerName] call MKK_fnc_strUnbreakSpace, _tmpPoints, _cupImg]; //add to str array
		_cupImg = "null.paa";
	} forEach _playersPointsArr;
	
	_playersPointsStr = _playersPointsStrArr joinString "<br/>"; //array to string
};

//gui
_screenPadding = 0.025;

_groupPosX = 0;
_groupPosY = safeZoneY + safeZoneH;
_groupPosWidth = safeZoneW;
_groupPosHeight = 1;

//create group
_grpCtrl = _display ctrlCreate ["RscControlsGroupNoScrollbars", -1]; //create group
_grpCtrl ctrlSetPosition [_groupPosX, _groupPosY, _groupPosWidth, _groupPosHeight]; //set position and size
_grpCtrl ctrlCommit 0; //commit

//create background
_bgCtrl = _display ctrlCreate ["RscText", -1, _grpCtrl]; //create background
_bgCtrl ctrlSetPosition [0, 0, _groupPosWidth, _groupPosHeight]; //set position and size
_bgCtrl ctrlSetBackgroundColor [0.05, 0.05, 0.05, 0.8]; //background color
_bgCtrl ctrlCommit 0; //commit

//create score control
_scoreCtrl = _display ctrlCreate ["RscStructuredText", -1, _grpCtrl]; //create title control
_scoreCtrl ctrlSetStructuredText parseText _playersPointsStr; //set text
_scoreCtrl ctrlSetPosition [0, 0, safeZoneW, 0]; _scoreCtrl ctrlCommit 0; //set initial position and size and commit to get control proper size

//next round countdown
_timeCtrl = _display ctrlCreate ["RscStructuredText", -1, _grpCtrl]; //create title control
_timeCtrl ctrlSetStructuredText parseText format ["<t size='1' align='center'>&#160;%1&#160;%2&#160;%3&#160;</t>", [localize "STR_MKK_round_nextroundstart"] call MKK_fnc_strUnbreakSpace, floor (MKK_scoreEnd - (call MKK_fnc_time)), localize "STR_MKK_seconds"]; //set text
_timeCtrl ctrlSetPosition [0, 0, safeZoneW, 0]; _timeCtrl ctrlCommit 0; //set initial position and size and commit to get control proper size

_groupPosWidth = ctrlTextWidth _scoreCtrl; //score control width
if ((ctrlTextWidth _timeCtrl) > _groupPosWidth) then {_groupPosWidth = ctrlTextWidth _timeCtrl}; //countdown control larger than score control
_groupPosHeight = (ctrlTextHeight _scoreCtrl) + _screenPadding + (ctrlTextHeight _timeCtrl);

_scoreCtrl ctrlSetPosition [0, 0, _groupPosWidth, (ctrlTextHeight _scoreCtrl)]; _scoreCtrl ctrlCommit 0; //update score control position
_timeCtrl ctrlSetPosition [0, (ctrlTextHeight _scoreCtrl) + _screenPadding, _groupPosWidth, (ctrlTextHeight _timeCtrl)]; _timeCtrl ctrlCommit 0; //update countdown control position
_bgCtrl ctrlSetPosition [0, 0, _groupPosWidth, _groupPosHeight]; _bgCtrl ctrlCommit 0; //update background control position
_grpCtrl ctrlSetPosition [safeZoneX + (safeZoneW - _groupPosWidth) / 2, safeZoneY + (safeZoneH - _groupPosHeight) / 2, _groupPosWidth, _groupPosHeight + 0.05]; _grpCtrl ctrlCommit 0; //update control group position

//debug skip, only here in solo
if !(isMultiplayer) then {
	_tmpCtrlPos = ctrlPosition _grpCtrl;
	[_display, "RscButton", -1, -1, _tmpCtrlPos select 0, (_tmpCtrlPos select 1) - 0.05, 0.20, 0.05, "Debug Skip Score", [], [], "missionNamespace setVariable ['MKK_scoreEnd', -1, true]"] call MKK_fnc_createRscControl;
};

while {sleep 0.5; (call MKK_fnc_time) < MKK_scoreEnd && {!(isNull _display)} && {(vehicle player) != player}} do {
	_timeCtrl ctrlSetStructuredText parseText format ["<t size='1' align='center'>&#160;%1&#160;%2&#160;%3&#160;</t>", [localize "STR_MKK_round_nextroundstart"] call MKK_fnc_strUnbreakSpace, floor (MKK_scoreEnd - (call MKK_fnc_time)), localize "STR_MKK_seconds"]; //set text
	//_timeCtrl ctrlCommit 0; //commit
};

ctrlDelete _timeCtrl; //delete control
ctrlDelete _scoreCtrl; //delete control
ctrlDelete _bgCtrl; //delete control
ctrlDelete _grpCtrl; //delete control
_display closeDisplay 1; //close intro display

["notMarioKartKnockoff_screenScore.sqf: End"] call NNS_fnc_debugOutput;