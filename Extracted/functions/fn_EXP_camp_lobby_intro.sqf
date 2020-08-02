/*

	PROJECT: R&D
	AUTHOR:  Endstar
	DATE:    18-04-2016

	fn_EXP_camp_lobby_intro.sqf

		Campaign Lobby: On Load Function (Does nothing)

	Params

		0:

	Return

		0:
*/

// Lobby UI defines
disableSerialization;
#include "\A3\Missions_F_Exp\Lobby\headers\ui_campaignLobbyDefines.inc"

// Primary displays
private _briefingDisplay				= _this select 0;
private _display						= _this select 1;
private _missionOptionCtrls				= _this select 2;

// Now fetch all the control groups
private _ctrlBackgroundFullGroup 		= _display displayCtrl IDC_CAMPAIGN_LOBBY_BACKGROUND_FULL_GROUP;
private _ctrlBackgroundGroup 			= _display displayCtrl IDC_CAMPAIGN_LOBBY_BACKGROUND_GROUP;
private _ctrlBackgroundLoadingGroup 	= _display displayCtrl IDC_CAMPAIGN_LOBBY_BACKGROUND_LOADING_GROUP;
private _ctrlBackgroundBorderGroup 		= _display displayCtrl IDC_CAMPAIGN_LOBBY_BACKGROUND_BORDER_GROUP;
private _ctrlTabletGroup 				= _display displayCtrl IDC_CAMPAIGN_LOBBY_TABLET_GROUP;
private _ctrlTabletButtonGroup 			= _display displayCtrl IDC_CAMPAIGN_LOBBY_TABLET_BUTTON_GROUP;
private _ctrlTabletMilitaryGroup 		= _display displayCtrl IDC_CAMPAIGN_LOBBY_TABLET_MILITARY_GROUP;
private _ctrlMainGroup 					= _display displayCtrl IDC_CAMPAIGN_LOBBY_MAIN_GROUP;
private _ctrlTreeGroup 					= _display displayCtrl IDC_CAMPAIGN_LOBBY_CTRG_TREE_GROUP;
private _ctrlTreeHeaderGroup 			= _display displayCtrl IDC_CAMPAIGN_LOBBY_CTRG_TREE_HEADER_GROUP;
private _ctrlTreeStructureGroup 		= _display displayCtrl IDC_CAMPAIGN_LOBBY_CTRG_TREE_STRUCTURE_GROUP;
private _ctrlTreeOptionCoreGroup 		= _display displayCtrl IDC_CAMPAIGN_LOBBY_CTRG_TREE_OPTION_CORE_GROUP;
private _ctrlTreeOptionGroup 			= _display displayCtrl IDC_CAMPAIGN_LOBBY_CTRG_TREE_OPTION_GROUP;
private _ctrlLoginGroup 				= _display displayCtrl IDC_CAMPAIGN_LOBBY_LOGIN_GROUP;
private _ctrlAccessKeyGroup 			= _display displayCtrl IDC_CAMPAIGN_LOBBY_ACCESS_KEY_GROUP;
private _ctrlMissionGroup 				= _display displayCtrl IDC_CAMPAIGN_LOBBY_MISSION_GROUP;
private _ctrlMissionVideoGroup 			= _display displayCtrl IDC_CAMPAIGN_LOBBY_MISSION_VIDEO_GROUP;
private _ctrlMissionIntelGroup 			= _display displayCtrl IDC_CAMPAIGN_LOBBY_MISSION_INTEL_GROUP;
private _ctrlMissionOverlayGroup 		= _display displayCtrl IDC_CAMPAIGN_LOBBY_MISSION_OVERLAY_GROUP;
private _ctrlMissionPlayerCoreGroup 	= _display displayCtrl IDC_CAMPAIGN_LOBBY_MISSION_PLAYER_CORE_GROUP;
private _ctrlMissionPlayerGroup 		= _display displayCtrl IDC_CAMPAIGN_LOBBY_MISSION_PLAYER_GROUP;
private _ctrlMissionProgressGroup 		= _display displayCtrl IDC_CAMPAIGN_LOBBY_PROGRESS_GROUP;
private _ctrlOverlayGroup 				= _display displayCtrl IDC_CAMPAIGN_LOBBY_OVERLAY_GROUP;

