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

// Lobby UI defines
disableSerialization;
#include "\A3\Missions_F_Exp\Lobby\headers\ui_campaignLobbyDefines.inc"

// Init mission number
private _rawMissionNumber				= _this select 0;
private _case							= _this select 1;
private _missionNumber 					= _rawMissionNumber/10;

// Grab display controls
private _display						= findDisplay IDD_CAMPAIGN_LOBBY;

// Grab relevant overview controls
private _ctrlBackground					= _display displayCtrl (IDC_CAMPAIGN_LOBBY_MISSION_INTEL_GROUP + 1);
private _ctrlTitle						= _display displayCtrl (IDC_CAMPAIGN_LOBBY_MISSION_INTEL_GROUP + 2);
private _ctrlDescription 				= _display displayCtrl (IDC_CAMPAIGN_LOBBY_MISSION_INTEL_GROUP + 3);

// Overlay controls
private _overlayGroup					= _display displayCtrl IDC_CAMPAIGN_LOBBY_MISSION_OVERLAY_GROUP;
private _overlayTop						= _display displayCtrl (IDC_CAMPAIGN_LOBBY_MISSION_OVERLAY_GROUP + 1);
private _overlayBottom					= _display displayCtrl (IDC_CAMPAIGN_LOBBY_MISSION_OVERLAY_GROUP + 2);
private _overlayLeft					= _display displayCtrl (IDC_CAMPAIGN_LOBBY_MISSION_OVERLAY_GROUP + 3);
private _overlayRight					= _display displayCtrl (IDC_CAMPAIGN_LOBBY_MISSION_OVERLAY_GROUP + 4);
private _overlayComplete				= _display displayCtrl (IDC_CAMPAIGN_LOBBY_MISSION_OVERLAY_GROUP + 5);
private _overlayTrigger					= _display displayCtrl (IDC_CAMPAIGN_LOBBY_MISSION_OVERLAY_GROUP + 6);

// Delete the old video layer
private _ctrlVideo						= (uiNamespace getVariable "A3X_UI_LOBBY_MISSION_VIDEO") select 0;
private _ctrlOverlay					= (uiNamespace getVariable "A3X_UI_LOBBY_MISSION_VIDEO") select 1;
private _inProgress						= (uiNamespace getVariable "A3X_UI_LOBBY_MISSION_VIDEO") select 2;

if !(isNil { _ctrlVideo }) then
{
	ctrlDelete _ctrlVideo;
	ctrlDelete _ctrlOverlay;
};

// Is this mission campaign lobby compatible?
private _cfgCampaign = missionConfigFile >> "CampaignLobby";

if (isNull _cfgCampaign) exitWith {};

private _cfgMission = (_cfgCampaign >> "Missions") select _missionNumber;

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

// Current mission
private _currentMission					= uiNamespace getVariable "A3X_UI_LOBBY_MISSION";

// If there is no current mission - exit
if (isNil { _currentMission }) exitWith {};

private _currentMissionIndex			= _currentMission select 0;
private _currentMissionOptionGroup		= _currentMission select 1;
private _currentMissionOptionLine		= _currentMission select 2;
private _currentMissionOptionText		= _currentMission select 3;
private _currentMissionOptionIcon		= _currentMission select 4;
private _currentMissionOptionButton		= _currentMission select 5;

// Init mission name and text
private _missionName					= "";
private _missionText					= "";
private _missionImage					= "";
private _missionOverlayImage			= "";

// Check completed missions
if (_missionNumber < _currentMissionIndex) then
{
	_missionName						= toUpper _cfgMissionName;
	_missionImage						= _cfgMissionDebriefingImage;
	_missionOverlayImage				= _cfgMissionBriefingImage;
	_missionText						= _cfgMissionDebriefingText;

	// Make sure the overlay is hidden
	_overlayComplete ctrlSetFade	1;
	_overlayComplete ctrlCommit		0;

	// Now show it
	_overlayComplete ctrlSetFade	0;
	_overlayComplete ctrlCommit		1;
	_overlayComplete ctrlShow true;
};

// Check if this is the current mission
if (_missionNumber == _currentMissionIndex) then
{
	_missionName						= toUpper _cfgMissionName;
	_missionImage						= _cfgMissionBriefingImage;
	_missionOverlayImage				= _cfgMissionDebriefingImage;
	_missionText						= _cfgMissionBriefingText;

	// Make sure the overlay is hidden
	_overlayComplete ctrlSetFade	1;
	_overlayComplete ctrlCommit		0;
};

// Check if this is a restricted mission
if (_missionNumber > _currentMissionIndex) then
{
	_missionName						= toUpper _cfgMissionRestrictedName;
	_missionImage						= _cfgMissionRestrictedImage;
	_missionOverlayImage				= _cfgMissionRestrictedImage;
	_missionText						= _cfgMissionRestrictedText;

	_overlayComplete ctrlShow false;
};

// Now update the controls with these details
_ctrlTitle 			ctrlSetText _missionName;
_ctrlDescription 	ctrlSetStructuredText parseText (format ["<t align='left'>%1</t>", _missionText]);

_ctrlTitle 			ctrlCommit 0;
_ctrlDescription 	ctrlCommit 0;

_ctrlTitle 			ctrlShow true;
_ctrlDescription 	ctrlShow true;

// Play video
[_missionImage, _missionOverlayImage, _missionNumber] execVM "\A3\Missions_F_Exp\Lobby\functions\fn_EXP_camp_lobby_playMissionVideo.sqf";