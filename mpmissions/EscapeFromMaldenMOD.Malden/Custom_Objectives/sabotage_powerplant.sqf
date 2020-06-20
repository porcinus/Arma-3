if !(["objective11"] call BIS_fnc_taskExists) then {
	task_completed_11 = false;
	
	_DeleteObjects = [ //list all map objects to hide
	"i_house_big_01_b_whiteblue_f",
	"i_addon_03_v1_f",
	"i_house_small_01_v3_f",
	"i_shop_01_v3_f",
	"i_addon_02_v1_f",
	"i_shop_02_b_pink_f",
	"i_house_small_01_b_pink_f",
	"i_addon_02_b_white_f",
	"i_house_small_02_b_yellow_f",
	"i_house_small_01_v2_f",
	"i_house_small_01_v1_f",
	"lampstreet_f",
	"pavement_wide_f",
	"pavement_wide_corner_f",
	"billboard_03_blank_f",
	"i_shed_ind_f",
	"cargo20_grey_f",
	"cargo20_blue_f",
	"cargo20_white_f",
	"cargo20_brick_red_f",
	"cargo20_cyan_f",
	"garbagecontainer_closed_f",
	"garbagepallet_f",
	"garbagecontainer_open_f",
	"marketshelter_f",
	"signm_forrent_f",
	"fishinggear_01_f",
	"fishinggear_02_f",
	"signt_infopicnicsite",
	"garbagebarrel_01_english_f",
	"garbagebin_01_f",
	"cratesplastic_f",
	"lampharbour_f"];

	{
		_tmpname = (format["%1",_x] splitString " ."); //parse object node/name
		_tmpname = _tmpname select ((count _tmpname) - 2); //extract name without extension
		if (_tmpname in _DeleteObjects) then {_x hideObjectGlobal true;} //in list: global hide
	} foreach (nearestTerrainObjects [[3590,3263,0],[],100,false]);

	_building0 = "Land_dp_mainFactory_F" createVehicle [0,0,0]; _building0 setDir 9.177; _building0 setPosATL [3606.76,3250.24,0];
	_building1 = "Land_Offices_01_V1_F" createVehicle [0,0,0]; _building1 setPosATL [3610.16,3299.33,0];
	_building2 = "Land_dp_smallFactory_F" createVehicle [0,0,0]; _building2 setDir 92.689; _building2 setPosATL [3573.16,3300.81,0];
	_building3 = "Land_dp_bigTank_F" createVehicle [0,0,0]; _building3 setDir 102.397; _building3 setPosATL [3569.96,3251.28,0];
	_building4 = "Land_dp_bigTank_F" createVehicle [0,0,0]; _building4 setDir 46.007; _building4 setPosATL [3556.06,3269.45,0];
	_building5 = "Land_dp_bigTank_F" createVehicle [0,0,0]; _building5 setDir 203.790; _building5 setPosATL [3541.73,3287.08,0];
	_lamp0 = "Land_LampHalogen_F" createVehicle [0,0,0]; _lamp0 setDir 311.448; _lamp0 setPosATL [3590.52,3310.65,0];
	_lamp1 = "Land_LampHalogen_F" createVehicle [0,0,0]; _lamp1 setDir 43.538; _lamp1 setPosATL [3652.47,3278.13,0];
	_lamp2 = "Land_LampHalogen_F" createVehicle [0,0,0]; _lamp2 setDir 281.854; _lamp2 setPosATL [3636.61,3252.95,0];
	_lamp3 = "Land_LampStreet_F" createVehicle [0,0,0]; _lamp3 setDir 202.681; _lamp3 setPosATL [3662.45,3272.45,0];
	_lamp4 = "Land_LampStreet_F" createVehicle [0,0,0]; _lamp4 setDir 5.082; _lamp4 setPosATL [3589.08,3267.25,0];
	
	waitUntil {sleep 5; daytime > 20}; //wait until night
	
	[BIS_grpMain,["objective11","objEscape"],[localize "STR_NNS_Escape_Objective_SabotagePowerplant_desc",localize "STR_NNS_Escape_Objective_SabotagePowerplant_title",""],getMarkerPos "objective_zone_11","ASSIGNED",1,true,"destroy"] call BIS_fnc_taskCreate;

	[_building3,_building4,_building5] spawn {
		fueltank0 = param [0, objNull];
		fueltank1 = param [1, objNull];
		fueltank2 = param [2, objNull];
		while {!task_completed_11} do {
			sleep 5;
			if(!alive (fueltank0) && {!alive (fueltank1)} && {!alive (fueltank2)}) then {
				task_completed_11 = true;
				["objective11", "Succeeded"] remoteExec ["BIS_fnc_taskSetState",BIS_grpMain,true];
				missionNamespace setVariable ["noPowerGrid",true]; publicVariable "noPowerGrid";
				
				
				_objects_lamps = ["Lamps_base_F", "PowerLines_base_F", "PowerLines_Small_base_F", "Land_fs_roof_F", "Land_FuelStation_01_roof_malevil_F", "Land_LightHouse_F", "Land_LightHouse_03_red_F", "Land_LightHouse_03_green_F", "Land_Airport_Tower_F", "Land_TTowerBig_1_F", "Land_TTowerBig_2_F", "Land_Communication_F", "Land_NavigLight", "Land_NavigLight_3_F"];
				_objects_tohide = ["Land_Flush_Light_red_F", "Land_Flush_Light_green_F", "Land_Flush_Light_yellow_F", "Land_runway_edgelight", "Land_runway_edgelight_blue_F"];
				_objects_todest = ["Land_Runway_Papi", "Land_Runway_Papi_2", "Land_Runway_Papi_3", "Land_Runway_Papi_4", "Land_fs_roof_F", "Land_fs_price_F", "Land_fs_sign_F"];
				
				[[_objects_lamps, _objects_tohide, _objects_todest], {
					_objects_lamps = _this select 0; _objects_tohide = _this select 1; _objects_todest = _this select 2;
					{_x switchLight "OFF";} forEach nearestObjects [player, _objects_lamps, 12000];
					{_x hideObject true;} forEach nearestObjects [player, _objects_tohide, 12000];
					{_x setDamage [1,false];} forEach nearestObjects [player, _objects_todest, 12000];
				}] remoteExec ["BIS_fnc_call",BIS_grpMain,true]; sleep 0.05;
				
				/*
				{
					[[_x], {(_this select 0) switchLight "OFF";}] remoteExec ["BIS_fnc_call"];
				} forEach nearestObjects [player, _lamps_objects, 12000]; //kill all lights
				*/
			};
		};
	};
};