/*

	PROJECT: R&D
	AUTHOR:  Endstar
	DATE:    18-04-2016

	fn_EXP_camp_lobby_UIMissionManager.sqf

		Campaign Lobby: Handles UI behaviour of tree mission options

	Params

		0:

	Return

		0:
*/

// Lobby UI defines
disableSerialization;
#include "\A3\Missions_F_Exp\Lobby\headers\ui_campaignLobbyDefines.inc"

// Grab params
private _ctrl = _this select 0;
private _case = _this select 1;

// Main Display
private _display						= findDisplay IDD_CAMPAIGN_LOBBY;

// Check host
private _host 							= missionNamespace getVariable "A3X_UI_LOBBY_HOST";

if (isNil { _host }) then
{
	_host = objNull;
};

// Mission option array
private _missionOptionCtrls 			= uiNamespace getVariable "A3X_UI_LOBBY_MISSION_OPTIONS";

if (isNil { _missionOptionCtrls }) exitWith {};

// Init controls
private _missionOptionGroup 			= controlNull;
private _missionOptionLine 				= controlNull;
private _missionOptionText 				= controlNull;
private _missionOptionIcon 				= controlNull;
private _missionOptionButton 			= controlNull;

// Find relevant controls
for "_i" from 0 to (count _missionOptionCtrls - 1) do
{
	private _optionGroup				= _missionOptionCtrls select _i select 0;
	private _optionLine					= _missionOptionCtrls select _i select 1;
	private _optionText					= _missionOptionCtrls select _i select 2;
	private _optionIcon					= _missionOptionCtrls select _i select 3;
	private _optionButton				= _missionOptionCtrls select _i select 4;

	if (_ctrl == _optionButton) exitWith
	{
		_missionOptionGroup 			= _optionGroup;
		_missionOptionLine 				= _optionLine;
		_missionOptionText 				= _optionText;
		_missionOptionIcon 				= _optionIcon;
		_missionOptionButton 			= _optionButton;
	};
};

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

// Hover option
private _hoverMissionOptionCtrls 		= uiNamespace getVariable "A3X_UI_LOBBY_MISSION_OPTION_HOVER";
private _hoverMissionOptionGroup		= controlNull;
private _hoverMissionOptionLine			= controlNull;
private _hoverMissionOptionText			= controlNull;
private _hoverMissionOptionIcon			= controlNull;
private _hoverMissionOptionButton		= controlNull;

if !(isNil { _hoverMissionOptionCtrls }) then
{
	_hoverMissionOptionGroup			= _hoverMissionOptionCtrls select 0;
	_hoverMissionOptionLine				= _hoverMissionOptionCtrls select 1;
	_hoverMissionOptionText				= _hoverMissionOptionCtrls select 2;
	_hoverMissionOptionIcon				= _hoverMissionOptionCtrls select 3;
	_hoverMissionOptionButton			= _hoverMissionOptionCtrls select 4;
};

// Current mission
private _currentMission					= uiNamespace getVariable "A3X_UI_LOBBY_MISSION";
private _currentMissionIndex			= _currentMission select 0;
private _currentMissionOptionGroup		= _currentMission select 1;
private _currentMissionOptionLine		= _currentMission select 2;
private _currentMissionOptionText		= _currentMission select 3;
private _currentMissionOptionIcon		= _currentMission select 4;
private _currentMissionOptionButton		= _currentMission select 5;

// If there is no current mission - exit
if (isNil { _currentMission}) exitWith {};

// Progress controls
private _progressOptionGroup			= _display displayCtrl IDC_CAMPAIGN_LOBBY_PROGRESS_GROUP;
private _progressOptionLogOutText		= _display displayCtrl (IDC_CAMPAIGN_LOBBY_PROGRESS_GROUP + 1);
private _progressOptionLogOutButton		= _display displayCtrl (IDC_CAMPAIGN_LOBBY_PROGRESS_GROUP + 2);
private _progressOptionApproveText 		= _display displayCtrl (IDC_CAMPAIGN_LOBBY_PROGRESS_GROUP + 3);
private _progressOptionApproveButton	= _display displayCtrl (IDC_CAMPAIGN_LOBBY_PROGRESS_GROUP + 4);

// Intel Controls
private _intelGroup						= _display displayCtrl (IDC_CAMPAIGN_LOBBY_MISSION_INTEL_GROUP);
private _intelBackground				= _display displayCtrl (IDC_CAMPAIGN_LOBBY_MISSION_INTEL_GROUP + 1);
private _intelTitle						= _display displayCtrl (IDC_CAMPAIGN_LOBBY_MISSION_INTEL_GROUP + 2);
private _intelText						= _display displayCtrl (IDC_CAMPAIGN_LOBBY_MISSION_INTEL_GROUP + 3);
private _intelStatus					= _display displayCtrl (IDC_CAMPAIGN_LOBBY_MISSION_INTEL_GROUP + 4);

