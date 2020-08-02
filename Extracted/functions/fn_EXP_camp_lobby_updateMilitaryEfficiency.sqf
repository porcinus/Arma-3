/*

	PROJECT: R&D
	AUTHOR:  Endstar
	DATE:    15-08-2016

	fn_EXP_camp_lobby_updateMilitaryEfficiency.sqf

		Campaign Lobby: Updates military efficiency radial bar

	Params

		0:

	Return

		0:
*/

// Lobby UI defines
disableSerialization;
#include "\A3\Missions_F_Exp\Lobby\headers\ui_campaignLobbyDefines.inc"

// Campaign Lobby display
private _display				= findDisplay IDD_CAMPAIGN_LOBBY;

// Init Briefing Display
private _briefingDisplay		= displayNull;

// Grab briefing display
if !(isNull (findDisplay 52)) then
{
	_briefingDisplay			= findDisplay 52;
} else
{
	if !(isNull (findDisplay 53)) then
	{
		_briefingDisplay		= findDisplay 53;
	};
};

// Military Efficiency Controls
private _militaryGroup				= _display displayCtrl (IDC_CAMPAIGN_LOBBY_TABLET_MILITARY_GROUP);
private _militaryTitle				= _display displayCtrl (IDC_CAMPAIGN_LOBBY_TABLET_MILITARY_GROUP + 1);
private _militaryMode				= _display displayCtrl (IDC_CAMPAIGN_LOBBY_TABLET_MILITARY_GROUP + 2);
private _militaryEfficiency			= _display displayCtrl (IDC_CAMPAIGN_LOBBY_TABLET_MILITARY_GROUP + 3);
private _militaryRadialBaseLeft		= _display displayCtrl (IDC_CAMPAIGN_LOBBY_TABLET_MILITARY_GROUP + 4);
private _militaryRadialBaseRight	= _display displayCtrl (IDC_CAMPAIGN_LOBBY_TABLET_MILITARY_GROUP + 5);
private _militaryRadialLeft			= _display displayCtrl (IDC_CAMPAIGN_LOBBY_TABLET_MILITARY_GROUP + 6);
private _militaryRadialBGLeft		= _display displayCtrl (IDC_CAMPAIGN_LOBBY_TABLET_MILITARY_GROUP + 7);
private _militaryRadialRight		= _display displayCtrl (IDC_CAMPAIGN_LOBBY_TABLET_MILITARY_GROUP + 8);

// Grab current load
private _currentLoad = _this param [0, 0, [0]];

// Init current angle
private _currentAngle = 0;

if (_currentLoad > 0) then
{
	_currentAngle = (360 * _currentLoad) min 360;
} else
{
	_currentAngle = 0;
};

// Rotate
if (_currentAngle <= 180) then
{
	// Hide right loading
	_militaryRadialRight	ctrlShow false;

	// Show left loading
	_militaryRadialLeft		ctrlShow true;

	// Load left bar
	_militaryRadialLeft		ctrlSetAngle [_currentAngle, 0.5, 0.5];
} else
{
	// Show right loading bar
	_militaryRadialRight	ctrlShow true;
	_militaryRadialLeft		ctrlShow true;

	_militaryRadialLeft		ctrlSetAngle [180, 0.5, 0.5];
	_militaryRadialRight	ctrlSetAngle [_currentAngle, 0.5, 0.5];
};

// Get percentage
private _percentage = [(_currentLoad * 100),0] call BIS_fnc_cutDecimals;

// Show percentage
_militaryEfficiency ctrlSetText ("+" + (str _percentage) + "%");

// Manage colours
private _colourStart 			= [CAMPAIGN_LOBBY_COLOR_GREEN	+ ALPHA_100] call BIS_fnc_HEXtoRGB;
private _colourEnd				= [CAMPAIGN_LOBBY_COLOR_BLUE	+ ALPHA_100] call BIS_fnc_HEXtoRGB;
private _loadOffset				= 0.25;
private _baseLoad				= 0;

