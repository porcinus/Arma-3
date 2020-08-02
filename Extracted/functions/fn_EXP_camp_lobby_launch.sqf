/*

	PROJECT: R&D
	AUTHOR:  Endstar
	DATE:    18-04-2016

	fn_EXP_camp_lobby_launch.sqf

		Campaign Lobby: Launch Function

	Params

		0:

	Return

		0:
*/

// Lobby UI defines
disableSerialization;
#include "\A3\Missions_F_Exp\Lobby\headers\ui_campaignLobbyDefines.inc"

// Wait for the briefing display to activate
private _briefingDisplay = displayNull;

waitUntil
{
	if (isServer) then
	{
		_briefingDisplay = findDisplay 52;
	} else
	{
		_briefingDisplay = findDisplay 53;
	};

	((!isNull _briefingDisplay) || (time > 0))
};

// JIP safety measures
if (isNull _briefingDisplay) exitWith {};
if (time > 0) exitWith {};

// Init map
private _map					= _briefingDisplay displayCtrl 51;

// Focus on bottom origin for high fps
_map ctrlMapAnimAdd [0, 0, [0,0,0]];
ctrlmapAnimCommit _map;

// Create the lobby on top
_display 						= _briefingDisplay createDisplay "RscDisplayCampaignLobby";

// Grab background and foreground control groups
private _ctrlBackgroundGroup 	= _display displayCtrl IDC_CAMPAIGN_LOBBY_BACKGROUND_GROUP;
private _ctrlMainGroup 			= _display displayCtrl IDC_CAMPAIGN_LOBBY_MAIN_GROUP;

// Fade out the background and foreground (managed in intro)
_ctrlBackgroundGroup	ctrlSetFade 1;
_ctrlBackgroundGroup	ctrlCommit	0;

_ctrlMainGroup			ctrlSetFade	1;
_ctrlMainGroup			ctrlCommit	0;

// Show them (as invisible)
_ctrlBackgroundGroup	ctrlShow true;
_ctrlMainGroup			ctrlShow true;

// Grab overlay and set that into focus
private _overlayGroup			= _display displayCtrl IDC_CAMPAIGN_LOBBY_OVERLAY_GROUP;
private _overlayBackground		= _display displayCtrl (IDC_CAMPAIGN_LOBBY_OVERLAY_GROUP + 1);

// Focus away from progress buttons
ctrlSetFocus _overlayGroup;

// Grab background image
private _cfgCampaign			= missionConfigFile >> "CampaignLobby";

// Grab access controls
private _accessTextCtrl			= _display displayCtrl (IDC_CAMPAIGN_LOBBY_ACCESS_KEY_GROUP + 5);

// Set access to uppercase
_accessTextCtrl ctrlSetText (toUpper (format ["%1: %2", localize "STR_A3_RscDisplayCampaignLobby_AccessLevel", 1]));
_accessTextCtrl ctrlCommit 0;

// Grab login controls
private _usernameTextCtrl		= _display displayCtrl (IDC_CAMPAIGN_LOBBY_LOGIN_GROUP + 1);
private _usernameEditCtrl		= _display displayCtrl (IDC_CAMPAIGN_LOBBY_LOGIN_GROUP + 2);
private _passwordTextCtrl		= _display displayCtrl (IDC_CAMPAIGN_LOBBY_LOGIN_GROUP + 3);
private _passwordEditCtrl		= _display displayCtrl (IDC_CAMPAIGN_LOBBY_LOGIN_GROUP + 4);

// Set username and password to uppercase
_usernameTextCtrl ctrlSetText (toUpper (localize "STR_A3_RscDisplayCampaignLobby_LoginUsername"));
_passwordTextCtrl ctrlSetText (toUpper (localize "STR_A3_RscDisplayCampaignLobby_LoginPassword"));
_usernameTextCtrl ctrlCommit 0;
_passwordTextCtrl ctrlCommit 0;

// Grab player squad name
private _playerName 			= call BIS_fnc_EXP_camp_lobby_getPlayerSquadName;

