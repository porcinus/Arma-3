/*

	PROJECT: R&D
	AUTHOR:  Endstar
	DATE:    18-04-2016

	fn_EXP_camp_lobby_serverPing.sqf

		Campaign Lobby: Updates player status

	Params

		0:

	Return

		0:
*/

// Init main params
if (isServer) then
{
	missionNamespace setVariable ["A3X_UI_LOBBY_SERVERPING", 1, true];
};