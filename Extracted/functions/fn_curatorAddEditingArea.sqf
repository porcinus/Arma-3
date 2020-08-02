private ["_curator","_areaPos","_areaRadius","_areaID","_editingArea"];

_curator = _this param [0,objnull,[objnull]];
_areaPos = _this param [1,[0,0,0],[[]]];
_areaRadius = _this param [2,0,[0]];
_areaID = -1;

if (_areaRadius > 0) then {
	//_editingArea = _curator call bis_fnc_curatorEditingArea;
	_editingArea = +(_curator getvariable ["bis_fnc_curatorSystem_editingArea",[]]);
	_areaID = count _editingArea;
	_editingArea set [_areaID,[_areaPos,_areaRadius]];
	_curator setvariable ["bis_fnc_curatorSystem_editingArea",_editingArea,true];
};

_areaID