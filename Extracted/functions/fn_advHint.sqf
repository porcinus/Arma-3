/*
	File: advHint.sqf
	Author: Borivoj Hlava

	Description:
	Primary function of advanced hint system

	Parameter(s):
	_this select 0: Array - Array in format ["hint mainclass","hint class"] or ["hint mainclass","hint class","sub-hint class"]
	_this select 1: Number (optional) - Duration of short version of hint in seconds
	_this select 2: String (optional) - Condition for hiding of short version of hint
	_this select 3: Number (optional) - Duration of full version of hint in seconds
	_this select 4: String (optional) - Condition for hiding of full version of hint
	_this select 5: Bool (optional) - True shows hint even if tutorial hints are disabled via game settings
	_this select 6: Bool (optional) - True shows directly the full hint without using of the short hint
	_this select 7: Bool (optional) - Show the hint in a mission only once (true) or multiple times (false)
	_this select 8: Bool (optional) - Sound is not used when false

	Returned value:
	None. Create variable BIS_fnc_advHint_hint:
	BIS_fnc_advHint_hint select 0: String - Class of hint
	BIS_fnc_advHint_hint select 1: String - Structured text of full hint
	BIS_fnc_advHint_hint select 2: String - Structured text of short hint
	BIS_fnc_advHint_hint select 3: Number - Duration of short hint in seconds
	BIS_fnc_advHint_hint select 4: String - Condition for hiding of short hint (default: "false")
	BIS_fnc_advHint_hint select 5: Number - Duration of full hint in seconds
	BIS_fnc_advHint_hint select 6: String - Condition for hiding of full hint (default: "false")
	BIS_fnc_advHint_hint select 7: Bool - True shows directly full hint (default: false)
	BIS_fnc_advHint_hint select 8: Bool - True for using of sound (default: true)

	Note: Hint must be defined in CfgHints.
*/

_ignoreTutHintsEnabled = _this param [5,false];

