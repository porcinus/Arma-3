/*
	Author: Thomas Ryan, updated by Karel Moricky

	Description:
	Displays a subtitle at the bottom of the screen.

	Parameters:
		_this select 0: STRING - Name of the person speaking.
		_this select 1: STRING - Contents of the subtitle.

	Returns:
	SCRIPT - Script controlling the displayed subtitle.
*/

//if (true) exitwith {
//	#include "\a3\Functions_F_Exp\Conversations\fn_showSubtitle.sqf"
//};

//#include "\a3\Ui_f\hpp\defineCommonGrids.inc"

#define POS_W		(0.4 * safeZoneW)
#define POS_H		(safeZoneH)
#define POS_X		(0.5 - POS_W / 2)
#define POS_Y		(safeZoneY + (7/8) * safeZoneH)
#define POS_Y_CAM	(safeZoneY + (31/32) * safeZoneH)

params [
	["_from", "", [""]],
	["_text", "", [""]],
	["_useTitleRsc",false,[true]]
];

if (_text == "") exitWith {
	//--- Reset
	if !(isNil {BIS_fnc_showSubtitle_subtitle}) then {terminate BIS_fnc_showSubtitle_subtitle};
	"BIS_fnc_showSubtitle" cuttext ["","PLAIN"];
	scriptnull;
};

// Terminate previous script
if !(isNil {BIS_fnc_showSubtitle_subtitle}) then {terminate BIS_fnc_showSubtitle_subtitle};

//--- Subtitles disabled, terminate
if !(getSubtitleOptions # 0) exitwith {scriptnull};

BIS_fnc_showSubtitle_subtitle = [_from,_text,_useTitleRsc] spawn {
	disableSerialization;
	scriptName format ["BIS_fnc_showSubtitle: subtitle display - %1", _this];

	params ["_from","_text","_useTitleRsc"];

	// Create display and control
	if (_useTitleRsc) then
    {
        titleRsc ["RscDynamicText", "PLAIN"];
    }
    else
    {
        "BIS_fnc_showSubtitle" cutRsc ["RscDynamicText", "PLAIN"]; //--- Cannot be titleRsc because it's used by kbTell titles
    };


	private "_display";
	waitUntil {_display = uiNamespace getVariable "BIS_dynamicText"; !(isNull _display)};
	private _ctrl = _display ctrlcreate ["RscStructuredText",-1];//_display displayCtrl 9999;
	uiNamespace setVariable ["BIS_dynamicText", displayNull];

	// Position control
	private _posY = if (
		count allMissionObjects "camera" > 0
		||
		{
			!isnull (uinamespace getvariable ["RscCinemaBorder",displaynull])
			||
			{!isnull (uinamespace getvariable ["RscDisplayRead",displaynull])}
		}
	) then {
		POS_Y_CAM
	} else {
		POS_Y
	}; //--- Letterbox when in camera view
	_ctrl ctrlsetbackgroundcolor (["Subtitles","Background"] call bis_fnc_displayColorGet);
	_ctrl ctrlsettextcolor (["Subtitles","Text"] call bis_fnc_displayColorGet);
	_ctrl ctrlSetPosition [POS_X,_posY,POS_W,POS_H];
	_ctrl ctrlCommit 0;

	// Show subtitle
	_ctrl ctrlSetStructuredText parseText format [
		if (_from == "") then {
			"<t align='center' shadow='2' size='%3' font='RobotoCondensedBold'>%2</t>"
		} else {
			if (_from == "#sfx") then {
				"<t align='center' shadow='2' size='%3' font='RobotoCondensedBold'>*%2*</t>"
			} else {
				"<t align='center' shadow='2' size='%3' font='RobotoCondensedBold'>%1:<br />%2</t>"
			}
		},
		toupper _from,
		_text,
		(safezoneH * 0.65) max 1
	];
	private _textHeight = ctrltextheight _ctrl;
	_ctrl ctrlSetPosition [POS_X,_posY - _textHeight,POS_W,_textHeight];
	_ctrl ctrlcommit 0;

	sleep 10;

	// Hide subtitle
	_ctrl ctrlSetFade 1;
	_ctrl ctrlCommit 0.5;
};

BIS_fnc_showSubtitle_subtitle