// Connected players
private _connectedPlayers				= missionNamespace getVariable "A3X_UI_LOBBY_PLAYERS";

// For the first time run - we could use a fake player at launch
if (isNil { _connectedPlayers }) then
{
	_connectedPlayers = [["",2,true]];
};

// Countdown Variable
private _countdown			= missionNamespace getVariable "A3X_UI_LOBBY_MISSION_COUNTDOWN";

// Is the mission restricted
_bRestrictedMission			= false;

// Find restricted missions through larger IDCs
if ((ctrlIDC _missionOptionText) > (ctrlIDC _currentMissionOptionText)) then
{
	_bRestrictedMission		= true;
};

// Is Everyone Ready
private _bEveryoneReady		= false;

if (({(_x select 1) == 2} count _connectedPlayers) == (count _connectedPlayers)) then
{
	_bEveryoneReady			= true;
};

// Is the game launching
private _bLaunching			= false;

if !(isNil { _countdown }) then
{
	_bLaunching				= true;
};

// Check hover state
private _bIsHovering		= false;

if !(isNil { _hoverMissionOptionButton }) then
{
	_bIsHovering			= true;
};

// Check host
private _bIsHost			= false;

if (player == _host) then
{
	_bIsHost				= true;
};

// Function to manage Approve Button
private _fn_showApproveButton =
{
	// Init alphas and show bool
	private _show		= _this select 0;
	private _alpha		= ALPHA_75;

	// Show or hide button
	_progressOptionApproveButton ctrlShow _show;

	// Manage alpha (we don't hide completely)
	if !(_show) then
	{
		_alpha			= ALPHA_10;
	};

	// If everyone is ready, manage colours of approve button
	if (_bEveryoneReady) then
	{
		_progressOptionApproveText	ctrlSetBackgroundColor	([CAMPAIGN_LOBBY_COLOR_GREEN	+ _alpha]		call BIS_fnc_HEXtoRGB);
		_progressOptionApproveText	ctrlSetTextColor		([CAMPAIGN_LOBBY_COLOR_BLACK	+ ALPHA_100]	call BIS_fnc_HEXtoRGB);
	} else
	{
		_progressOptionApproveText	ctrlSetBackgroundColor	([CAMPAIGN_LOBBY_COLOR_ORANGE	+ _alpha]		call BIS_fnc_HEXtoRGB);
		_progressOptionApproveText	ctrlSetTextColor		([CAMPAIGN_LOBBY_COLOR_BLACK	+ ALPHA_100]	call BIS_fnc_HEXtoRGB);
	};
};

// If everyone is ready, manage intel status
if (_bEveryoneReady) then
{
	_intelStatus ctrlSetText		toUpper (localize "STR_A3_RscDisplayCampaignLobby_ProgressReady");
	_intelStatus ctrlSetTextColor	([CAMPAIGN_LOBBY_COLOR_GREEN	+ ALPHA_100]	call BIS_fnc_HEXtoRGB);
} else
{
	_intelStatus ctrlSetText		toUpper (localize "STR_A3_RscDisplayCampaignLobby_ProgressWaitingForAssets");
	_intelStatus ctrlSetTextColor	([CAMPAIGN_LOBBY_COLOR_ORANGE	+ ALPHA_100]	call BIS_fnc_HEXtoRGB);
};

