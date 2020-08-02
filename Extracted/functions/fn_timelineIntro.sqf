params [
	["_missionCurrent",missionname,[""]],
	["_code",{},[{}]]
];
player enablesimulation false;

waituntil {!isnull (finddisplay 46)};

_fnc_skip = {
	bis_orange_timelineDone
	||
	((finddisplay 46) getvariable ["BIS_timelinePlayed",false]) //--- After restart (display #46 is not reset)
	||
	cheat0 //--- Dev cheat
};

bis_orange_timelineDone = false;
enablesaving [false,false];
[] call bis_orange_fnc_skip;
"BIS_cameraBlack" cuttext ["","black in",1e10];
_time = time + 1;

waituntil {time > _time || call _fnc_skip};

if !(call _fnc_skip) then {[] call _code;};

if !(call _fnc_skip) then {
	//["",[nil,0],2] call bis_orange_fnc_timeline;
	//[nil,[0,nil]] call bis_orange_fnc_timeline;
	[_missionCurrent] call bis_orange_fnc_timeline;
};
_time = time + 1;

waituntil {time > _time || call _fnc_skip};
//"BIS_cameraBlack" cuttext ["","black in",3];
//enablesaving [true,false];

(finddisplay 46) setvariable ["BIS_timelinePlayed",true]; //--- Mark as played, so it won't reappear upon mission restart
bis_orange_timelineDone = true;
//player enablesimulation true;