//--- Init variables
bis_orange_missions = (configProperties [missionconfigfile >> "CfgOrange" >> "Missions"] select {getnumber (_x >> "isHub") == 0} apply {tolower configname _x});
bis_orange_layers = getarray (missionconfigfile >> "CfgOrange" >> "Layers" >> "layers");
bis_orange_init = false;
bis_orange_timelineDone = false;
bis_orange_cameraDone = false;
bis_orange_cameraDoneTime = 0;
bis_orange_isIntro = missionname == "introOrange"; //--- Alternative Altis cutscene
bis_orange_isHub = !(tolower missionname in bis_orange_missions) || bis_orange_isIntro; //--- Any mission not in the missions list is considered a hub
bis_orange_draw = [];
bis_orange_enableSubtitles = true;
bis_kb = scriptnull;
cheat0 = false;
cheat1 = false;
cheat2 = false;
cheat3 = false;
cheat4 = false;
cheat5 = false;
cheat6 = false;
cheat7 = false;
cheat8 = false;
cheat9 = false;

//--- Peristent variables
_cfgVariables = missionconfigfile >> "CfgOrange" >> "Variables";
{
	_var = configname _x;
	missionnamespace setvariable [
		_var,
		missionnamespace getvariable [_var,[_cfgVariables,_var] call bis_fnc_returnconfigentry]
	];
} foreach configproperties [_cfgVariables];

//--- Set default map zoom
addmissioneventhandler [
	"map",
	{
		if (markerbrush "bis_defaultMapView" != "") then {
			if (_this select 0 && {"ItemMap" in assigneditems player}) then {

				//--- Instant zoom after restart or 3 minutes
				_duration = if (((finddisplay 46) getvariable ["bis_mapAnim",false]) || time > (3 * 60)) then {0} else {1};
				(finddisplay 46) setvariable ["bis_mapAnim",true];

				mapanimadd [0,0.01 / safezoneH,position player]; 
				mapanimcommit;
				mapanimadd [_duration,(markersize "bis_defaultMapView" select 1) * 0.000088 / safezoneH,markerpos "bis_defaultMapView"]; 
				mapanimcommit;
				removemissioneventhandler ["map",_thiseventhandler];
			};
		} else {
			removemissioneventhandler ["map",_thiseventhandler];
		};
	}
];

//--- Update collapsed buildings
addmissioneventhandler [
	"buildingChanged",
	{
		_from = _this select 0;
		_to = _this select 1;
		_layer = _from getvariable "BIS_Layer";
		if !(isnil "_layer") then {
			_layerVar = format ["BIS_layer_%1",_layer];
			_layerObjects = missionnamespace getvariable [_layerVar,[]];
			_fromId = _layerObjects find _from;
			if (_fromId >= 0) then {_layerObjects deleteat _fromId;};
			_layerObjects pushback _to;
		};
	}
];

//--- Save which mission was completed when returning to the hub
addmissioneventhandler [
	"ended",
	{
		//if (tolower _this in ["orange_hub","enddefault"]) then {
		if (tolower _this in ["orange_hub","enddefault"] || {isclass (missionconfigfile >> "CfgOrange" >> "Missions" >> _this)}) then {
			_this call compile preprocessfilelinenumbers "ended.sqf";
			BIS_previousMission = missionname;
			parsingnamespace setvariable ["Orange_Hub_ID",getnumber (missionconfigfile >> "scenarioID")]; //--- Save scenario ID, read by description.ext of the Hub
			//savevar "BIS_previousMission";
		};

		//--- Save total playtime, shown in phone call GUI
		BIS_playTime = BIS_playTime + time;
		//savevar "BIS_playTime";

		//--- Save all vars
		{savevar configname _x;} foreach configproperties [missionconfigfile >> "CfgOrange" >> "Variables"];
	}
];

//--- Initialize friendly fire
[ "Init", [] ] call BIS_fnc_moduleFriendlyFire;

//--- Initialize zone protection
[] spawn bis_orange_fnc_zoneRestriction;

//--- Create logic for attaching objects (if it doesn't exist yet)
if (isnil "bis_oreokastro") then {bis_oreokastro = (creategroup sidelogic) createunit ["Logic",[4559.894,21404.803,0],[],0,"can_collide"];};

