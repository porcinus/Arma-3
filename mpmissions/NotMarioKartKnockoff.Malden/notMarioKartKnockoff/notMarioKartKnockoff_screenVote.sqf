/*
NNS
Not Mario Kart Knockoff
Player side vote script.
*/

["notMarioKartKnockoff_screenVote.sqf: Start"] call NNS_fnc_debugOutput;

openMap false; //close map
//(vehicle player) lock 3; //lock player vehicle

//server global
//_gameModePointsArr = missionNamespace getVariable ["MKK_modePointArr", []];
//_gameModeLimitArr = missionNamespace getVariable ["MKK_modeLimitArr", []];
//_gameModeDurationArr = missionNamespace getVariable ["MKK_modeDuraArr", []];

//player global
_gameModeTextArr = missionNamespace getVariable ["MKK_modeNameArr", []];
_gameModeImgArr = missionNamespace getVariable ["MKK_gameImgArr", []];
_gameModeDescArr = missionNamespace getVariable ["MKK_gameDescArr", []];
_gameModeParamsTextArr = missionNamespace getVariable ["MKK_gameParamsTextArr", []];





waitUntil {!isNull (findDisplay 46)}; //wait for mission screen to open

_display = findDisplay 46 createDisplay "RscDisplayEmpty"; //vote display

disableSerialization;

//colors
_bgColor = [0.05, 0.05, 0.05, 0.8];
_bgSoftColor = [0.05, 0.05, 0.05, 0.3];

_screenWidth = 0.8;
_screenHeight = 4;

_screenPadding = 0.025;

_modesByLines = 3;

_voteBtnModeWidth = (_screenWidth - ((_modesByLines + 1) * _screenPadding)) / _modesByLines;
_voteBtnModeHeight = _voteBtnModeWidth;

_lastY = _screenPadding; //initial Y position
_innerSizeWidth = _screenWidth - (_screenPadding * 2);

_ctrlArr = []; //control array
_ctrlVotesArr = []; //control array to display current votes
_ctrlButtonArr = []; //button array

_elementsCount = 0; //possible element count
_voteEndTime = 0; //default vote end time
MKK_debugSkipVar = ""; //backup vote end time global var name
MKK_debugSkip = false; //forced end of current vote

//create group
_grpCtrl = [_display, "RscControlsGroupNoHScrollbars", -1, -1, safeZoneX + ((safeZoneW - _screenWidth) / 2), safeZoneY + 0.2, _screenWidth + (getNumber (configfile >> "RscControlsGroupNoHScrollbars" >> "VScrollbar" >> "width")), safeZoneH - 0.4] call MKK_fnc_createRscControl;
_grpCtrl ctrlShow false; //hide group

//create background
_bgCtrl = [_display, "RscText", -1, _grpCtrl, 0, 0, _screenWidth, _screenHeight, "", _bgColor] call MKK_fnc_createRscControl;

//create title
//_textHeader01 = "<t size='2.2' align='center' font='PuristaBold'>Not Mario Kart Knockoff</t>";
//_textHeader02 = format ["<t align='center' size='1'>%1</t>", localize "STR_MKK_desc"];
/*
_titleCtrl = [_display, "RscStructuredText", -1, _grpCtrl, -1, _lastY, _innerSizeWidth, -1, _textHeader01] call MKK_fnc_createRscControl;
_lastY = _lastY + ctrlTextHeight _titleCtrl; //update Y position
*/
_logoWidth = _innerSizeWidth * 0.85; _logoHeight = _logoWidth / 2;
_logoCtrl = [_display, "RscPictureKeepAspect", -1, _grpCtrl, -1, _lastY, _logoWidth, _logoHeight, "notMarioKartKnockoff\img\logo.paa"] call MKK_fnc_createRscControl;
_mainLastY = _lastY + _logoHeight; //update Y position

/*
_titleDescCtrl = [_display, "RscStructuredText", -1, _grpCtrl, -1, _lastY, _innerSizeWidth, -1, _textHeader02] call MKK_fnc_createRscControl;
_mainLastY = _lastY + ctrlTextHeight _titleDescCtrl + _screenPadding; //update Y position
*/


