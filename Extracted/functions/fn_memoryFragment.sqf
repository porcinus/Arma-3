#define WETDISTORTION_0(INTENSITY)\
[\
	1,\
	INTENSITY, INTENSITY,\
	4.10, 3.70, 2.50, 1.85,\
	0.005, 0.005, 0.005, 0.005,\
	0.5, 0.3, 10.0, 6.0\
]
#define WETDISTORTION_1(INTENSITY)\
[\
	1,\
	INTENSITY, INTENSITY,\
	8, 8, 8, 8,\
	0.005, 0.005, 0.005, 0.005,\
	0.0, 0.0, 1.0, 1.0\
]

#define ORDER\
	[\
		"bis_fragment_townsign",\
		"bis_fragment_aaf",\
		"bis_fragment_tree",\
		"bis_fragment_peacetalks",\
		"bis_fragment_idaplogistics",\
		"bis_fragment_hiker",\
		"bis_fragment_bodybags",\
		\
		"bis_fragment_familyhouse2",\
		"bis_fragment_blockade",\
		"bis_fragment_idaplocal",\
		"bis_fragment_role",\
		"bis_fragment_fiasupporters",\
		"bis_fragment_nato",\
		"bis_fragment_adams",\
		\
		"bis_fragment_aafmassacre",\
		"bis_fragment_brotherhouse",\
		"bis_fragment_cafe",\
		"bis_fragment_evacuation",\
		"bis_fragment_idapglobal",\
		"bis_fragment_earthquake",\
		"bis_fragment_siege1",\
		\
		"bis_fragment_siege2",\
		"bis_fragment_csat",\
		"bis_fragment_idapimpartiality",\
		"bis_fragment_hikerhouse",\
		"bis_fragment_castle",\
		"bis_fragment_gamification",\
		"bis_fragment_brothercar",\
		\
		"bis_fragment_brother",\
		"bis_fragment_fia",\
		"bis_fragment_infrastructure",\
		"bis_fragment_ambulance",\
		"bis_fragment_familyhouse1",\
		"bis_fragment_aan",\
		"bis_fragment_away",\
		\
		"bis_fragment_idapletters",\
		"bis_fragment_history",\
		"bis_fragment_dog",\
		"bis_fragment_natoinvasion",\
		"bis_fragment_pvtnelson",\
		"bis_fragment_eastwind",\
		"bis_fragment_hikerdead"\
	]