// Click, hover and selected case management
switch (_case) do
{
	// Click
	case 0:
	{
		// Check if we are re-selecting an already selected item - because we won't bother updating the intel if that is the case
		private _bReselect = false;
		if (_selectedMissionOptionGroup == _missionOptionGroup) then
		{
			_bReselect = true;
		};

		// Update selected button
		uiNamespace setVariable
		[
			"A3X_UI_LOBBY_MISSION_OPTION_SELECTED",
			[
				_missionOptionGroup, _missionOptionLine, _missionOptionText, _missionOptionIcon, _missionOptionButton
			]
		];

		_selectedMissionOptionGroup			= _missionOptionGroup;
		_selectedMissionOptionLine			= _missionOptionLine;
		_selectedMissionOptionText			= _missionOptionText;
		_selectedMissionOptionIcon			= _missionOptionIcon;
		_selectedMissionOptionButton		= _missionOptionButton;

		// Disable progress button by default
		if (_bIsHost) then
		{
			[false] call _fn_showApproveButton;
		};

		// Update colours
		for "_i" from 0 to (count _missionOptionCtrls - 1) do
		{
			// Init each control
			private _optionGroup			= _missionOptionCtrls select _i select 0;
			private _optionLine				= _missionOptionCtrls select _i select 1;
			private _optionText				= _missionOptionCtrls select _i select 2;
			private _optionIcon				= _missionOptionCtrls select _i select 3;
			private _optionButton			= _missionOptionCtrls select _i select 4;

			// SELECTED CONTROL
			if (_selectedMissionOptionButton == _optionButton) then
			{
				// NOT FOCUSED AND CLICKED [STATE]
				if (_bIsHovering) then
				{
					// Check Restriction
					if (_bRestrictedMission) then
					{
						// RESTRICTED MISSIONS
						_optionLine ctrlSetBackgroundColor					([CAMPAIGN_LOBBY_COLOR_RED		+ ALPHA_100] call BIS_fnc_HEXTORGB);
						_optionText ctrlSetBackgroundColor					([CAMPAIGN_LOBBY_COLOR_RED		+ ALPHA_100] call BIS_fnc_HEXTORGB);
						_optionText ctrlSetTextColor						([CAMPAIGN_LOBBY_COLOR_BLACK	+ ALPHA_50] call BIS_fnc_HEXTORGB);

					} else
					{
						// Check Current Mission
						if (_optionGroup == _currentMissionOptionGroup) then
						{
							// Enable Progress button
							if (_bIsHost) then
							{
								[true] call _fn_showApproveButton;
							};

							// CURRENT MISSION
							if (_bEveryoneReady) then
							{
								// Everyone ready
								_optionLine	ctrlSetBackgroundColor			([CAMPAIGN_LOBBY_COLOR_GREEN	+ ALPHA_100] call BIS_fnc_HEXTORGB);
								_optionText	ctrlSetBackgroundColor			([CAMPAIGN_LOBBY_COLOR_GREEN	+ ALPHA_100] call BIS_fnc_HEXTORGB);
								_optionText	ctrlSetTextColor				([CAMPAIGN_LOBBY_COLOR_BLACK	+ ALPHA_50] call BIS_fnc_HEXTORGB);

							} else
							{
								// Not everyone is ready
								_optionLine	ctrlSetBackgroundColor			([CAMPAIGN_LOBBY_COLOR_ORANGE	+ ALPHA_100] call BIS_fnc_HEXTORGB);
								_optionText	ctrlSetBackgroundColor			([CAMPAIGN_LOBBY_COLOR_ORANGE	+ ALPHA_100] call BIS_fnc_HEXTORGB);
								_optionText	ctrlSetTextColor				([CAMPAIGN_LOBBY_COLOR_BLACK	+ ALPHA_50] call BIS_fnc_HEXTORGB);

							};
						} else
						{

							// COMPLETED MISSIONS
							_optionLine	ctrlSetBackgroundColor				([CAMPAIGN_LOBBY_COLOR_WHITE	+ ALPHA_100] call BIS_fnc_HEXTORGB);
							_optionText	ctrlSetBackgroundColor				([CAMPAIGN_LOBBY_COLOR_WHITE	+ ALPHA_100] call BIS_fnc_HEXTORGB);
							_optionText	ctrlSetTextColor					([CAMPAIGN_LOBBY_COLOR_BLACK	+ ALPHA_50] call BIS_fnc_HEXTORGB);
						};
					};
				} else
				{
					// FOCUSED AND CLICKED [STATE]
					if (_hoverMissionOptionButton == _optionButton) then
					{
						// Check Restriction
						if (_bRestrictedMission) then
						{
							// RESTRICTED MISSIONS
							_optionLine	ctrlSetBackgroundColor				([CAMPAIGN_LOBBY_COLOR_RED		+ ALPHA_100] call BIS_fnc_HEXTORGB);
							_optionText	ctrlSetBackgroundColor				([CAMPAIGN_LOBBY_COLOR_RED		+ ALPHA_100] call BIS_fnc_HEXTORGB);
							_optionText	ctrlSetTextColor					([CAMPAIGN_LOBBY_COLOR_BLACK	+ ALPHA_50]  call BIS_fnc_HEXTORGB);
						} else
						{
							// Check Current Mission
							if (_optionGroup == _currentMissionOptionGroup) then
							{
								// Enable Progress button
								[true] call _fn_showApproveButton;

								// CURRENT MISSION
								if (_bEveryoneReady) then
								{
									// Everyone is ready
									_optionLine	ctrlSetBackgroundColor		([CAMPAIGN_LOBBY_COLOR_GREEN	+ ALPHA_100] call BIS_fnc_HEXTORGB);
									_optionText	ctrlSetBackgroundColor		([CAMPAIGN_LOBBY_COLOR_GREEN	+ ALPHA_100] call BIS_fnc_HEXTORGB);
									_optionText	ctrlSetTextColor			([CAMPAIGN_LOBBY_COLOR_BLACK	+ ALPHA_50]	 call BIS_fnc_HEXTORGB);

								} else
								{
									// Everyone not ready
									_optionLine	ctrlSetBackgroundColor		([CAMPAIGN_LOBBY_COLOR_ORANGE	+ ALPHA_100] call BIS_fnc_HEXTORGB);
									_optionText	ctrlSetBackgroundColor		([CAMPAIGN_LOBBY_COLOR_ORANGE	+ ALPHA_100] call BIS_fnc_HEXTORGB);
									_optionText	ctrlSetTextColor			([CAMPAIGN_LOBBY_COLOR_BLACK	+ ALPHA_50] call BIS_fnc_HEXTORGB);
								};
							} else
							{
								// COMPLETED MISSIONS
								_optionLine	ctrlSetBackgroundColor			([CAMPAIGN_LOBBY_COLOR_WHITE	+ ALPHA_100] call BIS_fnc_HEXTORGB);
								_optionText	ctrlSetBackgroundColor			([CAMPAIGN_LOBBY_COLOR_WHITE	+ ALPHA_100] call BIS_fnc_HEXTORGB);
								_optionText	ctrlSetTextColor				([CAMPAIGN_LOBBY_COLOR_BLACK	+ ALPHA_50]  call BIS_fnc_HEXTORGB);
							};
						};
					};
				};
			} else
			{
				// RESET ALL OTHER OPTIONS TO DEFAULT COLORS
				if ((ctrlIDC _optionButton) > (ctrlIDC _currentMissionOptionButton)) then
				{
					// RESTRICTED MISSIONS
					_optionLine	ctrlSetBackgroundColor						([CAMPAIGN_LOBBY_COLOR_RED		+ ALPHA_25] call BIS_fnc_HEXTORGB);
					_optionText	ctrlSetBackgroundColor						([CAMPAIGN_LOBBY_COLOR_RED		+ ALPHA_25] call BIS_fnc_HEXTORGB);
					_optionText	ctrlSetTextColor							([CAMPAIGN_LOBBY_COLOR_WHITE	+ ALPHA_25] call BIS_fnc_HEXTORGB);
				} else
				{
					// Check Current Mission
					if (_optionGroup == _currentMissionOptionGroup) then
					{
						// CURRENT MISSION
						if (_bEveryoneReady) then
						{
							// Everyone is ready
							_optionLine	ctrlSetBackgroundColor				([CAMPAIGN_LOBBY_COLOR_GREEN	+ ALPHA_75] call BIS_fnc_HEXTORGB);
							_optionText	ctrlSetBackgroundColor				([CAMPAIGN_LOBBY_COLOR_GREEN	+ ALPHA_75] call BIS_fnc_HEXTORGB);
							_optionText	ctrlSetTextColor					([CAMPAIGN_LOBBY_COLOR_WHITE	+ ALPHA_75] call BIS_fnc_HEXTORGB);
						} else
						{
							// Everyone not ready
							_optionLine	ctrlSetBackgroundColor				([CAMPAIGN_LOBBY_COLOR_ORANGE	+ ALPHA_75] call BIS_fnc_HEXTORGB);
							_optionText	ctrlSetBackgroundColor				([CAMPAIGN_LOBBY_COLOR_ORANGE	+ ALPHA_75] call BIS_fnc_HEXTORGB);
							_optionText	ctrlSetTextColor					([CAMPAIGN_LOBBY_COLOR_WHITE	+ ALPHA_75] call BIS_fnc_HEXTORGB);
						};
					} else
					{
						// NON RESTRICTED MISSIONS
						_optionLine	ctrlSetBackgroundColor					([CAMPAIGN_LOBBY_COLOR_RED		+ ALPHA_25] call BIS_fnc_HEXTORGB);
						_optionText	ctrlSetBackgroundColor					([CAMPAIGN_LOBBY_COLOR_BLACK	+ ALPHA_25] call BIS_fnc_HEXTORGB);
						_optionText	ctrlSetTextColor						([CAMPAIGN_LOBBY_COLOR_WHITE	+ ALPHA_25] call BIS_fnc_HEXTORGB);
					};
				};
			};

			// Commit options
			_optionGroup	ctrlCommit 0;
			_optionLine		ctrlCommit 0;
			_optionText		ctrlCommit 0;
			_optionIcon		ctrlCommit 0;
			_optionButton	ctrlCommit 0;
		};

		// Now run the action
		if !(_bReselect) then
		{
			[(ctrlIDC _selectedMissionOptionGroup) - IDC_CAMPAIGN_LOBBY_CTRG_TREE_OPTION_GROUP, 0] call BIS_fnc_EXP_camp_lobby_updateIntel;
		};
	};

	// Enter
	case 1:
	{
		// Update selected button
		uiNamespace setVariable
		[
			"A3X_UI_LOBBY_MISSION_OPTION_HOVER",
			[
				_missionOptionGroup,
				_missionOptionLine,
				_missionOptionText,
				_missionOptionIcon,
				_missionOptionButton
			]
		];

		// SELECTED + FOCUS
		if (_missionOptionButton == _selectedMissionOptionButton) then
		{
			// Check Restriction
			if (_bRestrictedMission) then
			{
				// RESTRICTED MISSIONS
				_missionOptionLine	ctrlSetBackgroundColor					([CAMPAIGN_LOBBY_COLOR_RED		+ ALPHA_100] call BIS_fnc_HEXTORGB);
				_missionOptionText	ctrlSetBackgroundColor					([CAMPAIGN_LOBBY_COLOR_RED		+ ALPHA_100] call BIS_fnc_HEXTORGB);
				_missionOptionText	ctrlSetTextColor						([CAMPAIGN_LOBBY_COLOR_BLACK	+ ALPHA_50] call BIS_fnc_HEXTORGB);
			} else
			{
				// Check Current Mission
				if (_missionOptionGroup == _currentMissionOptionGroup) then
				{
					// CURRENT MISSION
					if (_bEveryoneReady) then
					{
						// Everyone is ready (GREEN)
						_missionOptionLine	ctrlSetBackgroundColor			([CAMPAIGN_LOBBY_COLOR_GREEN	+ ALPHA_100] call BIS_fnc_HEXTORGB);
						_missionOptionText	ctrlSetBackgroundColor			([CAMPAIGN_LOBBY_COLOR_GREEN	+ ALPHA_100] call BIS_fnc_HEXTORGB);
						_missionOptionText	ctrlSetTextColor				([CAMPAIGN_LOBBY_COLOR_BLACK	+ ALPHA_50] call BIS_fnc_HEXTORGB);
					} else
					{
						// Not Everyone is ready (ORANGE)
						_missionOptionLine	ctrlSetBackgroundColor			([CAMPAIGN_LOBBY_COLOR_ORANGE	+ ALPHA_100] call BIS_fnc_HEXTORGB);
						_missionOptionText	ctrlSetBackgroundColor			([CAMPAIGN_LOBBY_COLOR_ORANGE	+ ALPHA_100] call BIS_fnc_HEXTORGB);
						_missionOptionText	ctrlSetTextColor				([CAMPAIGN_LOBBY_COLOR_BLACK	+ ALPHA_50] call BIS_fnc_HEXTORGB);
					};
				} else
				{
					// NON RESTRICTED MISSIONS
					_missionOptionLine	ctrlSetBackgroundColor				([CAMPAIGN_LOBBY_COLOR_WHITE	+ ALPHA_100] call BIS_fnc_HEXTORGB);
					_missionOptionText	ctrlSetBackgroundColor				([CAMPAIGN_LOBBY_COLOR_WHITE	+ ALPHA_100] call BIS_fnc_HEXTORGB);
					_missionOptionText	ctrlSetTextColor					([CAMPAIGN_LOBBY_COLOR_BLACK	+ ALPHA_50] call BIS_fnc_HEXTORGB);
				};
			};
		} else
		{
			// NO SELECTED + FOCUS

			// Check Restriction
			if (_bRestrictedMission) then
			{
				// RESTRICTED MISSIONS
				_missionOptionLine	ctrlSetBackgroundColor					([CAMPAIGN_LOBBY_COLOR_RED		+ ALPHA_100] call BIS_fnc_HEXTORGB);
				_missionOptionText	ctrlSetBackgroundColor					([CAMPAIGN_LOBBY_COLOR_RED		+ ALPHA_100] call BIS_fnc_HEXTORGB);
				_missionOptionText	ctrlSetTextColor						([CAMPAIGN_LOBBY_COLOR_WHITE	+ ALPHA_100] call BIS_fnc_HEXTORGB);
			} else
			{
				// Check Current Mission
				if (_missionOptionGroup == _currentMissionOptionGroup) then
				{
					// CURRENT MISSION
					if (_bEveryoneReady) then
					{
						// Everyone ready
						_missionOptionLine	ctrlSetBackgroundColor			([CAMPAIGN_LOBBY_COLOR_GREEN	+ ALPHA_100] call BIS_fnc_HEXTORGB);
						_missionOptionText	ctrlSetBackgroundColor			([CAMPAIGN_LOBBY_COLOR_GREEN	+ ALPHA_100] call BIS_fnc_HEXTORGB);
						_missionOptionText	ctrlSetTextColor				([CAMPAIGN_LOBBY_COLOR_BLACK	+ ALPHA_100] call BIS_fnc_HEXTORGB);
					} else
					{
						// Everyone not ready
						_missionOptionLine	ctrlSetBackgroundColor			([CAMPAIGN_LOBBY_COLOR_ORANGE	+ ALPHA_100] call BIS_fnc_HEXTORGB);
						_missionOptionText	ctrlSetBackgroundColor			([CAMPAIGN_LOBBY_COLOR_ORANGE	+ ALPHA_100] call BIS_fnc_HEXTORGB);
						_missionOptionText	ctrlSetTextColor				([CAMPAIGN_LOBBY_COLOR_BLACK	+ ALPHA_100] call BIS_fnc_HEXTORGB);
					};
				} else
				{
					// NON RESTRICTED MISSIONS
					_missionOptionLine	ctrlSetBackgroundColor				([CAMPAIGN_LOBBY_COLOR_RED		+ ALPHA_100] call BIS_fnc_HEXTORGB);
					_missionOptionText	ctrlSetBackgroundColor				([CAMPAIGN_LOBBY_COLOR_BLACK	+ ALPHA_100] call BIS_fnc_HEXTORGB);
					_missionOptionText	ctrlSetTextColor					([CAMPAIGN_LOBBY_COLOR_WHITE	+ ALPHA_100] call BIS_fnc_HEXTORGB);
				};
			};
		};
	};

	// Exit
	case 2:
	{
		// Update selected button
		uiNamespace setVariable ["A3X_UI_LOBBY_MISSION_OPTION_HOVER", nil];

		// SELECTED + NO FOCUS + CURRENT MISSION
		if (_missionOptionText == _selectedMissionOptionText) then
		{
			// RESTRICTED MISSIONS
			if (_bRestrictedMission) then
			{
				_missionOptionLine		ctrlSetBackgroundColor				([CAMPAIGN_LOBBY_COLOR_RED		+ ALPHA_100] call BIS_fnc_HEXTORGB);
				_missionOptionText		ctrlSetBackgroundColor				([CAMPAIGN_LOBBY_COLOR_RED		+ ALPHA_100] call BIS_fnc_HEXTORGB);
				_missionOptionText		ctrlSetTextColor					([CAMPAIGN_LOBBY_COLOR_BLACK	+ ALPHA_100] call BIS_fnc_HEXTORGB);
			} else
			{
				// CURRENT MISSION
				if (_missionOptionGroup == _currentMissionOptionGroup) then
				{
					if (_bEveryoneReady) then
					{
						// Everyone ready
						_missionOptionLine	ctrlSetBackgroundColor			([CAMPAIGN_LOBBY_COLOR_GREEN	+ ALPHA_100] call BIS_fnc_HEXTORGB);
						_missionOptionText	ctrlSetBackgroundColor			([CAMPAIGN_LOBBY_COLOR_GREEN	+ ALPHA_100] call BIS_fnc_HEXTORGB);
						_missionOptionText	ctrlSetTextColor				([CAMPAIGN_LOBBY_COLOR_BLACK	+ ALPHA_100] call BIS_fnc_HEXTORGB);
					} else
					{
						// Everyone Not Ready
						_missionOptionLine	ctrlSetBackgroundColor			([CAMPAIGN_LOBBY_COLOR_ORANGE	+ ALPHA_100] call BIS_fnc_HEXTORGB);
						_missionOptionText	ctrlSetBackgroundColor			([CAMPAIGN_LOBBY_COLOR_ORANGE	+ ALPHA_100] call BIS_fnc_HEXTORGB);
						_missionOptionText	ctrlSetTextColor				([CAMPAIGN_LOBBY_COLOR_BLACK	+ ALPHA_100] call BIS_fnc_HEXTORGB);
					};
				} else
				{
					// NON RESTRICTED MISSIONS
					_missionOptionLine	ctrlSetBackgroundColor				([CAMPAIGN_LOBBY_COLOR_WHITE	+ ALPHA_100] call BIS_fnc_HEXTORGB);
					_missionOptionText	ctrlSetBackgroundColor				([CAMPAIGN_LOBBY_COLOR_WHITE	+ ALPHA_100] call BIS_fnc_HEXTORGB);
					_missionOptionText	ctrlSetTextColor					([CAMPAIGN_LOBBY_COLOR_BLACK	+ ALPHA_100] call BIS_fnc_HEXTORGB);
				};
			};

		} else
		{
			// SELECTED + NO FOCUS

			// Check Restriction
			if (_bRestrictedMission) then
			{
				// RESTRICTED MISSIONS
				_missionOptionLine		ctrlSetBackgroundColor				([CAMPAIGN_LOBBY_COLOR_RED		+ ALPHA_25] call BIS_fnc_HEXTORGB);
				_missionOptionText		ctrlSetBackgroundColor				([CAMPAIGN_LOBBY_COLOR_RED		+ ALPHA_25] call BIS_fnc_HEXTORGB);
				_missionOptionText		ctrlSetTextColor					([CAMPAIGN_LOBBY_COLOR_WHITE	+ ALPHA_25] call BIS_fnc_HEXTORGB);
			} else
			{
				// Check Current Mission
				if (_missionOptionGroup == _currentMissionOptionGroup) then
				{
					// CURRENT MISSION
					if (_bEveryoneReady) then
					{
						_missionOptionLine	ctrlSetBackgroundColor			([CAMPAIGN_LOBBY_COLOR_GREEN	+ ALPHA_75] call BIS_fnc_HEXTORGB);
						_missionOptionText	ctrlSetBackgroundColor			([CAMPAIGN_LOBBY_COLOR_GREEN	+ ALPHA_75] call BIS_fnc_HEXTORGB);
						_missionOptionText	ctrlSetTextColor				([CAMPAIGN_LOBBY_COLOR_WHITE	+ ALPHA_75] call BIS_fnc_HEXTORGB);
					} else
					{
						// Everyone Not Ready
						_missionOptionLine	ctrlSetBackgroundColor			([CAMPAIGN_LOBBY_COLOR_ORANGE	+ ALPHA_75] call BIS_fnc_HEXTORGB);
						_missionOptionText	ctrlSetBackgroundColor			([CAMPAIGN_LOBBY_COLOR_ORANGE	+ ALPHA_75] call BIS_fnc_HEXTORGB);
						_missionOptionText	ctrlSetTextColor				([CAMPAIGN_LOBBY_COLOR_WHITE	+ ALPHA_75] call BIS_fnc_HEXTORGB);
					};
				} else
				{
					// NON RESTRICTED MISSIONS
					_missionOptionLine	ctrlSetBackgroundColor				([CAMPAIGN_LOBBY_COLOR_RED		+ ALPHA_25] call BIS_fnc_HEXTORGB);
					_missionOptionText	ctrlSetBackgroundColor				([CAMPAIGN_LOBBY_COLOR_BLACK	+ ALPHA_25] call BIS_fnc_HEXTORGB);
					_missionOptionText	ctrlSetTextColor					([CAMPAIGN_LOBBY_COLOR_WHITE	+ ALPHA_25] call BIS_fnc_HEXTORGB);
				};
			};
		};
	};

	// Reset / Update all controls
	case 3:
	{
		// Disable progress button by default
		if (_bIsHost) then
		{
			[false] call _fn_showApproveButton;
		};

		// Update colours
		for "_i" from 0 to (count _missionOptionCtrls - 1) do
		{
			// Init each control
			private _optionGroup						= _missionOptionCtrls select _i select 0;
			private _optionLine							= _missionOptionCtrls select _i select 1;
			private _optionText							= _missionOptionCtrls select _i select 2;
			private _optionIcon							= _missionOptionCtrls select _i select 3;
			private _optionButton						= _missionOptionCtrls select _i select 4;

			// Init select and hover state
			private _bSelected	= false;
			private _bHover		= false;

			// Selected mission check
			if (_selectedMissionOptionGroup == _optionGroup) then
			{
				_bSelected = true;
			};

			// Hover mission check
			if (_hoverMissionOptionGroup == _optionGroup) then
			{
				_bHover = true;
			};

			// Init base colours (obvious if something goes wrong, as they are overwritten)
			private _primaryColor						= CAMPAIGN_LOBBY_COLOR_ORANGE;
			private _blackColor							= CAMPAIGN_LOBBY_COLOR_BLACK;
			private _whiteColor							= CAMPAIGN_LOBBY_COLOR_WHITE;

			private _lineBackgroundColor				= ([_primaryColor	+ ALPHA_100] call BIS_fnc_HEXTORGB);
			private _textBackgroundColor				= ([_primaryColor	+ ALPHA_100] call BIS_fnc_HEXTORGB);
			private _textColor							= ([_blackColor		+ ALPHA_100] call BIS_fnc_HEXTORGB);

			// RESTRICTED MISSIONS
			if ((ctrlIDC _optionButton) > (ctrlIDC _currentMissionOptionButton)) then
			{
				// Set primary color to red
				_primaryColor							= CAMPAIGN_LOBBY_COLOR_RED;

				// Selected
				if (_bSelected) then
				{
					_lineBackgroundColor				= ([_primaryColor	+ ALPHA_100] call BIS_fnc_HEXTORGB);
					_textBackgroundColor				= ([_primaryColor	+ ALPHA_100] call BIS_fnc_HEXTORGB);

					// Hovering
					if (_bHover) then
					{
						_textColor						= ([_blackColor		+ ALPHA_50] call BIS_fnc_HEXTORGB);
					} else
					{
						_textColor						= ([_blackColor		+ ALPHA_100] call BIS_fnc_HEXTORGB);
					};
				} else	// Not selected
				{
					// Hovering
					if (_bHover) then
					{
						_lineBackgroundColor			= ([_primaryColor	+ ALPHA_100] call BIS_fnc_HEXTORGB);
						_textBackgroundColor			= ([_primaryColor	+ ALPHA_100] call BIS_fnc_HEXTORGB);
						_textColor						= ([_whiteColor		+ ALPHA_100] call BIS_fnc_HEXTORGB);
					} else
					{
						// Not hovering
						_lineBackgroundColor			= ([_primaryColor	+ ALPHA_25] call BIS_fnc_HEXTORGB);
						_textBackgroundColor			= ([_primaryColor	+ ALPHA_25] call BIS_fnc_HEXTORGB);
						_textColor						= ([_whiteColor		+ ALPHA_25] call BIS_fnc_HEXTORGB);
					};
				};
			} else
			{
				// Current Mission
				if (_optionGroup == _currentMissionOptionGroup) then
				{
					// Everyone ready
					if (_bEveryoneReady) then
					{
						// Set primary color to green
						_primaryColor					= CAMPAIGN_LOBBY_COLOR_GREEN;
					} else
					{
						// Set primary color to orange
						_primaryColor					= CAMPAIGN_LOBBY_COLOR_ORANGE;
					};

					// Selected
					if (_bSelected) then
					{
						// Enable progress button
						if (_bIsHost) then
						{
							[true] call _fn_showApproveButton;
						};

						// Hovering
						if (_bHover) then
						{
							_lineBackgroundColor		= ([_primaryColor	+ ALPHA_100] call BIS_fnc_HEXTORGB);
							_textBackgroundColor		= ([_primaryColor	+ ALPHA_100] call BIS_fnc_HEXTORGB);
							_textColor					= ([_blackColor		+ ALPHA_50] call BIS_fnc_HEXTORGB);
						} else
						{
							// Not hovering
							_lineBackgroundColor		= ([_primaryColor	+ ALPHA_100] call BIS_fnc_HEXTORGB);
							_textBackgroundColor		= ([_primaryColor	+ ALPHA_100] call BIS_fnc_HEXTORGB);
							_textColor					= ([_blackColor		+ ALPHA_100] call BIS_fnc_HEXTORGB);
						};
					} else	// Not selected
					{
						// Hovering
						if (_bHover) then
						{
							_lineBackgroundColor		= ([_primaryColor	+ ALPHA_100] call BIS_fnc_HEXTORGB);
							_textBackgroundColor		= ([_primaryColor	+ ALPHA_100] call BIS_fnc_HEXTORGB);
							_textColor					= ([_blackColor		+ ALPHA_100] call BIS_fnc_HEXTORGB);
						} else
						{
							_lineBackgroundColor		= ([_primaryColor	+ ALPHA_75] call BIS_fnc_HEXTORGB);
							_textBackgroundColor		= ([_primaryColor	+ ALPHA_75] call BIS_fnc_HEXTORGB);
							_textColor					= ([_whiteColor		+ ALPHA_100] call BIS_fnc_HEXTORGB);
						};
					};
				} else	// Completed missions
				{
					// Selected
					if (_bSelected) then
					{
						// Selected item is white
						_primaryColor					= CAMPAIGN_LOBBY_COLOR_WHITE;

						// Hovering
						if (_bHover) then
						{
							_lineBackgroundColor		= ([_primaryColor	+ ALPHA_100] call BIS_fnc_HEXTORGB);
							_textBackgroundColor		= ([_primaryColor	+ ALPHA_100] call BIS_fnc_HEXTORGB);
							_textColor					= ([_blackColor		+ ALPHA_50] call BIS_fnc_HEXTORGB);
						} else
						{
							// Not hovering
							_lineBackgroundColor		= ([_primaryColor	+ ALPHA_100] call BIS_fnc_HEXTORGB);
							_textBackgroundColor		= ([_primaryColor	+ ALPHA_100] call BIS_fnc_HEXTORGB);
							_textColor					= ([_blackColor		+ ALPHA_100] call BIS_fnc_HEXTORGB);
						};
					} else	// Not selected
					{
						// Not Selected item is black
						private _primaryColor			= CAMPAIGN_LOBBY_COLOR_BLACK;
						private _secondaryColor			= CAMPAIGN_LOBBY_COLOR_RED;

						// Hovering
						if (_bHover) then
						{
							_lineBackgroundColor		= ([_secondaryColor	+ ALPHA_100] call BIS_fnc_HEXTORGB);
							_textBackgroundColor		= ([_primaryColor	+ ALPHA_100] call BIS_fnc_HEXTORGB);
							_textColor					= ([_whiteColor		+ ALPHA_100] call BIS_fnc_HEXTORGB);
						} else
						{
							_lineBackgroundColor		= ([_secondaryColor	+ ALPHA_25] call BIS_fnc_HEXTORGB);
							_textBackgroundColor		= ([_primaryColor	+ ALPHA_25] call BIS_fnc_HEXTORGB);
							_textColor					= ([_whiteColor		+ ALPHA_25] call BIS_fnc_HEXTORGB);
						};
					};
				};
			};

			// Set all the colours
			_optionLine	ctrlSetBackgroundColor	_lineBackgroundColor;
			_optionText	ctrlSetBackgroundColor	_textBackgroundColor;
			_optionText	ctrlSetTextColor		_textColor;

			// Commit options
			_optionGroup	ctrlCommit 0;
			_optionLine		ctrlCommit 0;
			_optionText		ctrlCommit 0;
			_optionIcon		ctrlCommit 0;
			_optionButton	ctrlCommit 0;
		};
	};
};

// Commit all controls
_missionOptionGroup			ctrlCommit 0;
_missionOptionLine			ctrlCommit 0;
_missionOptionText			ctrlCommit 0;
_missionOptionIcon			ctrlCommit 0;
_missionOptionButton		ctrlCommit 0;