if ((call MKK_fnc_time) < MKK_voteTimeEnd && {(vehicle player) != player}) then { //area selection
	_voteEndTime = MKK_voteTimeEnd; //vote end time
	MKK_debugSkipVar = "MKK_voteTimeEnd"; //backup vote end time global var name
	
	_dayTimeTextArr = [localize "STR_MKK_Daytime_day", localize "STR_MKK_Daytime_night"];
	_dayTimeImgArr = ["notMarioKartKnockoff\img\votes\sun.paa", "notMarioKartKnockoff\img\votes\moon.paa"];
	
	_elementsCount = 2; //array size
	
	if (MKK_time == -1) then {player setVariable ["MKK_vote", 0, true]; //no time already set, default to day
	} else {player setVariable ["MKK_vote", MKK_time, true]}; //time set, use as default
	
	_lastY = _mainLastY; //restore good last Y var
	
	//current vote title
	_tmpTitleCtrl = [_display, "RscStructuredText", -1, _grpCtrl, -1, _lastY, -1, -1, format ["<t align='center' size='1' font='PuristaBold'>%1:</t></t>", localize "STR_MKK_Daytime_votefor"]] call MKK_fnc_createRscControl;
	_ctrlArr pushBack _tmpTitleCtrl; //add to array
	
	_lastY = _lastY + ctrlTextHeight _tmpTitleCtrl + _screenPadding; //update Y position
	
	_tmpElement = 0; //current element in line
	_tmpLine = 0; //current line
	_tmpColsByLine = [_elementsCount mod _modesByLines, _modesByLines] select ((_elementsCount - (_tmpLine * _modesByLines)) >= _modesByLines); //columns by line
	_tmpX = (_screenWidth + _screenPadding - ((_voteBtnModeWidth + _screenPadding) * _tmpColsByLine)) / 2; //current element X position
	_tmpY = _lastY; //current element Y position
	
	for "_i" from 0 to (_elementsCount - 1) do {
		//daytime name
		_tmpNameCtrl = [_display, "RscStructuredText", -1, _grpCtrl, _tmpX, _tmpY, _voteBtnModeWidth, -1, format ["<t size='0.9' align='center'>%1</t>", _dayTimeTextArr select _i]] call MKK_fnc_createRscControl;
		_ctrlArr pushBack _tmpNameCtrl; //add to array
		
		//daytime picture
		_tmpPicCtrl = [_display, "RscPictureKeepAspect", -1, _grpCtrl, _tmpX, _tmpY + (ctrlTextHeight _tmpNameCtrl), _voteBtnModeWidth, _voteBtnModeHeight, _dayTimeImgArr select _i] call MKK_fnc_createRscControl;
		_ctrlArr pushBack _tmpPicCtrl; //add to array
		
		//votes count
		_tmpVoteCtrl = [_display, "RscStructuredText", -1, _grpCtrl, _tmpX, _tmpY + (ctrlTextHeight _tmpNameCtrl) + _voteBtnModeHeight, _voteBtnModeWidth, -1, "<t size='0.8' align='center'>0 vote</t>"] call MKK_fnc_createRscControl;
		_ctrlVotesArr pushBack _tmpVoteCtrl; //add to array
		
		//vote button
		_tmpBntCtrl = [_display, "RscButton", -1, _grpCtrl, _tmpX, _tmpY, _voteBtnModeWidth, (ctrlTextHeight _tmpNameCtrl) + _voteBtnModeHeight + (ctrlTextHeight _tmpVoteCtrl), "", [], [], format ["player setVariable ['MKK_vote', %1, true]", _i], true, 0.7] call MKK_fnc_createRscControl;
		_ctrlButtonArr pushBack _tmpBntCtrl; //add to array
		
		_tmpX = _tmpX + _voteBtnModeWidth + _screenPadding; //set next X position
		_tmpElement = _tmpElement + 1; //increment current line elements count
		if (_tmpElement == _modesByLines && !(_tmpElement == _elementsCount)) then { //next element will be in new line
			_tmpElement = 0; //reset current line elements count
			_tmpLine = _tmpLine + 1; //increment line
			_tmpColsByLine = [_elementsCount mod _modesByLines, _modesByLines] select ((_elementsCount - (_tmpLine * _modesByLines)) >= _modesByLines); //new line columns count
			_tmpX = (_screenWidth + _screenPadding - ((_voteBtnModeWidth + _screenPadding) * _tmpColsByLine)) / 2; //new X position
			_tmpY = _lastY + (((ctrlTextHeight _tmpNameCtrl) + _voteBtnModeHeight + (ctrlTextHeight _tmpVoteCtrl) + _screenPadding) * _tmpLine); //new Y position
		};
	};
	
	_lastY = _tmpY + (ctrlTextHeight (_ctrlArr select 0)) + _voteBtnModeHeight + (ctrlTextHeight (_ctrlVotesArr select 0)) + (_screenPadding * 2); //update Y position
};