//#define DEBUG
params [
	["_input","",["",[]]],
	["_object",if !(isnil "this") then {this} else {objnull},[objnull]],
	["_condition","",[""]],
	["_area",[],[[]]],
	["_effectData",[],[[],0]]
];

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//--- Action effects
if (_input isequaltype []) exitwith {
	_input params [
		["_mode",""],
		["_this",[]]
	];
	_this params [
		["_object",objnull]
	];
	_input = _object getvariable ["bis_fragment",""];
	_isScenario = _object getvariable ["bis_isScenario",false];

	if (_isScenario) then {
		//--- Scenario trigger
		switch _mode do {
			case "Started": {
				if !(missionnamespace getvariable [format ["BIS_%1_action",_input],false]) then {
					missionnamespace setvariable [format ["BIS_%1_action",_input],true];
					bis_orange_scenarioTrigger_kb = [_input + "_trigger"] spawn bis_fnc_missionConversations;
				};
				"BIS_skip" cuttext [
					format [
						"<t font='RobotoCondensedBold' shadow='2'>%1</t>",
						localize "STR_A3_Orange_Campaign_memoryFragment_warning"
						//(["IGUI","WARNING_RGB"] call bis_fnc_displaycolorget) call bis_fnc_colorRGBtoHTML
					],
					"plain",0,false,true
				];
			};
			case "Progress": {
				//BIS_canSwitchPeriod = false;
				_progressTick = _this select 4;
				_coef = _progressTick / 24;

				playsound3d [((getarray (configfile >> "CfgSounds" >> "Orange_Action_Wheel" >> "sound")) param [0,""]) + ".wss",player,false,getposasl player,1,0.8 + 0.2 * _coef];

				BIS_PP_WetDistortion ppeffectadjust WETDISTORTION_0(_coef);
				BIS_PP_WetDistortion ppeffectcommit 0;

				BIS_PP_WetDistortion ppeffectadjust WETDISTORTION_1(_coef);
				BIS_PP_WetDistortion ppeffectcommit 0.2;
			};
			case "Interrupted": {
				//BIS_canSwitchPeriod = true;
				BIS_PP_WetDistortion ppeffectadjust WETDISTORTION_0(0);
				BIS_PP_WetDistortion ppeffectcommit 0.4;
				"BIS_skip" cuttext ["","plain"];
			};
			case "Completed": {
				showhud false;
				"BIS_memoryFragment" cuttext ["","black out",0.1];
				"BIS_skip" cuttext ["","plain"];
				player removeitem "MineDetector";
				sleep 0.1;
				5 fadesound 0;
				[_input,"SUCCEEDED"] call bis_fnc_taskSetState;
				waituntil {scriptdone (missionnamespace getvariable ["bis_orange_scenarioTrigger_kb",scriptnull])}; //--- Wait for trigger conversation to be finished
				[_input + "_in"] call bis_fnc_missionConversations;

				//--- Start the scenario
				endmission _input;
			};
			case "Blocked": {
				["BIS_Orange",true,nil,nil,nil,nil,true] call bis_fnc_setTask;
				[_input,true,nil,nil,"canceled",nil,false] call bis_fnc_setTask;
				[_input + "_blocked"] spawn bis_fnc_missionConversations;
				(_input + "_area") setmarkeralpha 0;

				//--- Mark as revealed
				_memoryFragmentsDone = missionnamespace getvariable ["BIS_memoryFragmentsDone",[]];
				_memoryFragmentsDone pushbackunique tolower _input;
				missionnamespace setvariable ["BIS_memoryFragmentsDone",_memoryFragmentsDone];
				savevar "BIS_memoryFragmentsDone";
			};
			case "Approach": {
				["BIS_Orange",true,nil,nil,nil,nil,false] call bis_fnc_setTask;
				[_input,true,nil,nil,true,nil,true] call bis_fnc_setTask;
				(_input + "_area") setmarkeralpha 0;
				if (_this param [1,true]) then {[_input + "_approach"] spawn bis_fnc_missionConversations;};
			};
			case "Timeout": {
				_time = time + 7 * 60;
				waituntil {
					sleep 1;
					time > _time || {_input in (player call BIS_fnc_tasksUnit)}
				};

				//--- Reveal the task
				if (time > _time) then {
					[["Approach",[_object,false]]] call bis_orange_fnc_memoryFragment;
				};
			};
		};
	} else {
		//--- Memory fragment
		switch _mode do {
			case "Progress": {
				_progressTick = _this select 4;
				if (_progressTick % 2 == 0) exitwith {};
				_coef = _progressTick / 24;

				playsound3d [((getarray (configfile >> "CfgSounds" >> "Orange_Action_Wheel" >> "sound")) param [0,""]) + ".wss",player,false,getposasl player,1,0.9 + 0.2 * _coef];

				if !(BIS_canSwitchPeriod) then {
					BIS_PP_WetDistortion ppeffectadjust WETDISTORTION_0(_coef);
					BIS_PP_WetDistortion ppeffectcommit 0;

					BIS_PP_WetDistortion ppeffectadjust WETDISTORTION_1(_coef);
					BIS_PP_WetDistortion ppeffectcommit 0.2;

					if (_progressTick == 23) then {cuttext ["","black out",0.05];};
				};
			};
			case "Interrupted": {
				if !(BIS_canSwitchPeriod) then {
					BIS_PP_WetDistortion ppeffectadjust WETDISTORTION_0(0);
					BIS_PP_WetDistortion ppeffectcommit 0.4;
					cuttext ["","plain",0];
				};
			};
			case "Completed": {
				//playsound ["Orange_MemoryFragment_Activated",true];

				#define AREA_SWITCH_START	0
				#define AREA_SWITCH_END		1.2

				//--- Switch to memory and handle switching back (only if manual switch is disabled)
				if !(BIS_canSwitchPeriod) then {
					[_input,_object] spawn {
						params ["_input","_object"];
						scriptname _input;

						[false,true,nil,true] call BIS_orange_fnc_switchPeriod;

						//--- Save position on which player switched
						if (_object getvariable ["bis_return",false]) then {
							_object setvariable ["bis_switchPos",[getposatl player,direction player]];
						};

						//--- Show hint about returning back
						if (_object getvariable ["bis_isManual",false]) then {
							[["Orange","MemoryFragment","Return"],nil,nil,1e10,"BIS_periodIsPost",true,true,nil,false] call bis_fnc_advHint;
						};

						//--- Unique effects
						switch _input do {

							//--- Replace hiker's body with a body bag
							case "bis_fragment_hikerdead": {

								//--- Move player to the prologue position
								player setpos [4857.92,21541.9,0];
								player setdir 244.912;
								selectnoplayer;
								selectplayer bis_eod;

								if (isnil "bis_hikerBag") then {
									//--- Consistent camera shot
									[[bis_cam_hikerDead_internal,bis_cam_hikerDead_external],player,6,nil,nil,-1] call bis_orange_fnc_camera;

									//--- Pack the hiker in a body bag
									bis_hikerBag = createvehicle ["Land_Bodybag_01_blue_F",position bis_hiker,[],0,"can_collide"];
									bis_hikerBag hideobject true;
									bis_hikerBag enablesimulation false;
									[bis_hikerBag,"Hub_Post"] call bis_orange_fnc_register;
									deletevehicle bis_hiker;
									bis_hikerWallet enablesimulation false;
									bis_hikerWallet setvariable ["BIS_defaultSimulation",false];
									bis_hikerWallet setpos (bis_hikerbag modelToWorld [0,0.27,0.11]);
									bis_hikerWallet setvectordirandup [[0.939693,0.34202,0],[0,0.1,1]];
									{_x setpos position bis_hikerWallet;} foreach ([_object] + ((_object getvariable ["bis_effects",[]]) apply {_x select 0}));
								};
							};
							case "bis_fragment_earthquake": {

							};
						};

						_area = _object getvariable "bis_area";
						_coef = 0;
						waituntil {
							if !(BIS_periodIsPost) then { //--- Cannot be exitWith, because it never exits for mysterious reasons
								_areaDistance = [_area,player,true] call bis_fnc_inTrigger;
								_coef = linearconversion [AREA_SWITCH_START,AREA_SWITCH_END,_areaDistance,0,1,true];
								BIS_PP_WetDistortion ppeffectadjust WETDISTORTION_0(_coef);
								BIS_PP_WetDistortion ppeffectcommit 0.1;
								sleep 0.1;
								if (_coef > 0) then {
									BIS_PP_WetDistortion ppeffectadjust WETDISTORTION_1(_coef);
									BIS_PP_WetDistortion ppeffectcommit 0.1;
									sleep 0.1;
								};
							};
							_coef == 1 || BIS_periodIsPost || BIS_canSwitchPeriod
						};
						if (!BIS_periodIsPost && !BIS_canSwitchPeriod) then {[true,true] call BIS_orange_fnc_switchPeriod;};

						//--- Restore position on which player switched (todo: Only when there is a mine around?)
						if !(isnil {_object getvariable "bis_switchPos"}) then {
							waituntil {!BIS_isSwitchingPeriod};
							(_object getvariable ["bis_switchPos",[getposatl player,direction player]]) params ["_switchPos","_switchDir"];
							player setposatl _switchPos;
							player setdir _switchDir;
							_object getvariable ["bis_switchPos",nil];
						};
					};
				};

				//--- Mark as played
				_memoryFragmentsDone = missionnamespace getvariable ["BIS_memoryFragmentsDone",[]];
				_first = !(_input in _memoryFragmentsDone);
				_memoryFragmentsDone pushbackunique _input;
				missionnamespace setvariable ["BIS_memoryFragmentsDone",_memoryFragmentsDone];
				savevar "BIS_memoryFragmentsDone";

				//--- First encounter
				if (_first) then {
					_object setvariable ["bis_done",true];
					_object spawn {

						//--- Play conversation
						_input = _this getvariable "bis_fragment";
						[_input,true] call bis_fnc_missionConversations;
						[["Log",[_this]]] call bis_orange_fnc_memoryFragment;

						sleep 2;
						[["UnlockAll"]] call bis_orange_fnc_memoryFragment;
					};

					//--- Reveal another memory
					[["ShowNext",[nil,_input]]] call bis_orange_fnc_memoryFragment;
					//_memoryFragments = (missionnamespace getvariable ["BIS_memoryFragments",[]]) select {!(_x getvariable ["bis_done",false])};
					//if (count _memoryFragments > 0 && {BIS_nextMemoryFragment == "" || BIS_nextMemoryFragment == _input}) then {
					//	_memoryFragments = _memoryFragments apply {[_x distance _object,_x]};
					//	_memoryFragments sort false;
                                        //
					//	//--- Highlight next marker
					//	BIS_nextMemoryFragment = ((_memoryFragments select 0) select 1) getvariable "bis_fragment";
					//	BIS_nextMemoryFragment setmarkercolor "coloryellow";
					//	BIS_nextMemoryFragment setmarkeralpha 1;
					//};

					//--- Change current marker
					_input setmarkercolor "colorwhite";
					_input setmarkeralpha 0.5;
				};
			};
			case "ShowNext": {
				_input = param [1,"",[""]]; //--- Input is passed directly, because it's only thing available persistently
				_refresh = param [2,false,[false]];
				if (_input == "") exitwith {};
				//_memoryFragments = (missionnamespace getvariable ["BIS_memoryFragments",[]]) select {!(_x getvariable ["bis_done",false])};
				_memoryFragments = ORDER - (missionnamespace getvariable ["BIS_memoryFragmentsDone",[]]);
				if (count _memoryFragments > 0 && {BIS_nextMemoryFragment == "" || BIS_nextMemoryFragment == _input}) then {
					//_memoryFragments = _memoryFragments apply {[_x distance bis_oreokastro,_x]};
					//_memoryFragments sort false;

					//--- Highlight next marker
					//BIS_nextMemoryFragment = ((_memoryFragments select 0) select 1) getvariable "bis_fragment";
					if !(_refresh) then {BIS_nextMemoryFragment = _memoryFragments select 0;};
					BIS_nextMemoryFragment setmarkercolor "coloryellow";
					BIS_nextMemoryFragment setmarkeralpha 1;
					savevar "BIS_nextMemoryFragment";
				};
			};
			case "Log": {

				//--- Add a log entry, so player can replay the conversation
				_memoryFragments = missionnamespace getvariable ["BIS_memoryFragments",[]];
				if !(player diarysubjectexists "bis_memoryFragments") then {
					player creatediarysubject ["bis_memoryFragments", localize "STR_A3_Orange_Campaign_memoryFragment_diarySubject"];
				};
				player createDiaryRecord [
					"bis_memoryFragments",
					[
						format [localize "STR_A3_Orange_Campaign_memoryFragment_diaryRecord",(ORDER find _input) + 1],
						format [
							"<font color='#ffffffff' size='14' face='RobotoCondensedLight'><marker name='%1'><img width='14' height='14' image='\A3\ui_f\data\map\diary\icons\diaryLocateTask_ca.paa' />%3</marker></font><br /><br /><font size='20'><br />%2</font>",
							_input,
							createDiaryLink ["bis_orange_kb",bis_orange_kbRecordLast,localize "str_a3_orange_kbtell_transcript"],
							localize "STR_A3_Locate"
						]
					]
				];

			};
			case "UnlockAll": {
				//--- All available ones unlocked
				_memoryFragments = missionnamespace getvariable ["BIS_memoryFragments",[]];
				_memoryFragmentsDone = +(missionnamespace getvariable ["BIS_memoryFragmentsDone",[]]);
				_memoryFragmentsDone = _memoryFragmentsDone - bis_orange_missions; //--- Remove scenario fragments

				//--- Unlock only in the last Oreokastro instance
				if (bis_missionID >= 6 && {count _memoryFragmentsDone == count ORDER}) then {
				
					//--- All unlocked - delete fragments and their markers
					setstatvalue ["OrangeCampaignComplete",1];
					["bis_fragment_all"] call bis_fnc_missionConversations;
					{
						_input = _x getvariable "bis_fragment";
						_input setmarkersize [0,0];
						{deletevehicle (_x select 0)} foreach (_x getvariable ["bis_effects",[]]);
						deletevehicle _x;
					} foreach _memoryFragments;
					[true,false] call bis_orange_fnc_switchPeriodEnable;
					[["Orange","MemorySwitch"],nil,nil,nil,nil,true,true,nil,false] call bis_fnc_advHint;
					playsound ["Orange_PeriodSwitch_Notification",true];
				};
			};
			case "UnlockDebug": {
				{
					_x setvariable ["bis_done",true];
					_input = _x getvariable "bis_fragment";
					_input setmarkercolor "colorwhite";
					_input setmarkeralpha 0.5;
					BIS_memoryFragmentsDone pushbackunique _input;
				} foreach (BIS_memoryFragments - [BIS_memoryFragments select 0]);
			};
			case "Init": {
				{
					_x call bis_orange_fnc_memoryFragment;
				} foreach (missionnamespace getvariable ["BIS_memoryFragmentsExec",[]]);
				{
					["",_x] call bis_orange_fnc_memoryFragment;
				} foreach ((getmissionlayerentities "Memory Fragments" select 0) select {!(_x iskindof "EmptyDetector")});
				if (BIS_nextMemoryFragment isequaltype objnull) then {BIS_nextMemoryFragment = BIS_nextMemoryFragment getvariable ["bis_fragment",""]}; //--- Backward compatibility, variable used to be of type object
				[["ShowNext",[nil,BIS_nextMemoryFragment,true]]] call bis_orange_fnc_memoryFragment; //--- Restore hint about the next fragment
			};
			case "Loaded": {
				{
					_x setmarkercolor "colorwhite";
					_x setmarkeralpha 0.5;
				} foreach (missionnamespace getvariable ["BIS_memoryFragmentsDone",[]]);
				[["ShowNext",[nil,BIS_nextMemoryFragment,true]]] call bis_orange_fnc_memoryFragment;
			};
		};
	};
};

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//--- Only register before all systems are initialized
if !(bis_orange_init) exitwith {
	_fragments = missionnamespace getvariable ["BIS_memoryFragmentsExec",[]];
	_fragments pushback [_input,_object,_condition,_area,_effectData];
	missionnamespace setvariable ["BIS_memoryFragmentsExec",_fragments];
};

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#ifndef DEBUG
	if (_object iskindof "Helper_Base_F") then {
		_object setobjecttexture [0,"#(argb,8,8,3)color(0,0,0,0)"];
	};
