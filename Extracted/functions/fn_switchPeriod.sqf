#define WETDISTORTION_0\
[\
	1,\
	0, 0,\
	4.10, 3.70, 2.50, 1.85,\
	0.005, 0.005, 0.005, 0.005,\
	0.5, 0.3, 10.0, 6.0\
]
#define WETDISTORTION_1\
[\
	1,\
	1, 1,\
	8, 8, 8, 8,\
	0.005, 0.005, 0.005, 0.005,\
	0.0, 0.0, 1.0, 1.0\
]

//--- Init
_isInit = isnil "BIS_periodIsPost";
if (_isInit) then {

	if (isnil "BIS_player2") then {BIS_player2 = player;};
	BIS_loadout = getunitloadout BIS_player2;
	deletevehicle BIS_player2;
	BIS_switchPeriodEnabled = false;
	BIS_periodIsPost = false;
	BIS_canSwitchPeriod = false;
	BIS_isSwitchingPeriod = false;

	BIS_PP_ColorCorrectionsPre = ppEffectCreate ["Colorcorrections",1611];
	BIS_PP_ColorCorrectionsPre ppeffectenable false;
	BIS_PP_ColorCorrectionsPre ppeffectadjust [1,1.1,0,[0,1,1,0.0],[1,1,1,1.21],[0,0.5,0.5,0]];//[1,1,0,[0,1,1,0.0],[1,1,1,1.21],[0.07,0.07,0.07,0]];
	BIS_PP_ColorCorrectionsPre ppeffectcommit 0;

	//BIS_PP_ColorCorrectionsPreVignette = ppEffectCreate ["Colorcorrections",1612];
	//BIS_PP_ColorCorrectionsPreVignette ppeffectenable false;
	//BIS_PP_ColorCorrectionsPreVignette ppeffectadjust [1,1,0,[0,1,1,0.0],[1,1,1,1.21],[0.07,0.07,0.07,0]];
	//BIS_PP_ColorCorrectionsPreVignette ppeffectcommit 0;

	BIS_PP_ColorCorrectionsPost = ppEffectCreate ["Colorcorrections",1613];
	BIS_PP_ColorCorrectionsPost ppeffectenable false;
	BIS_PP_ColorCorrectionsPost ppeffectadjust [1,1,-0.06,[0,0.4,1,0.03],[1,1,1,0.85],[0.75,0.25,0,1]];
	BIS_PP_ColorCorrectionsPost ppeffectcommit 0;

	BIS_PP_Vignette = ppeffectcreate ["colorCorrections",1896];
	BIS_PP_Vignette ppeffectenable false;
	BIS_PP_Vignette ppeffectadjust [1,1,0,[0,0,0,0.5],[1,1,1,1],[0,0,0,0],[0.8,0.75,0,0,0,0.5,1]];
	BIS_PP_Vignette ppeffectcommit 0;

	BIS_PP_RadialBlur = ppEffectCreate ["RadialBlur",112];
	BIS_PP_RadialBlur ppeffectenable false;
	BIS_PP_RadialBlur ppeffectadjust [0.005, 0.005, 0.225, 0.35];
	BIS_PP_RadialBlur ppeffectcommit 0;

	BIS_PP_WetDistortion = ppEffectCreate ["WetDistortion",300];
	BIS_PP_WetDistortion ppeffectenable true;
	BIS_PP_WetDistortion ppeffectadjust WETDISTORTION_0;
	BIS_PP_WetDistortion ppeffectcommit 0;

	BIS_PP_Pre = [BIS_PP_ColorCorrectionsPre,BIS_PP_Vignette,BIS_PP_RadialBlur];
	BIS_PP_Post = [BIS_PP_ColorCorrectionsPost];

	_fnc_initSwitch = {
		[] spawn {
			_idd = if (bis_orange_isIntro) then {0} else {46};
			waituntil {!isnull (finddisplay _idd)}; //--- Mission display not available instantly after Resuming
			if !((finddisplay _idd) getvariable ["BIS_switchPeriodInit",false]) then {
				(finddisplay _idd) setvariable ["BIS_switchPeriodInit",true];
				(finddisplay _idd) displayaddeventhandler [
					"keydown",
					{
						if ((_this select 1) in (actionkeys "teamSwitch")) exitwith {
							[] spawn BIS_Orange_fnc_switchPeriod;
							true
						};
						false
					}
				];
			};
		};
	};
	[] call _fnc_initSwitch;
	addmissioneventhandler ["loaded",_fnc_initSwitch];
	enableTeamSwitch false;

	//--- To memory
	_title = localize "STR_A3_Orange_Campaign_memoryFragment_action";
	_actionID = player addaction [
		_title,
		{
			[false] spawn BIS_Orange_fnc_switchPeriod;
		},
		[],
		1000,
		false,
		true,
		"action",
		"BIS_periodIsPost && {BIS_canSwitchPeriod && {savingenabled}}",
		3
	];
	player setUserActionText [
		_actionID,
		_title,
		"<img size='3' shadow='0' color='#ffffffff' image='\A3\Ui_f\data\IGUI\Cfg\HoldActions\progress\progress_0_ca.paa'/>",
		"<img size='3' color='#ffffff' image='\a3\UI_F_Orange\Data\CfgOrange\Missions\action_fragment_ca.paa'/><br/><br/>" + _title
	];

	//--- From memory
	_title = localize "str_a3_boot_m02_bis_return2_title";
	_actionID = player addaction [
		_title,
		{
			[true] spawn BIS_Orange_fnc_switchPeriod;
		},
		[],
		1000,
		false,
		true,
		"action",
		"!BIS_periodIsPost && {savingenabled}",
		3
	];
	player setUserActionText [
		_actionID,
		_title,
		"<img size='3' shadow='0' color='#ffffffff' image='\A3\Ui_f\data\IGUI\Cfg\HoldActions\progress\progress_0_ca.paa'/>",
		"<img size='3' color='#ffffff' image='\a3\UI_F_Orange\Data\CfgOrange\Missions\action_fragment_back_ca.paa'/><br/><br/>" + _title
	];
};
private _force = param [1,false,[false]];
private _skipEffect = param [3,false,[false]];

