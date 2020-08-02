/*

	PROJECT: R&D
	AUTHOR:  Endstar
	DATE:    18-04-2016

	fn_EXP_camp_lobby_playMissionVideo.sqf

		Campaign Lobby: Creates the control and plays mission video

	Params

		0:

	Return

		0:
*/

// Lobby UI defines
disableSerialization;
#include "\A3\Missions_F_Exp\Lobby\headers\ui_campaignLobbyDefines.inc"

// Mission Video
private _missionImage					= _this select 0;
private _missionOverlayImage			= _this select 1;
private _missionIndex					= _this select 2;

// Grab display controls
private _display						= findDisplay IDD_CAMPAIGN_LOBBY;
private _ctrlMissionGroup				= _display displayCtrl IDC_CAMPAIGN_LOBBY_MISSION_GROUP;
private _ctrlVideoGroup					= _display displayCtrl IDC_CAMPAIGN_LOBBY_MISSION_VIDEO_GROUP;

// Overlay controls (we only need complete)
private _overlayGroup					= _display displayCtrl IDC_CAMPAIGN_LOBBY_MISSION_OVERLAY_GROUP;
private _overlayTop						= _display displayCtrl (IDC_CAMPAIGN_LOBBY_MISSION_OVERLAY_GROUP + 1);
private _overlayBottom					= _display displayCtrl (IDC_CAMPAIGN_LOBBY_MISSION_OVERLAY_GROUP + 2);
private _overlayLeft					= _display displayCtrl (IDC_CAMPAIGN_LOBBY_MISSION_OVERLAY_GROUP + 3);
private _overlayRight					= _display displayCtrl (IDC_CAMPAIGN_LOBBY_MISSION_OVERLAY_GROUP + 4);
private _overlayComplete				= _display displayCtrl (IDC_CAMPAIGN_LOBBY_MISSION_OVERLAY_GROUP + 5);

// Selected option
private _selectedMissionOptionCtrls 	= uiNamespace getVariable "A3X_UI_LOBBY_MISSION_OPTION_SELECTED";
private _selectedMissionOptionGroup		= controlNull;
private _selectedMissionOptionLine		= controlNull;
private _selectedMissionOptionText		= controlNull;
private _selectedMissionOptionIcon		= controlNull;
private _selectedMissionOptionButton	= controlNull;

if !(isNil { _selectedMissionOptionCtrls }) then
{
	_selectedMissionOptionGroup			= _selectedMissionOptionCtrls select 0;
	_selectedMissionOptionLine			= _selectedMissionOptionCtrls select 1;
	_selectedMissionOptionText			= _selectedMissionOptionCtrls select 2;
	_selectedMissionOptionIcon			= _selectedMissionOptionCtrls select 3;
	_selectedMissionOptionButton		= _selectedMissionOptionCtrls select 4;
};

// Init main group control
private _ctrlTreeOptionGroup			= _display displayCtrl (IDC_CAMPAIGN_LOBBY_CTRG_TREE_OPTION_CORE_GROUP);

// Find sizes based on mission group size
private _xPos							= 0;
private _yPos							= 0;
private _wPos							= ctrlPosition _ctrlVideoGroup select 2;
private _hPos							= ctrlPosition _ctrlVideoGroup select 3;

// Video control variable
private _ctrlVideo						= uiNamespace getVariable "A3X_UI_LOBBY_MISSION_VIDEO" select 0;
private _ctrlOverlay					= uiNamespace getVariable "A3X_UI_LOBBY_MISSION_VIDEO" select 1;
private _currentMissionIndex			= uiNamespace getVariable "A3X_UI_LOBBY_MISSION_VIDEO" select 2;
private _inProgress						= uiNamespace getVariable "A3X_UI_LOBBY_MISSION_VIDEO" select 3;

if !(isNil { _ctrlVideo }) then
{
	ctrlDelete _ctrlVideo;
	ctrlDelete _ctrlOverlay;
};

// Create video control
_ctrlVideo		=
_display ctrlCreate
[
	"RscVideo",
	(IDC_CAMPAIGN_LOBBY_MISSION_VIDEO_GROUP + 2),
	_ctrlVideoGroup
];

// Set the position of this group
_ctrlVideo ctrlSetPosition
[
	0,
	0,
	_wPos,
	_hPos
];

// Set the mission video
_ctrlVideo ctrlSetText _missionImage;
_ctrlVideo ctrlCommit 0;

// Delete video
ctrlDelete _ctrlVideo;

// Create video
_ctrlVideo		=
_display ctrlCreate
[
	"RscVideo",
	(IDC_CAMPAIGN_LOBBY_MISSION_VIDEO_GROUP + 2),
	_ctrlVideoGroup
];

// Set the position of this control
_ctrlVideo ctrlSetPosition
[
	0,
	0,
	_wPos,
	_hPos
];

