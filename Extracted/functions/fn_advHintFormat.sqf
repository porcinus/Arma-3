/*
	Author: Karel Moricky

	Description:
	Return formatted texts of a CfgHints hint

	Parameter(s):
		0: STRING - Topic
		1: STRING - Hint
		2 (Optional): STRING - Sub-hint
		3 (Optional): ARRAY - Custom highlight color

	Returned value:
		ARRAY in format:
			0: CONFIG - hint path
			1: STRING - display name
			2: STRING - short displayName
			3: STRING - description
			4: STRING - tip
			5: STRING - image
			6: NUMBER - DLC ID
			7: BOOL - true if hint belongs to non-owned DLC
*/

private _topic = param [0,"",["",configfile]];
private _hint = param [1,"",[""]];
private _subhint = param [2,"",[""]];
private _color = param [3,[],[[]]];

//--- Get config path
private _cfgHint = if (_topic isequaltype configfile) then {
	_topic
} else {
	if (_subhint == "") then {
		[["CfgHints",_topic,_hint],configfile] call bis_fnc_loadclass
	} else {
		[["CfgHints",_topic,_hint,_subhint],configfile] call bis_fnc_loadclass
	};
};
if (_cfgHint == configfile) exitwith {["Hint '%1' in topic '%2' does not exist.",_hint,_topic] call bis_fnc_error; []};

//--- DLC restricted content, link to the DLC page instead
private _dlc = getnumber (_cfgHint >> "dlc");
private _isDlc = _dlc > 0 && !(_dlc in getDlcs 1);
if (_isDlc) then {
	//appIDs have grown too large to simply str
	private _dlcString = "";
	{_dlcString = _dlcString + (str _x)} forEach (_dlc call BIS_fnc_numberDigits);
	_cfgHint = configfile >> "CfgHints" >> "DlcMessage" >> format ["Dlc%1",_dlcString];
};

//--- Get properties
private _displayName = gettext (_cfgHint >> "displayName");
private _displayNameShort = gettext (_cfgHint >> "displayNameShort");
private _description = gettext (_cfgHint >> "description");
private _tip = gettext (_cfgHint >> "tip");
private _arguments = getarray (_cfgHint >> "arguments");
private _image = gettext (_cfgHint >> "image");
private _noImage = getnumber (_cfgHint >> "noImage");
if (_noImage > 0) then {_image = "";};

//--- Get custom color and brighten it if it's too dark
private _keyColor = (if (_color isequaltypearray [0,0,0,0]) then { +_color } else { ["GUI", "BCG_RGB"] call BIS_fnc_displayColorGet }) select [0, 3];
private _max = selectMax _keyColor; 
_keyColor = (if (_max > 0) then { _keyColor vectorMultiply (1 / _max) } else { [0,0,0] }) call BIS_fnc_colorRGBtoHTML;

//--- Parse arguments
_argumentsArray = [_arguments,_keyColor] call BIS_fnc_advHintArg;

//--- Apply arguments (every text is processed twice, because of possible '%number' variables used in arguments)
_displayName = format ([_displayName] + _argumentsArray);
_displayName = toupper (format ([_displayName] + _argumentsArray));
_displayNameShort = format ([_displayNameShort] + _argumentsArray);
_displayNameShort = format ([_displayNameShort] + _argumentsArray);
_description = format ([_description] + _argumentsArray);
_description = format ([_description] + _argumentsArray);
_tip = format ([_tip] + _argumentsArray);

[_cfgHint,_displayName,_displayNameShort,_description,_tip,_image,_dlc,_isDlc,_keyColor]