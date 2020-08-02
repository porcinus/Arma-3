/*
	Author: 
		Karel Moricky, optimised by Killzone_Kid

	Description:
		Returns main display of current mission/intro/outro.

	Parameter(s):
		NOTHING

	Returns:
		DISPLAY
*/


disableSerialization;

private _display = findDisplay getNumber (configFile >> "RscDisplayMission" >> "idd");

if (isNull _display) then 
{
	_display = findDisplay getNumber (configFile >> "RscDisplayIntro" >> "idd");
	
	if (isNull _display) then 
	{
		_display = findDisplay getNumber (configFile >> "RscDisplayOutro" >> "idd");
		
		if (isNull _display) then 
		{
			_display = findDisplay getNumber (configFile >> "RscDisplayMissionEditor" >> "idd");
		};
	};
};

_display 