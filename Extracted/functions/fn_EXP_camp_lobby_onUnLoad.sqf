/*

	PROJECT: R&D
	AUTHOR:  Endstar
	DATE:    18-04-2016

	fn_EXP_camp_lobby_onUnLoad.sqf

		Campaign Lobby: On display unload function - clear variables and close as necessary

	Params

		0:

	Return

		0:
*/

// Init display and case
private _display	= _this select 0 select 0;
private _case		= _this select 0 select 1;

// Grab resource and OnLoad check
private _resource	= _this select 1;

// Init briefing display
private _briefingDisplay	= displayNull;

// Grab briefing display
if !(isNull (findDisplay 52)) then
{
	_briefingDisplay = findDisplay 52;
} else
{
	if !(isNull (findDisplay 53)) then
	{
		_briefingDisplay = findDisplay 53;
	};
};

switch (_case) do
{
	// Log out button pressed
	case 0:
	{

	};

	// Escape pressed
	case 2:
	{
		// Everyone quits on a hosted server
		if (isServer) then
		{
			[0, true] remoteExec ["BIS_fnc_EXP_camp_lobby_go"];
		}
		else
		{
			// Clients can just leave
			[0, true] call BIS_fnc_EXP_camp_lobby_go;
		};
	};
};