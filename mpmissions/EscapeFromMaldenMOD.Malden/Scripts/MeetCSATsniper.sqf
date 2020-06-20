/*
NNS
Create a CSAT sniper team into given radius. Create a meet tack if _taskID is set.

If this script is used to create a pseudo submission, it is highly recommanded to set _initialEmitterPos and _forestIgnoreAngle.
Setting both will allow the script to ignore forest on specified heading from _initialEmitterPos within a cone (_forestIgnoreAngle).
if _forestIgnoreAngle set to 0, this feature is ignored.

Example : [[2674,5837,0],["sniper"],player,1000,1500,[2889,3698,0],45] execVM 'MeetCSATsniper.sqf';

Example : [[2867,4993,0],["sniper"],player,100,300,[2889,3698,0],45] execVM 'MeetCSATsniper.sqf';

					

*/

params
[
	["_centerPos",[],[]],
	["_taskID",[],[]], //["task"] or ["task","parent_task"]
	["_taskOwner",objNull], //if not set, owner will be player group
	["_taskMinRadius",1000], //minimum sniper group location from center
	["_taskMaxRadius",1500], //maximum sniper group location from center
	["_initialEmitterPos",[],[]], //position of the initial creator
	["_forestIgnoreAngle",0] //ignore cone
];

if (count _centerPos < 2) exitWith {["MeetCSATsniper.sqf : position/dir needed"] call BIS_fnc_NNS_debugOutput;};

sniperSpeech = [ //speech array when hostages are freed
localize "STR_NNS_Escape_Objective_MeetCSATsniper_speech0",
localize "STR_NNS_Escape_Objective_MeetCSATsniper_speech1",
localize "STR_NNS_Escape_Objective_MeetCSATsniper_speech2",
localize "STR_NNS_Escape_Objective_MeetCSATsniper_speech3",
localize "STR_NNS_Escape_Objective_MeetCSATsniper_speech4",
localize "STR_NNS_Escape_Objective_MeetCSATsniper_speech5"
];

_tmptaskID = "objectiveMeetCSATsniper"; //bypass if no task id set
if (count _taskID > 0) then {_tmptaskID = _taskID select 0;}; //task name