if (isTutHintsEnabled || _ignoreTutHintsEnabled) then {
	if (isNil {BIS_fnc_advHint_shownList}) then {BIS_fnc_advHint_shownList = []};
	_onlyOnceCheck = true;
	_onlyOnce = _this param [7,false];				//show only once or multiple times

	_class = _this select 0;
	_cfg = configFile;
	if ((count _class) > 2) then {
		_cfg = [["CfgHints",_class select 0,_class select 1,_class select 2],configfile >> "CfgHints" >> "Empty"] call bis_fnc_loadClass;
	} else {
		_cfg = [["CfgHints",_class select 0,_class select 1],configfile >> "CfgHints" >> "Empty"] call bis_fnc_loadClass;
	};
	if (isclass _cfg) then {
		if (_cfg in BIS_fnc_advHint_shownList) then {
			_onlyOnceCheck = false;
		} else {
			BIS_fnc_advHint_shownList set [count BIS_fnc_advHint_shownList,_cfg];
		};
	};

	if (!_onlyOnce || _onlyOnceCheck) then {
		_this spawn {
			scriptName "fn_advHint_mainLoop";
			// ========== Parameters ==========
			_class = _this select 0;
			_titleClass = _class select 1;									//classes, 2 requires
			_showT = _this param [1,15,[0]];				//duration of short hint
			_cond = _this param [2,"false",[""]];			//hide condition of short hint
			_showTF = _this param [3,35,[0]];				//duration of full hint
			_condF = _this param [4,"false",[""]];			//hide condition of full hint
			_show = _this param [5,false];					//show even if its disabled in options
			_onlyFull = _this param [6,false];				//show directly full hint
			_sound = _this param [8,true];					//use animation and sound

			if (_showT == 0) then {_showT = 15};
			if (_cond == "") then {_cond = "false"};
			if (_showTF == 0) then {_showTF = 35};
			if (_condF == "") then {_condF = "false"};

			//--- Get hint data
			_hintData = _class call bis_fnc_advHintFormat;
			_titleCfg = _hintData select 0;
			_titleName = _hintData select 1;
			_titleNameShort = _hintData select 2;
			_info = _hintData select 3;
			_tipString = _hintData select 4;
			_image = _hintData select 5;
			_dlc = _hintData select 6;
			_isDlc = _hintData select 7;
			_keyColor = _hintData select 8;
			_imageVar = _image != "";

			if (_isDlc) then {
				_showT = 15;
				_cond = "false";
				_showTF = 35;
				_condF = "false";
				_show = false;
				_onlyFull = true;
			};

			//marking of shown hints in FM
			if (isNil {BIS_fnc_advHint_FMMark}) then {BIS_fnc_advHint_FMMark = []};
			_FMClassList = ["GlobalTopic_"+(_class select 0),(_class select 0) + "_" + (_class select 1)];
			{
				if !(_x in BIS_fnc_advHint_FMMark) then {BIS_fnc_advHint_FMMark = BIS_fnc_advHint_FMMark + [_x]};
			} forEach _FMClassList;

			if (isNil {player getVariable "BIS_fnc_advHint_HActiveF"}) then {
				player setVariable ["BIS_fnc_advHint_HActiveF",""]
			};
			if (isNil {player getVariable "BIS_fnc_advHint_HActiveS"}) then {
				player setVariable ["BIS_fnc_advHint_HActiveS",""]
			};

			//Logging of shown hints to diary --------------------------------------
			//_dlcLog = if !((count _class) > 2) then {getNumber (_titleCfg >> "dlc")} else {getNumber (_topicCfg >> "dlc")};
			if (_dlc >= 0) then {	//no log for hint with negative dlc parameter
				//Check that "log" subject exists in diary. If not, create it.
				if (!(player diarysubjectexists "log")) then
				{
					player creatediarysubject ["log", localize "STR_UI_DIARY_TITLE"];
				};

				player createDiaryRecord ["log", [localize "STR_A3_RSCDIARY_RECORD_HINTS", format["<img image='%1' width=18 height=18/> <execute expression=""
				uinamespace setvariable ['RscDisplayFieldManual_Topic', '%2'];
				uinamespace setvariable ['RscDisplayFieldManual_Hint', '%3'];
				_display = if (!isnull (finddisplay 129)) then {finddisplay 129} else {finddisplay 12};
				_display createDisplay 'RscDisplayFieldManual';"">%4</execute>",
					getText (_titleCfg >> "image"),
					"GlobalTopic_" + (_class select 0),
					(_class select 0) + "_" + (_class select 1),
					_titleName]]];
			};
			//Logging of shown hints to diary --------------------------------------

			disableSerialization;
			waitUntil {!(isNull call BIS_fnc_displayMission)};
			BIS_fnc_advHint_HPressed = nil;

			// -- Hint recalling --
			///Note: This whole block of code is not in 'with uiNamespace do' because there was strange rare error when some variables were undefined even when they definitely shouldn't be
			if !(isNil {uiNamespace getVariable "BIS_fnc_advHint_hintHandlers"}) then {
				if !(uiNamespace getVariable ["BIS_fnc_advHint_hintHandlers",true]) then {
					_display = [] call BIS_fnc_displayMission;

					uiNamespace setVariable ["BIS_fnc_advHint_hintHandlers",true];
					_display displayAddEventHandler [
						"KeyDown",
						"
							_key = _this select 1;

							if (_key in actionkeys 'help') then {
								BIS_fnc_advHint_HPressed = true;
								BIS_fnc_advHint_RefreshCtrl = true;
								[true] call BIS_fnc_AdvHintCall;
								true;
							};
						"
					];
				};
			} else {
				_display = [] call BIS_fnc_displayMission;

				uiNamespace setVariable ["BIS_fnc_advHint_hintHandlers",true];
				_display displayAddEventHandler [
					"KeyDown",
					"
						_key = _this select 1;

						if (_key in actionkeys 'help') then {
							BIS_fnc_advHint_HPressed = true;
							BIS_fnc_advHint_RefreshCtrl = true;
							[true] call BIS_fnc_AdvHintCall;
							true;
						};
					"
				];
			};

			/*with uiNamespace do {
				disableSerialization;
				if !(isNil "BIS_fnc_advHint_hintHandlers") then {
					if !(BIS_fnc_advHint_hintHandlers) then {
						_display = [] call BIS_fnc_displayMission;

						BIS_fnc_advHint_hintHandlers = true;
						_display displayAddEventHandler [
							"KeyDown",
							"
								_key = _this select 1;

								if (_key in actionkeys 'help') then {
									BIS_fnc_advHint_HPressed = true;
									BIS_fnc_advHint_RefreshCtrl = true;
									[true] call BIS_fnc_AdvHintCall;
									true;
								};
							"
						];
					};
				} else {
					_display = [] call BIS_fnc_displayMission;

					BIS_fnc_advHint_hintHandlers = true;
					_display displayAddEventHandler [
						"KeyDown",
						"
							_key = _this select 1;

							if (_key in actionkeys 'help') then {
								BIS_fnc_advHint_HPressed = true;
								BIS_fnc_advHint_RefreshCtrl = true;
								[true] call BIS_fnc_AdvHintCall;
								true;
							};
						"
					];
				};
			};*/

			// -- Build hint --
			_textSizeSmall = 1;			// derived from default hint font size 0.8; final size = (0.8 * 1) = 0.8
			_textSizeNormal = 1.25;		// derived from default hint font size 0.8; final size = (0.8 * 1.25) = 1.0
			_invChar05 = "<img image='#(argb,8,8,3)color(0,0,0,0)' size='0.5' />";		//invisible object for small spaces
			_invChar02 = "<img image='#(argb,8,8,3)color(0,0,0,0)' size='0.2' />";		//invisible object for small spaces
			_shadowColor = "#999999";

			_helpArray = actionKeysNamesArray "help";

			private _keyString = if (count _helpArray != 0) then
			{
				format ["[<t color = '%1'>%2</t>]", _keyColor, _helpArray select 0];
			}
			else
			{
				//wrong name of action or undefined key, actionKeysNamesArray return empty array
				format ["[<t color = '#FF0000'>%1</t>]", toUpper localize "STR_A3_Hints_unmapped"];
			};

			_partString = format [localize "STR_A3_Hints_recall", _keyString];
			_partShortString = format [localize "STR_A3_Hints_moreinfo", _keyString];

			_startPartString = "";
			if (_titleNameShort == "") then {
				_titleNameShort = _titleName;
				_startPartString = "";	// from start to image
			} else {
				_startPartString = format ["<t size = '%3' align='center' color = '%5'>""%2""</t><br/>", _titleName, _titleNameShort, _textSizeNormal, _keyColor, _shadowColor];	// from start to image
			};
			_middlePartString = format ["<t align='left' size='%2'>%1</t><br/>", _info, _textSizeSmall];	// from image to tip
			_endPartString = format ["%4<br/><t size = '%2' color = '%3'>%1</t>", _partString, _textSizeSmall, _shadowColor, _invChar02];	// from tip to end
			_tipPartString = "";
			if (_tipString != "") then
			{
				_tipPartString = format ["<t align='left' size='%2' color='%3'>%1</t><br/>", _tipString, _textSizeSmall, _shadowColor];
			};

			_shortHint = format ["<t size = '%5' color = '%6'>%2</t>", _titleName, _partShortString, _textSizeNormal, _keyColor, _textSizeSmall, _shadowColor];

			if (_imageVar) then {		// hint with image
				if (_tipString != "") then {			// hint with tip
					_hint = format ["%1<img image = '%5' size = '5' shadow = '0' align='center' /><br/>%2<br/>%3%4", _startPartString, _middlePartString, _tipPartString, _endPartString, _image];
					BIS_fnc_advHint_hint = [_titleClass, [_titleName,_hint], [_titleNameShort,_shortHint], _showT, _cond, _showTF, _condF, _onlyFull, _sound];
				} else {						// hint without tip
					_hint = format ["%1<img image = '%4' size = '5' shadow = '0' align='center' /><br/>%2%3", _startPartString, _middlePartString, _endPartString, _image];
					BIS_fnc_advHint_hint = [_titleClass, [_titleName,_hint], [_titleNameShort,_shortHint], _showT, _cond, _showTF, _condF, _onlyFull, _sound];
				}
			} else {					// hint without image
				if (_tipString != "") then {			// hint with tip
					_hint = format ["%1<br/>%5<br/>%2<br/>%3%4", _startPartString, _middlePartString, _tipPartString, _endPartString, _invChar02];
					BIS_fnc_advHint_hint = [_titleClass, [_titleName,_hint], [_titleNameShort,_shortHint], _showT, _cond, _showTF, _condF, _onlyFull, _sound];
				} else {						// hint without tip
					_hint = format ["%1<t size='0.05'><br/>a<br/>a<br/></t>%2%3", _startPartString, _middlePartString, _endPartString];
					BIS_fnc_advHint_hint = [_titleClass, [_titleName,_hint], [_titleNameShort,_shortHint], _showT, _cond, _showTF, _condF, _onlyFull, _sound];
				}
			};

			[false] call BIS_fnc_AdvHintCall;
		};
	};
};