// Update username control with player squad name
_usernameEditCtrl ctrlSetText (toUpper _playerName);
_usernameEditCtrl ctrlCommit 0;

// Find number of player slots
private _playableSlots			= playableSlotsNumber blufor;

// Check if this is multiplayer solo
if (isMultiplayerSolo) then
{
	_playableSlots = 1;
};

// Grab player group control
private _ctrlPlayerCoreGroup	= _display displayCtrl (IDC_CAMPAIGN_LOBBY_MISSION_PLAYER_CORE_GROUP);

// Init playable slot controls array
private _playerCtrlSlots		= [];

// Create player slots
for "_i" from 0 to (_playableSlots - 1) do
{
	// For the first mission, use the existing mission option template
	private _ctrlPlayerGroup =
	_display ctrlCreate
	[
		"RscControlsGroup",
		IDC_CAMPAIGN_LOBBY_MISSION_PLAYER_GROUP + 10 * _i + 0,
		_ctrlPlayerCoreGroup
	];

	private _ctrlPlayerText =
	_display ctrlCreate
	[
		"RscText",
		IDC_CAMPAIGN_LOBBY_MISSION_PLAYER_GROUP + 10 * _i + 1,
		_ctrlPlayerGroup
	];

	private _ctrlPlayerHostIcon =
	_display ctrlCreate
	[
		"RscPictureKeepAspect",
		IDC_CAMPAIGN_LOBBY_MISSION_PLAYER_GROUP + 10 * _i + 2,
		_ctrlPlayerGroup
	];

	private _ctrlPlayerStatusIcon =
	_display ctrlCreate
	[
		"RscPictureKeepAspect",
		IDC_CAMPAIGN_LOBBY_MISSION_PLAYER_GROUP + 10 * _i + 3,
		_ctrlPlayerGroup
	];

	// Set the position of this group
	_ctrlPlayerGroup		ctrlSetPosition
	[
		MISSION_PLAYER_ITEM_X,
		MISSION_PLAYER_ITEM_Y + MISSION_PLAYER_ITEM_GUTTER_H * _i,
		MISSION_PLAYER_ITEM_W,
		MISSION_PLAYER_ITEM_H
	];

	// Set the position of the line
	_ctrlPlayerText			ctrlSetPosition
	[
		0,
		0,
		MISSION_PLAYER_ITEM_W,
		MISSION_PLAYER_ITEM_H
	];

	// Set the position of the text
	_ctrlPlayerHostIcon		ctrlSetPosition
	[
		MISSION_PLAYER_ITEM_HOST_ICON_X,
		MISSION_PLAYER_ITEM_HOST_ICON_Y,
		MISSION_PLAYER_ITEM_HOST_ICON_W,
		MISSION_PLAYER_ITEM_HOST_ICON_H
	];

	// Set the position of the text
	_ctrlPlayerStatusIcon	ctrlSetPosition
	[
		MISSION_PLAYER_ITEM_STATUS_ICON_X,
		MISSION_PLAYER_ITEM_HOST_ICON_Y,
		MISSION_PLAYER_ITEM_HOST_ICON_W,
		MISSION_PLAYER_ITEM_HOST_ICON_H
	];

	// Manage Fonts
	_ctrlPlayerText			ctrlSetFont				xGUI_FONT_NORMAL;
	_ctrlPlayerText			ctrlSetFontHeight		(MISSION_PLAYER_ITEM_H * 0.5);

	// Manage colors
	_ctrlPlayerText			ctrlSetBackgroundColor	([CAMPAIGN_LOBBY_COLOR_BLACK	+ ALPHA_25]		call BIS_fnc_HEXtoRGB);
	_ctrlPlayerText			ctrlSetTextColor		([CAMPAIGN_LOBBY_COLOR_WHITE	+ ALPHA_50]		call BIS_fnc_HEXtoRGB);

	_ctrlPlayerHostIcon		ctrlSetBackgroundColor	([CAMPAIGN_LOBBY_COLOR_BLACK	+ ALPHA_00]		call BIS_fnc_HEXtoRGB);
	_ctrlPlayerHostIcon		ctrlSetTextColor		([CAMPAIGN_LOBBY_COLOR_WHITE	+ ALPHA_100]	call BIS_fnc_HEXtoRGB);

	_ctrlPlayerStatusIcon	ctrlSetBackgroundColor	([CAMPAIGN_LOBBY_COLOR_BLACK	+ ALPHA_00]		call BIS_fnc_HEXtoRGB);
	_ctrlPlayerHostIcon		ctrlSetTextColor		([CAMPAIGN_LOBBY_COLOR_WHITE	+ ALPHA_100]	call BIS_fnc_HEXtoRGB);

	// Manage content
	_ctrlPlayerText			ctrlSetText				(toUpper (localize "STR_A3_RscDisplayCampaignLobby_PlayerOpenSlot"));;
	_ctrlPlayerHostIcon		ctrlSetText				PICTURE_CAMPAIGN_LOBBY_PLAYER_HOST;
	_ctrlPlayerStatusIcon	ctrlSetText				PICTURE_CAMPAIGN_LOBBY_PLAYER_STATUS_READY;

	// Show controls
	_ctrlPlayerGroup		ctrlShow				false;
	_ctrlPlayerText			ctrlShow				false;
	_ctrlPlayerHostIcon		ctrlShow				false;
	_ctrlPlayerStatusIcon	ctrlShow				false;

	// Commit all controls
	_ctrlPlayerGroup		ctrlCommit				0;
	_ctrlPlayerText			ctrlCommit				0;
	_ctrlPlayerHostIcon		ctrlCommit				0;
	_ctrlPlayerStatusIcon	ctrlCommit				0;

	// Add to array
	_playerCtrlSlots pushBack [_ctrlPlayerGroup, _ctrlPlayerText, _ctrlPlayerHostIcon, _ctrlPlayerStatusIcon];
};

