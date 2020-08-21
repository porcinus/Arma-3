/*
NNS
Not Mario Kart Knockoff
Player side intro script.
*/

["notMarioKartKnockoff_screenIntro.sqf: Start"] call NNS_fnc_debugOutput;

if ((call MKK_fnc_time) > MKK_introEnd) exitWith {["notMarioKartKnockoff_screenIntro.sqf: intro expired"] call NNS_fnc_debugOutput};

openMap false; //close map

//(vehicle player) lock 3; //lock player vehicle

_introStartInverval = 1.25; //interval between countdown image

//array with countdown images and sounds, index = time left * _introStartInverval
_introStartImgArr = ["notMarioKartKnockoff\img\start\start_go.paa", "notMarioKartKnockoff\img\start\start_1.paa", "notMarioKartKnockoff\img\start\start_2.paa", "notMarioKartKnockoff\img\start\start_3.paa"];
_introStartSndArr = ["MKK_start_go", "MKK_start_bip", "MKK_start_bip", "MKK_start_bip"];

_display = displayNull;

if !(isMultiplayer) then { //debug skip, only here in solo
	_display = findDisplay 46 createDisplay "RscDisplayEmpty"; //create intro display
} else {
	"introDisplay" cutRsc ["RscTitleDisplayEmpty", "PLAIN"]; //create intro display
	_display = uiNamespace getVariable "RscTitleDisplayEmpty"; //recover display variable
};

_gameModeText = MKK_modeNameArr select MKK_mode; //mode name
_gameModeDesc = MKK_gameDescArr select MKK_mode; //mode description
_gameModeParams = [(MKK_gameParamsTextArr select MKK_mode) select MKK_modeRules,"<br/>",", "] call MKK_fnc_stringReplace; //rules description

_grpCtrl = _display ctrlCreate ["RscControlsGroupNoScrollbars", -1]; //create group
_grpCtrl ctrlSetPosition [safeZoneX, safeZoneY, safeZoneW, safeZoneH]; //set position and size
_grpCtrl ctrlCommit 0; //commit

_imgSize = safeZoneH / 5; //initial image size
_startImgCtrlArr = [];
for "_i" from 0 to ((count _introStartImgArr) - 1) do { //generate control for each image
	_tmpPicCtrl = _display ctrlCreate ["RscPictureKeepAspect", -1, _grpCtrl]; //create picture
	_tmpPicCtrl ctrlSetPosition [(safeZoneW - (_imgSize * 2)) / 2, ((safeZoneH - _imgSize) / 3) * 2, _imgSize * 2, _imgSize]; //set position and size
	_tmpPicCtrl ctrlSetText (_introStartImgArr select _i); //image path
	_tmpPicCtrl ctrlShow false; //hide
	_tmpPicCtrl ctrlCommit 0; //commit
	_tmpPicCtrl ctrlSetPosition [(safeZoneW - ((_imgSize * 1.2) * 2)) / 2, ((safeZoneH - (_imgSize * 1.2)) / 3) * 2, (_imgSize * 1.2) * 2, (_imgSize * 1.2)]; //set position and size for next commit
	_startImgCtrlArr pushBack _tmpPicCtrl; //add to array
};

_titleCtrl = _display ctrlCreate ["RscStructuredText", -1, _grpCtrl]; //create title control
_titleCtrl ctrlSetStructuredText parseText format ["<t align='center' shadow='2'><t size='2' font='PuristaBold'>%1</t><br/><t size='1.2'>%2</t><br/><t size='1'>%3</t></t>", _gameModeText, _gameModeDesc, _gameModeParams]; //set text
_titleCtrl ctrlSetPosition [0, 0, ctrlTextWidth _titleCtrl, 0]; _titleCtrl ctrlCommit 0; //set width only, needed to get proper height
_titleCtrl ctrlSetPosition [(safeZoneW - (ctrlTextWidth _titleCtrl)) / 2, (safeZoneH - (ctrlTextHeight _titleCtrl)) / 3, ctrlTextWidth _titleCtrl, ctrlTextHeight _titleCtrl]; //set position and size
_titleCtrl ctrlsetfade 1; _titleCtrl ctrlCommit 0; //transparent
_titleCtrl ctrlsetfade 0; _titleCtrl ctrlCommit 1; //commit

//debug skip, only here in solo
if !(isMultiplayer) then {
	_tmpCtrlPos = ctrlPosition _titleCtrl;
	[_display, "RscButton", -1, -1, _tmpCtrlPos select 0, (_tmpCtrlPos select 1) - 0.05, 0.20, 0.05, "Debug Skip Intro", [], [], "missionNamespace setVariable ['MKK_introEnd', -1, true]"] call MKK_fnc_createRscControl;
};

for "_i" from ((count _startImgCtrlArr) - 1) to 0 step -1 do { //count down
	_tmpCtrl = _startImgCtrlArr select _i; //recover image control
	_tmpSnd = _introStartSndArr select _i; //recover sound class
	waitUntil {sleep 0.1; (MKK_introEnd - (call MKK_fnc_time)) < ((_i * _introStartInverval) + 1)}; //wait the right time
	if !(_tmpSnd == "") then {(vehicle player) say3D _tmpSnd}; //play sound
	_tmpCtrl ctrlShow true; sleep (_introStartInverval * 0.6); _tmpCtrl ctrlsetfade 1; _tmpCtrl ctrlCommit (_introStartInverval * 0.25); //animation
};

{ctrlDelete _x} forEach _startImgCtrlArr; //useless control cleanup

_display closeDisplay 1; //close intro display

waitUntil {sleep 0.1; (call MKK_fnc_time) > MKK_introEnd || {isNull _display} || {(vehicle player) == player}}; //wait for score screen script end

["notMarioKartKnockoff_screenIntro.sqf: End"] call NNS_fnc_debugOutput;