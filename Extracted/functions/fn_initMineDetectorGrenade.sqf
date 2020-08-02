_grenade = _this select 6;
_side = side (_this select 0);
_type = typeof _grenade;
_pos = position _grenade;
_maxDetectDistance = 100;

//--- Wait until detonation
while {!isnull _grenade} do {
	_pos = position _grenade;
	sleep 0.01;
};

//--- Add the grenade so it can be used again
_holder = createvehicle ["GroundWeaponHolder",_pos,[],0,"can_collide"];
_holder addmagazinecargoglobal [gettext (configfile >> "CfgAmmo" >> _type >> "defaultMagazine"),1];

//--- Detect nearby mines
_mines = _pos nearobjects ['MineGeneric',_maxDetectDistance];
_mines = _mines apply {[_pos distance _x,_x]};
_mines sort true;

{
	if (random 1 > (0.25 * ((_x select 0) / _maxDetectDistance))) then {
		_side revealmine (_x select 1);
		sleep 0.01;
	};
} foreach _mines;