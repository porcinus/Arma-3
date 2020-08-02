if (isServer) then {
	private _texOff = [];
	private _texQuad = [];
	
	{
		switch (typeOf _x) do {
			case "I_G_Offroad_01_armed_F": {
				if (count _texOff == 0) then {
					_texOff = [
						"\a3\soft_f\offroad_01\data\offroad_01_ext_base01_co.paa",
						"\a3\soft_f\offroad_01\data\offroad_01_ext_base02_co.paa",
						"\a3\soft_f\offroad_01\data\offroad_01_ext_base05_co.paa"
					];
				};
				
				private _tex = _texOff call BIS_fnc_selectRandom;
				_texOff = _texOff - [_tex];
				
				_x setObjectTextureGlobal [0, _tex];
			};
			
			case "I_G_Quadbike_01_F": {
				if (count _texQuad == 0) then {
					_texQuad = [
						[
							"\a3\soft_f_beta\quadbike_01\data\quadbike_01_civ_black_co.paa",
							"\a3\soft_f_beta\quadbike_01\data\quadbike_01_wheel_civblack_co.paa"
						],
						[
							"\a3\soft_f_beta\quadbike_01\data\quadbike_01_civ_blue_co.paa",
							"\a3\soft_f_beta\quadbike_01\data\quadbike_01_wheel_civblue_co.paa"
						],
						[
							"\a3\soft_f_beta\quadbike_01\data\quadbike_01_civ_red_co.paa",
							"\a3\soft_f_beta\quadbike_01\data\quadbike_01_wheel_civred_co.paa"
						],
						[
							"\a3\soft_f_beta\quadbike_01\data\quadbike_01_civ_white_co.paa",
							"\a3\soft_f_beta\quadbike_01\data\quadbike_01_wheel_civwhite_co.paa"
						]
					];
				};
				
				private _index = floor (random (count _texQuad - 1));
				private _texs = _texQuad select _index;
				_texQuad deleteAt _index;
				
				_x setObjectTextureGlobal [0, _texs select 0];
				_x setObjectTextureGlobal [1, _texs select 1];
			};
		};
	} forEach vehicles;
};

true