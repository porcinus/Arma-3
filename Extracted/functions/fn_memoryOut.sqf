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

params [
	["_camInternal",objnull,[objnull]],
	["_camExternal",objnull,[objnull]],
	["_duration",15,[0]],
	["_code",{},[{}]],
	["_fov",0.75,[0]]
];

waituntil {bis_orange_hub_init};

_commitTime = 3;
BIS_PP_WetDistortion ppeffectadjust WETDISTORTION_1;
BIS_PP_WetDistortion ppeffectcommit 0;
BIS_PP_WetDistortion ppeffectadjust WETDISTORTION_0;
BIS_PP_WetDistortion ppeffectcommit _commitTime;
cuttext ["","black in",_commitTime];
_commitTime fadesound 1;
playsound [selectrandom ["Orange_PeriodSwitch_Post_01","Orange_PeriodSwitch_Post_02","Orange_PeriodSwitch_Post_03"],true];

//--- Code
if (uinamespace getvariable ["BIS_Orange_skipIntro",false]) then {_duration = 0;};
[[_camInternal,_camExternal],player,_duration,_fov,_code,-1] call bis_orange_fnc_camera;

//--- Fade in
setInfoPanel ["DefaultVehicleSystemsDisplayManagerLeft","MineDetectorDisplay"];