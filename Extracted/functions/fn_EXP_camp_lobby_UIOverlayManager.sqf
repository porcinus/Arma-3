/*

	PROJECT: R&D
	AUTHOR:  Endstar
	DATE:    18-04-2016

	fn_EXP_camp_lobby_updateIntel.sqf

		Campaign Lobby: Updates the mission overview and intel from tree interactions

	Params

		0:

	Return

		0:
*/

// Has to be spawned
_nul = _this spawn
{
	// Lobby UI defines
	disableSerialization;
	#include "\A3\Missions_F_Exp\Lobby\headers\ui_campaignLobbyDefines.inc"

	// Init params
	private _ctrl			= _this select 0;
	private _case			= _this select 1;

	// Main Display
	private _display		= findDisplay IDD_CAMPAIGN_LOBBY;

	// Ctrl Video variables
	private _video			= uiNamespace getVariable "A3X_UI_LOBBY_MISSION_VIDEO";

	if (isNil { _video }) exitWith {};

	private _ctrlVideo		= _video select 0;
	private _ctrlOverlay	= _video select 1;
	private _missionIndex	= _video select 2;
	private _inProgress		= _video select 3;

	// Current mission
	private _currentMission	= uiNamespace getVariable "A3X_UI_LOBBY_MISSION";

	// If there is no current mission - exit
	if (isNil { _currentMission }) exitWith {};

	private _currentMissionIndex			= _currentMission select 0;
	private _currentMissionOptionGroup		= _currentMission select 1;
	private _currentMissionOptionLine		= _currentMission select 2;
	private _currentMissionOptionText		= _currentMission select 3;
	private _currentMissionOptionIcon		= _currentMission select 4;
	private _currentMissionOptionButton		= _currentMission select 5;

	// Is this mission campaign lobby compatible?
	private _cfgCampaign					= missionConfigFile >> "CampaignLobby";

	// Exit if no campaign
	if (isNull _cfgCampaign) exitWith {};

	// Mission index
	private _cfgMission						= (_cfgCampaign >> "Missions") select _missionIndex;

	// Grab all relevant mission config details
	private _missionClass					= configName (_cfgMission);
	private _cfgMissionName					= getText (_cfgMission >> "name");
	private _cfgMissionRestrictedName		= getText (_cfgMission >> "restrictedName");

	private _cfgMissionBriefingImage		= getText (_cfgMission >> "briefingImage");
	private _cfgMissionOverlayImage			= getText (_cfgMission >> "overlayImage");
	private _cfgMissionDebriefingImage		= getText (_cfgMission >> "debriefingImage");
	private _cfgMissionRestrictedImage		= getText (_cfgMission >> "restrictedImage");

	private _cfgMissionBriefingText			= getText (_cfgMission >> "briefingText");
	private _cfgMissionDebriefingText		= getText (_cfgMission >> "debriefingText");
	private _cfgMissionRestrictedText		= getText (_cfgMission >> "restrictedText");

	// Check in progress
	private _exit							= false;

	// Re-trigger this manager once the previous instance has finished - or quit if new mission is selected
	if (_inProgress) exitWith
	{
		// Grab temp mission index
		private _tempMissionIndex	= _missionIndex;

		// Loop to check for change of mission + retrigger
		waitUntil
		{
			private _video			= uiNamespace getVariable "A3X_UI_LOBBY_MISSION_VIDEO";

			if (isNil { _video} ) exitWith { true };

			private _ctrlVideo		= _video select 0;
			private _ctrlOverlay	= _video select 1;
			private _missionIndex	= _video select 2;
			private _inProgress		= _video select 3;

			if (!_inProgress) exitWith
			{
				if (_case != 0) then
				{
					[_ctrl, _case] call BIS_fnc_EXP_camp_lobby_UIOverlayManager;
				};

				true
			};

			if (_tempMissionIndex != _missionIndex) exitWith
			{
				true
			};
		};
	};

	// Exit if the mission changed
	if (_exit) exitWith {};

	// Now fetch all the control groups
	private _ctrlMissionIntelGroup 			= _display displayCtrl IDC_CAMPAIGN_LOBBY_MISSION_INTEL_GROUP;
	private _ctrlMissionOverlayGroup 		= _display displayCtrl IDC_CAMPAIGN_LOBBY_MISSION_OVERLAY_GROUP;
	private _ctrlMissionPlayerCoreGroup 	= _display displayCtrl IDC_CAMPAIGN_LOBBY_MISSION_PLAYER_CORE_GROUP;

	// Overlay controls
	private _overlayGroup					= _display displayCtrl IDC_CAMPAIGN_LOBBY_MISSION_OVERLAY_GROUP;
	private _overlayTop						= _display displayCtrl (IDC_CAMPAIGN_LOBBY_MISSION_OVERLAY_GROUP + 1);
	private _overlayBottom					= _display displayCtrl (IDC_CAMPAIGN_LOBBY_MISSION_OVERLAY_GROUP + 2);
	private _overlayLeft					= _display displayCtrl (IDC_CAMPAIGN_LOBBY_MISSION_OVERLAY_GROUP + 3);
	private _overlayRight					= _display displayCtrl (IDC_CAMPAIGN_LOBBY_MISSION_OVERLAY_GROUP + 4);
	private _overlayComplete				= _display displayCtrl (IDC_CAMPAIGN_LOBBY_MISSION_OVERLAY_GROUP + 5);
	private _overlayTrigger					= _display displayCtrl (IDC_CAMPAIGN_LOBBY_MISSION_OVERLAY_GROUP + 6);

	// Hide groups
	private _fn_fadeMissionControls			=
	{
		// Fade the mission items
		if ((ctrlFade _ctrlMissionIntelGroup) == 0) then
		{
			_ctrlMissionIntelGroup				ctrlSetFade		1;
			_ctrlMissionOverlayGroup			ctrlSetFade		1;
			_ctrlMissionPlayerCoreGroup			ctrlSetFade		1;

			_ctrlMissionIntelGroup				ctrlCommit		(1-(ctrlFade _ctrlMissionIntelGroup)) * 0.5;
			_ctrlMissionOverlayGroup			ctrlCommit		(1-(ctrlFade _ctrlMissionOverlayGroup)) * 0.5;
			_ctrlMissionPlayerCoreGroup 		ctrlCommit		(1-(ctrlFade _ctrlMissionPlayerCoreGroup)) * 0.5;

		} else
		{
			_ctrlMissionIntelGroup				ctrlSetFade		0;
			_ctrlMissionOverlayGroup			ctrlSetFade		0;
			_ctrlMissionPlayerCoreGroup			ctrlSetFade		0;

			_ctrlMissionIntelGroup				ctrlCommit		(ctrlFade _ctrlMissionIntelGroup) * 0.5;
			_ctrlMissionOverlayGroup			ctrlCommit		(ctrlFade _ctrlMissionOverlayGroup) * 0.5;
			_ctrlMissionPlayerCoreGroup 		ctrlCommit		(ctrlFade _ctrlMissionPlayerCoreGroup) * 0.5;
		};
	};

	// Completed Missions
	if (_missionIndex < _currentMissionIndex) then
	{
		// Interaction State
		switch (_case) do
		{
			// Click
			case 0:
			{
				if (ctrlFade _ctrlOverlay == 1) then
				{
					_ctrlOverlay 				ctrlSetText		_cfgMissionOverlayImage;
					_ctrlOverlay 				ctrlSetFade		0;
					_ctrlOverlay 				ctrlCommit		(ctrlFade _ctrlOverlay) * 0.25;
				} else
				{
					_ctrlVideo					ctrlSetText		_cfgMissionBriefingImage;
					_ctrlOverlay 				ctrlSetText		_cfgMissionOverlayImage;
					_ctrlOverlay 				ctrlSetFade		1;
					_ctrlOverlay 				ctrlCommit		(1 - (ctrlFade _ctrlOverlay)) * 0.25;
				};

				call _fn_fadeMissionControls;
			};

			// Enter
			case 1:
			{
				_ctrlOverlay					ctrlSetText		_cfgMissionOverlayImage;
				_ctrlOverlay					ctrlSetFade		0;
				_ctrlOverlay					ctrlCommit		(ctrlFade _ctrlOverlay) * 0.25;
			};

			// Exit
			case 2:
			{
				// If the intel group is faded out at all (it means we were using the briefing image)
				if (ctrlFade _ctrlMissionIntelGroup > 0) then
				{
					// Set overlay as the briefing image with the correct fade
					_ctrlOverlay				ctrlSetText		_cfgMissionBriefingImage;
					_ctrlOverlay				ctrlSetFade		(1 - (ctrlFade _ctrlOverlay));
					_ctrlOverlay				ctrlCommit		0;
				} else
				{
					// Normal crossfade
					_ctrlOverlay				ctrlSetText		_cfgMissionOverlayImage;
				};

				_ctrlVideo						ctrlSetText		_cfgMissionDebriefingImage;
				_ctrlOverlay					ctrlSetFade		1;
				_ctrlOverlay					ctrlCommit		(1 - (ctrlFade _ctrlOverlay)) * 0.25;

				_ctrlMissionIntelGroup			ctrlSetFade 	0;
				_ctrlMissionOverlayGroup		ctrlSetFade 	0;
				_ctrlMissionPlayerCoreGroup		ctrlSetFade 	0;

				_ctrlMissionIntelGroup			ctrlCommit		(ctrlFade _ctrlMissionIntelGroup) * 0.5;
				_ctrlMissionOverlayGroup		ctrlCommit		(ctrlFade _ctrlMissionOverlayGroup) * 0.5;
				_ctrlMissionPlayerCoreGroup 	ctrlCommit		(ctrlFade _ctrlMissionPlayerCoreGroup) * 0.5;
			};
		};
	};

	// Current Mission
	if (_missionIndex == _currentMissionIndex) then
	{
		// Interaction
		switch (_case) do
		{
			// Click
			case 0:
			{
				if (ctrlFade _ctrlOverlay == 1) then
				{
					_ctrlOverlay				ctrlSetText		_cfgMissionOverlayImage;
					_ctrlOverlay				ctrlSetFade		0;
					_ctrlOverlay				ctrlCommit		(ctrlFade _ctrlOverlay) * 0.25;
				} else
				{
					_ctrlOverlay				ctrlSetText		_cfgMissionOverlayImage;
					_ctrlOverlay				ctrlSetFade		1;
					_ctrlOverlay				ctrlCommit		(1 - (ctrlFade _ctrlOverlay)) * 0.25;
				};

				call _fn_fadeMissionControls;
			};

			// Enter
			case 1:
			{
				_ctrlOverlay					ctrlSetText		_cfgMissionOverlayImage;
				_ctrlOverlay					ctrlSetFade		0;
				_ctrlOverlay					ctrlCommit		(ctrlFade _ctrlOverlay) * 0.25;
			};

			// Exit
			case 2:
			{
				_ctrlOverlay					ctrlSetText		_cfgMissionOverlayImage;
				_ctrlOverlay					ctrlSetFade		1;
				_ctrlOverlay					ctrlCommit		(1 - (ctrlFade _ctrlOverlay)) * 0.25;

				_ctrlMissionIntelGroup			ctrlSetFade		0;
				_ctrlMissionOverlayGroup		ctrlSetFade		0;
				_ctrlMissionPlayerCoreGroup		ctrlSetFade		0;

				_ctrlMissionIntelGroup			ctrlCommit		(ctrlFade _ctrlMissionIntelGroup) * 0.5;
				_ctrlMissionOverlayGroup		ctrlCommit		(ctrlFade _ctrlMissionOverlayGroup) * 0.5;
				_ctrlMissionPlayerCoreGroup 	ctrlCommit		(ctrlFade _ctrlMissionPlayerCoreGroup) * 0.5;
			};
		};
	};

	// Restricted Mission
	if (_missionIndex > _currentMissionIndex) then
	{
		// Interaction
		switch (_case) do
		{
			// Click
			case 0:
			{

			};

			// Enter
			case 1:
			{

			};

			// Exit
			case 2:
			{

			};
		};
	};
};