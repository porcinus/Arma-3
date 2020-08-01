/*
	Author: 
		Killzone_Kid

	Description:
		Returns the admin state of a client the function is called on. 
		Compliments "admin" script command and used for self check on a local client.

	Parameter(s):
		NONE

	Returns:
		NUMBER 
			0 - this client is not an admin
			1 - this client is voted in admin
			2 - this client is logged in admin
*/

if (serverCommandAvailable "#logout") exitWith {[1, 2] select serverCommandAvailable "#exec"}; 0 