/*

	PROJECT:	R&D
	AUTHOR:		Endstar
	DATE:		18-04-2016

	fn_EXP_camp_lobby_findHost.sqf

		Campaign Lobby: Find host

	Params

		0:

	Return

		0:
*/

// Lobby UI defines
disableSerialization;
#include "\A3\Missions_F_Exp\Lobby\headers\ui_campaignLobbyDefines.inc"

private _allPlayers = [] call BIS_fnc_listPlayers;
private _host 		= objNull;

if (count _allPlayers > 0) then
{
	_host = _allPlayers select 0;
}
else
{
	["xRscDisplayCampaignLobby"] call BIS_fnc_EXP_camp_lobby_clearVars;
};

if !(isNull _host) then
{
	missionNamespace setVariable ["A3X_UI_LOBBY_HOST", _host, true];
	remoteExec ["BIS_fnc_EXP_camp_lobby_serverUpdate", owner _host];
};