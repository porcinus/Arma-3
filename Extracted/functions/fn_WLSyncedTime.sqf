/*
WARLORDS-SPECIFIC FUNCTION

Author: Josef Zemánek

Description: Returns time synced between server and clients
*/

if (isMultiplayer) then {
	serverTime;
} else {
	time;
};