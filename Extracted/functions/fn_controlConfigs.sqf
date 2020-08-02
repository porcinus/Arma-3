/*
	Author: Karel Moricky

	Description:
	Return config paths to all display controls

	Parameter(s):
		0: DISPLAY
		1: CONFIG - root display config path

	Returns:
	ARRAY in format [[<control1>,<configpath1>], [<control2>,<configpath2>],... [<controlN>,<configpathN>]]
*/

disableserialization;
private _display = param [0,displaynull,[displaynull]];
private _cfg = param [1,configfile,[configfile]];
private _result = [];
{
	private _path = "";
	private _ctrl = _x;
	private _ctrlParent = _ctrl;
	while {!isnull _ctrlParent} do {
		private _ctrlCurrent = _ctrlParent;
		_ctrlParent = ctrlParentControlsGroup _ctrlParent;
		if (isnull _ctrlParent) then {
			_path = " >> '" + ctrlclassname _ctrlCurrent + "'" + _path;
		} else {
			_path = " >> 'Controls' >> '" + ctrlclassname _ctrlCurrent + "'" + _path;
		};
	};
	{
		if !(isnull _x) then {
			_result pushback [_ctrl,_x];
		};
	} foreach [
		call compile ("_cfg >> 'Controls'" + _path),
		call compile ("_cfg >> 'ControlsBackground'" + _path)
	];
} foreach allcontrols _display;

_result