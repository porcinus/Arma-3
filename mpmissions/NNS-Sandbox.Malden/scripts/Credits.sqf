/*
NNS
Display credits. (based on BIS credit.sqf)
Allow usage of preformatted text or plain text, can set "title" and "description" for each credit "slide".

Credit position:
	0: bottom right (default if not set)
	1: bottom left
	2: top right
	3: top left
	4: center
	-1: random corner
	-2: random top corner
	-3: random bottom corner

Example :
	Credits with different positions for each "slide":
		_null = [[
		["bottom right","placeholder text",0],
		["bottom left","placeholder text",1],
		["top right","placeholder text",2],
		["top left","placeholder text<br/>with<br/>multiple<br/>lines",3],
		["<t font='PuristaBold' size='3'>Center</t>","preformatted title",4]
		]] execVM "scripts\Credits.sqf"

	Credits in random corners for each "slide":
		_null = [[
		["title","placeholder text",-1],
		["","placeholder text without title",-1],
		["title","placeholder text",-1],
		["","placeholder text without title",-1]
		]] execVM "scripts\Credits.sqf"

	Simplified usage:
		_null = [["title1",["title2","desc2"],"title3","title4"]] execVM "scripts\Credits.sqf"


Dependencies:
	in description.ext:
		class CfgFunctions {
			class NNS {
				class missionfunc {
					file = "nns_functions";
					class debugOutput {};
				};
			};
		};

	nns_functions folder:
		fn_debugOutput.sqf
		
	script folder:
		Credits.sqf
*/

params [
["_texts", []], //format : ["text0","text1",["text2",pos],["texttitle","textdesc",pos],...]
["_duration", 4], //each credit duration
["_interval", 1], //time after displaying a new credit
["_fade", 1], //fade duration
["_paddingX", 0.1], //X control padding
["_paddingY", 0.3] //Y control padding
];

if !(_texts isEqualType []) exitWith {["Credits.sqf: text need to be in a array"] call NNS_fnc_debugOutput}; //debug
if (_duration < 0) then {_duration = 0};
if (_interval < 0) then {_interval = 0};

fn_firstChar = { //extract first caracter from string with security, ["text"] call fn_firstChar;
	private _text = _this select 0; //recover text
	if (count _text > 0) exitWith {_text select [0,1]}; //return first character
	_text //return untouched text
};

_creditsLayer = "credits" call bis_fnc_rscLayer; //register RSC layer

{ //credit loop
	_text = ["", "", 0]; //reset text array: title, description, position on screen
	_creditText = []; //reset credit text array
	
	if (_x isEqualType [] && {count _x > 0}) then { //current element is a array
		_arrayPos = 0; //position in array
		for "_i" from 0 to ((count _x) - 1) do { //array loop
			_currElement = _x select _i; //extract current element
			if (typeName _currElement == "SCALAR") then {_text set [2, _currElement]; //element is a number, assumed as position on screen, update text array
			} else {if (_arrayPos < 2) then {_text set [_arrayPos, _currElement]; _arrayPos = _arrayPos + 1}}; //update text array if don't overflow, increment array position
		};
	} else {_text set [0, _x]}; //not a array, set text to title
	
	if !((_text select 0) == "") then { //title
		_tmpText = _text select 0; //current text
		if !([_tmpText] call fn_firstChar == "<") then {_tmpText = format ["<t font='PuristaBold'>%1</t>", _tmpText]}; //don't start with a tag, apply formating
		_creditText pushBack _tmpText; //add to array
	};
	
	if !((_text select 1) == "") then { //desctiption
		_tmpText = _text select 1; //current text
		if !([_tmpText] call fn_firstChar == "<") then {_tmpText = format ["<t size='0.8'>%1</t>", _tmpText]}; //don't start with a tag, apply formating
		_creditText pushBack _tmpText; //add to array
	};
	
	if ((_text select 2) == -1) then {_text set [2, round (random 3)]}; //random corner
	if ((_text select 2) == -2) then {_text set [2, 2 + round (random 1)]}; //random top corner
	if ((_text select 2) == -3) then {_text set [2, round (random 1)]}; //random bottom corner
	
	_creditSlide = [_creditsLayer, _creditText joinString "<br/>", _text select 2, _duration, _fade, _paddingX, _paddingY] spawn {
		disableSerialization; //disable serialization
		_layer = _this select 0; //screen layer
		_text = _this select 1; //credit text
		_pos = _this select 2; //credit position
		_duration = _this select 3; //slide duration
		_fade = _this select 4; //fade duration
		_paddingX = _this select 5; _paddingY = _this select 6; //control padding
		
		_layer cutrsc ["RscDynamicText","plain"]; //display wanted rsc
		_display = uinamespace getvariable ["BIS_dynamicText",displaynull]; //get proper display
		_ctrlText = _display displayctrl 9999; //recover text control
		_ctrlText ctrlsetstructuredtext (parsetext _text); //set control text
		_ctrlWidth = 0.5; _ctrlHeight = ctrlTextHeight _ctrlText; //get control height, width set to a oversized value
		_ctrlPos = [ //select right control position
			[(safeZoneX + safeZoneW - _paddingX - _ctrlWidth), (safeZoneY + safeZoneH - _paddingY - _ctrlHeight)], //0: bottom right (default if not set)
			[(safeZoneX + _paddingX), (safeZoneY + safeZoneH - _paddingY - _ctrlHeight)], //1: bottom left
			[(safeZoneX + safeZoneW - _paddingX - _ctrlWidth), (safeZoneY + _paddingY)], //2: top right
			[(safeZoneX + _paddingX), (safeZoneY + _paddingY)], //3: top left
			[(0.5 - (_ctrlWidth / 2)), (0.5 - (_ctrlHeight / 2))] //4: center
		] select _pos;
		_ctrlPos pushBack _ctrlWidth; _ctrlPos pushBack _ctrlHeight; //add control width and height to array
		_ctrlText ctrlsetposition _ctrlPos; //set control position
		_ctrlText ctrlsetfade 1; _ctrlText ctrlcommit 0; //transparent control
		_ctrlText ctrlsetfade 0; _ctrlText ctrlcommit _fade; //opaque control then fade
		
		sleep _duration; //wait slide duration
		_ctrlText ctrlsetfade 1; //transparent control
		_ctrlText ctrlcommit _fade; //fade control
	};
	
	waitUntil {sleep 0.5; isNull _creditSlide}; //wait until current credit slide is finished
	sleep _interval;
} forEach _texts;
