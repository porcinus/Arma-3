
/************************************************************
	Set Pitch and Bank
	Author: Andrew Barron

Parameters: [object, pitch, bank]
Returns: nothing

Rotates an object, giving it the specified pitch and bank,
in degrees.

Pitch is 0 when the object is level; 90 when pointing straight
up; and -90 when pointing straight down.

Bank is 0 when level; 90 when the object is rolled to the right,
-90 when rolled to the left, and 180 when rolled upside down.

Note that the object's yaw can be set with the setdir command,
which should be issued before using this function, if required.

The pitch/bank can be leveled out (set to 0) by using the
setdir command.

Example: [vehicle player, 45, -45] call BIS_fnc_setPitchBank
************************************************************/

params ["_obj", "_pitch", "_bank"];

private _vel = velocityModelSpace _obj; // store object current velocity
[_obj, [direction _obj, _pitch, _bank]] call BIS_fnc_setObjectRotation;
_obj setVelocityModelSpace _vel; // restore current object velocity