// Pull out background image
private _ctrlBackgroundImage			= _display displayCtrl (IDC_CAMPAIGN_LOBBY_BACKGROUND_GROUP + 1);
private _ctrlBackgroundImageOverlay		= _display displayCtrl (IDC_CAMPAIGN_LOBBY_BACKGROUND_GROUP + 2);

// Loading bar controls
private _ctrlLoadingText				= _display displayCtrl (IDC_CAMPAIGN_LOBBY_BACKGROUND_LOADING_GROUP + 1);
private _ctrlLoadingBar01				= _display displayCtrl (IDC_CAMPAIGN_LOBBY_BACKGROUND_LOADING_GROUP + 2);
private _ctrlLoadingBar02				= _display displayCtrl (IDC_CAMPAIGN_LOBBY_BACKGROUND_LOADING_GROUP + 3);

// Split up the access key
private _ctrlAccessKeyMainLine			= _display displayCtrl (IDC_CAMPAIGN_LOBBY_ACCESS_KEY_GROUP + 1);
private _ctrlAccessKeyIcon				= _display displayCtrl (IDC_CAMPAIGN_LOBBY_ACCESS_KEY_GROUP + 2);
private _ctrlAccessKeyCircle01			= _display displayCtrl (IDC_CAMPAIGN_LOBBY_ACCESS_KEY_GROUP + 3);
private _ctrlAccessKeyCircle02			= _display displayCtrl (IDC_CAMPAIGN_LOBBY_ACCESS_KEY_GROUP + 4);
private _ctrlAccessKeyLevel				= _display displayCtrl (IDC_CAMPAIGN_LOBBY_ACCESS_KEY_GROUP + 5);

// Tree structureline
private _ctrlTreeStructureMainLine		= _display displayCtrl (IDC_CAMPAIGN_LOBBY_CTRG_TREE_STRUCTURE_GROUP + 2);

// Settings Search Controls (Not in use)
private _ctrlSettingsSearchGroup		= _display displayCtrl (IDC_CAMPAIGN_LOBBY_TABLET_BUTTON_SEARCH_GROUP);
private _ctrlSettingsSearchImage		= _display displayCtrl (IDC_CAMPAIGN_LOBBY_TABLET_BUTTON_SEARCH_GROUP + 1);
private _ctrlSettingsSearchTitle		= _display displayCtrl (IDC_CAMPAIGN_LOBBY_TABLET_BUTTON_SEARCH_GROUP + 2);
private _ctrlSettingsSearchMode			= _display displayCtrl (IDC_CAMPAIGN_LOBBY_TABLET_BUTTON_SEARCH_GROUP + 3);
private _ctrlSettingsSearchButton		= _display displayCtrl (IDC_CAMPAIGN_LOBBY_TABLET_BUTTON_SEARCH_GROUP + 4);

// Settings Reset Controls
private _ctrlSettingsResetGroup			= _display displayCtrl (IDC_CAMPAIGN_LOBBY_TABLET_BUTTON_SETTINGS_GROUP);
private _ctrlSettingsResetImage			= _display displayCtrl (IDC_CAMPAIGN_LOBBY_TABLET_BUTTON_SETTINGS_GROUP + 1);
private _ctrlSettingsResetTitle			= _display displayCtrl (IDC_CAMPAIGN_LOBBY_TABLET_BUTTON_SETTINGS_GROUP + 2);
private _ctrlSettingsResetMode			= _display displayCtrl (IDC_CAMPAIGN_LOBBY_TABLET_BUTTON_SETTINGS_GROUP + 3);
private _ctrlSettingsResetButton		= _display displayCtrl (IDC_CAMPAIGN_LOBBY_TABLET_BUTTON_SETTINGS_GROUP + 4);

// Settings Respawn Controls
private _ctrlSettingsRespawnGroup		= _display displayCtrl (IDC_CAMPAIGN_LOBBY_TABLET_BUTTON_RESPAWN_GROUP);
private _ctrlSettingsRespawnImage		= _display displayCtrl (IDC_CAMPAIGN_LOBBY_TABLET_BUTTON_RESPAWN_GROUP + 1);
private _ctrlSettingsRespawnTitle		= _display displayCtrl (IDC_CAMPAIGN_LOBBY_TABLET_BUTTON_RESPAWN_GROUP + 2);
private _ctrlSettingsRespawnMode		= _display displayCtrl (IDC_CAMPAIGN_LOBBY_TABLET_BUTTON_RESPAWN_GROUP + 3);
private _ctrlSettingsRespawnButton		= _display displayCtrl (IDC_CAMPAIGN_LOBBY_TABLET_BUTTON_RESPAWN_GROUP + 4);

