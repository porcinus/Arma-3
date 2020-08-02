/*
	Author: Karel Moricky

	Description:
	Initialize hit effects on VR targets
	- grey - undamaged
	- orange - damaged
	- red - destroyed

	Parameter(s):
		0: OBJECT
		1 (Optional, default is 30): NUMBER - delay before hit parts are returned back to default

	Returns:
	NOTHING
*/


#define MAT_BLUE	"\A3\Structures_F_Mark\VR\Targets\Data\VR_Target_MBT_01_cannon_BLUFOR.rvmat"
#define MAT_RED		"\A3\Structures_F_Mark\VR\Targets\Data\VR_Target_MBT_01_cannon_OPFOR.rvmat"
#define MAT_GREEN	"\A3\Structures_F_Mark\VR\Targets\Data\VR_Target_MBT_01_cannon_INDEP.rvmat"
#define MAT_ORANGE	"\A3\Structures_F_Mark\VR\Targets\Data\VR_Target_MBT_01_cannon_damage.rvmat"
#define MAT_GREY	"\A3\Structures_F_Mark\VR\Targets\Data\VR_Target_MBT_01_cannon_destroy.rvmat"

_target = _this param [0,objnull,[objnull,[]]];

if (typename _target == typename objnull) then {

	//--- Init
	if ((_target getvariable ["bis_fnc_VRHitParts_handler",-1]) < 0) then {
		_delay = _this param [1,15,[0]];

		_target setvariable ["bis_fnc_VRHitParts_delay",_delay];
		_target setvariable [
			"bis_fnc_VRHitParts_handler",
			_target addeventhandler ["hitpart",{_this spawn bis_fnc_VRHitpart;}]
		];

		_hitpoints = [];
		_hitparts = [];
		_hitselections = [];
		_hitdamage = [];
		_hitalive = [];
		_hiddenselections = getarray (configfile >> "cfgvehicles" >> typeof _target >> "hiddenselections");
		{_hiddenselections set [_foreachindex,tolower _x];} foreach _hiddenselections;
		{
			_hitpoints pushback _x;
			_hitparts pushback tolower gettext (_x >> "name");
			_hitselections pushback (_hiddenselections find tolower gettext (_x >> "visual"));
			_hitdamage pushback 0;
			_hitalive pushback true;
			_target setobjectmaterial [_foreachindex,MAT_GREY];
		} foreach (configproperties [configfile >> "cfgvehicles" >> typeof _target >> "hitpoints"]);
		_target setvariable ["bis_fnc_VRHitParts_hitpoints",_hitpoints];
		_target setvariable ["bis_fnc_VRHitParts_hitparts",_hitparts];
		_target setvariable ["bis_fnc_VRHitParts_hitselections",_hitselections];
		_target setvariable ["bis_fnc_VRHitParts_hitdamage",_hitdamage];
		_target setvariable ["bis_fnc_VRHitParts_hitalive",_hitalive];
		_target setvariable ["bis_fnc_VRHitParts_script",scriptnull];
	};
} else {
	//--- Exec
	{
		_target = _x select 0;
		_shooter = _x select 1;
		_bullet = _x select 2;
		_position = _x select 3;
		_velocity = _x select 4;
		_selections = _x select 5;
		_ammo = _x select 6;
		_direction = _x select 7;
		_radius = _x select 8;
		_surface = _x select 9;
		_direct = _x select 10;

		if !(isnull _target) then {
			_targetArmor = getnumber (configfile >> "cfgvehicles" >> typeof _target >> "armor");
			_hit = _ammo select 0;
			_hitIndirect = _ammo select 1;
			_hitIndirectRange = _ammo select 2;
			_hitExplosive = _ammo select 3;
			_hitClass = _ammo select 4;

			//--- Some completely fake hit calculation to filter out HE rounds
			_hit = _hit / (_targetArmor max 1) / (_hitIndirectRange max 1);//* (1 - _hitExplosive);

			_hitpoints = _target getvariable ["bis_fnc_VRHitParts_hitpoints",[]];
			_hitparts = _target getvariable ["bis_fnc_VRHitParts_hitparts",[]];
			_hitselections = _target getvariable ["bis_fnc_VRHitParts_hitselections",[]];
			_hitdamage = _target getvariable ["bis_fnc_VRHitParts_hitdamage",[]];
			_hitalive = _target getvariable ["bis_fnc_VRHitParts_hitalive",[]];
			{
				_id = _hitparts find tolower _x;
				if (_id >= 0) then {
					private ["_minimalhit","_armor","_damage"];
					_hitpoint = _hitpoints select _id;
					if (_target iskindof "man") then {
						_minimalhit = 0.01;
						_armor = 0.9;
						_damage = (_target gethitpointdamage configname _hitpoint);
					} else {
						_minimalhit = getnumber (_hitpoint >> "minimalhit");
						_armor = getnumber (_hitpoint >> "armor");
						_damage = _hitdamage select _id;
						if (_hit > _minimalhit) then {
							_damage = _damage + _hit;
							_hitdamage set [_id,_damage];
						};
					};
					_mat = switch true do {
						case (_damage > _armor): {_hitalive set [_id,false]; MAT_RED};
						case (_damage > _minimalhit): {MAT_ORANGE};
						default {MAT_GREY};
					};
					_target setobjectmaterial [_hitselections select _id,_mat];
				};
			} foreach _selections;

			//--- Reset all textures after some time
			if (damage _target == 0) then {
				terminate (_target getvariable ["bis_fnc_VRHitParts_script",scriptnull]);
				_target setvariable [
					"bis_fnc_VRHitParts_script",
					_target spawn {
						_target = _this;
						sleep (_target getvariable ["bis_fnc_VRHitParts_delay",15]);
						if (isnull _target) exitwith {};

						//--- Play blinking effect
						_materials = getobjectmaterials _target;
						_selections = _target getvariable ["bis_fnc_VRHitParts_hitselections",[]];
						for "_i" from 0 to 10 do {
							{_target setobjectmaterial [_foreachindex,_x];} foreach _materials;
							sleep 0.05;
							{_target setobjectmaterial [_foreachindex,MAT_GREY];} foreach _materials;
							sleep 0.05;
						};

						//--- Reset damage
						_hitdamage = [];
						_hitalive = [];
						{
							_hitdamage pushback 0;
							_hitalive pushback true;
						} foreach _materials;
						_target setvariable ["bis_fnc_VRHitParts_hitdamage",_hitdamage];
						_target setvariable ["bis_fnc_VRHitParts_hitalive",_hitalive];
					}
				];
			};
		};
	} foreach _this;
};