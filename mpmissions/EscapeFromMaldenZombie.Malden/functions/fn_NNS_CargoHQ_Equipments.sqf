/*
NNS
Add box to cargo HQ, random position/box

Example: _null = Test_HQ_1 call BIS_fnc_NNS_CargoHQ_Equipments;
*/

// Params
params [
	["_building",objNull,[objNull]]
];

// Check for validity
if (isNull _building) exitWith {[format["BIS_fnc_NNS_CargoHQ_Equipments : Non-existing unit cargohq %1 used!",_building]] call BIS_fnc_NNS_debugOutput;};

[format["BIS_fnc_NNS_CargoHQ_Equipments : %1m",player distance2d _building]] call BIS_fnc_NNS_debugOutput; //debug

if ((damage _building) > 0.99) exitWith {[format["BIS_fnc_NNS_CargoTower_Equipments : Cargo HQ too damaged to add equipment (%1)",damage _building]] call BIS_fnc_NNS_debugOutput;};

_allowedPos = [ //where equipment can be placed, [pos,dir]
[1,0],
[2,90],
[3,0],
[6,90],
[7,90],
[8,0]];

_equipmentsList = ["Box_East_Ammo_F","Box_East_Wps_F","Box_East_WpsSpecial_F","Box_East_Support_F","O_supplyCrate_f"];

_selectedPos = selectRandom _allowedPos;
_selectedEquipment = selectRandom _equipmentsList;

_equipment = _selectedEquipment createVehicle [0,0,0];
_equipment setPosASL (AGLToASL (_building buildingPos (_selectedPos select 0)));
_equipment setDir ((getDir _building) + (_selectedPos select 1));
_equipment addMagazineCargoGlobal ["150Rnd_93x64_Mag", 3]; //Navid
_equipment addMagazineCargoGlobal ["6Rnd_45ACP_Cylinder", 6]; //Zubr
[_equipment,0,0,true] call BIS_fnc_NNS_AmmoboxLimiter;

if (random 1 > 0.5) then {
	_allowedPos deleteAt (_allowedPos find _selectedPos);
	_equipmentsList deleteAt (_equipmentsList find _selectedEquipment);
	
	_selectedPos = selectRandom _allowedPos;
	_selectedEquipment = selectRandom _equipmentsList;

	_equipment01 = _selectedEquipment createVehicle [0,0,0];
	_equipment01 setPosASL (AGLToASL (_building buildingPos (_selectedPos select 0)));
	_equipment01 setDir ((getDir _building) + (_selectedPos select 1));
	_equipment01 addMagazineCargoGlobal ["150Rnd_93x64_Mag", 3]; //Navid
	_equipment01 addMagazineCargoGlobal ["6Rnd_45ACP_Cylinder", 6]; //Zubr
	[_equipment01,0,0,true] call BIS_fnc_NNS_AmmoboxLimiter;
}