// Settings Respawn Controls
private _ctrlSettingsReviveGroup		= _display displayCtrl (IDC_CAMPAIGN_LOBBY_TABLET_BUTTON_REVIVE_GROUP);
private _ctrlSettingsReviveImage		= _display displayCtrl (IDC_CAMPAIGN_LOBBY_TABLET_BUTTON_REVIVE_GROUP + 1);
private _ctrlSettingsReviveTitle		= _display displayCtrl (IDC_CAMPAIGN_LOBBY_TABLET_BUTTON_REVIVE_GROUP + 2);
private _ctrlSettingsReviveMode			= _display displayCtrl (IDC_CAMPAIGN_LOBBY_TABLET_BUTTON_REVIVE_GROUP + 3);
private _ctrlSettingsReviveButton		= _display displayCtrl (IDC_CAMPAIGN_LOBBY_TABLET_BUTTON_REVIVE_GROUP + 4);

// Military Efficiency Controls
private _ctrlMilitaryTitle				= _display displayCtrl (IDC_CAMPAIGN_LOBBY_TABLET_MILITARY_GROUP + 1);
private _ctrlMilitaryMode				= _display displayCtrl (IDC_CAMPAIGN_LOBBY_TABLET_MILITARY_GROUP + 2);
private _ctrlMilitaryEfficiency			= _display displayCtrl (IDC_CAMPAIGN_LOBBY_TABLET_MILITARY_GROUP + 3);
private _ctrlMilitaryRadialBaseLeft		= _display displayCtrl (IDC_CAMPAIGN_LOBBY_TABLET_MILITARY_GROUP + 4);
private _ctrlMilitaryRadialBaseRight	= _display displayCtrl (IDC_CAMPAIGN_LOBBY_TABLET_MILITARY_GROUP + 5);
private _ctrlMilitaryRadialLeft			= _display displayCtrl (IDC_CAMPAIGN_LOBBY_TABLET_MILITARY_GROUP + 6);
private _ctrlMilitaryRadialBGLeft		= _display displayCtrl (IDC_CAMPAIGN_LOBBY_TABLET_MILITARY_GROUP + 7);
private _ctrlMilitaryRadialRight		= _display displayCtrl (IDC_CAMPAIGN_LOBBY_TABLET_MILITARY_GROUP + 8);

// Reset focus to the overlay (just incase)
ctrlSetFocus _ctrlOverlayGroup;

// Hide everything individually
{
	_x ctrlSetFade 1;
	_x ctrlCommit 0;
} foreach
[
	_ctrlBackgroundLoadingGroup,
	_ctrlBackgroundBorderGroup,
	_ctrlSettingsSearchGroup,
	_ctrlSettingsResetGroup,
	_ctrlSettingsRespawnGroup,
	_ctrlSettingsReviveGroup,
	_ctrlTabletMilitaryGroup,
	_ctrlTreeGroup,
	_ctrlTreeHeaderGroup,
	_ctrlTreeStructureGroup,
	_ctrlTreeOptionCoreGroup,
	_ctrlTreeOptionGroup,
	_ctrlLoginGroup,
	_ctrlAccessKeyGroup,
	_ctrlMissionGroup,
	_ctrlMissionVideoGroup,
	_ctrlMissionIntelGroup,
	_ctrlMissionOverlayGroup,
	_ctrlMissionPlayerCoreGroup,
	_ctrlMissionPlayerGroup,
	_ctrlMissionProgressGroup
];

// Set background fade
_ctrlBackgroundImage ctrlSetFade 1;
_ctrlBackgroundImage ctrlCommit 0;

_ctrlBackgroundImageOverlay ctrlSetFade 1;
_ctrlBackgroundImageOverlay ctrlCommit 0;

// Fade out
private _fadeTime = 1;

// Small wait
uiSleep 0.5;

// Fade in the background and foreground group instantly (this is to avoid the blink)
_ctrlBackgroundGroup ctrlSetFade 0;
_ctrlBackgroundGroup ctrlCommit 0.25;

_ctrlMainGroup ctrlSetFade 0;
_ctrlMainGroup ctrlCommit 0.25;

// Fade the overlay
_ctrlOverlayGroup ctrlSetFade 1;
_ctrlOverlayGroup ctrlCommit _fadeTime;

