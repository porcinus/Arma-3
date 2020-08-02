private ["_config","_param","_condition"];
_config =		_this param [0,configfile,[configfile]];
_param =		_this param [1,"",[""]];
_condition = gettext (_config >> _param);

if (_condition == "") then {
	_condition = str (_param != "hide") //--- Don't hide by default
};
_condition

/*

if (_condition == "") then {
	_condition = str (_param != "hide") //--- Don't hide by default
} else {
	private ["_checkMission","_returnMission"];
	_checkMission =		_this param [2,true,[true]];
	_returnMission =	_this param [3,false,[true]];

	if (_checkMission && _param != "enable") then {
		if (_condition in (true call bis_fnc_heliportMissionList)) then {
			_condition = if (_returnMission) then {
				campaignconfigfile >> "Campaign" >> "Missions" >> _condition
			} else {
				str (_condition in ([] call bis_fnc_heliportMissionList))
			};
		} else {
			"false"
		};
	};
};
_condition
*/