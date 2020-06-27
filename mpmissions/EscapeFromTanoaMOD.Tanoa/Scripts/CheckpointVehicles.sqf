// Creates vehicles and ammoboxes at CSAT checkpoints

params
[
["_checkpoint","",[""]] // which checkpoint should be used for vehicle spawn
];

if !(_checkpoint in ["Roadhouse","Vagalala","EastCoast","Tanouka","Cocoa","Banana","Dutch"]) exitWith {["Non-existing checkpoint %1 for vehicle spawn used",_checkpoint] call BIS_fnc_logFormat};

if (_checkpoint == "Roadhouse") then
{

	// Supply box
	_ammobox = "O_CargoNet_01_ammo_F" createVehicle [8453.73,12499.3,0];
	_ammobox setPos [8453.73,12499.3,0];
	_ammobox setDir 345;
	_ammobox allowDamage false;
	_ammobox call BIS_fnc_EfT_ammoboxCSAT;
	_ammobox enableDynamicSimulation true;

	_veh01 = "O_T_LSV_02_armed_F" createVehicle [8485.64,12486.9,0];
	_veh01 setDir 345;
	_veh01 setFuel 0.35;
	_veh01 setPosATL [8485.64,12486.9,0];

	_veh02 = "O_T_Truck_03_transport_ghex_F" createVehicle [8460.579,12458.112,0];
	_veh02 setDir 72;
	_veh02 setFuel 0.45;
	_veh02 setPosATL [8460.579,12458.112,0];

	{_x enableDynamicSimulation true} forEach [_veh01,_veh02];
	{clearMagazineCargoGlobal _x; clearWeaponCargoGlobal _x; clearItemCargoGlobal _x} forEach [_veh01,_veh02];
	{_x addItemCargoGlobal ["FirstAidKit",2]} forEach [_veh01,_veh02];
};

if (_checkpoint == "Vagalala") then
{

	// Supply box
	_ammobox = "O_CargoNet_01_ammo_F" createVehicle [11375.9,9733.68,7.62939e-006];
	_ammobox setPos [11375.9,9733.68,7.62939e-006];
	_ammobox setDir 280;
	_ammobox allowDamage false;
	_ammobox call BIS_fnc_EfT_ammoboxCSAT;
	_ammobox enableDynamicSimulation true;

	_veh01 = "O_T_LSV_02_armed_F" createVehicle [11394.573,9737.055,0];
	_veh01 setDir 270;
	_veh01 setFuel 0.35;
	_veh01 setPosATL [11394.573,9737.055,0];

	_veh02 = "O_T_Quadbike_01_ghex_F" createVehicle [11389.156,9717.887,0];
	_veh02 setDir 0;
	_veh02 setFuel 0.65;
	_veh02 setPosATL [11389.156,9717.887,0];

	{_x enableDynamicSimulation true} forEach [_veh01,_veh02];
	{clearMagazineCargoGlobal _x; clearWeaponCargoGlobal _x; clearItemCargoGlobal _x} forEach [_veh01,_veh02];
	{_x addItemCargoGlobal ["FirstAidKit",2]} forEach [_veh01,_veh02];
};

if (_checkpoint == "EastCoast") then
{

	// Supply box
	_ammobox = "O_CargoNet_01_ammo_F" createVehicle [14549,10316.2,3.8147e-006];
	_ammobox setPos [14549,10316.2,3.8147e-006];
	_ammobox setDir 0;
	_ammobox allowDamage false;
	_ammobox call BIS_fnc_EfT_ammoboxCSAT;
	_ammobox enableDynamicSimulation true;

	_veh01 = "O_T_LSV_02_armed_F" createVehicle [14551.442,10307.741,0];
	_veh01 setDir 224;
	_veh01 setFuel 0.35;
	_veh01 setPosATL [14551.442,10307.741,0];

	_veh02 = "O_T_Quadbike_01_ghex_F" createVehicle [14550,10299.184,0];
	_veh02 setDir 285;
	_veh02 setFuel 0.35;
	_veh02 setPosATL [14550,10299.184,0];

	_veh03 = "O_T_Quadbike_01_ghex_F" createVehicle [14534.786,10294.199,0];
	_veh03 setDir 98;
	_veh03 setFuel 0.65;
	_veh03 setPosATL [14534.786,10294.199,0];

	{_x enableDynamicSimulation true} forEach [_veh01,_veh02,_veh03];
	{clearMagazineCargo _x; clearWeaponCargo _x; clearItemCargoGlobal _x} forEach [_veh01,_veh02,_veh03];
	{_x addItemCargoGlobal ["FirstAidKit",2]} forEach [_veh01,_veh02,_veh03];
};

