_mode = _this select 0;
_params = _this select 1;
_logic = _params select 0;

switch _mode do {
	//--- Some attributes were changed (including position and rotation)
	case "attributesChanged3DEN";

	//--- Added to the world (e.g., after undoing and redoing creation)
	case "registeredToWorld3DEN": {
		_ammo = _logic getvariable ["type",gettext (configfile >> "cfgvehicles" >> typeof _logic >> "ammo")];
		if (_ammo != "") then {

			//--- Delete previous projectile
			_projectile = _logic getvariable ["bis_fnc_moduleGrenade_projectile",objnull];
			deletevehicle _projectile;

			//--- Create new projectile
			if (is3DEN || (_logic getvariable ["repeat",0] > 0)) then {
				//--- Use projectile without expiration
				_ammoInfinite = _ammo + "_Infinite";
				if (isclass (configfile >> "cfgammo" >> _ammoInfinite)) then {_ammo = _ammoInfinite;};
			};
			_pos = getposatl _logic;
			_projectile = createvehicle [_ammo,_pos,[],0,"none"];
			_projectile setposatl _pos;

			if (is3DEN) then {
				//--- Save projectile for other use in 3DEN
				_logic setvariable ["bis_fnc_moduleGrenade_projectile",_projectile];
			} else {
				//--- Attach to logic, so it moves together with it
				_projectile attachto [_logic,[0,0,0]];

				//--- Wait until either logic or projectile disappears
				waituntil {
					sleep 1;
					isnull _projectile || isnull _logic
				};

				deletevehicle _projectile;
				deletevehicle _logic;
			};
		} else {
			["Cannot create projectile, 'ammo' config attribute is missing in %1",typeof _logic] call bis_fnc_error;
		};
	};

	//--- Removed from the world (i.e., by deletion or undoing creation)
	case "unregisteredFromWorld3DEN": {
		_projectile = _logic getvariable ["bis_fnc_moduleGrenade_projectile",objnull];
		deletevehicle _projectile;
	};

	//--- Default object init
	case "init": {
		_activated = _params select 1;
		_isCuratorPlaced = _params select 2;

		//--- Local to curator who placed the module
		if (_isCuratorPlaced && {local _x} count (objectcurators _logic) > 0) then {
			//--- Reveal the circle to curators
			_logic hideobject false;
			_logic setpos position _logic;
		};

		//--- Terminate on client, all effects are handled by server
		if !(isserver) exitwith {};

		//--- Call effects (not in 3DEN, "registeredToWorld3DEN" handler is called automatically)
		if (_activated && !is3DEN) then {
			["registeredToWorld3DEN",[_logic]] spawn bis_fnc_moduleGrenade;
		};
	};
};