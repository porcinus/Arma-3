#define AREAS (_vehicle getvariable ["BIS_FireAreaRestricted_Triggers",synchronizedobjects _vehicle select {_x iskindof "EmptyDetector"}])

params [
	["_vehicle",objnull,[objnull]],
	["_weapon","",[""]],
	["_muzzle","",[""]],
	["_mode","",[""]],
	["_ammo","",[""]],
	["_magazine","",[""]],
	["_projectile",objnull,[objnull]]
];

//--- Apply only when enabled by editor attribute or custom variable
if (
	(_vehicle getvariable ["BIS_FireAreaRestricted",false]) param [0,false,[false]]
) then {
	if (
		{_vehicle inarea _x} count AREAS == 0
	) then {

		//--- Delete the projectile and restore it on the vehicle
		deletevehicle _projectile;
		{
			if (_x == _magazine) then {
				_vehicle setammoonpylon [_foreachindex + 1,(_vehicle ammo _weapon) + 1];
			};
		} foreach getPylonMagazines _vehicle;

		//--- Show warning
		["WarningFireAreaRestricted"] call bis_fnc_showNotification
	} else {

		//--- Delete the bomb when it falls outside of the area
		[_vehicle,_projectile] spawn {
			scriptname "BIS_fnc_firedBombDemine: Projectile";
			params ["_vehicle","_projectile"];

			//--- Detect sub-ammo
			_pos = position _projectile;
			waituntil {
				_xPos = position _projectile;
				if (_xPos distance [0,0,0] > 1) then {_pos = +_xPos; false} else {true};
			};
			_projectile = (_pos nearobjects ["BombDemine_01_SubAmmo_F",10]) param [0,objnull];

			waituntil {vectormagnitude velocity _projectile < 1};
			if ({_projectile inarea _x} count AREAS == 0) then {
				deletevehicle _projectile;

				//--- Show warning
				["WarningFireAreaRestrictedDetonate"] call bis_fnc_showNotification
			};
		};
	};
};