#endif

//--- Save ID
if (_input == "") then {_input = vehiclevarname _object;};
_input = tolower _input;

//--- Get status
private _nextScenario = bis_orange_missions select ((bis_orange_missions find tolower BIS_previousMission) + 1);
private _isScenario = (tolower _input) in bis_orange_missions;
if (_condition == "") then {_condition = _object getvariable ["bis_condition",""];};
private _show = if (_condition != "") then {missionnamespace getvariable [format ["BIS_%1_Done",_condition],false]} else {true};
private _memoryFragmentsDone = missionnamespace getvariable ["BIS_memoryFragmentsDone",[]];
private _done = _input in _memoryFragmentsDone;
_object setvariable ["bis_fragment",_input];
_object setvariable ["bis_isScenario",_isScenario];
_object setvariable ["bis_pos",getposatl _object];

//--- Evaluate conditions
if (_isScenario) then {

	_show = !(missionnamespace getvariable [format ["BIS_%1_Done",_input],true]);
	_markerSize = 15;
	_pos = getposatl _object;
	//_pos resize 2;
	//_pos = _pos getpos [(0 random _pos) * _markerSize / 2,(1 random _pos) * 360];
	if (!_show || _done) then {["BIS_Orange",true,nil,nil,nil,nil,false] call bis_fnc_setTask;};
	[
		[_input,"BIS_Orange"],
		!_show || _done,
		if (!_show) then {_input + "_Done"} else {_input},
		_pos,
		if (_show) then {"CREATED"} else {"SUCCEEDED"},
		nil,
		false,
		nil,
		if (_show) then {"unknown"} else {_input}
	] call bis_fnc_setTask;

	if (_show && !_done) then {
		_markerArea = createmarker [_input + "_area",_pos];
		_markerArea setmarkersize [_markerSize,_markerSize];
		_markerArea setmarkershape "ellipse";
		_markerArea setmarkerbrush "solidborder";
		_markerArea setmarkercolor "coloryellow";
		_markerArea setmarkeralpha 0.5;
	};

	//--- Continue only when the scenario follows next
	_show = _show && {_input == _nextScenario};
};

