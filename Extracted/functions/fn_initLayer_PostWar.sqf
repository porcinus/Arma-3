params [
	["_mode","",[""]],
	["_objects",[],[[]]]
];

lolol = _objects;

switch _mode do {
	case "Init": {
		//--- Save the list of all default buildings so they can be damaged later (they are always visible)
		if (count _objects > 0) then {
			bis_orange_fnc_initLayer_EastWind_damageObjects = (nearestterrainobjects [_objects select 0,["House","Church"],500]) - _objects;

			{
				if (damage _x == 0) then {
					_x setdamage 0.5;
					for "_i" from 1 to 15 do {
						_hitpoint = format ["Glass_%1_hitpoint",_i];
						if (isnil {_x gethitpointdamage _hitpoint}) exitwith {};
						_x sethitpointdamage [_hitpoint,1];
					};
				};
			} foreach _objects;
		} else {
			bis_orange_fnc_initLayer_EastWind_damageObjects = [];
		};
	};
	case "Show": {
		{
			_x setdamage 0.5;
		} foreach bis_orange_fnc_initLayer_EastWind_damageObjects;

		//--- Disable bell tower so it doesn't make any sound
		{_x enablesimulation false;} foreach (nearestObjects [bis_oreokastro,["Church_F"],100]);

		(missionnamespace getvariable ["BIS_A1_Flag",objnull]) setflagtexture "";
	};
	case "Hide": {
		{
			_x setdamage 0;
		} foreach bis_orange_fnc_initLayer_EastWind_damageObjects;
	};
};