#include "defines.inc"
/*
	Author: Jiri Wainar

	Description:
	Returns structured text that can be displayed in 'Hold Action' tech as animated unconscious state icon.

	Parameters:
	OBJECT - unconscious unit

	Returns:
	Structured text with animated unconscious state 'Hold Action' icon.

	Example:
	_structuredText = _unit call  bis_fnc_reviveGetActionIcon;
*/

private _selected = if (bis_revive_timer == 0 || {isNil{_this getVariable "bis_fnc_reviveGetActionIcon_textures"}}) then
{
	if (IS_BEING_REVIVED(_this)) then
	{
		TEXTURES_2D_BEING_REVIVED
	}
	else
	{
		if (IS_FORCING_RESPAWN(_this)) then
		{
			TEXTURES_2D_DYING
		}
		else
		{
			switch (_this getVariable [VAR_BLOOD_LEVEL,3]) do
			{
				case 0:
				{
					//["[ ] Dying 0-20"] call bis_fnc_logFormat;

					TEXTURES_2D_DYING
				};
				case 1:
				{
					//["[ ] Incapacitated 20-40: %1",bis_revive_timerCounter2] call bis_fnc_logFormat;

					[TEXTURES_2D_DYING,TEXTURES_2D_UNCONSCIOUS] select bis_revive_timerCounter2
				};
				case 2:
				{
					//["[ ] Incapacitated 40-60: %1",bis_revive_timerCounter3] call bis_fnc_logFormat;

					[TEXTURES_2D_DYING,TEXTURES_2D_UNCONSCIOUS,TEXTURES_2D_UNCONSCIOUS] select bis_revive_timerCounter3
				};
				default
				{
					//["[ ] Incapacitated 60+"] call bis_fnc_logFormat;

					TEXTURES_2D_UNCONSCIOUS
				};
			};
		};
	};
}
else
{
	_this getVariable "bis_fnc_reviveGetActionIcon_textures";
};

_this setVariable ["bis_fnc_reviveGetActionIcon_textures",_selected];
_selected select bis_revive_timer