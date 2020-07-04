/*
NNS
Add equipment to cargo tower, random position/box

Example: _null = Test_Tower_1 call NNS_fnc_CargoTower_Equipments;

*/

// Params
params [
	["_tower",objNull,[objNull]]
];

// Check for validity
if (isNull _tower) exitWith {[format["NNS_fnc_CargoTower_Equipments : Non-existing unit tower %1 used!",_tower]] call NNS_fnc_debugOutput;};

[format["NNS_fnc_CargoTower_Equipments : %1m",player distance2d _tower]] call NNS_fnc_debugOutput; //debug

if ((damage _tower) > 0.99) exitWith {[format["NNS_fnc_CargoTower_Equipments : Tower too damaged to add equipment (%1)",damage _tower]] call NNS_fnc_debugOutput;};

_allowedPos = [ //where equipment can be placed, [pos,dir]
[3,90],
[6,90],
[9,90],
[13,0],
[15,90],
[17,0]];

_equipmentsList = [];
if (BIS_playerSide == west) then {_equipmentsList = ["Box_NATO_Ammo_F","Box_NATO_Wps_F","Box_NATO_WpsSpecial_F","Box_NATO_Support_F","B_supplyCrate_f"];
} else {_equipmentsList = ["Box_East_Ammo_F","Box_East_Wps_F","Box_East_WpsSpecial_F","Box_East_Support_F","O_supplyCrate_f"]};

_selectedPos = selectRandom _allowedPos;
_selectedEquipment = selectRandom _equipmentsList;

_equipment = _selectedEquipment createVehicle [0,0,0];
_equipment allowDamage false;
_equipment setPosASL (AGLToASL (_tower buildingPos (_selectedPos select 0)));
_equipment setDir ((getDir _tower) + (_selectedPos select 1));

if (BIS_playerSide == west) then {
	_equipment addMagazineCargoGlobal ["130Rnd_338_Mag", 3]; //SPMG
} else {
	_equipment addMagazineCargoGlobal ["150Rnd_93x64_Mag", 3]; //Navid
	_equipment addMagazineCargoGlobal ["6Rnd_45ACP_Cylinder", 6]; //Zubr
};

[_equipment,0,0,true] call NNS_fnc_AmmoboxLimiter;
_equipment allowDamage true;

if (random 1 > 0.5) then {
	_allowedPos deleteAt (_allowedPos find _selectedPos);
	_equipmentsList deleteAt (_equipmentsList find _selectedEquipment);
	
	_selectedPos = selectRandom _allowedPos;
	_selectedEquipment = selectRandom _equipmentsList;

	_equipment01 = _selectedEquipment createVehicle [0,0,0];
	_equipment01 allowDamage false;
	_equipment01 setPosASL (AGLToASL (_tower buildingPos (_selectedPos select 0)));
	_equipment01 setDir ((getDir _tower) + (_selectedPos select 1));
	
	if (BIS_playerSide == west) then {
		_equipment01 addMagazineCargoGlobal ["130Rnd_338_Mag", 3]; //SPMG
	} else {
		_equipment01 addMagazineCargoGlobal ["150Rnd_93x64_Mag", 3]; //Navid
		_equipment01 addMagazineCargoGlobal ["6Rnd_45ACP_Cylinder", 6]; //Zubr
	};

	[_equipment01,0,0,true] call NNS_fnc_AmmoboxLimiter;
	_equipment01 allowDamage true;
};

