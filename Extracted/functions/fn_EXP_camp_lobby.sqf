/*

	PROJECT:	R&D
	AUTHOR:		Endstar
	DATE:		18-04-2016

	fn_EXP_camp_lobby.sqf

		Campaign Lobby: Core Function

	Params

		0:

	Return

		0:
*/

// Trigger player loop
if (isServer) then
{
	_null = [] spawn
	{
		if !(isDedicated) then
		{
			// Lobby UI defines
			disableSerialization;
			#include "\A3\Missions_F_Exp\Lobby\headers\ui_campaignLobbyDefines.inc"

			private _briefingDisplay 	= findDisplay 52;
			private _display			= findDisplay IDD_CAMPAIGN_LOBBY;

			waitUntil
			{
				_briefingDisplay 	= findDisplay 52;
				_display			= findDisplay IDD_CAMPAIGN_LOBBY;

				uiSleep 0.25;

				(
					((!isNull _briefingDisplay) && (!isNull _display)) ||
					(time > 0) ||
					!(isMultiplayer)
				)
			};

			waitUntil
			{
				_briefingDisplay 	= findDisplay 52;
				_display			= findDisplay IDD_CAMPAIGN_LOBBY;

				call BIS_fnc_EXP_camp_lobby_findHost;

				uiSleep 0.25;

				(
					(isNull _briefingDisplay) ||
					(isNull _display) ||
					(time > 0) ||
					!(isMultiplayer)
				)
			};
		} else
		{
			waitUntil
			{
				call BIS_fnc_EXP_camp_lobby_FindHost;

				uiSleep 0.25;

				(
					(time > 0) ||
					!(isMultiplayer)
				)
			};

			// Time is > 0 - run mission for all
			[1] remoteExec ["BIS_fnc_EXP_camp_lobby_go"];
		};
	};
};

if (!isDedicated && !didJip) then
{
	[] call BIS_fnc_EXP_camp_lobby_launch;
};