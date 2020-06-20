/*
NNS
Set AI goup skill based on noPowerGrid global variable and night time, restore when day

Example: 
[[_grp01,_grp02]] call BIS_fnc_NNS_AInoPower;

*/

// Params
params
[
	["_groups",[]] //unit to set skill to
];

// Check for validity
if (count _groups == 0) exitWith {["BIS_fnc_NNS_AInoPower : No group selected"] call BIS_fnc_NNS_debugOutput;};

[_groups] spawn { //NNS: decrease enemy spoting ability if no power
	sleep 5;
	_groups = _this select 0; //recover groups
	_nightStart = 20.5 + (random 1); //limit queue
	_nightEnd = 3.5 + (random 1); //limit queue
	_skillDay = []; _skillNight = []; _selectedSkill = []; //init array
	_updated = false; //new state updated
	_lastState = false; //false :day, true:night/no power
	
	{
		if (isNull _x) then {_skillDay pushBack 0.5; //group not exist, add fake value
		}else{_skillDay pushBack ((leader _x) skillFinal "spotDistance");}; //group exist, get skill from leader
	} forEach (_groups); //extract each group leader skill
	
	for "_i" from 0 to ((count _groups) - 1) do {_skillNight pushBack ((_skillDay select _i) * 0.5);}; //generate night value
	
	_aliveUnits = 1; //all groups are alive
	while {_aliveUnits > 0} do { //loop
		_noPowerGrid = missionNamespace getVariable ["noPowerGrid",false]; //recover noPowerGrid global var
		_aliveUnits = 0;
		{_aliveUnits =_aliveUnits + ({(alive _x)} count (units _x));} forEach _groups; //alives in groups
		
		if (_noPowerGrid && _aliveUnits > 0) then {
			_night = [false,true] select (daytime > _nightStart || {daytime < _nightEnd}); //night time bool
			
			if !(_lastState isEqualTo _night) then {_updated = false;}; //state change
			
			if !(_updated) then { //need to update value
				if (_night) then {_selectedSkill = _skillNight; //night state
				} else {_selectedSkill = _skillDay;}; //day state
				
				for "_i" from 0 to ((count _groups) - 1) do { //group loop
					if !(isNull (_groups select _i)) then { //group exist
						{
							if (alive _x) then { //unit still alive
								_x setSkill ["spotDistance", (_selectedSkill select _i)]; //set unit skill
								_x setSkill ["spotTime", (_selectedSkill select _i)]; //set unit skill
							};
						} forEach units (_groups select _i);
					};
				};
				
				_updated = true; //values are updated
			};
			_lastState = _night; //update last state
		};
		sleep 5;
	};
};