if (_checkpoint == "Tanouka") then
{

	// Supply box
	_ammobox = "O_CargoNet_01_ammo_F" createVehicle [8333.18,9715.64,0];
	_ammobox setPos [8333.18,9715.64,0];
	_ammobox setDir 70;
	_ammobox allowDamage false;
	_ammobox call BIS_fnc_EfT_ammoboxCSAT;
	_ammobox enableDynamicSimulation true;

	_veh01 = "O_T_Truck_03_transport_ghex_F" createVehicle [8306.542,9698.595,0];
	_veh01 setDir 26;
	_veh01 setFuel 0.45;
	_veh01 setPosATL [8306.542,9698.595,0];

	_veh02 = "O_T_MRAP_02_ghex_F" createVehicle [8332.112,9729.665,0];
	_veh02 setDir 323;
	_veh02 setFuel 0.35;
	_veh02 setPosATL [8332.112,9729.665,0];

	{_x enableDynamicSimulation true} forEach [_veh01,_veh02];
	{clearMagazineCargoGlobal _x; clearWeaponCargoGlobal _x; clearItemCargoGlobal _x} forEach [_veh01,_veh02];
	{_x addItemCargoGlobal ["FirstAidKit",2]} forEach [_veh01,_veh02];
};

if (_checkpoint == "Cocoa") then
{

	// Supply box
	_ammobox = "O_CargoNet_01_ammo_F" createVehicle [8998.11,6725.31,0];
	_ammobox setPos [8998.11,6725.31,0];
	_ammobox setDir 70;
	_ammobox allowDamage false;
	_ammobox call BIS_fnc_EfT_ammoboxCSAT;
	_ammobox enableDynamicSimulation true;

	_veh01 = "O_T_LSV_02_armed_F" createVehicle [9025.657,6733.28,0];
	_veh01 setDir 223;
	_veh01 setFuel 0.35;
	_veh01 setPosATL [9025.657,6733.28,0];

	_veh02 = "O_T_Quadbike_01_ghex_F" createVehicle [9005.381,6708.491,0];
	_veh02 setDir 0;
	_veh02 setFuel 0.35;
	_veh02 setPosATL [9005.381,6708.491,0];

	{_x enableDynamicSimulation true} forEach [_veh01,_veh02];
	{clearMagazineCargoGlobal _x; clearWeaponCargoGlobal _x; clearItemCargoGlobal _x} forEach [_veh01,_veh02];
	{_x addItemCargoGlobal ["FirstAidKit",2]} forEach [_veh01,_veh02];
};

if (_checkpoint == "Banana") then
{

	// Supply box
	_ammobox = "O_CargoNet_01_ammo_F" createVehicle [12361.3,8006.75,0];
	_ammobox setPos [12361.3,8006.75,0];
	_ammobox setDir 335;
	_ammobox allowDamage false;
	_ammobox call BIS_fnc_EfT_ammoboxCSAT;
	_ammobox enableDynamicSimulation true;

	_veh01 = "O_T_MRAP_02_ghex_F" createVehicle [12379.313,7995.745,0];
	_veh01 setDir 272;
	_veh01 setFuel 0.35;
	_veh01 setPosATL [12379.313,7995.745,0];

	_veh02 = "O_T_Quadbike_01_ghex_F" createVehicle [12359.289,7990.906,0];
	_veh02 setDir 355;
	_veh02 setFuel 0.75;
	_veh02 setPosATL [12359.289,7990.906,0];

	{_x enableDynamicSimulation true} forEach [_veh01,_veh02];
	{clearMagazineCargoGlobal _x; clearWeaponCargoGlobal _x; clearItemCargoGlobal _x} forEach [_veh01,_veh02];
	{_x addItemCargoGlobal ["FirstAidKit",2]} forEach [_veh01,_veh02];
};

if (_checkpoint == "Dutch") then
{

	// Supply box
	_ammobox = "O_CargoNet_01_ammo_F" createVehicle [11354.1,4165.41,0];
	_ammobox setPos [11354.1,4165.41,0];
	_ammobox setDir 95;
	_ammobox allowDamage false;
	_ammobox call BIS_fnc_EfT_ammoboxCSAT;
	_ammobox enableDynamicSimulation true;

	// No vehicle at the Dutch island checkpoint

};