if !([_tmptaskID] call BIS_fnc_taskExists) then { //task not exist
	_initialEmitterHeading = (((_initialEmitterPos select 1)-(_centerPos select 1)) atan2 ((_initialEmitterPos select 0)-(_centerPos select 0))); //heading from emiter
	_initialEmitterHeadingMin = _initialEmitterHeading-(_forestIgnoreAngle/2); _initialEmitterHeadingMax = _initialEmitterHeading+(_forestIgnoreAngle/2);
	
	//check if limits over/underflow -180/180deg, correct if so
	_overflow = false;
	if (_initialEmitterHeadingMin < -180) then {_initialEmitterHeadingMin = _initialEmitterHeadingMin+360; _overflow=true;};
	if (_initialEmitterHeadingMin > 180) then {_initialEmitterHeadingMin = _initialEmitterHeadingMin-360; _overflow=true;};
	if (_initialEmitterHeadingMax < -180) then {_initialEmitterHeadingMax = _initialEmitterHeadingMax+360; _overflow=true;};
	if (_initialEmitterHeadingMax > 180) then {_initialEmitterHeadingMax = _initialEmitterHeadingMax-360; _overflow=true;};
	
	_initialEmitterDist = _initialEmitterPos distance2D _centerPos;
	
	_initialEmitterPosMin = [
	(_centerPos select 0) + (_initialEmitterDist * cos(_initialEmitterHeadingMin)),
	(_centerPos select 1) + (_initialEmitterDist * sin(_initialEmitterHeadingMin)),
	0];
	
	_initialEmitterPosMax = [
	(_centerPos select 0) + (_initialEmitterDist * cos(_initialEmitterHeadingMax)),
	(_centerPos select 1) + (_initialEmitterDist * sin(_initialEmitterHeadingMax)),
	0];
	
	_forest = []; //store forest data
	_forest_final = []; //store final forest data
	_forestScoreMin = 0; //store minimum result
	_forestScoreMax = 0; //store maximum result
	_forestScoreMid = 0; //store median result
	
	for "_i" from 1 to 3 do { //forest detection retry loop
		_forestScoreMin = -999; _forestScoreMax = -999; //reset min/max result
		{
			if ((_x select 0) distance2D _centerPos > _taskMinRadius) then {
				_tmpPos = _x select 0;
				_tmpInCone = false;
				
				if !(_forestIgnoreAngle == 0) then { //cone angle defined
					_tmpHeading = (((_tmpPos select 1)-(_centerPos select 1)) atan2 ((_tmpPos select 0)-(_centerPos select 0))); //heading of current object
					if (_overflow && !(_tmpHeading < _initialEmitterHeadingMin && _tmpHeading > _initialEmitterHeadingMax)) then {_tmpInCone = true};
					if (!_overflow && (_tmpHeading > _initialEmitterHeadingMin && _tmpHeading < _initialEmitterHeadingMax)) then {_tmpInCone = true};
				};
				
				if !(_tmpInCone) then {
					if(_forestScoreMin == -999) then {_forestScoreMin = (_x select 1);}; //inital minimum result
					if(_forestScoreMax == -999) then {_forestScoreMax = (_x select 1);}; //inital maximum result
					
					if((_x select 1) < _forestScoreMin) then {_forestScoreMin = (_x select 1);}; //update minimum result
					if((_x select 1) > _forestScoreMax) then {_forestScoreMax = (_x select 1);}; //update maximum result
					_forest pushBack _x; //add current entry to forest list
				};
			};
		} forEach selectBestPlaces [_centerPos, _taskMaxRadius, "(forest) - (10 * meadow)", 50, 10]; //initial search for forest
		
		//if (count _forest == 0) then {systemChat format["Failed to detect forest, try %1", _i]; //something fail somewhere, retry
		if (count _forest > 0) then {
			_forestScoreMid = (_forestScoreMax + _forestScoreMin) / 2; //median result
			//systemChat format["count _forest: %1, _forestScoreMin: %2, _forestScoreMax: %3, _forestScoreMid: %4", count _forest, _forestScoreMin, _forestScoreMax ,_forestScoreMid]; //debug
			_i = 4; //exit loop
		};
	};
	
	//if (count _forest == 0) exitWith {systemChat "Failed to detect forest after 3 retry, exiting";}; //total fail
	
	{
		if ((_x select 1) >= _forestScoreMid) then {_forest_final pushBack _x;}; //over median, add current entry to forest final list
	} forEach _forest; //delete forest data under median value
	
	//systemChat format["count _forest_final: %1", count _forest_final]; //debug
	
	_forest = (selectRandom _forest_final) select 0; //pick up a random position
	
	//clean the area, 8m radius
	{_x hideObjectGlobal true;_x enableSimulationGlobal false;} forEach (nearestTerrainObjects [_forest, [], 6, false]); //terrain objects
	{deleteVehicle _x;} forEach (_forest nearObjects 6); //other objects
	
	_forestCampfire = 'Land_Campfire_F' createVehicle [0,0,0]; //create camp fire
	_forestCampfire setPosATL [_forest select 0,_forest select 1,0]; //set position
	_forestCampfire setDir (random 360); //random dir
	_forestCampfire setVectorUp surfaceNormal position _forestCampfire; //stick on ground
	
	//Create CSAT hostage group
	_grpCSAT = createGroup east;
	
	//Create units and set set there positions in building
	_unitCSAT01 = _grpCSAT createUnit ["O_sniper_F", [0,0,0], [], 0, "CAN_COLLIDE"];
	_unitCSAT01 setPosASL (AGLToASL ((_forestCampfire getPos [2 + (random 3),random 360])));
	 
	_unitCSAT02 = _grpCSAT createUnit ["O_Pathfinder_F", [0,0,0], [], 0, "CAN_COLLIDE"];
	_unitCSAT02 setPosASL (AGLToASL ((_forestCampfire getPos [2 + (random 3),random 360])));
	 
	_unitCSAT03 = _grpCSAT createUnit ["O_Sharpshooter_F", [0,0,0], [], 0, "CAN_COLLIDE"];
	_unitCSAT03 setPosASL (AGLToASL ((_forestCampfire getPos [2 + (random 3),random 360])));
	 
	_unitCSAT04 = _grpCSAT createUnit ["O_spotter_F", [0,0,0], [], 0, "CAN_COLLIDE"];
	_unitCSAT04 setPosASL (AGLToASL ((_forestCampfire getPos [2 + (random 3),random 360])));
	
	{
		_x setRank "PRIVATE"; _x setUnitRank "PRIVATE";  //set unit as private to avoid control taking when freed
		[_x,"sniper"] call BIS_fnc_NNS_AIskill; //set unit skill
		//_x setSkill ["AimingAccuracy",0.90]; //boost unit skill
		_x setCombatMode "WHITE"; //Hold Fire, Engage At Will
		
		_currentSpeech = selectRandom sniperSpeech; //select a speech
		sniperSpeech deleteAt (sniperSpeech find _currentSpeech); //remove selected speech from array
		
		[
			_x, //unit
			localize "STR_NNS_Escape_Salute", //displayed action title
			"img\holdAction_talk.paa", //icon when action not running
			"img\holdAction_talk.paa", //icon when action in progess
			"_this distance _target < 3 && alive _target && ((group _target) != (group _this))", //condition to allow action
			"_caller distance _target < 3 && alive _target && ((group _target) != (group _caller))", //condition to allow action to progess
			{}, //code executed when action starts
			{}, //code executed on every progress tick
			{
				[format["%1 (%2) : %3",name _target,gettext (configFile >> "CfgVehicles" >> typeOf _target >> "displayName"),(_this select 3) select 0]] remoteExec ["systemChat",0,true];
				{
					[group _x,behaviour leader group _caller] remoteExec ["setBehaviour",0,true];
					[_x,combatMode group _caller] remoteExec ["setCombatMode",0,true];
					[_x] remoteExec ["removeAllActions",0,true];
				} forEach (units group _target);
				[group _target,group player] spawn BIS_fnc_stalk;
				(group _target) setVariable ["meet",true,true];
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
	_grpCSAT setBehaviour "STEALTH";
	
	if (count _taskID > 0) then { //taskID is set
		if (isNull _taskOwner) then {_taskOwner = group player;}; //task owner set to player group
		[_taskOwner,_taskID,[localize "STR_NNS_Escape_Objective_MeetCSATsniper_desc",localize "STR_NNS_Escape_Objective_MeetCSATsniper_title",""],[_forest select 0,_forest select 1,0],"ASSIGNED",1,true,"talk"] call BIS_fnc_taskCreate;
		
		[_taskOwner,_taskID,_grpCSAT] spawn {
			_taskOwner = _this select 0; //task owner
			_task = (_this select 1) select 0; //task name
			_group = _this select 2; //CSAT group
			_groupunitcount = count (units _group); //units in group count
			_taskCompleted = false; _taskFailed = false; //trigger vars
			while {!_taskCompleted && !_taskFailed} do { //check loop
				sleep 5;
				_alive_units = {(alive _x)} count (units _group); //alive in CSAT group
				_group_meet = _group getVariable ["meet",false]; //is group meet
				if (_alive_units == 0) then {_taskFailed = true; [_task, "Failed"] remoteExec ["BIS_fnc_taskSetState",_taskOwner,true];}; //failed, all CSAT units are dead
				if (!_taskFailed && {_group_meet}) then {_taskCompleted = true; [_task, "Succeeded"] remoteExec ["BIS_fnc_taskSetState",_taskOwner,true];}; //all alive CSAT units no more in initial group
			};
		};
	};
};
