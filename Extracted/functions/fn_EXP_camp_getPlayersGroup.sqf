/*
	Author: Nelson Duarte

	Description:
	Returns group that players belong to in coop campaign scenario

	Parameters:
		Nothing

	Returns:
		GROUP of the players
*/

private _list = allPlayers;

if (count _list > 0) exitWith {group (_list select 0)};

grpNull;