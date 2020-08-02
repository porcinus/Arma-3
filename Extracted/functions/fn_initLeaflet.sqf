/*
	Author: Karel Moricky

	Description:
	Initialize interactive leaflet.

	Parameter(s):
		0: STRING - mode; use "init" for scripted initialization, other modes are used when leaflets are fired as a weapon.
		1: ARRAY - params in one of the following formats
			0: OBJECT - leaflet
			1: STRINg - texture
			2: STRING - localized text, shown when previewing the leaflet in full screen

			or

			0: OBJECT - leaflet
			1: STRING - class from CfgLeaflets

	Examples:
		["init",[myLeaflet,"#(argb,8,8,3)color(1,1,0,1)","Yellow pages"]] call bis_fnc_initLeaflet;

		["init",[myLeaflet,"Custom_02"]] call bis_fnc_initLeaflet;

	Returns:
	NOTHING
*/

params [
	["_mode","",[""]],
	["_this",[],[[]]]
];
switch _mode do {
	case "fired": {
		params ["_obj","_weapon","_muzzle","_mode","_ammo","_magazine"];

		////--- Leaflets for effect
		//_leafletsEffect = "#particlesource" createVehicleLocal position _obj;
		//_leafletsEffect setParticleClass "Leaflets";
		//_leafletsEffect attachto [_obj,[0,0,0]];

		// open door
		_obj animateSource ["leaflet_door",1];

		_time = time + 0.1;
		waituntil {time > _time};

		//--- Leaflets that turn into pickable objects
		_leaflets = objnull;
		_leafletsParams = "Leaflets" call bis_fnc_getCloudletParams;
		if (count _leafletsParams > 0) then {

			//--- Assign script
			private _leafletClass = gettext (configfile >> "CfgMagazines" >> _magazine >> "leafletClass");
			private _leafletScript = gettext (configfile >> "CfgLeaflets" >> ("script" + _leafletClass));
			if (_leafletScript == "") exitwith {["Script not defined for leaflet %1",_leafletClass] call bis_fnc_error;};
			(_leafletsParams select 0) set [17,_leafletScript];

			//--- Use custom model
			private _cfg = [["CfgLeaflets",_leafletClass],configfile >> "CfgLeaflets" >> "Default"] call bis_fnc_loadClass;
			if (istext (_cfg >> "model")) then {(_leafletsParams select 0 select 0) set [0,gettext (_cfg >> "model")];};

			//--- Create particle source
			_leaflets = "#particlesource" createVehicleLocal position _obj;
			_leaflets setParticleParams (_leafletsParams select 0);
			_leaflets setParticleRandom (_leafletsParams select 1);
			_leaflets setDropInterval (_leafletsParams select 2);
			_leaflets attachto [_obj,[0,0,0],"leaflet_spawn"];
		};

		_time = time + 1;
		waituntil {time > _time};
		//deletevehicle _leafletsEffect;
		deletevehicle _leaflets;
		// closing door anim is five times slower
		_obj animateSource ["leaflet_door",0,0.2];
	};
	case "init": {
		private _leaflet = objnull;
		private _texture = "";
		private _text = "";

		switch true do {
			case (_this isequaltypeparams [[],""]): {
				params [
					["_pos",[],[[]]],
					["_class","",[""]]
				];

				//--- Spawn it only when no other leaflets are around
				if (count (_pos nearentities ["Leaflet_05_Base_F",5]) == 0) then {
					private _cfg = [["CfgLeaflets",_class],configfile >> "CfgLeaflets" >> "Default"] call bis_fnc_loadClass;
					_texture = gettext (_cfg >> "texture");
					_text = gettext (_cfg >> "text");
					_leaflet = createvehicle ["Leaflet_05_F",_pos,[],0,"can_collide"];
					_leaflet setdir random 360;
					if (_texture == "") then {["Texture not defined for leaflet %1",_class] call bis_fnc_error;};
				};
			};
			case (_this isequaltypeparams [objnull,"",""]): {

				//--- Direct input of leaflet appearance
				_leaflet = param [0,objnull,[objnull]];
				_texture = param [1,"#(argb,8,8,3)color(1,1,1,1)",[""]];
				_text = param [2,"",[""]];
			};
			case (_this isequaltypeparams [objnull,""]): {
				_leaflet = param [0,objnull,[objnull]];
				_class = param [1,"",[""]];

				private _cfg = [["CfgLeaflets",_class],configfile >> "CfgLeaflets" >> "Default"] call bis_fnc_loadClass;
				_texture = gettext (_cfg >> "texture");
				_text = gettext (_cfg >> "text");
				if (_texture == "") then {["Texture not defined for leaflet %1",_class] call bis_fnc_error;};
			};
			default {}
		};

		//--- Spawn the leaflet
		if (_texture != "") then {
			[
				_leaflet,
				_texture,
				_text,
				selectrandom ["Orange_Leaflet_Investigate_01","Orange_Leaflet_Investigate_02","Orange_Leaflet_Investigate_03"]
			] call bis_fnc_initInspectable;
		};
	};
};