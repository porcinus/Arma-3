private ["_confirm"];
_confirm = [localize "STR_A3_TIME_TRIALS_CLEAR_STATS2", localize "STR_A3_FIRING_DRILLS_CLEAR_STATS1", true, true] call BIS_fnc_guiMessage;

waitUntil {!(isNil "_confirm")};

if (_confirm) then 
{
	"CONFIRMED" call BIS_fnc_log;
	
	private ["_cfgTimeTrials"];
	_cfgTimeTrials = configFile >> "CfgTimeTrials";

	for "_i" from 0 to ((count _cfgTimeTrials) - 1) do 
	{
		//TODO: relies on mission classes and this class to be the same (is not enforced?)
		private ["_class"];
		_class = _cfgTimeTrials select _i;
		if (isClass _class) then 
		{
			private ["_preFix"];
			_preFix = (configName _class) + "_" + (str 0) + "_0";
			
			profileNamespace setVariable [_preFix, nil];
		};
	};

	saveProfileNamespace;
};

true