// Hide all the military titles as we want to fade them in
{
	_x ctrlSetFade 1;
	_x ctrlCommit 0;
} foreach
[
	_ctrlSettingsSearchTitle,
	_ctrlSettingsSearchMode,
	_ctrlSettingsResetTitle,
	_ctrlSettingsResetMode,
	_ctrlSettingsRespawnTitle,
	_ctrlSettingsRespawnMode,
	_ctrlSettingsReviveTitle,
	_ctrlSettingsReviveMode,
	_ctrlMilitaryTitle,
	_ctrlMilitaryMode,
	_ctrlMilitaryEfficiency,
	_ctrlMilitaryRadialRight,
	_ctrlMilitaryRadialLeft
];


// Fade in the tablet buttons
{
	_x ctrlSetFade 0;
	_x ctrlCommit 0.5;
	uiSleep 0.15;
} foreach
[
	_ctrlSettingsSearchGroup,
	_ctrlSettingsResetGroup,
	_ctrlSettingsRespawnGroup,
	_ctrlSettingsReviveGroup,
	_ctrlTabletMilitaryGroup
];

// Show overlay background with a fade
_ctrlBackgroundImageOverlay ctrlSetFade 0;
_ctrlBackgroundImageOverlay ctrlCommit 0.1;

uiSleep 0.1;

// Hide overlay background immediately
_ctrlBackgroundImageOverlay ctrlSetFade 1;
_ctrlBackgroundImageOverlay ctrlCommit 0;

uiSleep 0.1;

// Show overlay background immediately
_ctrlBackgroundImageOverlay ctrlSetFade 0;
_ctrlBackgroundImageOverlay ctrlCommit 0;

// Set background immediately
_ctrlBackgroundImage ctrlSetFade 0;
_ctrlBackgroundImage ctrlCommit 0;

uiSleep 0.25;

// Hide overlay for good
_ctrlBackgroundImageOverlay ctrlSetFade 1;
_ctrlBackgroundImageOverlay ctrlCommit 0.1;


// Hide text and loading bars
{
	_x ctrlSetFade 1;
	_x ctrlCommit 0;
} foreach [_ctrlLoadingText, _ctrlLoadingBar01, _ctrlLoadingBar02];

// Split elements and turn white and hide
{
	_x ctrlSetTextColor				([CAMPAIGN_LOBBY_COLOR_WHITE	+ ALPHA_100]	call BIS_fnc_HEXtoRGB);
	_x ctrlSetBackgroundColor		([CAMPAIGN_LOBBY_COLOR_WHITE	+ ALPHA_100]	call BIS_fnc_HEXtoRGB);
	_x ctrlSetFade					1;
	_x ctrlCommit					0;
} foreach
[
	_ctrlAccessKeyMainLine,
	_ctrlAccessKeyIcon,
	_ctrlAccessKeyCircle01,
	_ctrlAccessKeyCircle02,
	_ctrlTreeStructureMainLine
];

// Hide access level
_ctrlAccessKeyLevel ctrlSetFade 1;
_ctrlAccessKeyLevel ctrlCommit 0;

// Fade in the login
_ctrlLoginGroup ctrlSetFade 0;
_ctrlLoginGroup ctrlCommit 0.25;

// Show loading bar
_ctrlBackgroundLoadingGroup ctrlSetFade 0;
_ctrlbackgroundLoadingGroup ctrlCommit 0;

// Show tree header
_ctrlTreeHeaderGroup ctrlSetFade 0;
_ctrlTreeheaderGroup ctrlCommit 0.25;

// Show tree structure and access group
_ctrlTreeStructureGroup ctrlSetFade 0;
_ctrlTreeStructureGroup ctrlCommit 0;

_ctrlAccessKeyGroup ctrlSetFade 0;
_ctrlAccessKeyGroup ctrlCommit 0;

// Show connections
{
	_x ctrlSetFade 0.5;
	_x ctrlCommit 0.5;
} forEach
[
	_ctrlTreeStructureMainLine,
	_ctrlAccessKeyMainLine,
	_ctrlAccessKeyCircle01,
	_ctrlAccessKeyCircle02
];

// Wait for login to finish fading
uiSleep 0.5;

// Connecting
_ctrlLoadingText ctrlSetText "CONNECTING...";