if ((call MKK_fnc_time) < MKK_voteAreaEnd && {(vehicle player) != player}) then { //area selection
	_voteEndTime = MKK_voteAreaEnd; //vote end time
	MKK_debugSkipVar = "MKK_voteAreaEnd"; //backup vote end time global var name
	
	_elementsCount = count MKK_boxs; //area array size
	player setVariable ["MKK_vote", round (random (_elementsCount - 1)), true]; //reset vote var with a random vote
	_lastY = _mainLastY; //restore good last Y var
	
	_areaSizesArr = MKK_areaSizesArr; //global to local
	
	//current vote title
	_tmpTitleCtrl = [_display, "RscStructuredText", -1, _grpCtrl, -1, _lastY, -1, -1, format ["<t align='center' size='1' font='PuristaBold'>%1:</t></t>", localize "STR_MKK_Area_votefor"]] call MKK_fnc_createRscControl;
	_ctrlArr pushBack _tmpTitleCtrl; //add to array
	
	_lastY = _lastY + ctrlTextHeight _tmpTitleCtrl + _screenPadding; //update Y position
	
	_tmpElement = 0; //current element in line
	_tmpLine = 0; //current line
	_tmpColsByLine = [_elementsCount mod _modesByLines, _modesByLines] select ((_elementsCount - (_tmpLine * _modesByLines)) >= _modesByLines); //columns by line
	_tmpX = (_screenWidth + _screenPadding - ((_voteBtnModeWidth + _screenPadding) * _tmpColsByLine)) / 2; //current element X position
	_tmpY = _lastY; //current element Y position
	
	_r2tArr = []; //r2t surfaces names array
	_markersPosArr = []; //markers positions array
	_camArr = []; //camera objects array
	
	for "_i" from 0 to (_elementsCount - 1) do {
		//r2t
		_tmpAreaR2tName = format ["mkkarea%1", _i]; //current r2t name
		_r2tArr pushBack _tmpAreaR2tName; //add to array
		_tmpMarkerPos = getMarkerPos format ["MKK_area%1", _i]; _tmpMarkerPos set [2, -35]; //current area marker position
		_markersPosArr pushBack _tmpMarkerPos; //add to array
		_tmpCam = "camera" camCreate _tmpMarkerPos; //create camera
		_tmpCam cameraEffect ["Internal", "Back", _tmpAreaR2tName]; _tmpCam camSetTarget _tmpMarkerPos; //set viewpoint, r2t name and camera target
		_camArr pushBack _tmpCam; //add to array
		
		//area name and size
		_tmpAreaName = "<t size='0.9'>&#160;</t><br/>";
		_tmpLocationsArr = nearestLocations [_tmpMarkerPos, ["NameCity", "NameVillage", "NameCityCapital", "NameLocal", "Airport"], 1000, _tmpMarkerPos]; //near location
		if (count _tmpLocationsArr > 0) then {
			_tmpLocationName = text (_tmpLocationsArr select 0); //location text
			if (_tmpLocationName == "") then {_tmpLocationName = name (_tmpLocationsArr select 0)}; //location name if text failed
			if !(_tmpLocationName == "") then { //non empty text
				_tmpAreaNameArr = _tmpLocationName splitString ""; _tmpAreaNameArr set [0, toUpper (_tmpAreaNameArr select 0)]; //split to array and capitalize first character
				_tmpAreaName = format ["<t size='0.9' align='center'>%1</t><br/>", _tmpAreaNameArr joinString ""]; //array to string and format
			};
		};
		
		_tmpNameCtrl = [_display, "RscStructuredText", -1, _grpCtrl, _tmpX, _tmpY, _voteBtnModeWidth, -1, format ["%1<t size='0.75' align='center'>%2</t>", _tmpAreaName, format [localize "STR_MKK_Area_areasize_title", _i + 1, _areaSizesArr select _i]]] call MKK_fnc_createRscControl;
		_ctrlArr pushBack _tmpNameCtrl; //add to array
		
		//area picture
		_tmpPicCtrl = [_display, "RscPicture", -1, _grpCtrl, _tmpX, _tmpY + (ctrlTextHeight _tmpNameCtrl), _voteBtnModeWidth, _voteBtnModeHeight, format ["#(argb,256,256,1)r2t(%1,%2)", _tmpAreaR2tName, _voteBtnModeWidth / _voteBtnModeHeight]] call MKK_fnc_createRscControl;
		_ctrlArr pushBack _tmpPicCtrl; //add to array
		
		//votes count
		_tmpVoteCtrl = [_display, "RscStructuredText", -1, _grpCtrl, _tmpX, _tmpY + (ctrlTextHeight _tmpNameCtrl) + _voteBtnModeHeight, _voteBtnModeWidth, -1, "<t size='0.8' align='center'>0 vote</t>"] call MKK_fnc_createRscControl;
		_ctrlVotesArr pushBack _tmpVoteCtrl; //add to array
		
		//vote button
		_tmpBntCtrl = [_display, "RscButton", -1, _grpCtrl, _tmpX, _tmpY, _voteBtnModeWidth, (ctrlTextHeight _tmpNameCtrl) + _voteBtnModeHeight + (ctrlTextHeight _tmpVoteCtrl), "", [], [], format ["player setVariable ['MKK_vote', %1, true]", _i], true, 0.7] call MKK_fnc_createRscControl;
		_ctrlButtonArr pushBack _tmpBntCtrl; //add to array
		
		_tmpX = _tmpX + _voteBtnModeWidth + _screenPadding; //set next X position
		_tmpElement = _tmpElement + 1; //increment current line elements count
		if (_tmpElement == _modesByLines && !(_tmpElement == _elementsCount)) then { //next element will be in new line
			_tmpElement = 0; //reset current line elements count
			_tmpLine = _tmpLine + 1; //increment line
			_tmpColsByLine = [_elementsCount mod _modesByLines, _modesByLines] select ((_elementsCount - (_tmpLine * _modesByLines)) >= _modesByLines); //new line columns count
			_tmpX = (_screenWidth + _screenPadding - ((_voteBtnModeWidth + _screenPadding) * _tmpColsByLine)) / 2; //new X position
			_tmpY = _lastY + (((ctrlTextHeight _tmpNameCtrl) + _voteBtnModeHeight + (ctrlTextHeight _tmpVoteCtrl) + _screenPadding) * _tmpLine); //new Y position
		};
	};
	
	[_display, _r2tArr, _markersPosArr, _camArr] spawn { //camera script
		_display = _this select 0; //current display
		_r2tArr = _this select 1; //r2t surfaces name array
		_markersPosArr = _this select 2; //markers position array
		_camArr = _this select 3; //camera array
		_camDist = 125; _camRotation = 0; //initial camera distance and rotation
		_camCount = (count _camArr) - 1; //camera count - 1
		
		_ssTime = date call BIS_fnc_sunriseSunsetTime; //get sunrine and sunset time
		if (count _ssTime == 2) then {if (daytime < (_ssTime select 0) || daytime > (_ssTime select 1)) then {
			for "_i" from 0 to _camCount do {
			(_r2tArr select _i) setPiPEffect [1];
			}; //night vision on
		}}; //night time
		
		while {(call MKK_fnc_time) < MKK_voteAreaEnd && {!(isNull _display)} && {(vehicle player) != player}} do { //current vote not expired
			for "_i" from 0 to _camCount do { //cameras loop
				_tmpCam = _camArr select _i; //current camera object
				_tmpMarkerPos = _markersPosArr select _i; //current area marker position
				_tmpCamPos = _tmpMarkerPos getPos [_camDist, _camRotation]; _tmpCamPos set [2, 125]; //compute new camera position
				_tmpCam camSetPos _tmpCamPos; _tmpCam camCommit 1; //set new postion and commit
			};
			_camRotation = _camRotation + 10; if (_camRotation > 360) then {_camRotation = 0}; //update rotation
			waitUntil {(_camArr findIf {camCommitted _x} != -1) || {isNull _display} || {(vehicle player) == player}}; //wait for first camera committed
		};
		
		for "_i" from 0 to _camCount do {_tmpCam = _camArr select _i; _tmpCam cameraEffect ["terminate", "back"]; camDestroy _tmpCam}; //unregister r2t and delete camera
	};
	
	_lastY = _tmpY + (ctrlTextHeight (_ctrlArr select 0)) + _voteBtnModeHeight + (ctrlTextHeight (_ctrlVotesArr select 0)) + (_screenPadding * 2); //update Y position
};