//--- Saving is disabled during cutscenes, use it also for disabling period switching
if (!savingenabled && !_force && !bis_orange_isIntro) exitwith {};

//--- Terminate when transition is already happening
if (BIS_isSwitchingPeriod) exitwith {};
BIS_isSwitchingPeriod = true;

//--- Check if player can switch, terminate otherwise
if !(//--- Negate conditions!
	_force //--- Always allow when forced
	||
	{
		!BIS_switchPeriodEnabled && !BIS_periodIsPost //--- Allow switching back from memory when custom switch is not enabled yet
		||
		{BIS_canSwitchPeriod && {player == cameraon && {!(position player inpolygon BIS_churchPolygon)}}} //--- Conditions for custom switch
	}
) exitwith {
	BIS_isSwitchingPeriod = false;
	//if !(BIS_switchPeriodEnabled) exitwith {};

	playsound [selectrandom ["Orange_PeriodSwitch_Disabled_01","Orange_PeriodSwitch_Disabled_02","Orange_PeriodSwitch_Disabled_03"],true];
	BIS_PP_WetDistortion ppeffectadjust WETDISTORTION_1;
	BIS_PP_WetDistortion ppeffectcommit 0;
	BIS_PP_WetDistortion ppeffectadjust WETDISTORTION_0;
	BIS_PP_WetDistortion ppeffectcommit 0.3;

	if (!BIS_periodIsPost && {isnil "bis_orange_minedispenser_blocked" && {position player inpolygon BIS_churchPolygon}}) then {
		bis_orange_minedispenser_blocked = true;
		[["Blocked",[bis_orange_minedispenser_trigger]]] call bis_orange_fnc_memoryFragment;
	};
};

//--- Switch the state
private _newPeriod = param [0,!BIS_periodIsPost,[false]];
if (_newPeriod isequalto BIS_periodIsPost && {!_isInit}) exitwith {};
BIS_periodIsPost = _newPeriod;
setacctime 1;
openmap false;

//--- Play effect
if (time > 0.1 && !_skipEffect) then {
	playsound [
		if (BIS_periodIsPost) then {
			selectrandom ["Orange_PeriodSwitch_Post_01","Orange_PeriodSwitch_Post_02","Orange_PeriodSwitch_Post_03"]
		} else {
			selectrandom ["Orange_PeriodSwitch_Pre_01","Orange_PeriodSwitch_Pre_02","Orange_PeriodSwitch_Pre_03"]
		},
		true
	];
	BIS_PP_WetDistortion ppeffectadjust WETDISTORTION_1;
	BIS_PP_WetDistortion ppeffectcommit 0.4;
	_time = time + 0.35;
	waituntil {time > _time};
	cuttext ["","black out",0.05];
	waituntil {ppeffectcommitted BIS_PP_WetDistortion};
};

//--- End effect
if (time > 0.1) then {
	cuttext ["","black in",1e10];
	BIS_PP_WetDistortion ppeffectadjust WETDISTORTION_0;
	BIS_PP_WetDistortion ppeffectcommit 0.4;
};

//--- Call custom code
private _code = param [2,{},[{}]];
[_newPeriod] call _code;