// Flash text and bar
for "_i" from 0 to 1 do
{
	{
		_x ctrlSetFade	0;
		_x ctrlCommit	0.15;
	} foreach
	[
		_ctrlLoadingText,
		_ctrlLoadingBar01
	];

	uiSleep 0.15;

	{
		_x ctrlSetFade	1;
		_x ctrlCommit	0.15;
	} foreach
	[
		_ctrlLoadingText,
		_ctrlLoadingBar01
	];

	uiSleep 0.15;
};

// Connected
_ctrlLoadingText ctrlSetText	"CONNECTED";
_ctrlLoadingText ctrlSetFade	0;
_ctrlLoadingText ctrlCommit		0;

_ctrlLoadingBar01 ctrlSetFade	0;
_ctrlLoadingBar01 ctrlCommit	0;

// Show connected main line in red
{
	_x ctrlSetTextColor				([CAMPAIGN_LOBBY_COLOR_RED	+ ALPHA_100]	call BIS_fnc_HEXtoRGB);
	_x ctrlSetBackgroundColor		([CAMPAIGN_LOBBY_COLOR_RED	+ ALPHA_100]	call BIS_fnc_HEXtoRGB);
	_x ctrlSetFade					0;
	_x ctrlCommit					0;
} foreach
[
	_ctrlAccessKeyCircle01,
	_ctrlTreeStructureMainLine
];

// Authorize
uiSleep 0.25;

// Connecting
_ctrlLoadingText ctrlSetText "AUTHORIZING...";
_ctrlLoadingText ctrlCommit 0;

// Set line to blue
_ctrlLoadingBar02 ctrlSetBackgroundColor ([CAMPAIGN_LOBBY_COLOR_BLUE	+ ALPHA_100]	call BIS_fnc_HEXtoRGB);

// Run the loading bar
_ctrlLoadingBar02 ctrlSetFade 0;
_ctrlLoadingBar02 ctrlCommit 0;

// Grab loading bar positions
private _loadingBarX				= ctrlPosition _ctrlLoadingBar02 select 0;
private _loadingBarY				= ctrlPosition _ctrlLoadingBar02 select 1;
private _loadingBarW				= ctrlPosition _ctrlLoadingBar02 select 2;
private _loadingBarH				= ctrlPosition _ctrlLoadingBar02 select 3;

// Set bar to 0
_ctrlLoadingBar02 ctrlSetPosition
[
	_loadingBarX,
	_loadingBarY,
	0,
	_loadingBarH
];

// Commit
_ctrlLoadingBar02 ctrlCommit 0;

// Set bar to 1
_ctrlLoadingBar02 ctrlSetPosition
[
	_loadingBarX,
	_loadingBarY,
	_loadingBarW,
	_loadingBarH
];

// Commit
_ctrlLoadingBar02 ctrlCommit 0.9;

// Flash Access Key
for "_i" from 0 to 2 do
{
	{
		_x ctrlSetFade	0.5;
		_x ctrlCommit	0.15;
	} foreach
	[
		_ctrlAccessKeyIcon
	];

	uiSleep 0.15;

	{
		_x ctrlSetFade	1;
		_x ctrlCommit	0.15;
	} foreach
	[
		_ctrlAccessKeyIcon
	];

	uiSleep 0.15;
};

// Authorized
_ctrlLoadingText ctrlSetText "AUTHORIZED";
_ctrlLoadingText ctrlCommit 0;

// Show connected access line in blue
{
	_x ctrlSetTextColor				([CAMPAIGN_LOBBY_COLOR_BLUE	+ ALPHA_100]	call BIS_fnc_HEXtoRGB);
	_x ctrlSetBackgroundColor		([CAMPAIGN_LOBBY_COLOR_BLUE	+ ALPHA_100]	call BIS_fnc_HEXtoRGB);
	_x ctrlSetFade					0;
	_x ctrlCommit					0;
} foreach
[
	_ctrlAccessKeyIcon,
	_ctrlAccessKeyCircle02,
	_ctrlAccessKeyMainLine
];

// Fade out the bar then reset
_ctrlLoadingBar02 ctrlSetFade 1;
_ctrlLoadingBar02 ctrlCommit 0.5;

// Wait
uiSleep 0.15;

[] call BIS_fnc_EXP_camp_lobby_updatePlayers;

// Synchronize
_ctrlLoadingText ctrlSetText "SYNCHRONIZING...";
_ctrlLoadingText ctrlCommit 0;

