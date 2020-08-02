/*

	PROJECT: R&D
	AUTHOR:  Endstar
	DATE:    18-04-2016

	fn_EXP_camp_lobby_getPlayerSquadName.sqf

		Campaign Lobby: Return the player squad name

	Params

		0:

	Return

		0:
*/

// Get name
private _playerName				= name player;

// Check if there's a tag on this player
private _playerSquad			= squadParams player;

// If there is a tag, add it to the end of the name for comparison
if (count _playerSquad > 0) then
{
	private _playerTag = _playerSquad select 0 select 0;
	_playerName = format ["%1 [%2]", _playerName, _playerTag];
};

// Return updated name
_playerName