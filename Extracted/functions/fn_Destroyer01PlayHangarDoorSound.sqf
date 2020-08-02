/*
	Author: Bravo Zero One development
	- John_Spartan

	Description:
	- This is a sub function designed to add sounds required for ship hangar door animation.

	Execution:
	- Call from main script that handles the hangar door animation.

		Example:
		[_shipPart, _soundPos, _animationState] spawn bis_fnc_destroyer01PlayHangarDoorSound;

	Parameter(s):
		_this select 0: mode (Scalar)
		0: ship-part object
		and
		1: position in word coordinates where the sound should be played (modelToWorldWorld)
		2: animation state of hangar doors


	Returns: nothing
	Result: Ship's hangar door animation gets a sound source added.

*/

private _shipPart = param [0, objNull];
private _soundPos = param [1, [0,0,0]];
private _animationState = param [2, 0];

playSound3D ["A3\sounds_f\structures\doors\servoramp\servorampslam.wss", _shipPart, false, _soundPos,5,1,15];
sleep 1;
playSound3D ["A3\sounds_f\structures\doors\servoramp\servorampsound_2.wss", _shipPart, false, _soundPos,5,1,15];

waitUntil
		{
			(_shipPart animationPhase "Door_Hangar_1_1_open") == _animationState;
		};
		
playSound3D ["A3\sounds_f\structures\doors\servoramp\servorampslam.wss", _shipPart, false, _soundPos,5,1,15];
