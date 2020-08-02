_clear = _this param [0,false,[false]];

//--- Global
hsim_heliportDB = if (_clear) then {
	["HSim_heliportDB cleared"] call bis_fnc_log;
	[]
} else {
	profilenamespace getvariable ["hsim_heliportDB",[]];
};

//--- Local
if (isnil "hsim_heliportDBCampaign") then {hsim_heliportDBCampaign = []};

//--- Return status (true if not empty)
count hsim_heliportDB > 0