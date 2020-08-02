#define TEXTURE_BACKGROUND	"\a3\UI_F_Orange\Data\Displays\RscDisplayOrangeChoice\background_ca.paa"
#define TEXTURE_TIMELINE	"\a3\UI_F_Orange\Data\Displays\RscDisplayOrangeChoice\timeline_ca.paa"

#define ICON_SIZE_UNKNOWN	0.0
#define ICON_SIZE_PLAYED	0.5

#define DELAY_ICON		3
#define DELAY_DATE		2
#define COMMIT_TIME_FADE	0.4
#define COMMIT_TIME_HUB		0.2
#define COMMIT_TIME_MISSION	0.4
#define COMMIT_TIME_DATE	0.8

params [
	["_missionCurrent",missionname,[""]],
	["_fade",[],[[]]],
	["_duration",6,[0]],
	["_centered",true,[true]]
];
_fade params [
	["_fadeIn",COMMIT_TIME_FADE,[0]],
	["_fadeOut",COMMIT_TIME_FADE,[0]]
];
if !(isnull (uiNamespace getVariable ["RscTitleDisplayEmpty",displaynull])) then {_fadeIn = 0;};

private _fnc_skip = {
	bis_orange_timelineDone
	||
	isnull _ctrGroup
	||
	((finddisplay 46) getvariable ["BIS_timelinePlayed",false]) //--- After restart (display #46 is not reset)
	||
	cheat0 //--- Dev cheat
};
private _fnc_terminate = {
	if !(isnull _ctrGroup) then {
		"BIS_timeline" cuttext ["","plain"];
		_ctrGroup = controlnull;
	};
};

disableserialization;
"BIS_timeline" cutrsc ["RscTitleDisplayEmpty","plain"];
private _display = displaynull;
waituntil {
	_display = uiNamespace getVariable ["RscTitleDisplayEmpty",displaynull];
	!isnull _display
};

//--- Remove vignette
(_display displayctrl 1202) ctrlshow false;

//--- Init coordinates
private _gridW = 16;
private _posW = 0.9;//safezoneW - 0.4;
private _posH = (_posW / _gridW) * 4/3;
private _posX = 0.5 - _posW / 2;
private _posY = if (_centered) then {0.5 - _posH / 2} else {safezoneY + 0.02};
private _iconH = _posH;
private _iconW = _posH * 3/4;
private _lineH = _posH * ICON_SIZE_PLAYED;//pixelH;//_posH / 16;

//--- Create controls group
private _ctrGroup = _display ctrlcreate ["RscControlsGroupNoScrollbars",-1];
_ctrGroup ctrlsetposition [_posX,_posY,_posW,_posH];
_ctrGroup ctrlsetfade 1; //--- Hide the group, so controls are created hidden first and revealed once ready
_ctrGroup ctrlcommit 0;

//--- Create time line
private _ctrlLine = _display ctrlcreate ["RscPicture",-1,_ctrGroup];
_ctrlLine ctrlsettext TEXTURE_TIMELINE;
_ctrlLine ctrlsettextcolor [1,1,1,1];
_ctrlLine ctrlsetposition [
	_iconW / 2,
	_posH /2 - _lineH / 2,
	_posW - _iconW,
	_lineH
];
_ctrlLine ctrlsetfade 1;
_ctrlLine ctrlcommit 0;
_ctrlLine ctrlsetfade 0.75;
_ctrlLine ctrlcommit _fadeIn;
if (_centered && _fadeIn > 0) then {playsound ["Orange_Timeline_FadeIn",true];};