// Init ui variable
uiNamespace setVariable ["A3X_UI_LOBBY_PLAYER_SLOTS", _playerCtrlSlots];

// Is this mission campaign lobby compatible?
private _cfgMissions = _cfgCampaign >> "Missions";

// Init main group control
private _ctrlTreeOptionGroup				= _display displayCtrl (IDC_CAMPAIGN_LOBBY_CTRG_TREE_OPTION_CORE_GROUP);

// Mission option array
private _missionOptionCtrls 				= [];

// Populate the campaign
if !(isNull _cfgCampaign) then
{
	// Init current mission select
	private _bCurrentMissionSelected = false;

	private _selectedMissionOptionGroup		= controlNull;
	private _selectedMissionOptionLine		= controlNull;
	private _selectedMissionOptionText		= controlNull;
	private _selectedMissionOptionIcon		= controlNull;
	private _selectedMissionOptionButton	= controlNull;

	// Populate mission options
	for "_i" from 0 to (count _cfgMissions - 1) do
	{
		// Grab mission
		private _cfgCurrentMission 		= _cfgMissions select _i;

		// Init mission specs
		private _missionClass			= configName (_cfgCurrentMission);
		private _missionName			= missionName;
		private _missionTitle			= getText (_cfgCurrentMission >> "name");
		private _missionImage			= getText (_cfgCurrentMission >> "image");
		private _missionDescription		= getText (missionConfigFile >> "overviewText");

		// Set uppercase missiontitle
		_missionTitle					= toUpper _missionTitle;

		// Create mission option group
		private _missionOptionGroup =
		_display ctrlCreate
		[
			"RscControlsGroup",
			IDC_CAMPAIGN_LOBBY_CTRG_TREE_OPTION_GROUP + 10 * _i + 0,
			_ctrlTreeOptionGroup
		];

		// Create mission option line
		private _missionOptionLine =
		_display ctrlCreate
		[
			"RscText",
			IDC_CAMPAIGN_LOBBY_CTRG_TREE_OPTION_GROUP + 10 * _i + 1,
			_missionOptionGroup
		];

		// Create mission option text
		private _missionOptionText =
		_display ctrlCreate
		[
			"RscTextNoShadow",
			IDC_CAMPAIGN_LOBBY_CTRG_TREE_OPTION_GROUP + 10 * _i + 2,
			_missionOptionGroup
		];

		// Create mission option complete
		private _missionOptionIcon =
		_display ctrlCreate
		[
			"RscPictureKeepAspect",
			IDC_CAMPAIGN_LOBBY_CTRG_TREE_OPTION_GROUP + 10 * _i + 3,
			_missionOptionGroup
		];

		// Create mission option button
		private _missionOptionButton =
		_display ctrlCreate
		[
			"RscButtonNoColor",
			IDC_CAMPAIGN_LOBBY_CTRG_TREE_OPTION_GROUP + 10 * _i + 4,
			_missionOptionGroup
		];

		// Update control array with newly created controls
		_missionOptionCtrls pushBack [_missionOptionGroup, _missionOptionLine, _missionOptionText, _missionOptionIcon, _missionOptionButton];

		// Set the position of this group
		_missionOptionGroup ctrlSetPosition
		[
			0,
			TREE_OPTION_GUTTER_H * _i,
			TREE_OPTION_W,
			TREE_OPTION_ITEM_H
		];

		// Set the position of the line
		_missionOptionLine ctrlSetPosition
		[
			TREE_OPTION_LINE_X,
			TREE_OPTION_LINE_Y,
			TREE_OPTION_LINE_W,
			TREE_OPTION_LINE_H
		];

		// Set the position of the text
		_missionOptionText ctrlSetPosition
		[
			TREE_OPTION_ITEM_X,
			0,
			TREE_OPTION_ITEM_W,
			TREE_OPTION_ITEM_H
		];

		// Set the position of the text
		_missionOptionIcon ctrlSetPosition
		[
			TREE_OPTION_ICON_X,
			TREE_OPTION_ICON_Y,
			TREE_OPTION_ICON_W,
			TREE_OPTION_ICON_H
		];

		// Set the position of the text
		_missionOptionButton ctrlSetPosition
		[
			TREE_OPTION_ITEM_X,
			0,
			TREE_OPTION_ITEM_W,
			TREE_OPTION_ITEM_H
		];

		// Invisible button
		_missionOptionButton	ctrlSetText				"#(argb,8,8,3)color(1,1,1,0)";

		// Set mission icon and colour
		_missionOptionIcon		ctrlSetText				PICTURE_CAMPAIGN_LOBBY_PLAYER_STATUS_READY;
		_missionOptionIcon		ctrlSetTextColor		([CAMPAIGN_LOBBY_COLOR_BLUE + ALPHA_50]		call BIS_fnc_HEXTORGB);

		// Set Text Color
		_missionOptionText		ctrlSetBackgroundColor	([CAMPAIGN_LOBBY_COLOR_WHITE + ALPHA_50]	call BIS_fnc_HEXTORGB);
		_missionOptionText		ctrlSetTextColor		([CAMPAIGN_LOBBY_COLOR_BLACK + ALPHA_50]	call BIS_fnc_HEXTORGB);

		// Set Text Font
		_missionOptionText		ctrlSetText 			_missionTitle;
		_missionOptionText		ctrlSetFont 			xGUI_FONT_NORMAL;
		_missionOptionText		ctrlSetFontHeight		(TREE_OPTION_ITEM_H * 0.5);

		// Show completed mission icon
		private _bShowCompleted			= false;

		// Select the current mission in the list
		if (_missionClass == _missionName) then
		{
			// Selected mission
			_bCurrentMissionSelected	= true;

			// Set access level
			_accessTextCtrl ctrlSetText (toUpper (format ["%1: %2", localize "STR_A3_RscDisplayCampaignLobby_AccessLevel", _i + 1]));
			_accessTextCtrl ctrlCommit 0;

			// Init selected vars for intel
			_selectedMissionOptionGroup		= _missionOptionGroup;
			_selectedMissionOptionLine		= _missionOptionLine;
			_selectedMissionOptionText		= _missionOptionText;
			_selectedMissionOptionIcon		= _missionOptionIcon;
			_selectedMissionOptionButton	= _missionOptionButton;

			// Selected colours
			_missionOptionLine		ctrlSetBackgroundColor	([CAMPAIGN_LOBBY_COLOR_GREEN + ALPHA_100]	call BIS_fnc_HEXTORGB);
			_missionOptionText 		ctrlSetBackgroundColor	([CAMPAIGN_LOBBY_COLOR_GREEN + ALPHA_100]	call BIS_fnc_HEXTORGB);
			_missionOptionText 		ctrlSetTextColor		([CAMPAIGN_LOBBY_COLOR_BLACK + ALPHA_100]	call BIS_fnc_HEXTORGB);
			_missionOptionIcon		ctrlSetTextColor		([CAMPAIGN_LOBBY_COLOR_WHITE + ALPHA_00]	call BIS_fnc_HEXTORGB);

			uiNamespace setVariable
			[
				"A3X_UI_LOBBY_MISSION",
				[
					_i,
					_missionOptionGroup,
					_missionOptionLine,
					_missionOptionText,
					_missionOptionIcon,
					_missionOptionButton
				]
			];

		} else
		{
			// Completed mission
			if !(_bCurrentMissionSelected) then
			{
				// Show completed
				_bShowCompleted		= true;

				_missionOptionText	ctrlSetText _missionTitle;

				_missionOptionLine 	ctrlSetBackgroundColor		([CAMPAIGN_LOBBY_COLOR_RED	 + ALPHA_25] call BIS_fnc_HEXTORGB);
				_missionOptionText 	ctrlSetBackgroundColor		([CAMPAIGN_LOBBY_COLOR_BLACK + ALPHA_25] call BIS_fnc_HEXTORGB);
				_missionOptionText 	ctrlSetTextColor			([CAMPAIGN_LOBBY_COLOR_WHITE + ALPHA_25] call BIS_fnc_HEXTORGB);
				_missionOptionIcon	ctrlSetTextColor			([CAMPAIGN_LOBBY_COLOR_WHITE + ALPHA_00] call BIS_fnc_HEXTORGB);

			} else
			{
				// Restricted mission
				_missionTitle = (toUpper (localize "STR_A3_RscDisplayCampaignLobby_MissionOption_Restricted"));

				_missionOptionLine	ctrlSetBackgroundColor		([CAMPAIGN_LOBBY_COLOR_RED	 + ALPHA_25] call BIS_fnc_HEXTORGB);
				_missionOptionText 	ctrlSetBackgroundColor		([CAMPAIGN_LOBBY_COLOR_RED	 + ALPHA_25] call BIS_fnc_HEXTORGB);
				_missionOptionText 	ctrlSetTextColor			([CAMPAIGN_LOBBY_COLOR_WHITE + ALPHA_25] call BIS_fnc_HEXTORGB);
				_missionOptionIcon	ctrlSetTextColor			([CAMPAIGN_LOBBY_COLOR_WHITE + ALPHA_00] call BIS_fnc_HEXTORGB);

				_missionOptionText	ctrlSetText _missionTitle;
			};
		};

		// Complete control management
		_missionOptionGroup		ctrlShow true;
		_missionOptionLine		ctrlShow true;
		_missionOptionText		ctrlShow true;
		_missionOptionButton	ctrlShow true;
		_missionOptionIcon		ctrlShow false;

		_missionOptionGroup		ctrlCommit 0;
		_missionOptionLine 		ctrlCommit 0;
		_missionOptionText 		ctrlCommit 0;
		_missionOptionIcon 		ctrlCommit 0;
		_missionOptionButton 	ctrlCommit 0;

		// Now add eventhandlers
		_missionOptionButton	ctrlAddEventHandler ["ButtonClick","[_this select 0, 0] call BIS_fnc_EXP_camp_lobby_UIMissionManager"];
		_missionOptionButton	ctrlAddEventHandler ["MouseEnter","[_this select 0, 1] call BIS_fnc_EXP_camp_lobby_UIMissionManager"];
		_missionOptionButton	ctrlAddEventHandler ["MouseExit","[_this select 0, 2] call BIS_fnc_EXP_camp_lobby_UIMissionManager"];
	};

	// Set mission option ctrls
	uiNamespace setVariable ["A3X_UI_LOBBY_MISSION_OPTIONS", _missionOptionCtrls];

	// Update the Mission UI
	[_selectedMissionOptionButton, 0] call BIS_fnc_EXP_camp_lobby_UIMissionManager;
};

