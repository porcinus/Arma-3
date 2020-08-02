private ["_curator","_units","_addCrew","_fnc_add","_editableUnits"];
_curator = _this param [0,objnull,[objnull]];
_units = _this param [1,[],[[]]];
_addCrew = _this param [2,true,[true]];

_fnc_add = {
	if !(_this in _editableUnits) then {
		_editableUnits set [count _editableUnits,_this];
		[_this,"bis_fnc_curatorSystem_curatorsEditableObject",[_curator],true,true] call bis_fnc_variablespaceadd;
	};
};

_editableUnits = _curator getvariable ["bis_fnc_curatorSystem_editableUnits",[]];
{
	_x call _fnc_add;

	//--- Add vehicle crew
	if (_addCrew) then {
		{_x call _fnc_add} foreach (crew _x);
	};
} foreach _units;
_curator setvariable ["bis_fnc_curatorSystem_editableUnits",_editableUnits,true];
_editableUnits