//--- Condition not met, terminate
if !(_show) exitwith {
	_object setpos (position _object vectoradd [0,0,-10]); //--- Move the sphere underground so it doesn't block other spheres
};

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//--- Register
if !(_isScenario) then {
	_memoryFragments = missionnamespace getvariable ["BIS_memoryFragments",[]];
	_memoryFragments pushback _object;
	missionnamespace setvariable ["BIS_memoryFragments",_memoryFragments];

	//--- Save status
	_object setvariable ["bis_done",_done];

	//--- Get custom memory area
	_trigger = missionnamespace getvariable [_input + "_area",objnull];
	if !(isnull _trigger) then {
		_area = [getposatl _trigger,triggerarea _trigger];
		deletevehicle _trigger;
	} else {
		_area = [getposatl _object,_object getvariable ["bis_area",[5,5,0,false,-1]]];
	};
	_object setvariable ["bis_area",_area];

	//--- Create marker
	createmarker [_input,position _object];
	_input setmarkertype "memoryFragment";
	_input setmarkercolor "colorwhite";
	_input setmarkersize [0.5,0.5];
	if (_done) then {
		_input setmarkeralpha 0.5;
		[_input,false] call bis_fnc_missionConversations;
		[["Log",[_object]]] call bis_orange_fnc_memoryFragment;
	} else {
		_input setmarkeralpha 0;
	};
};

