/*
NNS
Not Mario Kart Knockoff
Display a subtitle, similar to BIS_fnc_showSubtitle but allow more settings
*/

params [
	["_title", ""], //title text
	["_text", ""], //subtitle text
	["_inline", false], //draw title and text inline
	["_timeout", 5], //timeout
	["_yPos", safeZoneH / 10], //Y offset from screen bottom
	["_titleSize", 1.5], //title size, ignored if _inline is true
	["_textSize", 1.3], //text size
	["_titleColor", []], //title color: [R,G,B,A], [] if no set
	["_textColor", []] //text color: [R,G,B,A], [] if no set
];

if !(hasInterface) exitWith {scriptnull};
if (isNull findDisplay 46) exitWith {["MKK_fnc_displaySubtitle: mission display is null"] call NNS_fnc_debugOutput; scriptnull};
if (_title == "" && _text == "") exitWith {["MKK_fnc_displaySubtitle: at least a title or text needed"] call NNS_fnc_debugOutput; scriptnull};
if (count _titleColor < 3) then {_titleColor = []}; //invalid title color, set to default
if (count _textColor < 3) then {_textColor = []}; //invalid text color, set to default

if !(isNil "MKK_subtilteHandle") then {terminate MKK_subtilteHandle}; //kill running subtitle

if !(_inline) then {
	if !(_title == "") then {_title = format ["<t size='%2' align='center' font='PuristaBold' shadow='2'>%1</t>", _title, _titleSize]};
	if !(_text == "") then {_text = format ["<t size='%2' align='center' shadow='2'>%1</t>", _text, _textSize]};
} else {
	_tmpText = ["", " : "] select (!(_title == "" && _text == ""));
	if !(_text == "") then {_text = format ["<t size='%2'>%1</t>", _text, _textSize]};
	if !(_title == "") then {_title = format ["<t size='%2'>%1</t>", _title, _textSize]};
	_text = format ["<t align='center' shadow='2' font='PuristaBold'>%1%2%3</t>", _title, _tmpText, _text];
	_title = "";
};

MKK_subtilteHandle = [_title, _text, _titleColor, _textColor, _yPos, _timeout] spawn { //display subtitle script
	params ["_title", "_text", "_titleColor", "_textColor", "_yPos", "_timeout"];
	
	disableSerialization;
	
	_display = findDisplay 46; //current display
	_tmpY = safeZoneY + safeZoneH - _yPos; //starting Y position
	_titleCtrl = controlNull; //title control
	_textCtrl = controlNull; //text control

	if !(_text == "") then {
		_textCtrl = _display ctrlCreate ["RscStructuredText", -1]; //create text control
		_textCtrl ctrlShow false; //hide control
		_textCtrl ctrlSetStructuredText parseText _text; //set text
		_textCtrl ctrlSetPosition [0, 0, safeZoneW, 0]; _textCtrl ctrlCommit 0; //set width only, needed to get proper height
		_tmpY = _tmpY - (ctrlTextHeight _textCtrl); //update Y position
		_textCtrl ctrlSetPosition [safeZoneX, _tmpY, safeZoneW, ctrlTextHeight _textCtrl]; //set position and size
		if (count _textColor > 0) then {_textCtrl ctrlSetTextColor _textColor}; //set text color
		_textCtrl ctrlCommit 0; //commit
		_textCtrl ctrlShow true; //show control
	};

	if !(_title == "") then {
		_titleCtrl = _display ctrlCreate ["RscStructuredText", -1]; //create title control
		_titleCtrl ctrlShow false; //hide control
		_titleCtrl ctrlSetStructuredText parseText _title; //set text
		_titleCtrl ctrlSetPosition [0, 0, safeZoneW, 0]; _titleCtrl ctrlCommit 0; //set width only, needed to get proper height
		_tmpY = _tmpY - (ctrlTextHeight _titleCtrl); //update Y position
		_titleCtrl ctrlSetPosition [safeZoneX, _tmpY, safeZoneW, ctrlTextHeight _titleCtrl]; //set position and size
		if (count _titleColor > 0) then {_titleCtrl ctrlSetTextColor _titleColor}; //set text color
		_titleCtrl ctrlCommit 0; //commit
		_titleCtrl ctrlShow true; //show control
	};
	
	[_thisScript, _titleCtrl, _textCtrl] spawn { //delete control script
		params ["_parent", "_titleCtrl", "_textCtrl"];
		waitUntil {sleep 0.5; isNull _parent}; //wait for main spawn to die
		_titleCtrl ctrlSetFade 1; _textCtrl ctrlSetFade 1; //fade both controls
		_titleCtrl ctrlCommit 0.5; _textCtrl ctrlCommit 0.5; //commit both controls
		sleep 1; //wait enough time for a full fade
		ctrlDelete _titleCtrl; ctrlDelete _textCtrl; //delete both controls
	};
	
	_loop = 0; //used to count elapsed time
	while {sleep 1; !isNull _display && {!isNull _thisScript} && {_loop < _timeout}} do {_loop = _loop + 1}; //wait until timeout
};

MKK_subtilteHandle; //return handle