// Find the height of the mission list
private _missionListHeight			= TREE_OPTION_GUTTER_H * (count _missionOptionCtrls) - (pixelH);

// Grab the groups we need to dynamically scale
private _ctrlMissionGroup			= _display displayCtrl IDC_CAMPAIGN_LOBBY_MISSION_GROUP;

// Video group
private _ctrlVideoGroup				= _display displayCtrl IDC_CAMPAIGN_LOBBY_MISSION_VIDEO_GROUP;
private _ctrlVideoBackground		= _display displayCtrl (IDC_CAMPAIGN_LOBBY_MISSION_VIDEO_GROUP + 1);

// Overlay group
private _ctrlMissionOverlayGroup	= _display displayCtrl IDC_CAMPAIGN_LOBBY_MISSION_OVERLAY_GROUP;
private _ctrlMissionOverlayTop		= _display displayCtrl (IDC_CAMPAIGN_LOBBY_MISSION_OVERLAY_GROUP + 1);
private _ctrlMissionOverlayBottom	= _display displayCtrl (IDC_CAMPAIGN_LOBBY_MISSION_OVERLAY_GROUP + 2);
private _ctrlMissionOverlayLeft		= _display displayCtrl (IDC_CAMPAIGN_LOBBY_MISSION_OVERLAY_GROUP + 3);
private _ctrlMissionOverlayRight	= _display displayCtrl (IDC_CAMPAIGN_LOBBY_MISSION_OVERLAY_GROUP + 4);
private _ctrlMissionOverlayComplete	= _display displayCtrl (IDC_CAMPAIGN_LOBBY_MISSION_OVERLAY_GROUP + 5);
private _ctrlMissionOverlayTrigger	= _display displayCtrl (IDC_CAMPAIGN_LOBBY_MISSION_OVERLAY_GROUP + 6);