//--- Post-init
[] spawn {

	//--- Set previously played HUB mission
	BIS_previousMission = uinamespace getvariable ["BIS_Orange_previousMission",BIS_previousMission];
	if !(bis_orange_isHub) then {BIS_previousMission = missionname;};

	//--- Detect which missions were already played
	bis_missionID = 0;
	BIS_nextMission = "";
	_missionPlayed = true;
	{

		_isMissionCurrent = _x == BIS_previousMission;
		if (!bis_orange_isHub && _isMissionCurrent) then {_missionPlayed = false;}; //--- Mark this and following missions as unplayed
		missionnamespace setvariable [format ["BIS_%1_Done",_x],_missionPlayed];
		if (_missionPlayed) then {
			missionnamespace setvariable [_x,true];
			bis_missionID = bis_missionID + 1;
		} else {
			if (BIS_nextMission == "") then {BIS_nextMission = _x;};
		};

		if (bis_orange_isHub && _isMissionCurrent) then {_missionPlayed = false;}; //--- Mark following missions as unplayed
	} foreach bis_orange_missions;

	//--- Random seed for UXOs
	if (isnil "BIS_UXOType") then {
		BIS_UXOType = ceil random 3;
		savevar "BIS_UXOType";
	};

	//--- Restore custom minefield from Orange_Leaflets
	_minesLeaflets = [];
	{
		if (_x distance2d bis_oreokastro < 300) then {
			_mine = createvehicle ["APERSBoundingMine_Range_Ammo",_x,[],0,"can_collide"];
			_mine setposatl _x;
			_minesLeaflets pushback _mine;
		};
	} foreach BIS_minesLeaflets;
	[_minesLeaflets,"PostNGO"] call bis_orange_fnc_register;

	//--- Restore custom minefield from Orange_MineDispenser
	_minesMineDispenser = [];
	{
		//--- Use only mines which player can reach
		if ((_x select 2) < 1) then {
			_mine = createvehicle ["APERSMineDispenser_Mine_Ammo",_x,[],0,"can_collide"];
			_mine setposatl _x;
			_minesMineDispenser pushback _mine;
		};
	} foreach BIS_minesMineDispenser;
	[_minesMineDispenser,"Church"] call bis_orange_fnc_register;

	//--- Restore barricade
	_simulateBarricade = BIS_previousMission == "Orange_Leaflets";
	bis_barricadeObjects = [];
	{
		_type = _x select 0;
		_pos = _x select 1;
		_vector = _x select 2;
		_customization = _x select 3;

		_veh = createvehicle [_type,_pos,[],0,"can_collide"];
		_veh setposworld _pos;
		_veh setvectordirandup _vector;
		_veh setvelocity [0,0,0];
		_veh enablesimulation false;
		_veh setvariable ["bis_pos",[_pos,_vector]];
		([_veh] + _customization) call bis_fnc_initVehicle;

		//if (gettext (configfile >> "CfgVehicles" >> _type >> "destrType") == "destructWreck") then {
		if (false && {_simulateBarricade && {_type iskindof "Van_02_base_F"}}) then {

			//--- Don't use wreck model, because it messes up collisions
			{_veh setHitPointDamage [_x,1];} foreach ((getAllHitPointsDamage _veh) select 0);
			_veh setobjectmaterial [0,"a3\Soft_F_Orange\Van_02\Data\van_body_destruct.rvmat"];
			_veh allowdamage false;
			_veh lock true;
			clearweaponcargo _veh;
			clearmagazinecargo _veh;
			clearbackpackcargo _veh;
			clearitemcargo _veh;
		} else {

			//--- Apply damage directly
			_veh setdamage [1,false];
		};

		//--- Block for memory switching
		if (bis_orange_isHub) then {
			[_veh,!_simulateBarricade] call bis_orange_fnc_switchPeriodArea; //--- Not baked after Leaflets, because it's broken through
		};
		bis_barricadeObjects pushback _veh;
	} foreach BIS_barricade;
	[bis_barricadeObjects,"PostNGO"] call bis_orange_fnc_register;
	{deletevehicle _x;} foreach (getmissionlayerentities "Barricade" select 0);

	//--- Create powerlines
	if !(isnil "bis_powerline_C2_1") then {
		_allLines = [];
		{
			_allLines append (_x call bis_orange_fnc_createPowerline);
		} foreach [
			//[bis_powerline_C2_1,bis_powerline_N4_1],
			//[bis_powerline_C2_2,bis_powerline_N3_1],
			[bis_powerline_C2_1,bis_powerline_S10_1],
			[bis_powerline_C2_2,bis_powerline_N2_2],
			[bis_powerline_C2_3,bis_powerline_S10_4],
			[bis_powerline_C2_5,bis_powerline_C10_1],
			[bis_powerline_C2_6,bis_powerline_S2_1],
			[bis_powerline_C2_4,bis_powerline_N2_4],
			[bis_powerline_S10_2,bis_powerline_A2_1],
			[bis_powerline_S2_3,bis_powerline_S3_1]
		];
		[_allLines,"NoDamage"] call bis_orange_fnc_register;
		{deletevehicle _x} foreach (getmissionlayerentities "Powerlines" select 0);
	};

	//--- Initialize local hub layers
	if (bis_orange_isHub) then {

		_layers = [
			["_Pre",	"Hub_Pre",	false],
			["_PreX",	"Hub_Pre",	true],
			["_Post",	"Hub_Post",	false],
			["_PostX",	"Hub_Post",	true]
		];

		{
			_layer = _x;
			_isMissionCurrent = _layer == BIS_previousMission;

			if (_foreachindex < bis_missionID) then {
				missionnamespace setvariable [_x,true];

				//--- Register the layer
				{
					_suffix = _x select 0;
					_targetLayer = _x select 1;
					_isExclusive = _x select 2;

					_layerObjects = (getMissionLayerEntities (_layer + _suffix)) param [0,[]];
					if (count _layerObjects > 0) then {
						if (!_isExclusive || {_isExclusive && _isMissionCurrent}) then {
							[_layerObjects,_targetLayer] call bis_orange_fnc_register;
						} else {
							//--- Played, but exclusive to previous instances
							{
								{deletevehicle (_x select 0);} foreach (_x getvariable ["BIS_effects",[]]);
								deletevehicle _x;
								//_x enablesimulation false;
								//_x hideobject true;
							} foreach _layerObjects;
						};
					};
				} foreach _layers;
			} else {

				//--- Not played yet
				_layerObjects = (getMissionLayerEntities _layer) param [0,[]];
				{
					{deletevehicle (_x select 0);} foreach (_x getvariable ["BIS_effects",[]]);
					deletevehicle _x;
					//_x enablesimulation false;
					//_x hideobject true;
				} foreach _layerObjects;
			};
		} foreach bis_orange_missions;
	};

	//--- Initialize editor layers
	_compositions = getarray (missionconfigfile >> "CfgOrange" >> "Layers" >> "compositions");
	{
		_layer = _x;
		_layerVar = format ["BIS_layer_%1",_layer];
		_layerObjects = missionnamespace getvariable [_layerVar,[]];
		//_editorLayerEntities = getMissionLayerEntities _layer;
		_editorLayerObjects = (getMissionLayerEntities _layer) param [0,[]];
		_explosivesVar = format ["bis_layer_%1_explosives",_layer];
		_explosives = missionnamespace getvariable [_explosivesVar,[]];
		{
			_editorLayerObjects append ((getMissionLayerEntities format ["%1_%2",_x,_layer]) param [0,[]]);
		} foreach _compositions;
		if (count _editorLayerObjects > 0) then {
			//_editorLayerObjects = _editorLayerEntities select 0;
			{
				if (_x iskindof "Default") then {

					//--- Replace UXO with side specific variant (selected randomly for each player)
					if (_x iskindof "UXO1_Ammo_Base_F") then {
						_xID = switch true do {
							case (_x iskindof "UXO4_Ammo_Base_F"): {4};
							case (_x iskindof "UXO3_Ammo_Base_F"): {3};
							case (_x iskindof "UXO2_Ammo_Base_F"): {2};
							default {1};
						};
						_xClass = format ["BombCluster_0%1_UXO%2_Ammo_F",BIS_UXOType,_xID];
						_xNew = createvehicle [_xClass,position _x,[],0,"can_collide"];
						_xNew setposatl getposatl _x;
						_xNew setvectordirandup [vectordir _x,vectorup _x];
						_editorLayerObjects set [_foreachindex,_xNew];
						_x setpos [10,10,10];
						deletevehicle _x;
						_x = _xNew;
					};
					_explosives pushbackunique _x;
					//missionnamespace setvariable [format ["BIS_%1",_x],getposatl _x];
				};
				if !(simulationenabled _x) then {_x setvariable ["BIS_defaultSimulation",false];};
				_x setvariable ["BIS_layer",tolower _layer];
				_x enablesimulation false;
				_x hideobject true;

				//--- Disable inventory containers
				if (!(_x iskindof "AllVehicles") && {_x iskindof "WeaponHolder" || {_x canAdd "FirstAidKit"}}) then {_x setdamage 1;};

				//clearweaponcargo _x;
				//clearmagazinecargo _x;
				//clearbackpackcargo _x;
				//clearitemcargo _x;
			} foreach _editorLayerObjects;
			_layerObjects append _editorLayerObjects;
		};
		missionnamespace setvariable [_layerVar,_layerObjects];
		missionnamespace setvariable [_explosivesVar,_explosives];

		_layerFnc = missionnamespace getvariable format ["BIS_orange_fnc_initLayer_%1",_layer];
		if !(isnil "_layerFnc") then {["Init",_layerObjects] call _layerFnc;};
	} foreach BIS_orange_layers;
	[getarray (missionconfigfile >> "CfgOrange" >> "Layers" >> missionname)] call bis_orange_fnc_showLayers;

	[] call bis_orange_fnc_initKB;

	//--- Initialize conversations
	[
		missionnamespace,
		"BIS_fnc_kbTellLocal_played",
		{
			params [
				["_from",objnull],
				["_to",objnull],
				["_sentence",""],
				["_channel",""]
			];
			_cfgSounds = [["CfgSounds",_sentence],confignull] call bis_fnc_loadClass;
			if (acctime == 1 && !isnull _cfgSounds && {_from != vehicle player && {!("ItemRadio" in (assignedItems _from))}}) then {
				playsound [_sentence,true];
			};
			if (_from in [BIS_EOD,BIS_Journalist] && (_to != BIS_Driver) && missionname != "Orange_Hiker" && bis_orange_enableSubtitles) then {
				RscPhoneCall_data = [
					_from getvariable ["bis_nameCall",name _from],
					_from getvariable ["bis_avatar","#(argb,8,8,3)color(1,0,1,1)"],
					BIS_playTime
				];
				"RscPhoneCall" cutrsc ["RscPhoneCall","plain"];
			};
			bis_orange_enableSubtitles
		}
	] call bis_fnc_addscriptedeventhandler;

	//--- Refresh markers to make sure they're placed above greyed out area
	if !(bis_orange_isHub) then {
		allmapmarkers spawn {
			scriptname "BIS_orange_fnc_init: allMapMarkers";
			waituntil {markershape "bis_fnc_moduleCoverMap_border" != ""};
			_markers = _this;
			{
				_data = [[_x,markerpos _x],markerdir _x,markertype _x,markershape _x,markerbrush _x,markersize _x,markercolor _x,markeralpha _x,markertext _x];
				deletemarker _x;
				_marker = createmarker (_data select 0);
				_marker setmarkerdir (_data select 1);
				if ((_data select 3) == "ICON") then {
					_marker setmarkertype (_data select 2);
				} else {
					_marker setmarkershape (_data select 3);
					_marker setmarkerbrush (_data select 4);
				};
				_marker setmarkersize (_data select 5);
				_marker setmarkercolor (_data select 6);
				_marker setmarkeralpha (_data select 7);
				_marker setmarkertext (_data select 8);
			} foreach _markers;
		};
	};

	//--- Loaded
	addmissioneventhandler ["loaded",{_this call bis_orange_fnc_initLoaded;}];
	[] call bis_orange_fnc_initLoaded;

	//--- Init diary
	[] call bis_orange_fnc_initDiary;

	//--- Draw custom map icons
	[] spawn bis_orange_fnc_initMap;

	//--- Hide map view marker
	"bis_defaultMapView" setmarkeralpha 0;

	//--- Create locations with dubbing
	[[[4585,21420,0],[135,160,320,false]],"loc_town",localize "STR_A3_Oreokastro0"] call bis_orange_fnc_createLocationWithDubbing;
	[[[4550,21502,0],[36,40,10,false]],"obj_church",localize "str_dn_church"] call bis_orange_fnc_createLocationWithDubbing;

	//--- Erase debug variables
	//uinamespace setvariable ["BIS_Orange_previousMission",nil];
	uinamespace setvariable ["BIS_Orange_showAllMemoryFragments",nil];

	//--- Mark as initialized
	bis_orange_init = true;
	sleep 0.01;

	if (bis_orange_isHub) then {
		//--- Remove inactive objects from restricted areas
		_objects = missionnamespace getvariable ["BIS_switchPeriodAreas",[]];
		_objects = _objects - [objnull];
		missionnamespace setvariable ["BIS_switchPeriodAreas",_objects];

		//--- Remove radio protocol
		{
			{
				_x setspeaker "NoVoice";
			} foreach units _x;
		} foreach allgroups;
	};

	//--- Hide AO markers until player actually leaves AO
	waituntil {markerbrush "bis_fnc_moduleCoverMap_border" != ""};
	_alpha = if (missionname == "Orange_AirDrop") then {0.75} else {0};
	{
		_x setmarkeralpha _alpha;
	} foreach [
		"bis_fnc_moduleCoverMap_border",
		"bis_fnc_moduleCoverMap_0",
		"bis_fnc_moduleCoverMap_90",
		"bis_fnc_moduleCoverMap_180",
		"bis_fnc_moduleCoverMap_270",
		"bis_fnc_moduleCoverMap_dot_0",
		"bis_fnc_moduleCoverMap_dot_90",
		"bis_fnc_moduleCoverMap_dot_180",
		"bis_fnc_moduleCoverMap_dot_270"
	];
};