// Change colours based on load
if (_currentLoad <= 0.25) then
{
	_colourStart				= [CAMPAIGN_LOBBY_COLOR_WHITE	+ ALPHA_25] call BIS_fnc_HEXtoRGB;
	_colourEnd					= [CAMPAIGN_LOBBY_COLOR_WHITE	+ ALPHA_50] call BIS_fnc_HEXtoRGB;
	_baseLoad					= 0;

} else
{
	if (_currentLoad <= 0.5) then
	{
		_colourStart			= [CAMPAIGN_LOBBY_COLOR_WHITE	+ ALPHA_50] call BIS_fnc_HEXtoRGB;
		_colourEnd				= [CAMPAIGN_LOBBY_COLOR_GREEN	+ ALPHA_100] call BIS_fnc_HEXtoRGB;
		_baseLoad				= 0.25;
	} else
	{
		if (_currentLoad <= 0.75) then
		{
			_colourStart		= [CAMPAIGN_LOBBY_COLOR_GREEN	+ ALPHA_100] call BIS_fnc_HEXtoRGB;
			_colourEnd			= [CAMPAIGN_LOBBY_COLOR_GREEN	+ ALPHA_100] call BIS_fnc_HEXtoRGB;
			_baseLoad			= 0.50;
		} else
		{
			_colourStart		= [CAMPAIGN_LOBBY_COLOR_GREEN	+ ALPHA_100] call BIS_fnc_HEXtoRGB;
			_colourEnd			= [CAMPAIGN_LOBBY_COLOR_BLUE	+ ALPHA_100] call BIS_fnc_HEXtoRGB;
			_baseLoad			= 0.75;
		};
	};
};

// Starting channels
private _startRed		= _colourStart select 0;
private _startGreen		= _colourStart select 1;
private _startBlue		= _colourStart select 2;
private _startAlpha		= _colourStart select 3;

// Final channels
private _endRed			= _colourEnd select 0;
private _endGreen		= _colourEnd select 1;
private _endBlue		= _colourEnd select 2;
private _endAlpha		= _colourEnd select 3;

// Delta channels
private _deltaRed		= abs(_endRed		- _startRed);
private _deltaGreen		= abs(_endGreen		- _startGreen);
private _deltaBlue		= abs(_endBlue		- _startBlue);
private _deltaAlpha		= abs(_endAlpha		- _startAlpha);

// Load Offset
private _updateLoad		= _currentLoad;

// As long as load offset is > 0
if (_loadOffset > 0) then
{
	// Ensure we always get a 0 to 1 ratio for every tier
	_updateLoad		= (1/_loadOffset) * (_currentLoad - _baseLoad);
};

// Update channels
private _updateRed		= _startRed		+ (_deltaRed	* _updateLoad);
private _updateGreen	= _startGreen	+ (_deltaGreen	* _updateLoad);
private _updateBlue		= _startBlue	+ (_deltaBlue	* _updateLoad);
private _updateAlpha	= _startAlpha	+ (_deltaAlpha	* _updateLoad);

// Reverse management
if (_startRed	> _endRed)		then { _updateRed	= _startRed		- (_deltaRed	* _updateLoad); };
if (_startGreen > _endGreen)	then { _updateGreen	= _startGreen	- (_deltaGreen	* _updateLoad); };
if (_startBlue	> _endBlue)		then { _updateBlue	= _startBlue	- (_deltaBlue	* _updateLoad); };
if (_startAlpha > _endAlpha)	then { _updateAlpha	= _startAlpha	- (_deltaAlpha	* _updateLoad); };

// Apply colours
_militaryRadialLeft		ctrlSetTextColor [_updateRed, _updateGreen, _updateBlue, _updateAlpha];
_militaryRadialRight	ctrlSetTextColor [_updateRed, _updateGreen, _updateBlue, _updateAlpha];

_militaryEfficiency		ctrlSetTextColor [_updateRed, _updateGreen, _updateBlue, _updateAlpha];
_militaryMode			ctrlSetTextColor [_updateRed, _updateGreen, _updateBlue, _updateAlpha];
_militaryTitle			ctrlSetTextColor [_updateRed, _updateGreen, _updateBlue, _updateAlpha];

// Commit
_militaryEfficiency		ctrlCommit 0;
_militaryRadialLeft		ctrlCommit 0;
_militaryRadialRight	ctrlCommit 0;
_militaryTitle			ctrlCommit 0;
_militaryMode			ctrlCommit 0;