// Intel group
private _ctrlIntelGroup				= _display displayCtrl (IDC_CAMPAIGN_LOBBY_MISSION_INTEL_GROUP);
private _ctrlIntelBackground		= _display displayCtrl (IDC_CAMPAIGN_LOBBY_MISSION_INTEL_GROUP + 1);
private _ctrlIntelTitle				= _display displayCtrl (IDC_CAMPAIGN_LOBBY_MISSION_INTEL_GROUP + 2);
private _ctrlIntelText				= _display displayCtrl (IDC_CAMPAIGN_LOBBY_MISSION_INTEL_GROUP + 3);
private _ctrlIntelStatus			= _display displayCtrl (IDC_CAMPAIGN_LOBBY_MISSION_INTEL_GROUP + 4);

// Set the text of the Overlay Complete to upper
_ctrlMissionOverlayComplete ctrlSetText (toUpper (localize "STR_A3_RscDisplayCampaignLobby_MissionCompleted"));
_ctrlMissionOverlayComplete ctrlCommit 0;

// Width and Height management based on group h
private _grids	= floor ((MISSION_GROUP_H / xGUI_GRID_H) * 2);	// Find the number of grids to make the width
private _width	= xGUI_GRID_W * _grids;
private _height	= MISSION_GROUP_H;