//--- Remove previous instance (used for debugging)
_effects = _object getvariable ["bis_effects",[]];
if (count _effects > 0) then {
	{deletevehicle (_x select 0)} foreach _effects;
	{_object removeaction _x;} foreach (actionIDs _object);
};

//--- Create particle effect
_effectData params [
	["_effectSize",1.5,[0]],
	["_effectOffset",[0,0,0],[[]]]
];
private _effect = createvehicle ["#particlesource",getposatl _object,[],0,"can_collide"];
_effect setParticleParams [
	#ifdef DEBUG
		["\A3\data_f\ParticleEffects\Universal\Universal",16,7,48,1],
	#else
		["\A3\data_f\ParticleEffects\Universal\Refract",1,0,1,0],
	#endif
	"",
	"Billboard",
	1,
	0.2,
	[0,0,0],
	[0,0,0],
	1,
	1.275,
	1,
	0,
	[_effectSize],
	[[0,0,0,0.0],[0,0,0,0.5],[0,0,0,0.0]],
	[1],
	0.1,
	0.05,
	"",
	"",
	"",
	0,
	false,
	0,
	[]
];
_effect setParticleRandom [
	0,
	[0,0,0],
	[0,0,0],
	1,
	0.1,
	[0,0,0,0],
	0,
	0,
	1,
	0
];
_effect setDropInterval 0.01;
_effects = [[_effect,0.01]];

