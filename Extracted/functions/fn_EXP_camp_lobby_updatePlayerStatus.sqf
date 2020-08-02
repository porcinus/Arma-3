/*

	PROJECT: R&D
	AUTHOR:  Endstar
	DATE:    18-04-2016

	fn_EXP_camp_lobby_updatePlayerStatus.sqf

		Campaign Lobby: Updates player status

	Params

		0:

	Return

		0:
*/

// Init main params
private _currentPlayer 	= _this select 0;
private _status			= _this select 1;

if (isNil { _currentPlayer }) exitWith {};

private _connectedPlayers		= missionNamespace getVariable "A3X_UI_LOBBY_PLAYERS";

if (isNil { _connectedPlayers }) exitWith {};

for "_i" from 0 to (count _connectedPlayers - 1) do
{
	private _checkPlayer	= _connectedPlayers select _i select 0;
	private _checkStatus	= _connectedPlayers select _i select 1;
	private _checkHost		= _connectedPlayers select _i select 2;

	if (_currentPlayer == _checkPlayer) then
	{
		_connectedPlayers set [_i, [_checkPlayer, _status, _checkHost]];
		missionNamespace setVariable ["A3X_UI_LOBBY_PLAYERS", _connectedPlayers, true];
		remoteExec ["BIS_fnc_EXP_camp_lobby_updatePlayers"];
	};
};