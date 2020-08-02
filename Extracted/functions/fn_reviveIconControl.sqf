if (difficultyOption "groupIndicators" == 0) exitWith {};

#include "defines.inc"
/*
	Author: Jiri Wainar

	Description:
	Manage the adding, removing, and effects applied to 3D icons used for visualizing incapacitated units.

	Parameters:
		_this select 0: STRING - Mode to be executed.
		_this select 1 (Optional): OBJECT - Unit to execute effects on.

	Returns:
	True if successful, false if not.

	Icon states:
		#define ICON_STATE_REMOVE		-2
		#define ICON_STATE_ADD			-1
*/

#define DEBUG_LOG	{}

private _mode = param [0, ICON_STATE_ADD, [123]];
private _unitVar = param [1, "", [""]];
private _playerVar = GET_UNIT_VAR(player);

if (_unitVar == _playerVar) exitWith {};

/*--------------------------------------------------------------------------------------------------

	ADD ICON

--------------------------------------------------------------------------------------------------*/
if (_mode == ICON_STATE_ADD) exitWith
{
	if (_unitVar in bis_revive3d_unitsToProcess) exitWith {};

	//["[!] ADDING unit '%1' to %2",_unitVar,bis_revive3d_unitsToProcess] call bis_fnc_logFormat;

	//manage unit's icon
	bis_revive3d_unitsToProcess pushBackUnique _unitVar;
};

/*--------------------------------------------------------------------------------------------------

	REMOVE ICON

--------------------------------------------------------------------------------------------------*/
if (_mode == ICON_STATE_REMOVE) exitWith
{
	if !(_unitVar in bis_revive3d_unitsToProcess) exitWith {};

	//["[!] REMOVING unit '%1' from %2",_unitVar,bis_revive3d_unitsToProcess] call bis_fnc_logFormat;

	bis_revive3d_unitsToProcess = bis_revive3d_unitsToProcess - [_unitVar];
	bis_revive3d_unitsPreprocessed = bis_revive3d_unitsPreprocessed - [_unitVar];

	//reset 3d icon set to default 'unconscious' variant
	GET_UNIT(_unitVar) setVariable ["bis_fnc_reviveGet3dIcons_textures",nil];
};