//--- Create light
private _light = createvehicle ["#lightpoint",getposatl _object,[],0,"can_collide"];
_light setlightambient [0.05,0.05,0.05]; 
_light setlightcolor [0.2,0.2,0.2];
_light setlightbrightness 200;
_light setLightAttenuation [0,100,100,0,0.1,1];
_light setlightdaylight true;
_effects pushback [_light,200];

//--- Scenario specific effect
_layer = _object getvariable "bis_layer";
if (_isScenario) then {
	_light setlightambient [0.025,0.05,0.075];//[0.2,0.15,0.05];
	_light setlightcolor [0.25,0.5,0.75];//[1,0.75,0.25];
	if (_input in ["orange_leaflets","orange_cluster"]) then {
		_light setLightAttenuation [0,500,100,0,0.1,1.5];
	};

	//private _lightScenario = createvehicle ["#lightpoint",getposatl _object,[],0,"can_collide"];
	//_lightScenario setlightbrightness 15;
	//_lightScenario setlightambient [0,1,0];
	//_lightScenario setlightcolor [0,1,0];
	//_lightScenario setLightAttenuation [0,4,4,0,1,2]; //[start, constant, linear, quadratic, hardlimitstart, hardlimitend]: Array

	private _effectScenario = createvehicle ["#particlesource",getposatl _object,[],0,"can_collide"];
	_effectScenario setParticleParams [
		//["\A3\data_f\ParticleEffects\Universal\Universal",16,14,5,1],
		//["\A3\data_f\ParticleEffects\Universal\Universal",16,12,16,0],
		//["\A3\data_f\ParticleEffects\Universal\Universal",16,15,15,1],
		["\A3\data_f\ParticleEffects\Universal\Refract",1,0,1,0],
		"",
		"Billboard",
		1,
		1,
		[0,0,0],
		[0,0,1],
		1,
		1.275,
		1,
		0,
		[_effectSize * 10],
		[[1,1,1,0.0],[1,1,1,0.5],[1,1,1,0.0]],
		[1000],
		0.1,
		0.05,
		"",
		"",
		"",
		0,
		false,
		0,
		[]
	];
	_effectScenario setParticleRandom [
		0,
		[0.1,0.1,0],
		[0,0,0],
		1,
		0.1,
		[0,0,0,0.1],
		0,
		0,
		1,
		0
	];

	_effectScenario setDropInterval 7;
	_effects pushback [_effectScenario,7];

	//--- Sound for scenario specific fragment
	//[["Sound_MemoryFragment_" + _input,position _object],_layer] call bis_orange_fnc_registerEffect;
	_effects pushback ["Sound_MemoryFragment_" + _input,getposatl _object];
};