//--- Create mission icons
private _ctrlLabel1 = controlnull;
private _ctrlLabel2 = controlnull;
private _ctrlIconCurrent = controlnull;
private _ctrlIconBackgroundCurrent = controlnull;
private _posCurrent = [0,0,0,0];
private _commitTime = COMMIT_TIME_MISSION;
{
	private _mission = configname _x;
	private _isHub = getnumber (_x >> "isHub") > 0;
	private _offset = getnumber (_x >> "timelineOffset") * _gridW;
	private _texture = gettext (_x >> "timelineTexture");
	private _label = toupper gettext (_x >> "timelineLabel");
	private _color = getarray (_x >> "timelineColor");
	private _colorBackground = getarray (_x >> "timelineColorBackground");
	private _date = getarray (_x >> "date");

	private _done = missionnamespace getvariable [format ["BIS_%1_done",_mission],false];
	private _size = if (_done || _isHub) then {ICON_SIZE_PLAYED} else {ICON_SIZE_UNKNOWN};

	//--- Create mission icon
	private _iconPos = [
		(_offset / _gridW * _posW) + _iconW * (1 - _size) / 2,
		_iconH * (1 - _size) / 2,
		_iconW * _size,
		_iconH * _size
	];

	_iconFade = if (_centered || _isHub) then {0} else {0.5};
	private _ctrlIconBackground = _display ctrlcreate ["RscPicture",-1,_ctrGroup];
	_ctrlIconBackground ctrlsettext TEXTURE_BACKGROUND;
	_ctrlIconBackground ctrlsetposition _iconPos;
	_ctrlIconBackground ctrlsetfade 1;
	_ctrlIconBackground ctrlcommit 0;
	_ctrlIconBackground ctrlsetfade _iconFade;
	_ctrlIconBackground ctrlcommit _fadeIn;
	if (_done || _isHub || _mission == _missionCurrent) then {
		private _ctrlIcon = _display ctrlcreate ["RscPicture",-1,_ctrGroup];
		_ctrlIcon ctrlsettext _texture;
		_ctrlIcon ctrlsettextcolor [0,0,0,1];
		_ctrlIcon ctrlsetposition _iconPos;
		_ctrlIcon ctrlsetfade 1;
		_ctrlIcon ctrlcommit 0;
		_ctrlIcon ctrlsetfade _iconFade;
		_ctrlIcon ctrlcommit _fadeIn;
	};

	if (_mission == _missionCurrent) then {

		//--- Create icon of current mission
		_commitTime = if (_isHub) then {COMMIT_TIME_HUB} else {COMMIT_TIME_MISSION};

		_ctrlIconBackgroundCurrent = _display ctrlcreate ["RscPicture",-1,_ctrGroup];
		_ctrlIconBackgroundCurrent ctrlsettext TEXTURE_BACKGROUND;
		_ctrlIconBackgroundCurrent ctrlsettextcolor _colorBackground;
		_ctrlIconBackgroundCurrent ctrlsetposition ctrlposition _ctrlIconBackground;
		_ctrlIconBackgroundCurrent ctrlsetfade 1;
		_ctrlIconBackgroundCurrent ctrlcommit 0;

		_ctrlIconCurrent = _display ctrlcreate ["RscPicture",-1,_ctrGroup];
		_ctrlIconCurrent ctrlsettext _texture;
		_ctrlIconCurrent ctrlsettextcolor _color;
		_ctrlIconCurrent ctrlsetposition ctrlposition _ctrlIconBackground;
		_ctrlIconCurrent ctrlsetfade 1;
		_ctrlIconCurrent ctrlcommit 0;

		_posCurrent = [_offset / _gridW * _posW,0,_iconW,_iconH];

		//--- Create label
		_dateFormat = format ["%1 %2",localize format ["STR_3DEN_Attributes_Date_Month%1_text",_date select 1],_date select 0];
		_ctrlLabel1 = _display ctrlcreate ["RscStructuredText",-1];
		_ctrlLabel1 ctrlsetstructuredtext parsetext format ["<t shadow='2' align='center'><t font ='RobotoCondensedBold' size='1.3'>%2</t><br /></t>",_dateFormat,_label];
		_ctrlLabel1 ctrlsetposition [
			_posX + (_offset / _gridW * _posW) + (_iconW / 2) - 0.5,
			_posY + _posH * 1.1,
			1,
			0.2
		];
		_ctrlLabel1 ctrlsetfade 1;
		_ctrlLabel1 ctrlcommit 0;

		_ctrlLabel2 = _display ctrlcreate ["RscStructuredText",-1];
		_ctrlLabel2 ctrlsetstructuredtext parsetext format ["<t shadow='2' align='center'><t font ='RobotoCondensedBold' size='1.3'></t><br />%1</t>",_dateFormat,_label];
		_ctrlLabel2 ctrlsetposition ctrlposition _ctrlLabel1;
		_ctrlLabel2 ctrlsetfade 1;
		_ctrlLabel2 ctrlcommit 0;
	};
} foreach configproperties [missionconfigfile >> "CfgOrange" >> "Missions"];
_ctrGroup ctrlsetfade 0;
_ctrGroup ctrlcommit 0;

//--- Delay current icon animation
_time = time + DELAY_ICON;
waituntil {!_centered || {time > _time || call _fnc_skip}};

//--- Fade in current icon
waituntil {!_centered || {ctrlcommitted _ctrlLine || call _fnc_skip}};
if (call _fnc_skip) exitwith {call _fnc_terminate};
_ctrlIconBackgroundCurrent ctrlsetfade 0;
_ctrlIconBackgroundCurrent ctrlcommit 0.1;
_ctrlIconCurrent ctrlsetfade 0;
_ctrlIconCurrent ctrlcommit 0.1;
if (_centered) then {playsound ["Orange_Timeline_IconFadeIn",true];};

//--- Enlarge current icon
waituntil {ctrlcommitted _ctrlIconCurrent || call _fnc_skip};
if (call _fnc_skip) exitwith {call _fnc_terminate};
_ctrlIconBackgroundCurrent ctrlsetposition _posCurrent;
_ctrlIconBackgroundCurrent ctrlcommit _commitTime;
_ctrlIconCurrent ctrlsetposition _posCurrent;
_ctrlIconCurrent ctrlcommit _commitTime;
_ctrlLabel1 ctrlsetfade 0;
_ctrlLabel1 ctrlcommit (_commitTime);

//--- Delay
waituntil {!_centered || {ctrlcommitted _ctrlLabel1 || call _fnc_skip}};
_time = time + DELAY_DATE;

//--- Show second part of the date
waituntil {time > _time || call _fnc_skip || !_centered};
_ctrlLabel2 ctrlsetfade 0;
_ctrlLabel2 ctrlcommit (_commitTime);
if (_centered) then {playsound ["Orange_Timeline_DateFadeIn",true];};

//--- Wait
waituntil {!_centered || {ctrlcommitted _ctrlIconCurrent || call _fnc_skip}};
if (isnull _ctrGroup) exitwith {};
_time = time + _duration;

//--- Fade out
waituntil {time > _time || call _fnc_skip};
if (isnull _ctrGroup) exitwith {call _fnc_terminate};
_ctrlLabel1 ctrlsetfade 1;
_ctrlLabel1 ctrlcommit _fadeOut;
_ctrlLabel2 ctrlsetfade 1;
_ctrlLabel2 ctrlcommit _fadeOut;
_ctrGroup ctrlsetfade 1;
_ctrGroup ctrlcommit _fadeOut;
if (_centered && _fadeOut > 0) then {playsound ["Orange_Timeline_FadeOut",true];};

waituntil {ctrlcommitted _ctrGroup || call _fnc_skip};
call _fnc_terminate;