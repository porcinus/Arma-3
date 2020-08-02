private ["_mission"];
_mission = _this param [0,"",[""]];

_mission = if (_mission != "") then {
	[hsim_heliportDBCampaign,["mission"],_mission] call bis_fnc_dbValueSet;
	_mission
} else {
	if (([] call bis_fnc_singleMissionName) != "") then {
		[] call bis_fnc_singleMissionName
	} else {
		[hsim_heliportDBCampaign,["mission"],missionName] call bis_fnc_dbValueReturn;
	};
};
_mission