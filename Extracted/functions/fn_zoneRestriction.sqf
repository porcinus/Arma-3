#define WETDISTORTION_0(COEF)\
[\
	1,\
	COEF, COEF,\
	8 - 4 * COEF, 8 - 4 * COEF, 8 - 4 * COEF, 8 - 4 * COEF,\
	0.005, 0.005, 0.005, 0.005,\
	0.5, 0.3, 10.0, 6.0\
]
#define WETDISTORTION_1(COEF)\
[\
	1,\
	1, 1,\
	8, 8, 8, 8,\
	0.005 * COEF, 0.005 * COEF, 0.005 * COEF, 0.005 * COEF,\
	0.0, 0.0, 1.0, 1.0\
]
BIS_disableZoneRestriction = false;
BIS_refreshZoneRestriction = true;
_marker = "bis_fnc_moduleCoverMap_border";
sleep 1; //--- Wait for Cover Map module to be initialized
if (markerbrush _marker == "") exitwith {};

_disBuffer = getmissionconfigvalue ["zoneRestrictionBuffer",50];

_PP_WetDistortion = ppEffectCreate ["WetDistortion",301];
_PP_WetDistortion ppeffectenable false;
_PP_WetDistortion ppeffectadjust WETDISTORTION_0(0);
_PP_WetDistortion ppeffectcommit 0;

_scriptMoveBack = scriptnull;
_showWarning = true;
_kbPlayed = false;
_sound = (getarray (configfile >> "CfgSounds" >> "Orange_ZoneRestriction" >> "sound")) param [0,""];

private ["_markerPos","_areaCmd","_areaFnc"];
while {alive player} do {
	_veh = vehicle player;

	//--- Refresh area params
	if (BIS_refreshZoneRestriction) then {
		_markerPos = markerpos _marker;
		_areaCmd = [_markerPos] + markersize _marker + [markerdir _marker,true];
		_areaFnc = [_markerPos,markersize _marker + [markerdir _marker,true]];
		BIS_refreshZoneRestriction = false;
	};

	if (_veh inarea _areaCmd || {BIS_disableZoneRestriction || {!savingenabled}}) then {
		_PP_WetDistortion ppeffectenable false;
		if !(_showWarning) then {
			"BIS_zoneRestriction" cuttext ["","plain"];
			_showWarning = true;
			if (bis_orange_isHub) then {player setfatigue 0;};
		};
		sleep 1;
	} else {
		_dis = [_areaFnc,_veh,true] call bis_fnc_inTrigger;
		_coef = _dis / _disBuffer;

		if (_showWarning) then {
			if !(_kbPlayed) then {
				_kbPlayed = true;
				["LeavingAO"] spawn bis_fnc_missionConversations;
			};
			"BIS_zoneRestriction" cuttext [
				format [
					"<t size='2' shadow='1' shadowColor='%2'><img image='\a3\Ui_f\data\Map\Markers\Military\warning_ca.paa' /><br />%1</t>",
					toupper localize "STR_A3_Orange_Campaign_zoneRestriction",
					(["IGUI","ERROR_RGB"] call bis_fnc_displaycolorget) call bis_fnc_colorRGBtoHTML
				],
				"plain",
				1,
				true,
				true
			];
			playsound "Orange_ZoneRestriction_Warning";
			_showWarning = false;

			//--- Reveal the area
			{
				_x setmarkeralpha 0.75;
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

		if (_coef > 1 && isnull _scriptMoveBack) exitwith {

			//--- Move back to AO
			_scriptMoveBack = [_markerPos,_areaFnc] spawn {
				_markerPos = _this select 0;
				_areaFnc = _this select 1;
				_veh = vehicle player;
				"BIS_cameraBlack" cuttext ["","black out"];
				playsound "Orange_ZoneRestriction_Teleport";
				sleep 1;

				_dis = [_areaFnc,_veh,true] call bis_fnc_inTrigger;
				_dirTo = _veh getdir _markerPos;
				_veh setdir _dirTo;
				_veh setvehicleposition [_veh getpos [_dis + 20,_dirTo],[],0,"none"];
				_veh setvelocity [0,0,0];
				if (_veh == player) then {player switchmove "";};
				"BIS_cameraBlack" cuttext ["","black in"];
				_time = time;
			};
		};

		//--- Play memory effect
		if (bis_orange_isHub) then {
			player setfatigue (getfatigue player + 0.1);
			sleep 0.1;
		} else {
			_delay = 0.3703;//((1 - _coef) max 0.2);

			_sound = [
				"Orange_ZoneRestriction_Distance_01",
				"Orange_ZoneRestriction_Distance_02",
				"Orange_ZoneRestriction_Distance_03",
				"Orange_ZoneRestriction_Distance_04"
			] select floor ((_coef min 0.99) * 4);
			playsound _sound;
			_PP_WetDistortion ppeffectenable true;
			_PP_WetDistortion ppeffectadjust WETDISTORTION_0(_coef);
			_PP_WetDistortion ppeffectcommit _delay;
			sleep _delay;
			_PP_WetDistortion ppeffectadjust WETDISTORTION_1(_coef);
			_PP_WetDistortion ppeffectcommit _delay;
			sleep _delay;
		};
	};
};