// Set the mission video
_ctrlVideo ctrlSetText _missionImage;
_ctrlVideo ctrlCommit 0;

// Create the overlay image
_ctrlOverlay	=
_display ctrlCreate
[
	"RscVideo",
	(IDC_CAMPAIGN_LOBBY_MISSION_VIDEO_GROUP + 4),
	_ctrlVideoGroup
];

// Set the position of this control
_ctrlOverlay ctrlSetPosition
[
	0,
	0,
	_wPos,
	_hPos
];

// Set overlay position
_ctrlOverlay ctrlCommit 0;

// Set variable controls and trigger
uiNamespace setVariable ["A3X_UI_LOBBY_MISSION_VIDEO",[_ctrlVideo, _ctrlOverlay, _missionIndex, true]];

// Begin spawn
_nul = [_ctrlVideo, _ctrlOverlay, _missionIndex, _missionImage, _missionOverlayImage] spawn
{
	disableSerialization;

	private _tempCtrlVideo				= _this select 0;
	private _tempCtrlOverlay			= _this select 1;
	private _tempMissionIndex			= _this select 2;
	private _tempMissionImage			= _this select 3;
	private _tempMissionOverlayImage	= _this select 4;

	// Set the mission video
	_tempCtrlOverlay ctrlSetText _tempMissionOverlayImage;
	_tempCtrlOverlay ctrlCommit 0;

	// Video control variable
	private _ctrlVideo						= uiNamespace getVariable "A3X_UI_LOBBY_MISSION_VIDEO" select 0;
	private _ctrlOverlay					= uiNamespace getVariable "A3X_UI_LOBBY_MISSION_VIDEO" select 1;
	private _currentMissionIndex			= uiNamespace getVariable "A3X_UI_LOBBY_MISSION_VIDEO" select 2;
	private _inProgress						= uiNamespace getVariable "A3X_UI_LOBBY_MISSION_VIDEO" select 3;

	if (isNil { _ctrlVideo })				exitWith {};
	if (isNil { _ctrlOverlay })				exitWith {};
	if (isNil { _currentMissionIndex }) 	exitWith {};
	if (isNil { _inProgress })				exitWith {};

	// Check if a new image was run already or progress has been stopped
	if ((_tempMissionIndex != _currentMissionIndex) || (!_inProgress)) exitWith {};

	// Grace burn period
	uiSleep 0.25;

	// Video control variable
	_ctrlVideo								= uiNamespace getVariable "A3X_UI_LOBBY_MISSION_VIDEO" select 0;
	_ctrlOverlay							= uiNamespace getVariable "A3X_UI_LOBBY_MISSION_VIDEO" select 1;
	_currentMissionIndex					= uiNamespace getVariable "A3X_UI_LOBBY_MISSION_VIDEO" select 2;
	_inProgress								= uiNamespace getVariable "A3X_UI_LOBBY_MISSION_VIDEO" select 3;

	if (isNil { _ctrlVideo })				exitWith {};
	if (isNil { _ctrlOverlay })				exitWith {};
	if (isNil { _currentMissionIndex }) 	exitWith {};
	if (isNil { _inProgress })				exitWith {};

	// Check if a new image was run already or progress has been stopped
	if ((_tempMissionIndex != _currentMissionIndex) || (!_inProgress)) exitWith {};

	// Fade out the overlay image
	_tempCtrlOverlay ctrlSetFade 1;
	_tempCtrlOverlay ctrlCommit 0.5;

	// Add video stopped EH to loop video
	_tempCtrlVideo ctrlAddEventHandler
	[
		"VideoStopped",
		format
		["['%1'] execVM ""\A3\Missions_F_Exp\Lobby\functions\fn_EXP_camp_lobby_playMissionVideo.sqf"";", _tempMissionImage]
	];

	// Commit sleep
	uiSleep 0.5;

	_ctrlVideo								= uiNamespace getVariable "A3X_UI_LOBBY_MISSION_VIDEO" select 0;
	_ctrlOverlay							= uiNamespace getVariable "A3X_UI_LOBBY_MISSION_VIDEO" select 1;
	_currentMissionIndex					= uiNamespace getVariable "A3X_UI_LOBBY_MISSION_VIDEO" select 2;
	_inProgress								= uiNamespace getVariable "A3X_UI_LOBBY_MISSION_VIDEO" select 3;

	if (isNil { _ctrlVideo })				exitWith {};
	if (isNil { _ctrlOverlay })				exitWith {};
	if (isNil { _currentMissionIndex }) 	exitWith {};
	if (isNil { _inProgress })				exitWith {};

	// Check if a new image was run already
	if ((_tempMissionIndex != _currentMissionIndex) || (!_inProgress)) exitWith {};

	// Set variable controls and trigger
	uiNamespace setVariable ["A3X_UI_LOBBY_MISSION_VIDEO",[_tempCtrlVideo, _tempCtrlOverlay, _tempMissionIndex, false]];
};

