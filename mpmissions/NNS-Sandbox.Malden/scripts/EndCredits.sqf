/*
NNS
Display a scrolling credits with possibility to add a picture at the beginning.
Allow usage of preformatted text or plain text, can set "title" and "description" for each credit.

Example :
	Credits with a image at the beginning:
		_null = [[
		["bottom right","placeholder text1"],
		["bottom left","placeholder text2"],
		["top right","placeholder text3"],
		["top left","placeholder text<br/>with<br/>multiple<br/>lines"],
		["<t font='PuristaBold' size='3'>Center</t>","preformatted title"]
		], "\A3\data_f\SteamPublisher\All\Arma3_workshop_scenario.jpg"] execVM "scripts\EndCredits.sqf"
		
	Previous example but remove credits from screen once done:
		_null = [[
		["bottom right","placeholder text1"],
		["bottom left","placeholder text2"],
		["top right","placeholder text3"],
		["top left","placeholder text<br/>with<br/>multiple<br/>lines"],
		["<t font='PuristaBold' size='3'>Center</t>","preformatted title"]
		], "\A3\data_f\SteamPublisher\All\Arma3_workshop_scenario.jpg",-1,-1,-1,true] execVM "scripts\EndCredits.sqf"
		
	Simplified usage:
		_null = [["title1",["title2","desc2"],"title3","title4"]] execVM "scripts\EndCredits.sqf"


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
		EndCredits.sqf
*/

params [
["_texts", []], //format : ["text0","text1",["texttitle","textdesc"],...]
["_image", ""], //image to display at the very beginning
["_imageSize", 6], //image size
["_speed", 12], //time to scroll one screen height
["_fade", 4], //initial fade to black duration
["_restore", false] //return back to normal when finished
];

if !(_texts isEqualType []) exitWith {["EndCredits.sqf: text need to be in a array"] call NNS_fnc_debugOutput}; //debug
if (_imageSize == -1) then {_imageSize = 6}; //default image size
if (_speed == -1) then {_speed = 12}; //default scroll speed
if (_fade == -1) then {_fade = 4}; //default fade duration

fn_firstChar = { //extract first caracter from string with security, ["text"] call fn_firstChar;
	private _text = _this select 0; //recover text
	if (count _text > 0) exitWith {_text select [0,1]}; //return first character
	_text //return untouched text
};

_creditTextArray = []; //credit text array
_creditText = ""; //credit text

if !(_image == "") then {_creditTextArray pushBack (format ["<img shadow='0' size='%2' image='%1' />", _image, _imageSize])}; //image is set, add image tag in credit array

{ //credit loop
	_text = ["", ""]; //reset text array: title, description
	
	if (_x isEqualType [] && {count _x > 0}) then { //current element is a array
		_arrayPos = 0; //position in array
		for "_i" from 0 to ((count _x) - 1) do {if (_arrayPos < 2) then {_text set [_arrayPos, _x select _i]; _arrayPos = _arrayPos + 1}}; //array loop, update text array if don't overflow, increment array position
	} else {_text set [1, _x]}; //not a array, set text to description
	
	_tmpText = _text select 0; //current text
	if !(_tmpText == "") then { //title is set
		if !([_tmpText] call fn_firstChar == "<") then {_text set [0, format ["<t font='PuristaBold'>%1</t>", _tmpText]]}; //don't start with a tag, apply formating
	} else {_text deleteAt 0}; //title not set, delete array element
	
	_arrayIndex = (count _text) - 1; //last array index
	_tmpText = _text select _arrayIndex; //current text
	if !(_tmpText == "") then { //description is set
		if !([_tmpText] call fn_firstChar == "<") then {_text set [_arrayIndex, format ["<t size='0.8'>%1</t>", _tmpText]]}; //don't start with a tag, apply formating
	} else {_text deleteAt _arrayIndex}; //description not set, delete array element
	
	if (count _text > 0) then {_creditTextArray pushBack (_text joinString "<br/>")}; //add current text to credits array if title and/or description exist
} forEach _texts;

if (count _creditTextArray == 0) exitWith {["EndCredits.sqf: failed, no credits to display"] call NNS_fnc_debugOutput}; //debug

_creditText = _creditTextArray joinString "<br/><br/>"; //array to string

//declare key event handlers to allow skip credits, press key for 1.5sec
player setVariable ["EndCreditSkip", false]; //reset skipped variable
player getVariable ["EndCreditKeyDown", -1]; //reset key down start time
_missionDisplay = [] call BIS_fnc_displayMission; //found proper mission display

