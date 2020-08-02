private ["_curator","_areas"];
_curator = _this param [0,objnull,[objnull]];
_areas = +(_curator getvariable ["bis_fnc_curatorSystem_editingArea",[]]);
_areas = _areas - [-1];

//--- Remove position params used by visualization
{
	if (count _x > 2) then {
		_x resize 2
	};
} foreach _areas;
_areas