if ((call MKK_fnc_time) < MKK_voteModeEnd && {(vehicle player) != player}) then { //game mode selection
	_voteEndTime = MKK_voteModeEnd; //vote end time
	MKK_debugSkipVar = "MKK_voteModeEnd"; //backup vote end time global var name

	_elementsCount = count _gameModeTextArr; //game mode array size
	player setVariable ["MKK_vote", 0, true]; //reset vote var
	_lastY = _mainLastY; //restore good last Y var
	
	//current vote title
	_tmpTitleCtrl = [_display, "RscStructuredText", -1, _grpCtrl, -1, _lastY, -1, -1, format ["<t align='center' size='1' font='PuristaBold'>%1:</t></t>", localize "STR_MKK_Gamemode_votefor"]] call MKK_fnc_createRscControl;
	_ctrlArr pushBack _tmpTitleCtrl; //add to array
	
	_lastY = _lastY + ctrlTextHeight _tmpTitleCtrl + _screenPadding; //update Y position
	
	_tmpElement = 0; //current element in line
	_tmpLine = 0; //current line
	_tmpColsByLine = [_elementsCount mod _modesByLines, _modesByLines] select ((_elementsCount - (_tmpLine * _modesByLines)) >= _modesByLines); //columns by line
	_tmpX = (_screenWidth + _screenPadding - ((_voteBtnModeWidth + _screenPadding) * _tmpColsByLine)) / 2; //current element X position
	_tmpY = _lastY; //current element Y position
	
	for "_i" from 0 to (_elementsCount - 1) do {
		//mode name
		_tmpNameCtrl = [_display, "RscStructuredText", -1, _grpCtrl, _tmpX, _tmpY, _voteBtnModeWidth, -1, format ["<t size='0.9' align='center'>%1</t>", _gameModeTextArr select _i]] call MKK_fnc_createRscControl;
		_ctrlArr pushBack _tmpNameCtrl; //add to array
		
		//mode picture
		_tmpPicCtrl = [_display, "RscPictureKeepAspect", -1, _grpCtrl, _tmpX, _tmpY + (ctrlTextHeight _tmpNameCtrl), _voteBtnModeWidth, _voteBtnModeHeight, _gameModeImgArr select _i] call MKK_fnc_createRscControl;
		_ctrlArr pushBack _tmpPicCtrl; //add to array
		
		//votes count
		_tmpVoteCtrl = [_display, "RscStructuredText", -1, _grpCtrl, _tmpX, _tmpY + (ctrlTextHeight _tmpNameCtrl) + _voteBtnModeHeight, _voteBtnModeWidth, -1, "<t size='0.8' align='center'>0 vote</t>"] call MKK_fnc_createRscControl;
		_ctrlVotesArr pushBack _tmpVoteCtrl; //add to array
		
		//vote button
		_tmpBntCtrl = [_display, "RscButton", -1, _grpCtrl, _tmpX, _tmpY, _voteBtnModeWidth, (ctrlTextHeight _tmpNameCtrl) + _voteBtnModeHeight + (ctrlTextHeight _tmpVoteCtrl), "", [], [], format ["player setVariable ['MKK_vote', %1, true]", _i], true, 0.7] call MKK_fnc_createRscControl;
		_ctrlButtonArr pushBack _tmpBntCtrl; //add to array
		
		_tmpX = _tmpX + _voteBtnModeWidth + _screenPadding; //set next X position
		_tmpElement = _tmpElement + 1; //increment current line elements count
		if (_tmpElement == _modesByLines && !(_tmpElement == _elementsCount)) then { //next element will be in new line
			_tmpElement = 0; //reset current line elements count
			_tmpLine = _tmpLine + 1; //increment line
			_tmpColsByLine = [_elementsCount mod _modesByLines, _modesByLines] select ((_elementsCount - (_tmpLine * _modesByLines)) >= _modesByLines); //new line columns count
			_tmpX = (_screenWidth + _screenPadding - ((_voteBtnModeWidth + _screenPadding) * _tmpColsByLine)) / 2; //new X position
			_tmpY = _lastY + (((ctrlTextHeight _tmpNameCtrl) + _voteBtnModeHeight + (ctrlTextHeight _tmpVoteCtrl) + _screenPadding) * _tmpLine); //new Y position
		};
	};
	
	_lastY = _tmpY + (ctrlTextHeight (_ctrlArr select 0)) + _voteBtnModeHeight + (ctrlTextHeight (_ctrlVotesArr select 0)) + _screenPadding; //update Y position
	
	//mode description
	_maxHeight = 0; //max control size
	_modeDescCtrl = _display ctrlCreate ["RscStructuredText", -1, _grpCtrl]; //create title control, require idc
	{ //detect max height loop
		_modeDescCtrl ctrlSetStructuredText parseText format ["<t size='0.9' align='center'>%1</t>", _x]; //tmp size
		_modeDescCtrl ctrlSetPosition [0, 0, _innerSizeWidth, 0]; _modeDescCtrl ctrlCommit 0; //set text and width only, needed to get proper height
		if ((ctrlTextHeight _modeDescCtrl) > _maxHeight) then {_maxHeight = ctrlTextHeight _modeDescCtrl}; //update max height var
	} forEach _gameModeDescArr;
	_modeDescCtrl ctrlSetStructuredText parseText ""; //reset text
	_modeDescCtrl ctrlSetPosition [(_screenWidth - _innerSizeWidth) / 2, _lastY, _innerSizeWidth, _maxHeight]; //set proper position and size
	_modeDescCtrl ctrlCommit 0; //commit
	_ctrlArr pushBack _modeDescCtrl; //add to array
	
	_lastY = _lastY + _maxHeight + _screenPadding; //update Y position
	
	//add button event to display description of each mode
	for "_i" from 0 to (_elementsCount - 1) do { //button event loop
		_tmpCtrl = _ctrlButtonArr select _i; //recover control
		_tmpCtrl setVariable ["desc", _gameModeDescArr select _i]; //set var with description
		_tmpCtrl setVariable ["ctrl", _modeDescCtrl]; //add description control
		_handle = _tmpCtrl ctrlAddEventHandler ["MouseEnter", {((_this select 0) getVariable "ctrl") ctrlSetStructuredText parseText format ["<t size='0.9' align='center'>%1</t>", (_this select 0) getVariable "desc"]}];
		_handle = _tmpCtrl ctrlAddEventHandler ["MouseExit", {((_this select 0) getVariable "ctrl") ctrlSetStructuredText parseText ""}];
	};
};

