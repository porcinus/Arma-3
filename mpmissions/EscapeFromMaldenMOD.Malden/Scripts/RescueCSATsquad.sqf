/*
NNS
Create a barn at given position or use existing barn (50m radius detection from position) with CSAT hostages and NATO guard, create a tack if _taskID is set.
If the objective is a success and _taskIDsniper is set, a additionnal objective will be added to meet a CSAT sniper team.

_initialEmitterPos is position of the initial element that created the mission, this is used for sniper mission to avoid a position heading initial position.

Add to description.ext:
	class CfgTaskTypes {
		class RescueHostage {icon = "\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_secure_ca.paa";};
	};

Example : [[2674,5837,0],["rescue"],player,["sniper"],[1618,4663,0]] execVM 'RescueCSATsquad.sqf';
*/

params
[
	["_barnPos",[],[]], //[x,y,dir]
	["_taskID",[],[]], //["task"] or ["task","parent_task"]
	["_taskOwner",objNull], //if not set, owner will be player group
	["_taskIDsniper",[],[]], //["task"] or ["task","parent_task"]
	["_initialEmitterPos",[],[]] //position of the initial creator
];

if (count _barnPos < 3) exitWith {["RescueCSATsquad.sqf : position/dir needed"] call BIS_fnc_NNS_debugOutput;};

hostageSpeech = [ //speech array when hostages are freed
localize "STR_NNS_Escape_Objective_RescueCSATsquad_speech0",
localize "STR_NNS_Escape_Objective_RescueCSATsquad_speech1",
localize "STR_NNS_Escape_Objective_RescueCSATsquad_speech2",
localize "STR_NNS_Escape_Objective_RescueCSATsquad_speech3",
localize "STR_NNS_Escape_Objective_RescueCSATsquad_speech4",
localize "STR_NNS_Escape_Objective_RescueCSATsquad_speech5",
localize "STR_NNS_Escape_Objective_RescueCSATsquad_speech6",
localize "STR_NNS_Escape_Objective_RescueCSATsquad_speech7"
];

_barn = objNull;
_barnPos = [_barnPos select 0 ,_barnPos select 1 ,0]; //barn position
_barnDir = _barnPos select 2; //barn direction

//try to detect a existing barn
{
	if (typeOf _x in ["Land_Barn_01_brown_F","Land_Barn_01_grey_F"]) then {
		["RescueCSATsquad.sqf : existing barn detected"] call BIS_fnc_NNS_debugOutput;
		_barn = _x; _barnPos = getPosASL _x; _barnDir = getDir _x;
	};
} forEach (_barnPos nearObjects 50); //object detection loop

_tmptaskID = "objectiveRescueCSATsquad"; //bypass if no task id set
if (count _taskID > 0) then {_tmptaskID = _taskID select 0;}; //task name