// Set line to red
_ctrlLoadingBar02 ctrlSetBackgroundColor ([CAMPAIGN_LOBBY_COLOR_RED	+ ALPHA_100]	call BIS_fnc_HEXtoRGB);

// Set bar to 0
_ctrlLoadingBar02 ctrlSetPosition
[
	_loadingBarX,
	_loadingBarY,
	0,
	_loadingBarH
];

// Commit
_ctrlLoadingBar02 ctrlCommit 0;

// Set bar to 1
_ctrlLoadingBar02 ctrlSetPosition
[
	_loadingBarX,
	_loadingBarY,
	_loadingBarW,
	_loadingBarH
];

// Commit
_ctrlLoadingBar02 ctrlCommit 0.75;

// Show line
_ctrlLoadingBar02 ctrlSetFade 0;
_ctrlLoadingBar02 ctrlCommit 0;

// Show mission option groups
_ctrlTreeOptionGroup ctrlSetFade 0;
_ctrlTreeOptionGroup ctrlCommit 0;

_ctrlTreeOptionCoreGroup ctrlSetFade 0;
_ctrlTreeOptionCoreGroup ctrlCommit 0;

// Hide all missions individually
{
	private _ctrlTreeMissionOptionGroup = _x select 0;

	_ctrlTreeMissionOptionGroup ctrlSetFade 1;
	_ctrlTreeMissionOptionGroup ctrlCommit 0;
} foreach _missionOptionCtrls;

// Show all missions individually
{
	private _ctrlTreeMissionOptionGroup = _x select 0;

	uiSleep 0.1;

	_ctrlTreeMissionOptionGroup ctrlSetFade 0;
	_ctrlTreeMissionOptionGroup ctrlCommit 0.25;

} foreach _missionOptionCtrls;

// Wait
uiSleep 0.15;

// Complete
_ctrlLoadingText ctrlSetText "COMPLETE";
_ctrlLoadingText ctrlCommit 0;

// Hide loading bar
_ctrlLoadingBar01 ctrlShow false;
_ctrlLoadingBar02 ctrlShow false;

// Allow interaction
_ctrlOverlayGroup ctrlShow false;

uiSleep 0.1;

// Hide the military efficiency loading bars
_ctrlMilitaryRadialRight 	ctrlShow false;
_ctrlMilitaryRadialLeft		ctrlShow false;

// Reset Efficiency
[0] call BIS_fnc_EXP_camp_lobby_updateMilitaryEfficiency;

// Show everything else
{
	_x ctrlSetFade 0;
	_x ctrlCommit 0.5;
} forEach
[
	_ctrlMissionGroup,
	_ctrlMissionVideoGroup,
	_ctrlMissionIntelGroup,
	_ctrlMissionOverlayGroup,
	_ctrlMissionPlayerCoreGroup,
	_ctrlMissionPlayerGroup,
	_ctrlMissionProgressGroup,
	_ctrlTabletButtonGroup
];

uiSleep 0.5;

// Find current and final values
uiNamespace setVariable ["A3X_UI_LOBBY_MILITARY_CURRENT", nil];
uiNamespace setVariable ["A3X_UI_LOBBY_MILITARY_FINAL", nil];

// Show all the military titles as we want to fade them in
{
	_x ctrlSetFade 0;
	_x ctrlCommit 0.5;
} foreach
[
	_ctrlSettingsSearchTitle,
	_ctrlSettingsSearchMode,
	_ctrlSettingsResetTitle,
	_ctrlSettingsResetMode,
	_ctrlSettingsRespawnTitle,
	_ctrlSettingsRespawnMode,
	_ctrlSettingsReviveTitle,
	_ctrlSettingsReviveMode,
	_ctrlMilitaryTitle,
	_ctrlMilitaryMode,
	_ctrlMilitaryEfficiency,
	_ctrlMilitaryRadialLeft,
	_ctrlMilitaryRadialRight
];

// Update Efficiency
remoteExec ["BIS_fnc_EXP_camp_lobby_updateHostSettings"];

// Hide loading bar
_ctrlBackgroundLoadingGroup ctrlSetFade 1;
_ctrlBackgroundLoadingGroup ctrlCommit 0.35;

// Wait
uiSleep 0.25;

// Show access level
_ctrlAccessKeyLevel ctrlSetFade 0;
_ctrlAccessKeyLevel ctrlCommit 0.35;