if ((call MKK_fnc_time) < MKK_voteRulesEnd && {(vehicle player) != player}) then { //params selection
	_voteEndTime = MKK_voteRulesEnd; //vote end time
	MKK_debugSkipVar = "MKK_voteRulesEnd"; //backup vote end time global var name
	waitUntil {sleep 0.1; MKK_mode != -1}; //wait until current mode broadcast
	
	_modeParamsArr = _gameModeParamsTextArr select MKK_mode; //get right game mode params
	_elementsCount = count _modeParamsArr; //update current mode parameters count
	player setVariable ["MKK_vote", 0, true]; //reset vote var
	
	_lastY = _mainLastY; //restore good last Y var
	
	//selected game mode title
	_tmpSelectedModeCtrl = [_display, "RscStructuredText", -1, _grpCtrl, -1, _lastY, _innerSizeWidth, -1, format ["<t align='center' valign='bottom'><t size='1'>%1</t> : <t size='1.1' font='PuristaBold'>%2</t></t>", localize "STR_MKK_Gamemode_selected", _gameModeTextArr select MKK_mode]] call MKK_fnc_createRscControl;
	_ctrlArr pushBack _tmpSelectedModeCtrl; //add to array
	
	_lastY = _lastY + ctrlTextHeight _tmpSelectedModeCtrl + _screenPadding; //update Y position
	
	//current vote title
	_tmpTitleCtrl = [_display, "RscStructuredText", -1, _grpCtrl, -1, _lastY, -1, -1, format ["<t align='center' size='1' font='PuristaBold'>%1:</t></t>", localize "STR_MKK_Gamemode_voteforparams"]] call MKK_fnc_createRscControl;
	_ctrlArr pushBack _tmpTitleCtrl; //add to array
	
	_lastY = _lastY + ctrlTextHeight _tmpTitleCtrl + _screenPadding; //update Y position
	
	_tmpElement = 0; //current element in line
	_tmpLine = 0; //current line
	_tmpColsByLine = [_elementsCount mod _modesByLines, _modesByLines] select ((_elementsCount - (_tmpLine * _modesByLines)) >= _modesByLines); //columns by line
	_tmpX = (_screenWidth + _screenPadding - ((_voteBtnModeWidth + _screenPadding) * _tmpColsByLine)) / 2; //current element X position
	_tmpY = _lastY; //current element Y position
	
	//detect params max text height
	_maxHeight = 0; //max param text height
	_tmpNameCtrl = _display ctrlCreate ["RscStructuredText", -1, _grpCtrl]; //create temporary control
	{ //detect max height loop
		_tmpNameCtrl ctrlSetStructuredText parseText format ["<t align='center'><br/>%1<br/><br/></t>", _x]; _tmpNameCtrl ctrlSetPosition [-1, -1, _voteBtnModeWidth, 0]; _tmpNameCtrl ctrlCommit 0; //set text, width only, needed to get proper height
		if ((ctrlTextHeight _tmpNameCtrl) > _maxHeight) then {_maxHeight = ctrlTextHeight _tmpNameCtrl}; //update max height var
	} forEach _modeParamsArr;
	ctrlDelete _tmpNameCtrl; //delete control
	
	for "_i" from 0 to (_elementsCount - 1) do { //params
		//parameters name
		_tmpNameCtrl = [_display, "RscStructuredText", -1, _grpCtrl, _tmpX, _tmpY, _voteBtnModeWidth, _maxHeight, format ["<t size='0.9' align='center' valign='middle'><br/>%1<br/><br/></t>", _modeParamsArr select _i], _bgSoftColor] call MKK_fnc_createRscControl;
		_tmpNameCtrl ctrlEnable false;
		_ctrlArr pushBack _tmpNameCtrl; //add to array
		
		//votes count
		_tmpVoteCtrl = [_display, "RscStructuredText", -1, _grpCtrl, _tmpX, _tmpY + _maxHeight, _voteBtnModeWidth, -1, "<t size='0.8' align='center'>0 vote</t>"] call MKK_fnc_createRscControl;
		_ctrlVotesArr pushBack _tmpVoteCtrl; //add to array
		
		//vote button
		_tmpBntCtrl = [_display, "RscButton", -1, _grpCtrl, _tmpX, _tmpY, _voteBtnModeWidth, _maxHeight + (ctrlTextHeight _tmpVoteCtrl), "", [], [], format ["player setVariable ['MKK_vote', %1, true]", _i], true, 0.7] call MKK_fnc_createRscControl;
		_ctrlButtonArr pushBack _tmpBntCtrl; //add to array
		
		_tmpX = _tmpX + _voteBtnModeWidth + _screenPadding; //set next X position
		_tmpElement = _tmpElement + 1; //increment current line elements count
		if (_tmpElement == _modesByLines && !(_tmpElement == _elementsCount)) then { //next element will be in new line
			_tmpElement = 0; //reset current line elements count
			_tmpLine = _tmpLine + 1; //increment line
			_tmpColsByLine = [_elementsCount mod _modesByLines, _modesByLines] select ((_elementsCount - (_tmpLine * _modesByLines)) >= _modesByLines); //new line columns count
			_tmpX = (_screenWidth + _screenPadding - ((_voteBtnModeWidth + _screenPadding) * _tmpColsByLine)) / 2; //new X position
			_tmpY = _lastY + ((_maxHeight + (ctrlTextHeight _tmpVoteCtrl) + _screenPadding) * _tmpLine); //new Y position
		};
	};
	
	_lastY = _tmpY + _maxHeight + (ctrlTextHeight (_ctrlVotesArr select 0)) + _screenPadding; //update Y position
};

