params [
	["_house",objnull,[objnull,true]]
];

//--- Init
if (_house isequalto true) exitwith {
	_houses = bis_orange_fnc_initLayer_EastWind_damageObjects;
	{
		_houses pushback _x;
		_xPost = missionnamespace getvariable [format ["%1_PostWar",vehiclevarname _x],objnull];
		if !(isnull _xPost) then {

			//--- List hitzones which cannot be damaged
			_hitzones = switch (typeof _xPost) do {
				case "Land_d_House_Big_01_V1_F": {["dam_2"]};
				case "Land_d_Stone_Shed_V1_F": {["dam_2"]};
				case "Land_d_Stone_HouseSmall_V1_F": {["dam_1"]};
				case "Land_d_House_Small_02_V1_F": {["dam_2"]};
				case "Land_d_House_Small_01_V1_F": {["dam_2"]};
				default {[]};
			};
			if (count _hitzones > 0) then {
				_x setvariable ["bis_hitzones",_hitzones];
			};
		};
	} foreach (bis_layer_town select {_x iskindof "House_F" && vehiclevarname _x != ""});

	//--- Add handler to all houses
	{
		_x call bis_orange_fnc_houseHandleDamage;
	} foreach ((bis_layer_postwar select {_x iskindof "House_F"}) + _houses);

	//--- Don't let damaged houses to be fully destroyed
	addmissioneventhandler [
		"buildingchanged",
		{
			(_this select 1) allowdamage false;
			//_from = _this select 0;
			//_to = _this select 1;
			//{_to setvariable [_x,_from getvariable _x];} foreach allvariables _from;
			//_to call bis_orange_fnc_houseHandleDamage;
		}
	];
};

//--- Individual house
_house addeventhandler [
	"handledamage",
	{
		_damage = _this select 2;
		if (_damage > 0.01 && {side (_this select 3) != west}) then {
			_hitpoint = _this select 1;
			if (_hitpoint == "") then {
				//--- Apply visual damage without collapsing the building
				0.5
			} else {
				if (_hitpoint in ((_this select 0) getvariable ["bis_hitzones",["dam_1","dam_2"]])) then {
					//--- Apply no damage to major hitpoints
					0
				} else {
					if (_hitpoint in ["dam_1","dam_2"]) then {

						//--- Apply damage on story hitpoints and avoid taking any further damage, so the house won't dissapear completely
						_house = _this select 0;
						if (_house gethit _hitpoint == 0) then {
							_house sethit [_hitpoint,1];
							_house allowdamage false;
						};
						1
					} else {
						_damage
					};
				}
			}
		} else {
			0
		}
	}
];