private ["_curator"];
_curator = _this param [0,objnull,[objnull]];
if (isnull _curator) then {
	[]
} else {
	(_curator getvariable ["bis_fnc_curatorSystem_editableUnits",[]]) - [-1];
};