if !([_tmptaskID] call BIS_fnc_taskExists) then { //task not exist
	if (_barn isEqualTo objNull) then { //not barn detected nearby
		_barn = "Land_Barn_01_brown_F" createVehicle _barnPos; //create barn 
		_barn setDir _barnDir; //set barn direction
	};
	
	//Create CSAT hostage group
	_grpCSAT = createGroup east;
	
	//Create units and set set there positions in building
	_unitCSAT01 = _grpCSAT createUnit ["O_officer_F", [0,0,0], [], 0, "CAN_COLLIDE"]; _unitCSAT01 setPosASL (AGLToASL (_barn buildingPos 4));
	_unitCSAT02 = _grpCSAT createUnit ["O_Soldier_HAT_F", [0,0,0], [], 0, "CAN_COLLIDE"]; _unitCSAT02 setPosASL (AGLToASL (_barn buildingPos 5));
	_unitCSAT03 = _grpCSAT createUnit [selectRandom ["O_Soldier_F","O_Soldier_TL_F"], [0,0,0], [], 0, "CAN_COLLIDE"]; _unitCSAT03 setPosASL (AGLToASL (_barn buildingPos 6));
	_unitCSAT04 = _grpCSAT createUnit [selectRandom ["O_HeavyGunner_F","O_Soldier_AR_F"], [0,0,0], [], 0, "CAN_COLLIDE"]; _unitCSAT04 setPosASL (AGLToASL (_barn buildingPos 10));

	{
		_x setRank "PRIVATE"; _x setUnitRank "PRIVATE";  //set unit as private to avoid control taking when freed
		_x setCaptive 1; //set as captive
		_x doWatch _barn; //force unit to look at building center
		_x switchMove (selectRandom ["Acts_AidlPsitMstpSsurWnonDnon01","Acts_AidlPsitMstpSsurWnonDnon02","Acts_AidlPsitMstpSsurWnonDnon03"]); //set animation as hostage
		[_x,"specops"] call BIS_fnc_NNS_AIskill; //set unit skill
		//_x setSkill ["AimingAccuracy",0.85]; //boost unit skill
		_x disableAI "RADIOPROTOCOL"; //disable ability to use radio
		_currentSpeech = selectRandom hostageSpeech; //select a freed speach
		hostageSpeech deleteAt (hostageSpeech find _currentSpeech); //remove selected speech from array
		[
			_x, //unit
			localize "STR_NNS_Escape_FreeHostage", //displayed action title
			"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_secure_ca.paa", //icon when action not running
			"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_unbind_ca.paa", //icon when action in progess
			"_this distance _target < 3 && alive _target", //condition to allow action
			"_caller distance _target < 3 && alive _target", //condition to allow action to progess
			{}, //code executed when action starts
			{}, //code executed on every progress tick
			{
				[format["%1 (%2) : %3",name _target,gettext (configFile >> "CfgVehicles" >> typeOf _target >> "displayName"),(_this select 3) select 0]] remoteExec ["systemChat",0,true];
				[_target,objNull] remoteExec ["doWatch",0,true];
				[_target,"Acts_AidlPsitMstpSsurWnonDnon_out"] remoteExec ["switchmove",0,true];
				[_target,"RADIOPROTOCOL"] remoteExec ["enableAI",0,true];
				[_target,0] remoteExec ["setCaptive",0,true];
			}, //code executed on completion
			{}, //code executed on interrupted
			[_currentSpeech], //arguments passed to the scripts as _this select 3
			1, //action duration [s]
			0, //priority
			true, //remove on completion
			false //chow in unconscious state 
		] remoteExec ["BIS_fnc_holdActionAdd", 0, _x]; //Create ability to be freed
	} forEach (units _grpCSAT); //CSAT unit loop

	_grpCSAT enableDynamicSimulation true;
	
	//Create NATO group
	_grpNato = createGroup west;
	
	//Create units and set set there positions in building
	_unitNato01 = _grpNato createUnit ["B_Soldier_SL_F", _barn buildingPos 3, [], 0, "CAN_COLLIDE"]; _unitNato01 setPosASL (AGLToASL (_barn buildingPos 3)); _unitNato01 setFormDir _barnDir+235;
	_unitNato02 = _grpNato createUnit [selectRandom ["B_HeavyGunner_F","B_Soldier_AR_F"], _barn buildingPos 2, [], 0, "CAN_COLLIDE"]; _unitNato02 setPosASL (AGLToASL (_barn buildingPos 2)); _unitNato02 setFormDir _barnDir+180;
	_unitNato03 = _grpNato createUnit [selectRandom ["B_Sharpshooter_F","B_Soldier_M_F"], _barn buildingPos 8, [], 0, "CAN_COLLIDE"]; _unitNato03 setPosASL (AGLToASL (_barn buildingPos 8)); _unitNato03 setFormDir _barnDir+345;
	_unitNato04 = _grpNato createUnit [selectRandom ["B_Soldier_LAT_F","B_Soldier_F"], _barn buildingPos 9, [], 0, "CAN_COLLIDE"]; _unitNato04 setPosASL (AGLToASL (_barn buildingPos 9)); _unitNato04 setFormDir _barnDir+260;
	_unitNato05 = _grpNato createUnit ["B_Soldier_F", _barn buildingPos 1, [], 1, "CAN_COLLIDE"]; _unitNato05 setPosASL (AGLToASL (_barn buildingPos 1)); _unitNato05 setFormDir (random 360);
	_unitNato06 = _grpNato createUnit ["B_engineer_F", _barn buildingPos 1, [], 4, "CAN_COLLIDE"]; _unitNato06 setPosASL (AGLToASL (_barn buildingPos 1)); _unitNato06 setFormDir (random 360);

	{_x setUnitPos "Up"; [_x] call BIS_fnc_NNS_AIskill;} forEach (units _grpNato); //Nato unit loop
	_grpNato setBehaviour "SAFE"; _grpNato setCombatMode "YELLOW";
	_grpNato enableDynamicSimulation true;
	
	//Create empty vehicle nearby
	_vehiPos = [_barnPos, 10, 50, 10, 0, 0.5, 0] call BIS_fnc_findSafePos; //safe place
	if (_barnPos distance2D _vehiPos > 10) then { //create vehicle is safe place found
		_vehi = createVehicle [selectRandom ["B_MRAP_01_gmg_F","B_MRAP_01_hmg_F","B_LSV_01_armed_F"], _vehiPos, [], 0, "NONE"];
		_vehi setDir (random 360); //set vehicle direction
	};
	
	if (count _taskID > 0) then { //taskID is set
		if (isNull _taskOwner) then {_taskOwner = group player;}; //task owner set to player group
		[_taskOwner,_taskID,[localize "STR_NNS_Escape_Objective_RescueCSATsquad_desc",localize "STR_NNS_Escape_Objective_RescueCSATsquad_title",""],[_barnPos select 0,_barnPos select 1,0],"ASSIGNED",1,true,"RescueHostage"] call BIS_fnc_taskCreate;
		
		[_taskOwner,_taskID,_grpCSAT,_taskIDsniper,_initialEmitterPos] spawn {
			_taskOwner = _this select 0; //task owner
			_task = (_this select 1) select 0; //task name
			_group = _this select 2; //CSAT group
			_groupUnits = units _group; //backup group units for sniper mission
			_groupPos = position leader _group; //backup group leader position, used for sniper mission radius
			_groupunitcount = count (units _group); //units in group count
			_taskCompleted = false; _taskFailed = false; //trigger vars
			while {!_taskCompleted && !_taskFailed} do { //check loop
				sleep 5;
				_alive_units = {(alive _x)} count (units _group); //alive in CSAT group
				_captive_units = {(captive _x && alive _x)} count (units _group); //captive and alive in CSAT group
				if (_alive_units == 0) then {_taskFailed = true; [_task, "Failed"] remoteExec ["BIS_fnc_taskSetState",_taskOwner,true];}; //failed, all CSAT units are dead
				if (!_taskFailed && {(_alive_units > 0 && _captive_units == 0)}) then {_taskCompleted = true; [_task, "Succeeded"] remoteExec ["BIS_fnc_taskSetState",_taskOwner,true];}; //all alive CSAT units no more in initial group
			};
			
			if (_taskCompleted && {count (_this select 3) > 0}) then { //rescue tack completed and sniper task id is set
				[_group,group player] spawn BIS_fnc_stalk; //group follow player group
				for "_i" from 1 to _groupunitcount do { //search for first alive unit
					if (alive (_groupUnits select _i)) then {
						[format["%1 (%2) : %3",name (_groupUnits select _i),gettext (configFile >> "CfgVehicles" >> typeOf (_groupUnits select _i) >> "displayName"),localize "STR_NNS_Escape_Objective_RescueCSATsquad_sniper_speech1"]] remoteExec ["systemChat",0,true];
						sleep 2;
						_initialEmitterPos = _this select 4; //recover emiter position
						_initialEmitterCone = 45; //default ignore cone
						if (count _initialEmitterPos == 0) then {_initialEmitterPos = [0,0,0];_initialEmitterCone = 0;}; //no emiter position, cone set to 0 to disable feature
						[[_groupPos,(_this select 3),_this select 0,750,1500,_initialEmitterPos,_initialEmitterCone], "Scripts\MeetCSATsniper.sqf"] remoteExec ["execVM", 0, true];
						_i = _groupunitcount+1; //overfow _i to kill loop
					};
				};
			};
		};
	};
};