if (_width > MISSION_GROUP_W) then
{
	_grids		= floor (MISSION_GROUP_W / xGUI_GRID_W);
	_width		= xGUI_GRID_W * _grids;
	_height		= xGUI_GRID_H * _grids * 0.5;
};

// Set the position of the video group
{
	_x ctrlSetPosition
	[
		0,
		0,
		_width,
		_height
	];

	_x ctrlCommit 0;

} foreach [_ctrlVideoGroup, _ctrlVideoBackground, _ctrlMissionOverlayGroup, _ctrlMissionOverlayTrigger];

// Set the position of the "Completed" mission control
_ctrlMissionOverlayComplete ctrlSetPosition
[
	_width * 0.5 - (MISSION_OVERLAY_COMPLETE_W * 0.5),
	_height * 0.5 - (MISSION_OVERLAY_COMPLETE_H * 0.5),
	(ctrlPosition _ctrlMissionOverlayComplete select 2),
	(ctrlPosition _ctrlMissionOverlayComplete select 3)
];

// Commit overlay complete
_ctrlMissionOverlayComplete ctrlCommit 0;

// Manage positions of outlines
private _outlineXPos		= ctrlPosition _ctrlVideoGroup select 0;
private _outlineYPos		= ctrlPosition _ctrlVideoGroup select 1;
private _outlineWPos		= ctrlPosition _ctrlVideoGroup select 2;
private _outlineHPos		= ctrlPosition _ctrlVideoGroup select 3;