_skipCreditKeyDownHandle = _missionDisplay displayAddEventHandler ["KeyDown", { //KeyDown event handler
	if ((_this select 1) in [1, 57]) then { //from escape to space key : https://community.bistudio.com/wiki/DIK_KeyCodes
		if (player getVariable ["EndCreditKeyDown", -1] == -1) then {player setVariable ["EndCreditKeyDown", time]}; //not already pressed, backup time
		if ((time - (player getVariable ["EndCreditKeyDown", time])) > 1.5) then { //pressed for over 1.5sec
			player setVariable ["EndCreditSkip", true]; //set EndCreditSkip variable
			(_this select 0) displayRemoveEventHandler ["keyDown", (player getVariable ["EndCreditKeyDownHandle", 0])]; //remove keyDown handler
			(_this select 0) displayRemoveEventHandler ["KeyUp", (player getVariable ["EndCreditKeyUpHandle", 0])]; //remove KeyUp handler
		};
	};
}];

_skipCreditKeyUpHandle = _missionDisplay displayAddEventHandler ["KeyUp", {if ((_this select 1) in [1, 57]) then {player setVariable ["EndCreditKeyDown", -1]}}]; //KeyUp event handler

player setVariable ["EndCreditKeyDownHandle", _skipCreditKeyDownHandle]; //backup keyDown handle
player setVariable ["EndCreditKeyUpHandle", _skipCreditKeyUpHandle]; //backup KeyUp handle

_creditsLayer = "credits" call bis_fnc_rscLayer; //register RSC layer
_creditsLayer cutrsc ["RscDynamicText","plain"]; //display wanted rsc
_display = uiNamespace getvariable ["BIS_dynamicText", displaynull]; //get proper display

disableSerialization; //disable serialization

//credits background
_ctrlBg = _display ctrlCreate ["RscText", -1]; //control
_ctrlBg ctrlSetPosition [safeZoneX, safeZoneY, safeZoneW, safeZoneH]; //position and size
_ctrlBg ctrlSetBackgroundColor [0, 0, 0, 1]; //color
_ctrlBg ctrlsetfade 1; _ctrlBg ctrlcommit 0; //transparent control
_ctrlBg ctrlsetfade 0; _ctrlBg ctrlcommit _fade; //opaque control then fade

//credits
_ctrlText = _display displayctrl 9999; //recover text control
_ctrlText ctrlsetstructuredtext (parsetext _creditText); //set control text
_ctrlHeight = ctrlTextHeight _ctrlText; //get control height, width set to a oversized value
_ctrlText ctrlsetposition [0, safeZoneY + 0.3, 1, _ctrlHeight]; //set control position
_ctrlText ctrlsetfade 1; _ctrlText ctrlcommit 0; //transparent control
_ctrlText ctrlsetfade 0; _ctrlText ctrlcommit _fade; //opaque control then fade

waitUntil {sleep 0.1; (ctrlCommitted _ctrlText) || (player getVariable ["EndCreditSkip", false])}; //wait for fade to finish or user to skip

if (player getVariable ["EndCreditSkip", false]) then { //credits was skipped
	_ctrlText ctrlsetfade 1; //transparent control
	_ctrlText ctrlcommit (_fade / 2); //fade fast
} else { //credit not skipped
	sleep 1; //wait a bit before starting scrolling credits
	
	_ctrlText ctrlsetposition [0, safeZoneY - (_ctrlHeight + 0.3), 1, _ctrlHeight]; //set control position
	_ctrlText ctrlcommit (((_ctrlHeight + 0.6) / safeZoneH) * _speed); //start control move
	
	waitUntil {sleep 0.1; (ctrlCommitted _ctrlText) || (player getVariable ["EndCreditSkip", false])}; //wait for scroll to finish or user to skip
	
	if (player getVariable ["EndCreditSkip", false]) then { //credits was skipped
		_ctrlText ctrlsetfade 1; //transparent control
		_ctrlText ctrlcommit (_fade / 2); //fade fast
	};
};

if !(player getVariable ["EndCreditSkip", false]) then { //credits was not skipped
	_missionDisplay displayRemoveEventHandler ["keyDown", _skipCreditKeyDownHandle]; //remove keyDown handler
	_missionDisplay displayRemoveEventHandler ["KeyUp", _skipCreditKeyUpHandle]; //remove KeyUp handler
};

if (_restore) then { //remove credits from screen
	_ctrlBg ctrlsetfade 1; _ctrlBg ctrlcommit (_fade / 2); //transparent background, fade fast
	_ctrlText ctrlsetfade 1; _ctrlText ctrlcommit (_fade / 2); //transparent text, fade fast
};
