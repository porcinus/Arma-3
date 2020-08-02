/*
	Author: Muf

	Description:
		* Converts text of selected classes in one display to upper-case.
		* Searches inside Controls class of the display. Looks inside RscControlsGroup as well.
		* Doesn't toUpper class with name "PlayersName" (TODO - Maybe make it parameter as well).

	Parameter(s):
		0: STRING - Class name of the display (e. g. "RscDisplayOptionsAudio").
		1: ARRAY OF STRINGS - Class names of parents of controls you want to toUpper (e. g. ["RscText", "RscTitle"]).
		2 (Optional): ARRAY OF STRINGS - Class names of controls you don't want toUpper (e. g. ["CA_VehicleAuthor"] - suitable for toUppering all RscTexts except CA_VehicleAuthor).

	Returns:
	NOTHING
*/



private ["_displayClassName","_controlClassesDoUpper","_controlClassesDontUpper",
         "_classInsideControls","_current","_controlsGroupControls","_classInsideCGcontrols","_idc","_control"];

_displayClassName = _this param [0,"",["ExampleString"]];
_controlClassesDoUpper = _this param [1,[],[["ExampleArray"]]];
_controlClassesDontUpper = _this param [2,[],[["ExampleArray"]]];
_classInsideControls = configfile >> _displayClassName >> "controls";
	
for "_i" from 0 to (count _classInsideControls - 1) do   						//Go to all subclasses
{
	_current = _classInsideControls select _i;
	
	if ((isclass _current)
	     && (({_x == configName _current} count _controlClassesDontUpper) == 0)			//Do not toUpper classes specified in second array.
	     && ((({_x == configName(inheritsFrom(_current))} count _controlClassesDoUpper) > 0)	//toUpper only classes that inherit from classes specified as fnc. parameters
	     || (configName(inheritsFrom(_current)) == "RscControlsGroup"))				//Look inside ControlsGroup as well
	   ) then {
		//If RscControlsGroup is found, search inside
		if (configName(inheritsFrom(_current)) == "RscControlsGroup") then
		{		
			//Search inside ControlsGroup
			_controlsGroupControls = _current >> "controls";

			for "_k" from 0 to (count _controlsGroupControls - 1) do   			//Go to all subclasses of ControlsGroup
			{
				_classInsideCGcontrols = _controlsGroupControls select _k;

				if ((isclass _classInsideCGcontrols)
				     && (({_x == configName _classInsideCGcontrols} count _controlClassesDontUpper) == 0)		//Do not toUpper classes specified in second array.
				     && (({_x == configName(inheritsFrom(_classInsideCGcontrols))} count _controlClassesDoUpper) > 0)	//toUpper only classes that inherit from RscText.
				   ) then {
					_idc = getnumber (_classInsideCGcontrols >> "idc");
					if (_idc < 0) then {
						//safe-check, there can be more -1 idc elements used and function would work only with the first one!
						debuglog format ["BIS_fnc_toUpperDisplayTexts: WARNING! Control '%1' in display '%2' uses negative value as IDC and cannot be processed!",_classInsideCGcontrols,_displayClassName];
					} else {
						_control = _display displayctrl _idc;
						_control ctrlSetText (toUpper (ctrlText _control));
					};
				};
			};
		}
		else
		{
			//Search inside main controls class
			_idc = getnumber (_current >> "idc");
			if (_idc < 0) then {
				//safe-check, there can be more -1 idc elements used and function would work only with the first one!
				debuglog format ["BIS_fnc_toUpperDisplayTexts: WARNING! Control '%1' in display '%2' uses negative value as IDC and cannot be processed!",_current,_displayClassName];
			} else {
				_control = _display displayctrl _idc;
				_control ctrlSetText (toUpper (ctrlText _control));
			};
		};
	};
};