// Set outlines
_ctrlMissionOverlayTop		ctrlSetPosition [_outlineXPos, _outlineYPos, _outlineWPos, MISSION_OVERLAY_LINE01_H];
_ctrlMissionOverlayBottom	ctrlSetPosition [_outlineXPos, _outlineYPos + _outlineHPos - MISSION_OVERLAY_LINE01_H, _outlineWPos, MISSION_OVERLAY_LINE01_H];
_ctrlMissionOverlayLeft		ctrlSetPosition [_outlineXPos, _outlineYPos, MISSION_OVERLAY_LINE03_W, _outlineHPos];
_ctrlMissionOverlayRight	ctrlSetPosition [_outlineXPos + _outlineWPos - MISSION_OVERLAY_LINE03_W, _outlineYPos, MISSION_OVERLAY_LINE03_W, _outlineHPos];

// Commit outlines
_ctrlMissionOverlayTop		ctrlCommit 0;
_ctrlMissionOverlayBottom	ctrlCommit 0;
_ctrlMissionOverlayLeft		ctrlCommit 0;
_ctrlMissionOverlayRight	ctrlCommit 0;

// Place the player group next to the video
private _playerXPos = _width + pixelW;

// If we don't have room, overlap with video
if ((_playerXPos + MISSION_PLAYER_ITEM_W) > MISSION_GROUP_W) then
{
	_playerXPos = _width - MISSION_PLAYER_ITEM_W - MISSION_OVERLAY_LINE03_W - pixelW;
};

// Find number of players
private _playerCount		= count _playerCtrlSlots;

// Find correct height for player group
private _playerGroupYPos	= _height - MISSION_INTEL_H - (MISSION_PLAYER_ITEM_GUTTER_H * _playerCount);
private _playerGroupHeight	= MISSION_PLAYER_ITEM_GUTTER_H * _playerCount;

if (_playerGroupHeight > (_height - MISSION_INTEL_H)) then
{
	_playerGroupYPos		= pixelH;
	_playerGroupHeight		= (_height - MISSION_INTEL_H - pixelH);
};

// Set size of the player group
_ctrlPlayerCoreGroup ctrlSetPosition
[
	_playerXPos,
	_playerGroupYPos,
	MISSION_PLAYER_ITEM_W,
	_playerGroupHeight
];

// Commit player group
_ctrlPlayerCoreGroup ctrlCommit 0;

// Manage position of intel group
_ctrlIntelGroup ctrlSetPosition
[
	ctrlPosition _ctrlIntelGroup select 0,
	_height - (ctrlPosition _ctrlIntelGroup select 3),
	_width,
	ctrlPosition _ctrlIntelGroup select 3
];

// Commit intel group
_ctrlIntelGroup ctrlCommit 0;

// Manage position of the intel background
_ctrlIntelBackground ctrlSetPosition
[
	ctrlPosition _ctrlIntelBackground select 0,
	ctrlPosition _ctrlIntelBackground select 1,
	_width,
	ctrlPosition _ctrlIntelBackground select 3
];

// Commit intel background
_ctrlIntelBackground ctrlCommit 0;

// Manage position of intel controls
{
	_x ctrlSetPosition
	[
		(ctrlPosition _x select 0) + MAIN_GUTTER_W,
		ctrlPosition _x select 1,
		_width - MAIN_GUTTER_W,
		ctrlPosition _x select 3
	];

	_x ctrlCommit 0;
} foreach [_ctrlIntelTitle, _ctrlIntelText];

