/*
	Author: Karel Moricky

	Description:
	Display a list of all available functions

	Parameter(s):
	NONE

	Returns:
	NOTHING
*/
if !(isnull (findDisplay 2929)) exitwith {};
_this spawn {
	disableserialization;
	_parent = _this param [0,displaynull,[displaynull]];
	if (isnull _parent) then {
		_displayMission = [] call (uinamespace getvariable "bis_fnc_displayMission");
		if !(isnull (finddisplay 312)) then {_displayMission = finddisplay 312;}; //--- Curator
		_parent = if (isnull _displayMission) then {
			_displays = alldisplays - [finddisplay 12];
			if (count _displays > 0) then {
				if (ctrlidd (_displays select (count _displays - 1)) == 56) then {
					//--- Debug console is open - use the display below it (otherwise you couldn't access the console while in the viewer)
					_displays select (count _displays - 2)
				} else {
					//--- Open the viewer from the last open display
					_displays select (count _displays - 1)
				};
			} else {
				//--- No displays are tracked - cannot open
				displaynull
			};
		} else {
			//--- Mission display is present - use it as parent
			_displayMission
		};
	};
	_parent createdisplay "RscDisplayFunctionsViewer";
};