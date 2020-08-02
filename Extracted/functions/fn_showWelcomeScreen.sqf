/*
	Author: Karel Moricky

	Description:
		Show welcome screen. TO be used in the main menu.

	Parameter(s):
		0: DISPLAY - parent display
		1 (Optional): BOOL - force showing the latest welcome screen

	Returns:
		BOOL - true when a screen was opened
*/


disableserialization;
private _display = param [0,displaynull,[displaynull]];
private _forceShow = param [1,false,[false]];
private _result = false;

if(!(uinamespace getvariable ["bis_fnc_showWelcomeScreen_shown",false]) && (_forceShow || !isAutotest)) then
{
	//Linux & Mac port switch (if a port platform is not specifically detected, default to primary Windows)
	if ((toLower (productVersion select 6)) in ["linux", "osx"]) then 
	{
		//Port (Linux / Mac)
		//Showing the Port Welcome Screen once per profile
		if ((profileNamespace getVariable ["BIS_welcomeScreenPortShown", 0]) <= 0) then
		{
			//If any welcome was not already shown to any profile this session, show it.
			if (_forceShow || !(uiNamespace getVariable ["BIS_welcomeScreenPortShown", false])) then
			{
				_display createDisplay "RscDisplayWelcome";
				_result = true;
			}
			else
			{
				//If any welcome already shown to another profile, assume seen and register.
				private ["_shown"];
				_shown = profileNamespace getVariable ["BIS_welcomeScreenPortShown", 0];
				_shown = _shown + 1;
				profileNamespace setVariable ["BIS_welcomeScreenPortShown", _shown];
				saveProfileNamespace;
			};
		};
	} 
	else 
	{				
		//Windows
		if ((configName (configFile >> "CfgPatches" >> "A3_Missions_F_EPC")) != "") then
		{
			//Full game
			//Showing the Welcome Screen once per profile
			if (_forceShow || (profileNamespace getVariable ["BIS_welcomeScreenShown", 0]) <= 0) then
			{
				//If any welcome was not already shown to any profile this session, show it.
				if (_forceShow || !(uiNamespace getVariable ["BIS_welcomeScreenShown", false])) then
				{
					_display createDisplay "RscDisplayWelcome";
					_result = true;
				}
				else
				{
					//If any welcome already shown to another profile, assume seen and register.
					private ["_shown"];
					_shown = profileNamespace getVariable ["BIS_welcomeScreenShown", 0];
					_shown = _shown + 1;
					profileNamespace setVariable ["BIS_welcomeScreenShown", _shown];
					saveProfileNamespace;
				};
			}
			else
			{
				//Showing the Contact Welcome Screen once per profile
				if (_forceShow || (profileNamespace getVariable ["BIS_welcomeScreenContactShown", 0]) <= 0) then
				{
					//Test Contact is installed
					if ((configName (configFile >> "CfgPatches" >> "A3_Missions_F_Enoch")) != "") then
					{
						//If any welcome was not already shown to any profile this session, show it.
						if (_forceShow || !(uiNamespace getVariable ["BIS_welcomeScreenContactShown", false])) then
						{
							_display createDisplay "RscDisplayWelcome";
							_result = true;
						}
						else
						{
							//If any welcome already shown to another profile, assume seen and register.
							private ["_shown"];
							_shown = profileNamespace getVariable ["BIS_welcomeScreenContactShown", 0];
							_shown = _shown + 1;
							profileNamespace setVariable ["BIS_welcomeScreenContactShown", _shown];
							saveProfileNamespace;
						};
					};
				};
			};
		}
		else
		{
			//Trial
			//If any welcome was not already shown to any profile this session, show it.
			if (_forceShow || !(uiNamespace getVariable ["BIS_welcomeScreenShown", false])) then
			{
				_display createDisplay "RscDisplayWelcome";
				_result = true;
			};
		};				
	};
};
if (_result) then {uinamespace setvariable ["bis_fnc_showWelcomeScreen_shown",true];}; //--- Avoid showing multiple screens per session
_result