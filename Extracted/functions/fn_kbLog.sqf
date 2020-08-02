params [
	["_topicName","",[""]],
	["_mission","",[""]],
	["_section",[],[[]]]
];

//--- Register
private _played = missionnamespace getvariable ["bis_orange_kbLogged",[]];
private _playedRecord = [_topicName,_mission];
if (_playedRecord in _played) exitwith {false};
_played pushback _playedRecord;
missionnamespace setvariable ["bis_orange_kbLogged",_played];

//--- Get config
private _cfg = configfile >> "CfgSentences" >> _mission >> _topicName >> "Sentences";
if !(isclass _cfg) exitwith {["Conversation not found in CfgSentences >> %1 >> %2",_mission,_topicName] call bis_fnc_error; false};

//--- Get section to be played
_section params [
	["_sectionStart",0,[0]],
	["_sectionEnd",100,[0]]
];

//--- Create subject
if !(player diarysubjectexists "bis_orange_kb") then {
	player creatediarysubject ["bis_orange_kb", localize "str_a3_orange_kbtell_transcript"];
};

//--- Get conversation name based on the first line
private _cfgClasses = configproperties [_cfg];
private _cfgClassesCount = count _cfgClasses - 1;
private _cfgFirstSentence = _cfgClasses select _sectionStart;
private _fromFirstVar = gettext (_cfgFirstSentence >> "actor");
private _fromFirst = missionnamespace getvariable [_fromFirstVar,objnull];
private _fromFirstName = _fromFirst getvariable ["bis_nameShort",name _fromFirst];
private _title = gettext (_cfgFirstSentence >> "textPlain");
if (_title == "") then {_title = gettext (_cfgFirstSentence >> "text");};
private _titleChars = count _fromFirstName;
private _titleArray = (_title splitstring " ");
{
	_titleChars = _titleChars + count _x;
	if (_titleChars > 24) exitwith {_titleArray resize _foreachindex;};
} foreach _titleArray;
_title = format ["%1: ""%2...""",_fromFirstName,_titleArray joinstring " "];

//--- Log each sentence
for "_i" from (_sectionEnd min _cfgClassesCount) to _sectionStart step -1 do {
	private _cfgSentence = _cfgClasses select _i;

	private _fromVar = gettext (_cfgSentence >> "actor");
	private _from = missionnamespace getvariable [_fromVar,objnull];
	private _text = gettext (_cfgSentence >> "textPlain");
	if (_text == "") then {_text = gettext (_cfgSentence >> "text");};

	player createDiaryRecord [
		"bis_orange_kb",
		[
			_title,
			format [
				"<font face='EtelkaMonospacePro' size='12'>%1:<br />""%2""</font>",
				name _from,
				_text
			]
		]
	];
};

//--- Link to replay
missionnamespace setvariable [
	"bis_orange_kbRecordLast",
	player createDiaryRecord [
		"bis_orange_kb",
		[
			_title,
			format [
				"<font size='20'><br /><execute expression=""%2"">%1</execute></font>",
				localize "STR_A3_Orange_Campaign_memoryFragment_replay",
				format ["['%1','%2',1,0,[%3,%4],true] call bis_orange_fnc_kbTell;",_topicName,_mission,_sectionStart,_sectionEnd]
			]
		]
	]
];
true