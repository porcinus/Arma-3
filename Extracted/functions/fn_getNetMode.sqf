/*
	Author: Nelson Duarte

	Description:
		Returns one of the following net modes:
		- DedicatedServer
		- Server
		- HeadlessClient
		- Client
		- SinglePlayer

	Parameters:
		NONE

	Returns:
		STRING: The net mode of current machine
*/
switch (true) do
{
	case (isMultiplayer && {isDedicated}) : 	{ "DedicatedServer" };
	case (isMultiplayer && {isServer}) : 		{ "Server" };
	case (isMultiplayer && {!hasInterface}) : 	{ "HeadlessClient" };
	case (isMultiplayer) : 				{ "Client" };
	default 					{ "SinglePlayer" };
};