params [
	["_trigger",objnull,[objnull]],
	["_type","Goat_random_F",[""]],
	["_count",10,[0]]
];

private _animals = [];
for "_i" from 1 to _count do {
	_animal = createAgent [_type,_trigger call bis_fnc_randomPosTrigger,[],1,"CAN_COLLIDE"];
	_animal setVariable ["BIS_fnc_animalBehaviour_disable",true];
	_animal setdir random 360;
	_animal moveto position _animal;
	_animals pushback _animal;
};
[_animals,_trigger getvariable "bis_layer"] call bis_orange_fnc_register;

_list = missionnamespace getvariable ["bis_initAnimals_list",[]];
_list append _animals;
missionnamespace setvariable ["bis_initAnimals_list",_list];

_animals