// Position Intel Title Complete
_ctrlIntelStatus ctrlSetPosition
[
	(ctrlPosition _ctrlIntelStatus select 0),
	(ctrlPosition _ctrlIntelStatus select 1),
	_width - MAIN_GUTTER_W * 2,
	(ctrlPosition _ctrlIntelStatus select 3)
];

// Commit intel
_ctrlIntelStatus ctrlCommit 0;

// Grab progress controls
private _progressOptionGroup			= _display displayCtrl IDC_CAMPAIGN_LOBBY_PROGRESS_GROUP;
private _progressOptionLogOutText		= _display displayCtrl (IDC_CAMPAIGN_LOBBY_PROGRESS_GROUP + 1);
private _progressOptionLogOutButton		= _display displayCtrl (IDC_CAMPAIGN_LOBBY_PROGRESS_GROUP + 2);
private _progressOptionApproveText 		= _display displayCtrl (IDC_CAMPAIGN_LOBBY_PROGRESS_GROUP + 3);
private _progressOptionApproveButton	= _display displayCtrl (IDC_CAMPAIGN_LOBBY_PROGRESS_GROUP + 4);

// First position the approve button to match the mission group
{
	_x ctrlSetPosition
	[
		_width - PROGRESS_BUTTON_W,
		(ctrlPosition _x select 1),
		(ctrlPosition _x select 2),
		(ctrlPosition _x select 3)
	];

	_x ctrlCommit 0;

} forEach [_progressOptionApproveText, _progressOptionApproveButton];

// Set expected progress text
_progressOptionLogOutText	ctrlSetText (toUpper (localize "STR_A3_RscDisplayCampaignLobby_ProgressLogOut"));
_progressOptionApproveText	ctrlSetText (toUpper (localize "STR_A3_RscDisplayCampaignLobby_ProgressApprove"));

// Commit progress controls
_progressOptionLogOutText	ctrlCommit 0;
_progressOptionApproveText	ctrlCommit 0;

// Add to array
private _progressOptionCtrls =
[
	[_progressOptionLogOutText,_progressOptionLogOutButton],
	[_progressOptionApproveText,_progressOptionApproveButton]
];

// Drop array in UI namespace
uiNamespace setVariable ["A3X_UI_LOBBY_PROGRESS_OPTIONS", _progressOptionCtrls];

// Current mission
private _currentMission					= uiNamespace getVariable "A3X_UI_LOBBY_MISSION";
private _currentMissionIndex			= _currentMission select 0;
private _currentMissionOptionGroup		= _currentMission select 1;
private _currentMissionOptionLine		= _currentMission select 2;
private _currentMissionOptionText		= _currentMission select 3;
private _currentMissionOptionIcon		= _currentMission select 4;
private _currentMissionOptionButton		= _currentMission select 5;

// Set mouse position to the selected control
private _currentMissionOptionGroupX 	= (ctrlPosition (ctrlParentControlsGroup _currentMissionOptionGroup) select 0);
private _currentMissionOptionGroupY 	= (ctrlPosition (ctrlParentControlsGroup _currentMissionOptionGroup) select 1);
private _currentMissionOptionGroupW 	= (ctrlPosition (ctrlParentControlsGroup _currentMissionOptionGroup) select 2);
private _currentMissionOptionGroupH 	= (ctrlPosition (ctrlParentControlsGroup _currentMissionOptionGroup) select 3);

// Set mouse position to the current mission index
setMousePosition
[
	(safeZoneX + _currentMissionOptionGroupX) + _currentMissionOptionGroupW * 0.5,
	(safeZoneY + _currentMissionOptionGroupY) + TREE_OPTION_GUTTER_H * _currentMissionIndex + TREE_OPTION_ITEM_H * 0.5
];

// Fade in the lobby
[_briefingDisplay, _display, _missionOptionCtrls] execVM "\A3\Missions_F_Exp\Lobby\functions\fn_EXP_camp_lobby_intro.sqf";