//--- Sound
//[["Sound_MemoryFragment",position _object],_layer] call bis_orange_fnc_registerEffect;
_effects pushback ["Sound_MemoryFragment",getposatl _object];

//--- Attach to object (if it's simulated)
if !(isnull group _object) then {
	{
		_x attachto [_object,_offset];
	} foreach _effects;
};

//--- Save attached effects
_object setvariable ["bis_effects",_effects];
{
	[_x,_layer] call bis_orange_fnc_registerEffect;
} foreach _effects;

//--- Action
if (_isScenario && {_input != BIS_nextMission}) exitwith {}; //--- Terminate when the scenario trigger is not active yet (but keep the effect)

_actionTitle = localize "STR_A3_Orange_Campaign_memoryFragment_action";
_actionIcon = "\a3\UI_F_Orange\Data\CfgOrange\Missions\action_fragment_ca.paa";
if (_isScenario) then {
	_actionTitle = format [localize "STR_A3_Orange_Campaign_memoryFragment_play",toupper gettext (missionconfigfile >> "CfgOrange" >> "Missions" >> _input >> "actionName")];
	_actionIcon = gettext (missionconfigfile >> "CfgOrange" >> "Missions" >> _input >> "actionIcon");
};
_actionDistance = _object getvariable ["bis_distance",if (_isScenario) then {3} else {4}];
[
	//--- 0: Target
	_object,

	//--- 1: Title
	_actionTitle,

	//--- 2: Idle Icon
	_actionIcon,

	//--- 3: Progress Icon
	_actionIcon,

	//--- 4: Condition Show
	format ["_this distance _target < %1 && {cameraon == player}",_actionDistance],

	//--- 5: Condition Progress
	"!BIS_isSwitchingPeriod",

	//--- 6: Code Start
	{[["Started",_this]] call BIS_Orange_fnc_memoryFragment;},

	//--- 7: Code Progress
	{[["Progress",_this]] call BIS_Orange_fnc_memoryFragment;},

	//--- 8: Code Completed
	{[["Completed",_this]] spawn BIS_Orange_fnc_memoryFragment;},

	//--- 9: Code Interrupted
	{[["Interrupted",_this]] call BIS_Orange_fnc_memoryFragment;},

	//--- 10: Arguments
	[],

	//--- 11: Duration
	if (_isScenario) then {4} else {0.5},

	//--- 12: Priority
	nil,

	//--- 13: Remove When Completed
	false
] call bis_fnc_holdActionAdd;