//debug skip, only here in solo
if !(isMultiplayer) then {
	[_display, "RscButton", -1, _grpCtrl, 0, 0, 0.2, 0.05, "Debug Skip Vote", [], [], "if !(MKK_debugSkipVar=='') then {missionNamespace setVariable [MKK_debugSkipVar, floor (call MKK_fnc_time), true]; MKK_debugSkip = true};"] call MKK_fnc_createRscControl;
};

//version
_textVersion = localize "STR_MKK_version";
if !(_textVersion == "") then {
	_versionCtrl = [_display, "RscStructuredText", -1, _grpCtrl, 0, _lastY + _screenPadding, -1, -1, format ["<t size='0.7'>%1</t>", _textVersion], [], [1,1,1,0.25]] call MKK_fnc_createRscControl;
	_ctrlArr pushBack _versionCtrl; //add to array
};

//vote time remain
_timeRemainCtrl = [_display, "RscStructuredText", -1, _grpCtrl, -1, _lastY, _innerSizeWidth, -1, format ["<t size='0.8' align='center'>%1 %2</t>", floor (_voteEndTime - (call MKK_fnc_time)), localize "STR_MKK_Gamemode_voteends"]] call MKK_fnc_createRscControl;
_ctrlArr pushBack _timeRemainCtrl; //add to array

