_trigger = _this param [0,objnull,[objnull]];
if (isnil "hsim_noFlyZones") then {[] call bis_fnc_noFlyZonesCreate;};

if (player in list _trigger) then {
	_type = _this param [1,-1,[0]];
	_mode = _this param [2,true,[true]];

	switch _type do {{

		//--- Airport (D)
		case 0: {
		};

		//--- International Airport (B)
		case 1: {
		};

		//--- Restricted
		case 2: {
		};
	};

	};
};
