if (missionname == "Orange_Hiker") exitwith {};

_timelineText = "";
_yearPrev = 3000;
_dateNumberNow = (date select 0) + datetonumber date;
_colorHighlight = (["GUI","BCG_RGB"] call bis_fnc_displaycolorget) call bis_fnc_colorRGBtoHTML;
{
	_isToday = !isarray (_x >> "date");
	_date = if (_isToday) then {date} else {getarray (_x >> "date")};
	_date params [["_year",0],["_month",0],["_day",0],["_hour",1],["_minute",1]];

	_condition = gettext (_x >> "condition");
	_isDecision = isnumber (_x >> "decisionResult");
	_descisionResult = if (_isDecision) then {
		(_condition != missionname) && {((missionnamespace getvariable [format ["BIS_%1_Decision",_condition],0]) max 0) == getnumber (_x >> "decisionResult")}
	} else {
		true
	};
	_conditionResult = if (bis_orange_isHub) then {
		//--- Hub - Specific scenario has been finished or no scenario is required
		_condition == "" || {missionnamespace getvariable [format ["BIS_%1_done",_condition],false]}
	} else {
		//--- Scenario - date is lower or equal to the scenario date
		(_year + datetonumber [_year,_month,_day max 1,_hour,_minute]) <= _dateNumberNow
	};

	//_conditionResult = _condition == "" || {missionnamespace getvariable [format ["BIS_%1_done",_condition],false]};
	//if !(bis_orange_isHub) then {_conditionResult && (_year + datetonumber [_year,_month,_day max 1,_hour,_minute]) <= _dateNumberNow};

	if (_conditionResult && _descisionResult) then {

		//--- Year
		if (_year < _yearPrev) then {
			_yearPrev = _year;
			_timelineText = _timelineText + format ["<font size='28' face='RobotoCondensedBold'>%1</font><br />",_year];
		};

		//--- Date
		_dateFormat = if (_day == 0) then {"%1"} else {localize "str_a3_orangecampaign_timeline_date"};
		_dateFormat = format [_dateFormat,localize format ["STR_3DEN_Attributes_Date_Month%1_text",_month],_day];
		_timelineText = _timelineText + format ["<font color='#99ffffff' size='18'>%1</font>",_dateFormat];

		//--- Date text
		_textDate = gettext (_x >> "textDate");
		if (_textDate != "") then {
			_timelineText = _timelineText + format ["<font color='#99ffffff'> (%1)</font>",_textDate]
		};

		//--- Icon
		_icon = if (_isToday) then {gettext (missionconfigfile >> "CfgOrange" >> "Timeline" >> "icon" + missionname)} else {gettext (_x >> "icon")};
		if (_icon != "") then {
			_timelineText = _timelineText + format ["<img color='#99ffffff' width='20' height='20' image='%1' />",_icon]
		};

		//--- New
		if (_condition != "" && {_condition == bis_previousMission || _condition == missionname}) then {
			_timelineText = _timelineText + format ["<font color='%2'>  %1</font>",toupper localize "str_ca_new",_colorHighlight];
		};

		//--- Text
		_timelineText = _timelineText + format [
			"<br />%1<br /><br />",
			format getarray (_x >> "text")
		];
	};
} foreach configproperties [missionconfigfile >> "CfgOrange" >> "Timeline","isclass _x"];

player creatediaryrecord [
	"Diary",
	[
		localize "STR_A3_OrangeCampaign_Timeline_title",
		_timelineText
	]
];