//--- Execute in non-scheduled environment
#define VEHICLES_WITH_ENINGE	[bis_drone1,bis_drone2,bis_deliveryDrone]
addmissioneventhandler [
	"eachframe",
	{
		//--- Remove the handler (it's used for single-use non-scheduled execution); ToDo: EH fix
		if !(isnil "BIS_handlerExecuted") exitwith {};
		BIS_handlerExecuted = true;
		_thiseventhandler spawn {
			removemissioneventhandler ["eachframe",_this];
			BIS_handlerExecuted = nil;
		};

		//--- Delete ambient life and objects
		{deletevehicle _x;} foreach (allMissionObjects "bird");
		{_x hideobject !(isobjecthidden _x);} foreach (allMissionObjects "#crater" + allMissionObjects "#mark" + allMissionObjects "#track");

		//--- Set loadout
		private _loadout = getunitloadout player;
		player setunitloadout BIS_loadout;
		BIS_loadout = _loadout;

		if !(isnil "bis_deliveryDrone") then {player disableUAVConnectability [bis_deliveryDrone,true];}; //--- Disable connection again because inventory changed
		_posOrig = getposatl player;

		if (BIS_periodIsPost) then {

			//--- Post-war
			[getarray (missionconfigfile >> "CfgOrange" >> "Layers" >> ("Orange_Hub_Post"))] call bis_orange_fnc_showLayers;

			0 setfog [0.2,0.0001,1000];
			[] spawn {0 setrain 0.2; sleep 0.5; 600 setrain 0.2;};
			setwind [4.2,0,true];
			600 setrain 0.2;
			if !(bis_orange_isIntro) then {0.2 fademusic 0.0;};
			0.2 fadesound 1.0;
			{if (isnil {_x getvariable "bis_layer"}) then {deletevehicle _x;};} foreach (entities "Animal");
			{
				_pos = position _x;
				if ((_pos select 2) > 900) then {
					_x setposatl (_pos vectoradd [0,0,-10000]);
				};
			} foreach VEHICLES_WITH_ENINGE;

			//--- Force show mine detector panel
			setInfoPanel ["DefaultVehicleSystemsDisplayManagerLeft",BIS_infoPanel select 0];
			setInfoPanel ["DefaultVehicleSystemsDisplayManagerRight",BIS_infoPanel select 1];
		} else {

			//--- Pre-war
			[getarray (missionconfigfile >> "CfgOrange" >> "Layers" >> ("Orange_Hub_Pre"))] call bis_orange_fnc_showLayers;
			0 setfog 0;
			0 setrain 0;
			setwind [0,0,true];
			if !(bis_orange_isIntro) then {0.6 fademusic 0.4;};
			0.2 fadesound 0.5;//0.2;

			//--- Disable sounds of vehicles with engine (todo: better solution?)
			{
				_x spawn {
					_this enablesimulation true;
					_this setposatl (getposatl _this vectoradd [0,0,10000]);
					sleep 0.01;
					_this enablesimulation false;
				};
			} foreach VEHICLES_WITH_ENINGE;

			//--- Remember info panel
			BIS_infoPanel = [infopanel "left" select 0,infopanel "right" select 0];
		};
		{_x ppeffectenable !BIS_periodIsPost;} foreach BIS_PP_Pre;
		{_x ppeffectenable BIS_periodIsPost;} foreach BIS_PP_Post;
		enableenvironment [!BIS_periodIsPost,BIS_periodIsPost];
		player forcewalk !BIS_periodIsPost;
		{player forgetTarget _x} foreach allunits;

		//--- Check for collisions
		if (vehicle player == player) then {
			#define GROUND_TOLERANCE	0.05
			_bbox = (boundingboxreal player select 0) vectoradd (boundingboxreal player select 1);
			_refPosStart = agltoasl(player modelToWorldVisual _bbox);
			_refPosEnd = _refPosStart vectoradd [0,0,-(_bbox select 2) + GROUND_TOLERANCE];
			_collisionObjects = lineintersectswith [_refPosStart,_refPosEnd,player];
			if (count _collisionObjects > 0) then {player setvehicleposition [_posOrig,[],0,"none"];};
		};

		//--- Avoid falling down
		if (vehicle player == player && {(position player select 2) > 1 || {(animationstate player) find "ladder" >= 0}}) then {
			player setvehicleposition [position player,[],0,"none"];
			player switchmove "";
		};

		//--- Altitude changed dramatically, use unaltered position instead
		_altDiff = ((getposatl player select 2) - (_posOrig select 2));
		if (_altDiff > 1) then {player setposatl _posOrig;};

		//--- Prevent the barricade from exploding
		{
			_x allowdamage false;
			_x enablesimulation (BIS_periodIsPost && {!isnil "bis_barricadeClearing"});
		} foreach bis_barricadeObjects;

		//--- Reset animal animations
		{_x playactionnow selectrandom ["WalkF","StopRelaxed"];} foreach ((missionnamespace getvariable ["bis_initAnimals_list",[]]) select {simulationenabled _x});

		//--- Close inventory
		(finddisplay 602) closedisplay 2;

		if (time <= 0.1) then {
			BIS_isSwitchingPeriod = false;
		};
	}
];

//if (vehicle player == player && (getposatl player select 2) < 0.1) then {
//	player setVehiclePosition [position player,[],0,"none"];
//	[player,0] call bis_fnc_setheight;
//};

if (time > 0.1) then {
	sleep 0.01;
	cuttext ["","black in",0.2];
	BIS_isSwitchingPeriod = false;
	if !(bis_orange_isIntro) then {
		_duration = missionnamespace getvariable ["bis_switchPeriodTimelineDuration",3];
		[if (BIS_periodIsPost) then {"Orange_Hub_Post"} else {"Orange_Hub_Pre"},nil,_duration,false] spawn bis_orange_fnc_timeline;
		missionnamespace setvariable ["bis_switchPeriodTimelineDuration",nil];
	};
};