/*
NNS
Not Mario Kart Knockoff
Create RSC control.


[_display,
_ctrlType,
-1,
_grpCtrl,
_ctrlX,
_ctrlY,
_ctrlWidth,
_ctrlHeight,
_ctrlText,
_ctrlColorBg,
_ctrlColorText,
_ctrlAction,
_ctrlShow,
_ctrlFade] call MKK_fnc_createRscControl;

*/

params [
	["_display", displayNull], //diplay to draw on
	["_ctrlType", "RscText"], //type
	["_ctrlIdc", -1], //idc, -1 if not care
	["_ctrlParent", -1], //-1 if no parent
	["_ctrlX", safeZoneX], //X position, -999 if no set, -1 to center
	["_ctrlY", safeZoneY], //Y position, -999 if no set, -1 to center
	["_ctrlWidth", safeZoneW], //Width, -999 if no set, -1 for automatic width
	["_ctrlHeight", safeZoneH], //Height, -999 if no set, -1 for automatic height
	["_ctrlText", ""], //text, "" if no set
	["_ctrlColorBg", []], //background color: [R,G,B,A], [] if no set
	["_ctrlColorText", []], //text color: [R,G,B,A], [] if no set
	["_ctrlAction", ""], //control action for buttons
	["_ctrlShow", true], //show control var
	["_ctrlFade", 0] //control fade
];

if (isNull _display) exitWith {["MKK_fnc_CreateRscControl: invalid display"] call NNS_fnc_debugOutput}; //invalid display
if (_ctrlType == "") exitWith {["MKK_fnc_CreateRscControl: control type needed"] call NNS_fnc_debugOutput}; //invalid control type
if (typeName _ctrlParent != "CONTROL") then {_ctrlParent = controlNull}; //no parent
if (_ctrlX == -999) then {_ctrlX = safeZoneX}; //no X position set, set to safeZoneX
if (_ctrlY == -999) then {_ctrlY = safeZoneY}; //no Y position set, set to safeZoneY
if (_ctrlWidth == -999) then {_ctrlWidth = safeZoneW}; //no width set, set to safeZoneW
if (_ctrlHeight == -999) then {_ctrlHeight = safeZoneH}; //no height set, set to safeZoneH
if (count _ctrlColorBg < 3) then {_ctrlColorBg = []}; //invalid background color, set to default
if (count _ctrlColorText < 3) then {_ctrlColorText = []}; //invalid text color, set to default

_ctrlType = toLower _ctrlType; //lowercase control type
_structuredTextControls = ["rscstructuredtext"]; //list of structured text controls

private _ctrl = _display ctrlCreate [_ctrlType, _ctrlIdc, _ctrlParent]; //create control
_ctrl ctrlShow false; //hide control
_ctrl ctrlCommit 0; //commit

if (_ctrlText != "") then {if (_ctrlType in _structuredTextControls) then {_ctrl ctrlSetStructuredText parseText _ctrlText} else {_ctrl ctrlSetText _ctrlText}}; //set text

if (_ctrlWidth == -1) then {_ctrlWidth = ctrlTextWidth _ctrl}; //automatic width

if (_ctrlHeight == -1) then { //automatic height
	_ctrl ctrlSetPosition [0, 0, _ctrlWidth, 0]; //set width only, needed to get proper height
	_ctrl ctrlCommit 0; //commit
	_ctrlHeight = ctrlTextHeight _ctrl; //recover control height
};

//center X position
private _parentPos = []; //init parent position array
if (_ctrlX == -1 || _ctrlY == -1) then {_parentPos = ctrlPosition _ctrlParent}; //recover parent position and size

if (_ctrlX == -1) then { //center X position
	if (isNull _ctrlParent) then {_ctrlX = safeZoneX + (safeZoneW - _ctrlWidth) / 2; //no parent
	} else {_ctrlX = ((_parentPos select 2) - _ctrlWidth) / 2}; //use parent
};

if (_ctrlY == -1) then { //center Y position
	if (isNull _ctrlParent) then {_ctrlY = safeZoneY + (safeZoneH - _ctrlHeight) / 2; //no parent
	} else {_ctrlY = ((_parentPos select 3) - _ctrlHeight) / 2}; //use parent
};

_ctrl ctrlSetPosition [_ctrlX, _ctrlY, _ctrlWidth, _ctrlHeight]; //set position and size

if (count _ctrlColorBg > 0) then {_ctrl ctrlSetBackgroundColor _ctrlColorBg}; //set background color
if (count _ctrlColorText > 0) then {_ctrl ctrlSetTextColor _ctrlColorText}; //set text color

if (_ctrlAction != "") then {_ctrl buttonSetAction _ctrlAction}; //set action

if (_ctrlFade > 0) then {_ctrl ctrlSetFade _ctrlFade}; //set control fade

_ctrl ctrlShow _ctrlShow; //hide or display control

_ctrl ctrlCommit 0; //commit

_ctrl //return control