//update group and background position and size
_bgPos = ctrlPosition _bgCtrl; //get background position and size
_bgHeight = _lastY + (ctrlTextHeight _timeRemainCtrl) + _screenPadding; //background height
_bgCtrl ctrlSetPosition [_bgPos select 0, _bgPos select 1, _bgPos select 2, _bgHeight]; //update position and size
_bgCtrl ctrlCommit 0; //commit
_grpPos = ctrlPosition _grpCtrl; //get background position and size
if (_bgHeight < (safeZoneH - 0.2)) then {_grpCtrl ctrlSetPosition [_grpPos select 0, safeZoneY + (safeZoneH - _bgHeight) / 2, _grpPos select 2, _bgHeight + 0.05];  //update position and vertical center
} else {_grpCtrl ctrlSetPosition [_grpPos select 0, safeZoneY + 0.1, _grpPos select 2, (safeZoneH - 0.2)]}; //update position and limit height
_grpCtrl ctrlCommit 0; //commit
_grpCtrl ctrlShow true; //show group

//update player votes and remaining time
_playerVotesArr = []; for "_i" from 0 to _elementsCount do {_playerVotesArr pushBack 0}; //contain initial player votes
_voteResetArr = +(_playerVotesArr); //used to reset votes
_lastVoteArr = +(_playerVotesArr); //backup last vote
while {sleep 0.25; (call MKK_fnc_time) < _voteEndTime && {!(isNull _display)} && {(vehicle player) != player} && {!MKK_debugSkip}} do { //current screen not expired
	_playerVotesArr = +(_voteResetArr); //reset votes
	
	{ //all players loop
		_tmpvote = _x getVariable ["MKK_vote", -1]; //get var from player
		if !(_tmpvote == -1) then {_playerVotesArr set [_tmpvote, (_playerVotesArr select _tmpvote) + 1]}; //increment vote count
	} forEach allPlayers;
	
	for "_i" from 0 to (_elementsCount - 1) do { //update displayed votes loop
		_tmpvote = _playerVotesArr select _i; //get votes for current mode
		if !(_tmpvote == (_lastVoteArr select _i)) then {
			(_ctrlVotesArr select _i) ctrlSetStructuredText parseText format ["<t size='0.8' align='center'>%1 vote%2</t>", _tmpvote, ["","s"] select (_tmpvote > 1)]; //update text
			_playerVotesArr set [_i, 0]; //reset vote for current mode
			_lastVoteArr set [_i, _tmpvote]; //backup last vote
		};
	};
	
	_remainingTime = floor (_voteEndTime - (call MKK_fnc_time));
	if (_remainingTime < 0) then {_remainingTime = 0}; //little desync
	_timeRemainCtrl ctrlSetStructuredText parseText format ["<t size='0.8' align='center'>%1 %2</t>", _remainingTime, localize "STR_MKK_Gamemode_voteends"]; //set text
};

//screen useless control cleanup
{ctrlDelete _x} forEach _ctrlArr;
{ctrlDelete _x} forEach _ctrlButtonArr;
{ctrlDelete _x} forEach _ctrlVotesArr;
{ctrlDelete _x} forEach [_logoCtrl, /*_titleCtrl, _titleDescCtrl, */_bgCtrl, _grpCtrl]; //remove remaining controls

_display closeDisplay 1; //close vote display
//(vehicle player) lock 0; //unlock player vehicle

["notMarioKartKnockoff_screenVote.sqf: End"] call NNS_fnc_debugOutput;